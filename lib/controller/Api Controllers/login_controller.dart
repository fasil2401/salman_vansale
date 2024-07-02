import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/User%20By%20ID%20Model/user_by_id_model.dart';
import 'package:axoproject/services/Api%20Services/common_api_service.dart';
import 'package:axoproject/services/Api%20Services/login_services.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Sync%20Screen/sync_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

// final locationController = Get.put(LocationController());

class LoginController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initPlatformState();
  }

  final settingsController = Get.put(ConnectionSettingController());
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  var isLoading = false.obs;
  var isAttaching = false.obs;
  var res = 0.obs;
  var message = ''.obs;
  var access = ''.obs;
  var userId = ''.obs;
  var connectionName = ''.obs;
  var dbName = ''.obs;
  var password = ''.obs;
  var userName = ''.obs;
  var serverIp = ''.obs;
  var port = ''.obs;
  var database = ''.obs;
  var isRemember = false.obs;
  var userByIDList = <UserByIDModel>[].obs;

  initPlatformState() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      await UserSimplePreferences.setDeviceInfo(
          "${androidInfo.brand} ${androidInfo.model}");
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      await UserSimplePreferences.setDeviceInfo(iosInfo.utsname.machine!);
    }
  }

  setPassword(String password) {
    this.password.value = password;
    log("${this.password.value} ${userId.value}",
        name: "username and password");
  }

  setUsername(String userName) {
    userId.value = userName;
  }

  setServerIp(String serverIp) {
    this.serverIp.value = serverIp;
  }

  setPort(String port) {
    this.port.value = port;
  }

  setDatabase(String database) {
    this.database.value = database;
  }

  setConnectionName(String connectionName) {
    this.connectionName.value = connectionName;
    log("nnnn${this.connectionName.value}");
  }

  String loginStatus = '';
  getLogin() async {
    loginStatus = UserSimplePreferences.getLogin() ?? '';
    log("${loginStatus}");
    database.value = UserSimplePreferences.getDatabase() ?? '';
    port.value = UserSimplePreferences.getPort() ?? '';
    serverIp.value = UserSimplePreferences.getServerIp() ?? '';
    userId.value = UserSimplePreferences.getUsername() ?? '';
    password.value = UserSimplePreferences.getUserPassword() ?? '';
    final data = jsonEncode({
      "Instance": serverIp.value,
      "UserId": userId.value,
      "Password": password.value,
      "PasswordHash": "",
      "DbName": database.value,
      "Port": port.value,
      "servername": ""
    });
    print(data);
    var feedback;

    try {
      // if (UserSimplePreferences.getLogin() != 'loggedin') {
      //   // Get.defaultDialog(
      //   //   title: "Please Wait",
      //   //   content: Center(
      //   //     child: CircularProgressIndicator(),
      //   //   ),
      //   // );
      // }
      feedback = await RemoteServicesLogin().getLogin(data);
      if (feedback != null) {
        res.value = feedback.res;
        message.value = feedback.msg;
        isLoading.value = false;
        UserSimplePreferences.setRememberPassword(isRemember.value);
      } else {
        isLoading.value = false;
        message.value = 'failure';
        SnackbarServices.errorSnackbar("${message.value}");
      }
    } finally {
      if (res.value == 1) {
        access.value = feedback.loginToken;
        // userId.value = feedback.userId;
        await UserSimplePreferences.setAccessToken(access.value);
        // await UserSimplePreferences.setPreviousUsername(feedback.userId);
        dbName.value = feedback.dbName;
        try {
          var feedbackUserByID = await ApiManager.fetchDataVAN(
              api:
                  'GetUserByID?token=${feedback.loginToken}&id=${userId.value}');
          if (feedbackUserByID != null) {
            if (feedbackUserByID["result"] == 1) {
              var result = UserByIDListModel.fromJson(feedbackUserByID);
              userByIDList.value = result.userList!;
              String salesPerSonID = userByIDList.isNotEmpty
                  ? userByIDList[0].defaultSalesPersonID ?? ''
                  : '';
              print("SalesPersonID is :$salesPerSonID");
              await UserSimplePreferences.setSalesPersonID(salesPerSonID);

              if (loginStatus != 'true') {
                goToHome();
              }
            } else {
              log(feedbackUserByID["msg"].toString(), name: 'error message');
              SnackbarServices.errorSnackbar(
                  feedbackUserByID["msg"].toString());
            }
          } else {
            SnackbarServices.errorSnackbar("ERROR! Please try again");
          }
        } catch (e) {
          log(e.toString(), name: 'error message catch');
          SnackbarServices.errorSnackbar("${e.toString()}");
        } finally {}
        isLoading.value = false;
        // Get.offNamed('/sync');
        // buslistController.getBusList();
      } else {
        // Get.back();
      }
    }
  }

// getUserByID(String token, String userID) async{
//    try {
//     var feedback = await ApiManager.fetchDataVAN(
//       api: 'GetVANCashRegisterList?token=$token&vanID=VAN06',
//     );
//     if (feedback != null) {
//         result = PosCashRegisterListModel.fromJson(feedback);
//         posCashRegisterList.value = result.Modelobject.where((r) => r.salesPersonID == );
//         print('test start');
//         print(posCashRegisterList.value);
//         await cashRegisterControler.deleteTable();
//         await cashRegisterControler.insertCashRegisterList(posCashRegisterList : posCashRegisterList);
//         if (feedback["result"] == 1) {
//           isLoadingCashRegister.value = false;
//           isCashRegisterSuccess.value = true;
//         } else {
//           isLoadingCashRegister.value = false;
//           isCashRegisterSuccess.value = false;
//         }
//         print('inserted test');
//         cashRegisterControler.getCashRegisterList();
//         String? registerID = posCashRegisterList.first.cashRegisterID ;
//         // print('register id is $registerID');
//       }
//   } finally {
//     isLoadingCashRegister.value = false;
//   }
// }

  void goToHome() async {
    await UserSimplePreferences.setLogin('true');
    String userName = UserSimplePreferences.getUsername() ?? '';
    String previousUserName = UserSimplePreferences.getPreviousUsername() ?? '';
    // await UserSimplePreferences.setUsername(userId.value);
    // await UserSimplePreferences.setUserPassword(password.value);
    Get.to(() => SyncScreenView());
    // Get.offAllNamed('/routeDetails');
    // locationController.getDialogue();
    if (userName.toLowerCase() != previousUserName.toLowerCase()) {
      await UserSimplePreferences.setProductSync('clear');
      await UserSimplePreferences.setTransferTypeSync('clear');
      await UserSimplePreferences.setSysDocSync('clear');
      await UserSimplePreferences.setRouteSync('clear');
      // locationController.getDialogue();
    }
    // UserSimplePreferences.getLocation() == "" ? locationController.getDialogue() : locationController.getLocation();
  }

  updateConnectionSetting() async {
    String connectionName =
        await UserSimplePreferences.getConnectionName() ?? '';
    await settingsController.updateLocalSettings(
        connectionName: connectionName,
        userName: userId.value,
        password: password.value);
  }

  saveCredentials() async {
    await updateConnectionSetting();
    await UserSimplePreferences.setUsername(userId.value);
    await UserSimplePreferences.setUserPassword(password.value);

    await getLogin();
    if (loginStatus != 'true') {
      activityLogLocalController.insertactivityLogList(
          activityLog: UserActivityLogModel(
              sysDocId: "",
              voucherId: "",
              activityType: ActivityTypes.login.value,
              date: DateTime.now().toIso8601String(),
              description: "Logged In",
              machine: UserSimplePreferences.getDeviceInfo(),
              userId: userId.value,
              isSynced: 0));
    }
  }

  rememberPassword() async {
    isRemember.value = !isRemember.value;
  }
}
