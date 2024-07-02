import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_price_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/expenses_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/new_order_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/payment_collection_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/payment_method_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sales_invoice_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sys_doc_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/tax_controller.dart';
import 'package:axoproject/controller/app%20controls/expenses_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Routes/user_route_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Route%20Model/route_model.dart';
import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/components/common_button.dart';
import 'package:axoproject/view/components/texts.dart';
import 'package:axoproject/view/route%20details/route_details_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getUserDetails();
   
  }

  // final sysDocLocalListController = Get.put(SysDocLocalListController());
  final loginController = Get.put(LoginController());
  final taxListController = Get.put(TaxListController());
  final sysDocController = Get.put(SysDocDetailListController());
  final cashRegisterController = Get.put(PosCashRegisterListController());
  final paymentMethodController = Get.put(PaymentMethodListController());
  final customerPriceController = Get.put(CustomerPriceListController());
  final expensesLocalController = Get.put(ExpensesTransactionLocalController());
  final salesInvoiceLocalController = Get.put(SalesInvoiceLocalController());
  final newOrderLocalController = Get.put(NewOrderLocalController());
  final paymentCollectionLocalController =
      Get.put(PaymentCollectionLocalController());
  var cashRegisterList = [].obs;
  var isLoading = false.obs;
  var sysDocList = [].obs;
  var sysDocFilterList = [].obs;
  var customer = CustomerModel().obs;
  var sysDoc = SysDocDetail().obs; //SysDocIdLocalListModel().obs;
  var commonFilterList = [].obs;
  var commonItemList = [].obs;
  var vendorList = [].obs;
  var inspectorList = [].obs;
  var originList = [].obs;
  var menuSecurityList = [].obs;
  var screenSecurityList = [].obs;
  var categoryList = [].obs;
  var brandList = [].obs;
  var styleList = [].obs;
  var employeeId = ''.obs;
  var model = [].obs;
  var response = 0.obs;
  var userImage = ''.obs;
  var userRouteList = <dynamic>[].obs;
  var userRoute = RouteModel().obs;
  var isUserRouteLoading = false.obs;
  var taxGroupList = <TaxModel>[].obs;
  var paymentMethodList = <PaymentMethodModel>[].obs;
  var printingMacAddress = ''.obs;
  var cashRegisterName = ''.obs;
  var salesPerson = ''.obs;
  var customerPriceList = <CustomerPriceModel>[].obs;

  // var user = UserModel().obs;

  getNextVoucher(
      {required String numberPrefix,
      required int nextNumber,
      required String sysDoc}) async {
    String data = '${numberPrefix}${nextNumber.toString().padLeft(6, '0')}';
    // bool isAvailbale = await salesInvoiceLocalController
    //     .isVoucherAlreadyPresent(voucher: data);
    int lastNumber = nextNumber;
    // if (isAvailbale) {
    lastNumber = await salesInvoiceLocalController.getLastVoucher(
            prefix: numberPrefix, sysDoc: sysDoc, nextNumber: nextNumber) ??
        0;
    data = '${numberPrefix}${lastNumber.toString().padLeft(6, '0')}';
    // }

    return data;
  }

  getNextVoucherPaymentCollection(
      {required String numberPrefix,
      required int nextNumber,
      required String sysDoc}) async {
    String data = '${numberPrefix}${nextNumber.toString().padLeft(6, '0')}';
    // bool isAvailbale = await salesInvoiceLocalController
    //     .isVoucherAlreadyPresent(voucher: data);
    int lastNumber = nextNumber;
    // if (isAvailbale) {
    lastNumber = await paymentCollectionLocalController.getLastVoucher(
            prefix: numberPrefix, sysDoc: sysDoc, nextNumber: nextNumber) ??
        0;
    data = '${numberPrefix}${lastNumber.toString().padLeft(6, '0')}';
    // }

    return data;
  }

  getNextVoucherNewOrder(
      {required String numberPrefix,
      required int nextNumber,
      required String sysDoc}) async {
    String data = '${numberPrefix}${nextNumber.toString().padLeft(6, '0')}';
    // bool isAvailbale = await salesInvoiceLocalController
    //     .isVoucherAlreadyPresent(voucher: data);
    int lastNumber = nextNumber;
    lastNumber = await newOrderLocalController.getLastVoucher(
            prefix: numberPrefix, sysDoc: sysDoc, nextNumber: nextNumber) ??
        0;
    data = '${numberPrefix}${lastNumber.toString().padLeft(6, '0')}';

    return data;
  }

  getNextVoucherExpenses(
      {required String numberPrefix,
      required int nextNumber,
      required String sysDoc}) async {
    String data = '${numberPrefix}${nextNumber.toString().padLeft(6, '0')}';
    // bool isAvailbale = await salesInvoiceLocalController
    //     .isVoucherAlreadyPresent(voucher: data);
    int lastNumber = nextNumber;
    // if (isAvailbale) {
    lastNumber = await expensesLocalController.getLastVoucher(
            prefix: numberPrefix, sysDoc: sysDoc, nextNumber: nextNumber) ??
        0;
    data = '${numberPrefix}${lastNumber.toString().padLeft(6, '0')}';
    // }

    return data;
  }

  updateSysdocNextNumber(
      {required int nextNumber, required String sysDoc}) async {
    nextNumber++;
    await sysDocController.updateSysDoc(nextNumber: nextNumber, sysDoc: sysDoc);
  }

  // Routes Popup start
  getFirstSysDoc({required String sysDocId}) async {
    // await getCashRegisterList();
    log(sysDocId, name: 'Sysdoc');
    await getSystemDocList();

    sysDoc.value = sysDocList.firstWhere(
      (element) => element.sysDocID == sysDocId,
      orElse: () => SysDocDetail(),
    );
    log("${sysDoc.value.sysDocID}");
    return sysDoc.value;
  }

  getRoutePopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () async {
                      await getUserRoute();
                      if (userRouteList.isNotEmpty) {
                        listRoutes(context);
                      }
                    },
                    child: Row(
                      children: [
                        Obx(
                          () => LargeText(
                            title: userRoute.value.routeName ?? 'Select Route',
                            color: mutedColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Obx(() => CommonButton(
                    title: 'CONTINUE',
                    callback: 'search',
                    isLoading: isUserRouteLoading.value,
                    onPressed: () {
                      if (userRoute.value.routeID == null) {
                        SnackbarServices.errorSnackbar('Please Select Route');
                      } else {
                        UserSimplePreferences.setRoute(
                            userRoute.value.routeName!);
                        UserSimplePreferences.setRouteId(
                            userRoute.value.routeID!);
                        print('TTEESS');
                        Get.offAllNamed('/routeDetails');
// Get.toNamed('/routeDetails');
// Get.to(() => RouteDetailsScreen());
                        // Navigator.pop(context);

                        // routeController.getRoute();
                        // Get.toNamed('/sync');
                        // Get.to(() => SyncScreenView());
                      }
                    },
                  ))
            ],
          ),
        );
      },
    );
  }

  assignUserRoute() async {
    userRoute.value.routeID = UserSimplePreferences.getRouteId();
    userRoute.value.routeName = UserSimplePreferences.getRoute();
    update();
  }

  listRoutes(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              'Routes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: userRouteList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          userRoute.value = userRouteList.value[index];
                          update();
                          await UserSimplePreferences.setRoute(
                              userRoute.value.routeName ?? '');
                          await UserSimplePreferences.setRouteId(
                              userRoute.value.routeID ?? '');
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          title: Text(
                              userRouteList.value[index].routeName ?? '',
                              style: TextStyle(fontFamily: 'Rubik')),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  final routeControler = Get.put(RouteListController());

  getUserRoute() async {
    isUserRouteLoading.value = true;
    String user = UserSimplePreferences.getUsername() ?? '';
    try {
      userRouteList = (await routeControler.getRouteList())!;
    } finally {
      isUserRouteLoading.value = false;
    }
  }

  //Routes Popup end

  Future<void> showPrivacyPolicy() async {
    print('start test');
    Uri url = Uri(
        scheme: 'https',
        host: 'axolonerp.com',
        path:
            'axolon-app-privacy-policy/'); // "https://pub.dev/packages/url_launcher/example";
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch URL');
    }
    print('end test');
  }

  getTaxGroupDetailList() async {
    taxGroupList.clear();
    await taxListController.getTaxList();
    taxGroupList.value = taxListController.taxList;
    update();
  }

  getCustomerPriceList() async {
    customerPriceList.clear();
    await customerPriceController.getCustomerPriceList();
    customerPriceList.value = customerPriceController.customerPriceList;
    update();
  }

  getSystemDocList() async {
    sysDocList.clear();
    await sysDocController.getSysDocList();
    sysDocList.value = sysDocController.sysDocDetailList;
  }

  getCashRegisterList() async {
    cashRegisterList.clear();
    await cashRegisterController.getCashRegisterList();
    cashRegisterList.value = cashRegisterController.posCashRegisterList;
  }

  getPaymentMethodList() async {
    paymentMethodList.clear();
    await paymentMethodController.getPaymentMethodList();
    paymentMethodList.value = paymentMethodController.paymentMethodList;
  }

  getCustomerDetails(CustomerModel customer) {
    this.customer.value = customer;
    update;
  }
}
