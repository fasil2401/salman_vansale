import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_visit_controller_local.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_customer_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Customer%20Visit%20Log%20Model/customer_visit_log_model.dart';
import 'package:axoproject/model/Route%20Customer%20Model/route_customer_model.dart';
import 'package:axoproject/services/user_location/get_user_location.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as dev;

class CustomerTasksController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  var customerList = <dynamic>[].obs;
  final customerControler = Get.put(CustomerListController());
  final homeController = Get.put(HomeController());
  final customerVisitLocalController = Get.put(CustomerVisitLocalController());
  final cashRegisterControler = Get.put(PosCashRegisterListController());
  final routeCustomerController = Get.put(RouteCustomerListController());
  var selectedSkipReasons = 'no fuel'.obs;
  var isLoading = false.obs;
  var reasonForSkipping = TextEditingController().obs;
  var customer = RouteCustomerModel().obs;

  var isStarted = false.obs;
  skipReasons(String value) {
    selectedSkipReasons.value = value;
    update();
  }

  getRouteCustomer(String customerId) async {
    await routeCustomerController.getRouteCustomerList();
    customer.value = routeCustomerController.routeCustomerList
        .firstWhere((element) => element.customerID == customerId);
  }

  getAllCustomers() async {
    customerList.value = await customerControler.getCustomerList() ?? [];

    CustomerModel? customer = customerList.firstWhere(
      (element) =>
          element.customerID == UserSimplePreferences.getSelectedCustomerID(),
      orElse: () => null,
    );
    if (customer != null) {
      await homeController.getCustomerDetails(customer);
      dev.log(homeController.customer.value.customerID.toString(),
          name: 'customer id');
    }

    isStarted.value = UserSimplePreferences.getIsVisitStarted() ?? false;
  }

  startOrEndVisit(CustomerModel currentCust) async {
    isLoading.value = true;
    try {
      await GetUserLocation.getCurrentLocation();
      if (UserSimplePreferences.getLatitude()!.isEmpty ||
          UserSimplePreferences.getLongitude()!.isEmpty) {
        isLoading.value = false;
        SnackbarServices.errorSnackbar(
            "Error in location. Turn on Gps and try again");
        return;
      }
      if (!isStarted.value) {
        var uuid = Uuid();
        isStarted.value = true;
        UserSimplePreferences.setIsVisitStarted(true);
        UserSimplePreferences.setSelectedCustomerID(
            homeController.customer.value.customerID.toString());
        UserSimplePreferences.setVisitLogID(uuid.v1());
        List<Map<String, dynamic>> registers =
            await cashRegisterControler.getCashRegisterList();
        Map<String, dynamic>? thisRegister =
            registers.isNotEmpty ? registers.first : null;
        final CustomerVisitApiModel customerVisit = CustomerVisitApiModel(
            customerId: UserSimplePreferences.getSelectedCustomerID(),
            startTime: DateTime.now().toIso8601String(),
            visitLogId: UserSimplePreferences.getVisitLogID(),
            startLatitude: UserSimplePreferences.getLatitude(),
            startLongitude: UserSimplePreferences.getLongitude(),
            salesPersonId: UserSimplePreferences.getSalesPersonID(),
            routeID: UserSimplePreferences.getRouteId(),
            vanID: thisRegister?['CashRegisterID'] ?? "",
            isSkipped: 0);
        await customerVisitLocalController.insertCustomerVisit(
            header: customerVisit);
        isLoading.value = false;
      } else // End visit
      {
        isStarted.value = false;
        await customerVisitLocalController.updateEndVisit(
            endTime: DateTime.now().toIso8601String(),
            closeLat: UserSimplePreferences.getLatitude().toString(),
            closeLong: UserSimplePreferences.getLongitude().toString(),
            visitID: UserSimplePreferences.getVisitLogID().toString());
        UserSimplePreferences.setIsVisitStarted(false);
        UserSimplePreferences.setSelectedCustomerID("");
        UserSimplePreferences.setVisitLogID("");
        Get.offAllNamed('/routeCustomers');
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  skippedVisit() async {
    List<Map<String, dynamic>> registers =
        await cashRegisterControler.getCashRegisterList();
    Map<String, dynamic>? thisRegister =
        registers.isNotEmpty ? registers.first : null;
    final CustomerVisitApiModel customerVisit = CustomerVisitApiModel(
        customerId: UserSimplePreferences.getSelectedCustomerID(),
        startTime: DateTime.now().toIso8601String(),
        visitLogId: UserSimplePreferences.getVisitLogID(),
        startLatitude: UserSimplePreferences.getLatitude(),
        startLongitude: UserSimplePreferences.getLongitude(),
        salesPersonId: UserSimplePreferences.getSalesPersonID(),
        routeID: UserSimplePreferences.getRouteId(),
        vanID: thisRegister?['CashRegisterID'] ?? "",
        endTime: "",
        isSkipped: 1,
        reasonForSkipping: selectedSkipReasons.value == "others"
            ? reasonForSkipping.value.text
            : selectedSkipReasons.value);
    await customerVisitLocalController.insertCustomerVisit(
        header: customerVisit);
  }
}
