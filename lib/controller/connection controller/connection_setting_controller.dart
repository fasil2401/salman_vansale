import 'dart:convert';
import 'dart:developer';

import 'package:axoproject/utils/Encryption/encryptor.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/login/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/router_report.dart';
import 'package:image_picker/image_picker.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:axoproject/model/Local%20DB%20model/connection_setting_model.dart';
import 'package:share_plus/share_plus.dart';

class ConnectionSettingController extends GetxController {
  var serverIp = ''.obs;
  var port = ''.obs;
  var database = ''.obs;
  var encryptedServerIp = ''.obs;
  var encryptedPort = ''.obs;
  var encryptedDatabase = ''.obs;
  var encryptedConnectionName = ''.obs;
  var qrCode = ''.obs;
  var connectionName = ''.obs;
  var qrData = ''.obs;
  var isLocalSettings = false.obs;
  var image = XFile("").obs;
  var nameWarning = false.obs;
  var ipWarning = false.obs;
  var portWarning = false.obs;
  var databaseNameWarning = false.obs;
  var isLoading = false.obs;
  setConnectionName(String connectionName) async {
    this.connectionName.value = connectionName;
    if (encryptedConnectionName.isNotEmpty) {
      encryptedConnectionName.value = EncryptData.encryptAES(connectionName);
      await setQrCode();
    }
  }

  setServerIp(String serverIp) async {
    this.serverIp.value = serverIp;
    if (serverIp.isNotEmpty) {
      encryptedServerIp.value = EncryptData.encryptAES(serverIp);
      await setQrCode();
    }
  }

  setPort(String port) async {
    this.port.value = port;
    if (port.isNotEmpty) {
      encryptedPort.value = EncryptData.encryptAES(port);
      await setQrCode();
    }
  }

  setDatabase(String database) async {
    this.database.value = database;
    if (database.isNotEmpty) {
      encryptedDatabase.value = EncryptData.encryptAES(database);
      await setQrCode();
    }
  }

  setQrCode() {
    qrCode.value = jsonEncode({
      "Instance": encryptedServerIp.value,
      "DbName": encryptedDatabase.value,
      "Port": encryptedPort.value,
    });
  }

  getConnectionName(String connectionName) {
    if (connectionName.isEmpty) {
      nameWarning.value = true;
    } else {
      nameWarning.value = false;
    }
    this.connectionName.value = connectionName;
    encryptedConnectionName.value = EncryptData.encryptAES(connectionName);
    getQrData();
  }

  getServerIp(String serverIp) {
    if (serverIp.isEmpty) {
      ipWarning.value = true;
    } else {
      ipWarning.value = false;
    }
    this.serverIp.value = serverIp;
    encryptedServerIp.value = EncryptData.encryptAES(serverIp);
    getQrData();
  }

  getPort(String port) {
    if (port.isEmpty) {
      portWarning.value = true;
    } else if (port.isNotEmpty && port.contains(':')) {
      portWarning.value = false;
    }
    this.port.value = port;
    encryptedPort.value = EncryptData.encryptAES(port);
    getQrData();
  }

  getDatabaseName(String databaseName) {
    if (databaseName.isEmpty) {
      databaseNameWarning.value = true;
    } else {
      databaseNameWarning.value = false;
    }
    this.database.value = databaseName;
    encryptedDatabase.value = EncryptData.encryptAES(databaseName);
    getQrData();
    // getHttpPort(databaseName);
  }

  getQrData() {
    qrData.value = jsonEncode({
      "connectionName": encryptedConnectionName.value,
      "serverIp": encryptedServerIp.value,
      "port": encryptedPort.value,
      "databaseName": encryptedDatabase.value,
    });
  }

  Future getImage() async {
    final images = await ImagePicker().pickImage(source: ImageSource.gallery);
    image.value = images!;
  }

  final connectionSettings = [].obs;

  Future<void> getLocalSettings() async {
    final List<Map<String, dynamic>> elements =
        await DBHelper().queryAllSettings();
    connectionSettings.assignAll(
        elements.map((data) => ConnectionModel.fromMap(data)).toList());
  }

  addLocalSettings({required ConnectionModel element}) async {
    await DBHelper().insertSettings(element);
    log('adding');
    connectionSettings.add(element);
    // getTransferOut();
  }

  updateLocalSettings(
      {required String connectionName,
      required String userName,
      required String password}) async {
    log('updating ${connectionName}');
    await DBHelper()
        .updateConnectionSettings(connectionName, userName, password);
    getLocalSettings();
  }

  updateFields(
      {required String connectionName,
      required String serverIp,
      required String port,
      required String databaseName}) async {
    print('updating');
    await DBHelper().updateFields(
        connectionName: connectionName,
        serverIp: serverIp,
        port: port,
        databaseName: databaseName);
    getLocalSettings();
  }

  deleteConnectionSettings(String connectionName) async {
    await DBHelper().deleteConnectionSettings(connectionName);
    getLocalSettings();
  }

  deleteTable() async {
    await DBHelper().deleteSettingsTable();
  }

  validateForm({
    required String connectionName,
    required String serverIp,
    required String port,
    required String databaseName,
  }) {
    if (connectionName.isEmpty) {
      nameWarning.value = true;
    } else {
      nameWarning.value = false;
    }
    if (serverIp.isEmpty) {
      ipWarning.value = true;
    } else {
      ipWarning.value = false;
    }
    if (port.isEmpty) {
      portWarning.value = true;
    } else {
      portWarning.value = false;
    }
    if (databaseName.isEmpty) {
      databaseNameWarning.value = true;
    } else {
      databaseNameWarning.value = false;
    }
  }

  saveSettings(List<ConnectionModel> list) async {
    // isLoading.value = true;
    await UserSimplePreferences.setLogin("logged out");
    if (nameWarning.value == false &&
        ipWarning.value == false &&
        portWarning.value == false &&
        databaseNameWarning.value == false) {
      // await UserSimplePreferences.setConnectionName(connectionName.value);
      // await UserSimplePreferences.setServerIp(serverIp.value);
      // await UserSimplePreferences.setPort(port.value);
      // await UserSimplePreferences.setDatabase(database.value);
      // await UserSimplePreferences.setConnection('true');
      // goToLogin();
      getConfirmation(list);
      // final isValid = await validateConnection();
      // if (isValid) {
      //   getConfirmation(list);
      //   isLoading.value = false;
      // } else {
      //   isLoading.value = false;
      //   SnackbarServices.errorSnackbar('Please check your connection settings');
      // }
    } else {
      SnackbarServices.errorSnackbar('Please fill all the fields');
    }
  }

  getConfirmation(List<ConnectionModel> list) async {
    for (var element in list) {
      if (element.connectionName == connectionName.value) {
        log("message");
        isLocalSettings.value = true;
      }
    }
    if (isLocalSettings.value == false) {
      await addLocalSettings(
        element: ConnectionModel(
          connectionName: connectionName.value,
          serverIp: serverIp.value,
          port: port.value,
          databaseName: database.value,
        ),
      );
      goToLogin();
    } else {
      log("connection name value ${connectionName.value}");
      await updateFields(
          connectionName: connectionName.value,
          serverIp: serverIp.value,
          port: port.value,
          databaseName: database.value);
      goToLogin();
    }
  }

  goToLogin() {
    Get.to(() => LoginScreen());
  }
}
