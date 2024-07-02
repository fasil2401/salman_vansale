import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20DB%20model/connection_setting_model.dart';
import 'package:axoproject/utils/Routes/route_manger.dart';
import 'package:axoproject/utils/default_settings.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Customer%20Tasks%20Tab%20Screen/customer_tasks_tab_screen.dart';
import 'package:axoproject/view/Sync%20Screen/sync_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final connectionSettingController = Get.put(ConnectionSettingController());
final homeController = Get.put(HomeController());
final customerControler = Get.put(CustomerListController());

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  var settingsList = [
    ConnectionModel(
        connectionName: 'Select Settings',
        serverIp: '',
        port: '',
        databaseName: '')
  ];
  enterApp(BuildContext context) async {
    String isConnected = await UserSimplePreferences.getConnection() ?? 'false';
    String isLoggedIn = await UserSimplePreferences.getLogin() ?? 'false';
    await Future.delayed(Duration(seconds: 4), () async {
      if (isConnected != 'true' && !DefaultSettings.isConnectionDisabled) {
        Get.offNamed(RouteManager().routes[2].name);
        return;
      }

      if (isLoggedIn != 'true') {
        Get.offNamed(RouteManager().routes[1].name);
        return;
      } else {
        bool? isSynced = await UserSimplePreferences.getIsSynced();
        if (isSynced != null && !isSynced) {
          Get.off(() => SyncScreenView());
          return;
        }

        String? routeID = UserSimplePreferences.getRouteId();
        bool? isVisiting = await UserSimplePreferences.getIsVisitStarted();
        int? batchID = UserSimplePreferences.getBatchID();
        if (isVisiting != null && isVisiting) {
          var customerList = await customerControler.getCustomerList();

          // for (var element in customerList) {
          //   log(element.customerID.toString());
          // }
          log(customerList.toString());
          CustomerModel? item = customerList?.firstWhere(
            (customer) =>
                customer.customerID ==
                UserSimplePreferences.getSelectedCustomerID(),
            orElse: () => CustomerModel(),
          );
          log(item.toString());
          if (item != null && item != CustomerModel()) {
            Get.off(() => CustomerTaskTabScreen(item));
          }
        } else if (batchID != null &&
            batchID > 0) // route started already and not yet closed
        {
          Get.offAllNamed('/routeCustomers');
        } else if (routeID != null && routeID.trim().isEmpty) {
          homeController.getRoutePopUp(context);
        } else {
          Get.offAllNamed('/routeDetails');
        }
      }

      // if (isConnected == 'true' || DefaultSettings.isConnectionDisabled) {
      //   await checkForDefault();
      //   if (isLoggedIn == 'true') {
      //     print('INSIDE');
      //     // Get.offNamed(RouteManager().routes[3].name);
      //     Get.offAllNamed('/routeDetails');
      //   } else {
      //     Get.offNamed(RouteManager().routes[1].name);
      //   }
      // } else {

      // }
    });
  }

  checkForDefault() async {
    // String isConnectionAVailable =
    //     await UserSimplePreferences.getIsConnectionAvailable() ?? 'false';
    if (DefaultSettings.isConnectionDisabled) {
      await UserSimplePreferences.setIsConnectionAvailable('true');
      await UserSimplePreferences.setConnectionName(
          DefaultSettings.connectionName);
      await UserSimplePreferences.setServerIp(DefaultSettings.serverIP);
      await UserSimplePreferences.setPort(DefaultSettings.port);
      await UserSimplePreferences.setDatabase(DefaultSettings.databaseName);
      await setData();
      // connectionSettingController.saveSettings(settingsList);
      // await UserSimplePreferences.setConnection('true');
      connectionSettingController.saveSettings(settingsList);
      UserSimplePreferences.setConnection('true');
    }
  }

  setData() async {
    await connectionSettingController
        .getConnectionName(DefaultSettings.connectionName);
    await connectionSettingController.getServerIp(DefaultSettings.serverIP);
    await connectionSettingController.getPort(DefaultSettings.port);
    await connectionSettingController
        .getDatabaseName(DefaultSettings.databaseName);
  }
}
