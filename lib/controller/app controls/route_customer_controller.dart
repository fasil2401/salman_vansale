import 'dart:convert';
import 'dart:developer';
import 'package:axoproject/controller/Api%20Controllers/batch_sync_controller.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_customer_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Routes/user_route_model.dart';
import 'package:axoproject/model/Route%20Customer%20Model/route_customer_model.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:developer' as developer;

import 'package:open_filex/open_filex.dart';

class RouteCustomerController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  var customerList = <dynamic>[].obs;
  final customerControler = Get.put(CustomerListController());
  final routeCustomerController = Get.put(RouteCustomerListController());
  var filterCustomerList = [].obs;
  var routeCustomerList = [].obs;
  var selectedFilter = ''.obs;
  var selectedStatus = ''.obs;

  filter(String value) {
    selectedFilter.value = value;
    update();
  }

  status(String value) {
    selectedStatus.value = value;
    update();
  }

  getAllCustomers() async {
    customerList.value = await customerControler.getCustomerList() ?? [];

    await routeCustomerController.getRouteCustomerList();
    routeCustomerList.value = routeCustomerController.routeCustomerList;
    filterCustomerList.value = routeCustomerList;
    // log(filterCustomerList.value.toString(), name: 'Rpoute Customer');
    update();
  }

  searchCustomer(String value) {
    filterCustomerList.value = routeCustomerList.where((element) {
      if (selectedFilter.value == 'name') {
        return element.customerName.toLowerCase().contains(value.toLowerCase());
      } else if (selectedFilter.value == 'id') {
        return element.routeCustomerID
            .toLowerCase()
            .contains(value.toLowerCase());
      }
      return element.customerName.toLowerCase().contains(value.toLowerCase()) ||
          element.routeCustomerID.toLowerCase().contains(value.toLowerCase());
    }).toList();
    update();
  }

  CustomerModel getRouteCustomer(String customerId) {
    CustomerModel customer =
        customerList.firstWhere((element) => element.customerID == customerId);
    return customer;
  }
}
