import 'dart:convert';

import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/services/Api%20Services/common_api_service.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/user_location/get_user_location.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

final cashRegisterControler = Get.put(PosCashRegisterListController());

class BatchSyncController extends GetxController {
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final loginController = Get.put(LoginController());
  var isBatchClosing = false.obs;

  Future startSyncing() async {
    if (UserSimplePreferences.getBatchID() != null &&
        UserSimplePreferences.getBatchID()! > 0) {
      await closeBatch();
    } else {
      await openBatch();
    }
  }

  Future openBatch() async {
    try {
      await loginController.getLogin();
      if (loginController.access.value.isEmpty) {
        await loginController.getLogin();
      }
      final String token = loginController.access.value;
      List<Map<String, dynamic>> registers =
          await cashRegisterControler.getCashRegisterList();
      Map<String, dynamic>? thisRegister =
          registers.isNotEmpty ? registers.first : null;
      await GetUserLocation.getCurrentLocation();
      if (thisRegister != null) {
        final data = jsonEncode({
          "token": token,
          "LocationID": thisRegister['LocationID'],
          "StartLatitude": UserSimplePreferences.getLatitude().toString(),
          "StartLongitude": UserSimplePreferences.getLongitude().toString(),
        });
        var feedbackBatch = await ApiManager.fetchDataRawBodyVAN(
            api: 'CreateVanBatch', data: data);
        if (feedbackBatch["res"] == 1) {
          var feedbackBatch = await ApiManager.fetchDataVAN(
            api:
                'GetActiveBatchNumber?token=$token&locationID=${thisRegister['LocationID']}',
          );
          if (feedbackBatch["result"] == 1) {
            if (feedbackBatch["Modelobject"] > 0) {
              UserSimplePreferences.setBatchID(feedbackBatch["Modelobject"]);
              print('Batch Openend ${UserSimplePreferences.getBatchID()}');
            }
          }
        } else {
          SnackbarServices.errorSnackbar("Error in Opening batch");
        }
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
    }
  }

  Future closeBatch() async {
    isBatchClosing.value = true;
    List<Map<String, dynamic>> registers =
        await cashRegisterControler.getCashRegisterList();
    Map<String, dynamic>? thisRegister =
        registers.isNotEmpty ? registers.first : null;
    if (thisRegister != null) {
      dynamic result;
      try {
        await loginController.getLogin();
        if (loginController.access.value.isEmpty) {
          await loginController.getLogin();
        }

        await GetUserLocation.getCurrentLocation();
        if (UserSimplePreferences.getLatitude()!.isEmpty ||
            UserSimplePreferences.getLongitude()!.isEmpty) {
          SnackbarServices.errorSnackbar(
              "Error in location. Turn on Gps and try again");
          return;
        }
        final String token = loginController.access.value;
        var feedback = await ApiManager.fetchDataVAN(
          api:
              'CloseVanBatch?token=$token&batchID=${UserSimplePreferences.getBatchID() ?? ''}&locationID=${thisRegister['LocationID']}&closeLatitude=${UserSimplePreferences.getLatitude() ?? ''}&closeLongitude=${UserSimplePreferences.getLongitude() ?? ''}',
        );
        if (feedback != null) {
          if (feedback["result"] == 1 && feedback["Modelobject"] == true) {
            UserSimplePreferences.setBatchID(0);
            SnackbarServices.successSnackbar("Batch Closed");
            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.close.value,
                    date: DateTime.now().toIso8601String(),
                    description: "Close Route",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
            Get.offAllNamed('/routeDetails');
          } else {
            SnackbarServices.errorSnackbar(
                "Error ${feedback["msg"] ?? feedback["err"]}");
          }
        } else {
          SnackbarServices.errorSnackbar("Error in closing Batch");
        }
      } catch (e) {
        SnackbarServices.errorSnackbar(e.toString());
      } finally {
        isBatchClosing.value = false;
      }
    }
  }
}
