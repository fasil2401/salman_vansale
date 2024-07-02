import 'dart:async';
import 'dart:convert';

import 'package:axoproject/controller/Api%20Controllers/batch_sync_controller.dart';
import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/account_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/bank_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/company_controller.dart.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_balance_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_class_price_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_price_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_visit_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/expenses_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/location_price_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/new_order_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/outstanding_invoice_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/payment_collection_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/payment_method_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_lot_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_price_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sales_invoice_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/security_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sys_doc_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/tax_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/unit_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/van_price_controller.dart';
import 'package:axoproject/controller/app%20controls/splash_screen_controller.dart';
import 'package:axoproject/model/Account%20Model/account_model.dart';
import 'package:axoproject/model/Bank%20Model/bank_model.dart';
import 'package:axoproject/model/Company%20Model/company_model.dart';
import 'package:axoproject/model/Customer%20Balance%20Model/customer_balance_model.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/PaymentCollectionModel/payment_collection_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/New%20Order%20Model/create_new_order_model.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Pos%20Cash%20Register%20Model/pos_cash_register_model.dart';
import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Route%20Customer%20Model/route_customer_model.dart';
import 'package:axoproject/model/Route%20Model/route_model.dart';
import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/model/Security%20Model/security_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Api%20Services/common_api_service.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:axoproject/services/Enums/credit_limit_type.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/user_location/get_user_location.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:permission_handler/permission_handler.dart';

class SyncController extends GetxController {
  final visitLogLocalController = Get.put(CustomerVisitLocalController());
  final expenseLocalController = Get.put(ExpensesTransactionLocalController());
  final loginController = Get.put(LoginController());
  final batchSyncController = Get.put(BatchSyncController());
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final salesInvoiceLocalController = Get.put(SalesInvoiceLocalController());
  final newOrderLocalController = Get.put(NewOrderLocalController());
  final cashRegisterControler = Get.put(PosCashRegisterListController());
  final paymentCollectionLocalController =
      Get.put(PaymentCollectionLocalController());
  final companyControler = Get.put(CompanyListController());
  final customerControler = Get.put(CustomerListController());
  final routeCustomerControler = Get.put(RouteCustomerListController());
  final routeControler = Get.put(RouteListController());
  final sysDocControler = Get.put(SysDocDetailListController());
  final accountControler = Get.put(AccountListController());
  final securityControler = Get.put(SecurityListController());
  final taxControler = Get.put(TaxListController());
  final paymentMethodControler = Get.put(PaymentMethodListController());
  final bankControler = Get.put(BankListController());
  final productLotControler = Get.put(ProductLotListController());
  final productControler = Get.put(ProductListController());
  final unitControler = Get.put(UnitListController());
  final routePriceControler = Get.put(RoutePriceListController());
  final vanPriceControler = Get.put(VanPriceListController());
  final customerPriceControler = Get.put(CustomerPriceListController());
  final customerClassPriceControler =
      Get.put(CustomerClassPriceListController());
  final locationPriceControler = Get.put(LocationPriceListController());
  final outstandingControler = Get.put(OutstandingInvoiceListController());
  final balanceCustomerControler = Get.put(CustomerBalanceListController());

  var isAllSelectIn = false.obs;
  var isAllSelectOut = false.obs;

  // String regID = "VAN06";
  // String salesPersonID = "SP069";
  var regID = "".obs;

  // sync in start

  var cashRegisterToggle = false.obs;
  var companyToggle = false.obs;
  var routeToggle = false.obs;
  var customerToggle = false.obs;
  var productToggle = false.obs;
  var bankToggle = false.obs;
  var paymentMethodToggle = false.obs;
  var taxToggle = false.obs;
  var securityToggle = false.obs;
  var accountToggle = false.obs;

  var isCashRegisterSyncing = false.obs;
  var isCompanySyncing = false.obs;
  var isRouteSyncing = false.obs;
  var isCustomerSyncing = false.obs;
  var isProductSyncing = false.obs;
  var isBankSyncing = false.obs;
  var isPaymentMethodSyncing = false.obs;
  var isTaxSyncing = false.obs;
  var isSecuritySyncing = false.obs;
  var isAccountSyncing = false.obs;

  var isCashRegisterSuccess = false.obs;
  var isCompanySuccess = false.obs;
  var isRouteSuccess = false.obs;
  var isCustomersSuccess = false.obs;
  var isProductsSuccess = false.obs;
  var isBanksSuccess = false.obs;
  var isPaymentMethodsSuccess = false.obs;
  var isTaxSuccess = false.obs;
  var isSecuritySuccess = false.obs;
  var isAccountSuccess = false.obs;

  var isLoadingCashRegister = false.obs;
  var isLoadingCompany = false.obs;
  var isLoadingRoute = false.obs;
  var isLoadingCustomer = false.obs;
  var isLoadingProduct = false.obs;
  var isLoadingBank = false.obs;
  var isLoadingPaymentMethod = false.obs;
  var isLoadingTax = false.obs;
  var isLoadingSecurity = false.obs;
  var isLoadingAccount = false.obs;

  var errorCashRegister = ''.obs;
  var errorCompany = ''.obs;
  var errorRoute = ''.obs;
  var errorCustomer = ''.obs;
  var errorProduct = ''.obs;
  var errorBank = ''.obs;
  var errorPaymentMethod = ''.obs;
  var errorTax = ''.obs;
  var errorSecurity = ''.obs;
  var errorAccount = ''.obs;

  var isErrorCashRegister = false.obs;
  var isErrorCompany = false.obs;
  var isErrorRoute = false.obs;
  var isErrorCustomer = false.obs;
  var isErrorProduct = false.obs;
  var isErrorBank = false.obs;
  var isErrorPaymentMethod = false.obs;
  var isErrorTax = false.obs;
  var isErrorSecurity = false.obs;
  var isErrorAccount = false.obs;

  var posCashRegisterList = <PosCashRegisterModel>[].obs;
  var companyList = <CompanyModel>[].obs;
  var customerList = <CustomerModel>[].obs;
  var routeCustomerList = <RouteCustomerModel>[].obs;
  var routeList = <RouteModel>[].obs;
  var sysDocList = <SysDocDetail>[].obs;
  var accountList = <AccountModel>[].obs;
  var securityList = <SecurityModel>[].obs;
  var taxList = <TaxModel>[].obs;
  var paymentMethodList = <PaymentMethodModel>[].obs;
  var bankList = <BankModel>[].obs;
  var productList = <ProductModel>[].obs;
  var productLotList = <ProductLotModel>[].obs;
  var unitList = <UnitModel>[].obs;
  var routePriceList = <RoutePriceModel>[].obs;
  var vanPriceList = <VanPriceModel>[].obs;
  var customerPriceList = <CustomerPriceModel>[].obs;
  var customerClassPriceList = <CustomerClassPriceModel>[].obs;
  var locationPriceList = <LocationPriceModel>[].obs;
  var outstandingInvoiceList = <OutstandingInvoiceModel>[].obs;
  var balanceCustomerList = <CustomerBalanceModel>[].obs;

  selectAllIn() {
    isAllSelectIn.value = !isAllSelectIn.value;
    cashRegisterToggle.value = isAllSelectIn.value;
    companyToggle.value = isAllSelectIn.value;
    routeToggle.value = isAllSelectIn.value;
    customerToggle.value = isAllSelectIn.value;
    productToggle.value = isAllSelectIn.value;
    bankToggle.value = isAllSelectIn.value;
    paymentMethodToggle.value = isAllSelectIn.value;
    taxToggle.value = isAllSelectIn.value;
    securityToggle.value = isAllSelectIn.value;
    accountToggle.value = isAllSelectIn.value;
  }

  toggleCashRegister(bool value) {
    cashRegisterToggle.value = value;
  }

  toggleCompany(bool value) {
    companyToggle.value = value;
  }

  toggleRoute(bool value) {
    routeToggle.value = value;
  }

  toggleCustomer(bool value) {
    customerToggle.value = value;
  }

  toggleProduct(bool value) {
    productToggle.value = value;
  }

  toggleBank(bool value) {
    bankToggle.value = value;
  }

  togglePaymentMethod(bool value) {
    paymentMethodToggle.value = value;
  }

  toggleTax(bool value) {
    taxToggle.value = value;
  }

  toggleSecurity(bool value) {
    securityToggle.value = value;
  }

  toggleAccount(bool value) {
    accountToggle.value = value;
  }

  syncCashRegister({isResyncing = false}) async {
    isErrorCashRegister.value = false;
    if (cashRegisterToggle.value == false && isResyncing == false) return;
    isCashRegisterSyncing.value = true;
    isLoadingCashRegister.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    dynamic sysResult;
    try {
      var feedback = await ApiManager.fetchDataVAN(
        api: 'GetVANCashRegisterList?token=$token',
      );
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = PosCashRegisterListModel.fromJson(feedback);
          posCashRegisterList.value = result.Modelobject.where((r) =>
                  r.salesPersonID == UserSimplePreferences.getSalesPersonID())
              .toList();
          // developer.log(posCashRegisterList.value.toString());
          await cashRegisterControler.deleteTable();
          await cashRegisterControler.insertCashRegisterList(
              posCashRegisterList: posCashRegisterList);
          regID.value = posCashRegisterList.first.cashRegisterID!;
          // homeController.cashRegisterName.value =
          //     posCashRegisterList.first.cashRegisterName!;
          UserSimplePreferences.setVanName(
              posCashRegisterList.first.cashRegisterName!);
          // homeController.salesPerson.value =
          //     posCashRegisterList.first.salesPersonID!;
          try {
            var feedbackSys = await ApiManager.fetchDataVAN(
              api: 'GetSysDocDetails?token=$token&vanID=${regID.value}',
            );
            if (feedbackSys != null) {
              if (feedbackSys["result"] == 1) {
                sysResult = SysDocDetailListModel.fromJson(feedbackSys);
                sysDocList.value = sysResult.modelObject;
                await sysDocControler.deleteTable();
                await sysDocControler.insertSysDocList(
                    sysDocDetailList: sysDocList);

                List<Map<String, dynamic>> registers =
                    await cashRegisterControler.getCashRegisterList();
                var thisRegister = registers.firstWhereOrNull(
                    (item) => item['CashRegisterID'] == regID.value);
                if (thisRegister != null) {
                  var feedbackBatch = await ApiManager.fetchDataVAN(
                    api:
                        'GetActiveBatchNumber?token=$token&locationID=${thisRegister['LocationID']}',
                  );
                  if (feedbackBatch["result"] == 1) {
                    if (feedbackBatch["Modelobject"] > 0 &&
                        UserSimplePreferences.getBatchID() != null) {
                      // await batchSyncController.closeBatch();
                    }
                  }
                }

                isLoadingCashRegister.value = false;
                isCashRegisterSuccess.value = true;
              }
            } else {
              errorCashRegister.value = feedbackSys["msg"].toString();
              isErrorCashRegister.value = true;
              isLoadingCashRegister.value = false;
              isCashRegisterSuccess.value = false;
            }
          } catch (eSysDoc) {
            isLoadingCashRegister.value = false;
            isCashRegisterSuccess.value = false;
            errorCashRegister.value = eSysDoc.toString();
            isErrorCashRegister.value = true;
          } finally {}
        } else {
          errorCashRegister.value = feedback["msg"].toString();
          isErrorCashRegister.value = true;
          isLoadingCashRegister.value = false;
          isCashRegisterSuccess.value = false;
        }

        // print('register id is $registerID');
      } else {
        isCashRegisterSuccess.value = false;
        errorCashRegister.value = "Error! Please try again";
      }
    } catch (e) {
      isLoadingCashRegister.value = false;
      isCashRegisterSuccess.value = false;
      isErrorCashRegister.value = true;
      errorCashRegister.value = e.toString();
    } finally {
      isLoadingCashRegister.value = false;
    }
  }

  syncCompany() async {
    isErrorCompany.value = false;
    if (companyToggle.value == false) return;
    isCompanySyncing.value = true;
    isLoadingCompany.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataVAN(
        api: 'GetCompanyInfo?token=$token',
      );
      if (feedback != null) {
        if (feedback["result"] == 1) {
          UserSimplePreferences.setCompanyTRN(
              feedback['Modelobject'][0]['Notes']);
          UserSimplePreferences.setCompanyName(
              feedback['Modelobject'][0]['CompanyName']);
          String addressPrint =
              feedback['AddressModel'][0]['AddressPrintFormat'];
          String formattedAddress = addressPrint.replaceAll('\n', ' ');
          UserSimplePreferences.setCompanyAddress(formattedAddress);
          result = CompanyListModel.fromJson(feedback);
          companyList.value = result.modelObject;
          await companyControler.deleteTable();
          await companyControler.insertCompanyList(companyList: companyList);
          isLoadingCompany.value = false;
          isCompanySuccess.value = true;
        } else {
          errorCompany.value = feedback["msg"].toString();
          isErrorCompany.value = true;
          isLoadingCompany.value = false;
          isCompanySuccess.value = false;
        }
      } else {
        isCompanySuccess.value = false;
        errorCompany.value = "Error! Please try again";
        isErrorCompany.value = true;
      }
    } catch (e) {
      isLoadingCompany.value = false;
      isCompanySuccess.value = false;
      isErrorCompany.value = true;
      errorCompany.value = e.toString();
    } finally {
      isLoadingCompany.value = false;
    }
  }

  syncRoute() async {
    isErrorRoute.value = false;
    if (routeToggle.value == false) return;
    isRouteSyncing.value = true;
    isLoadingRoute.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataVAN(
        api: 'GetVanRouteList?token=$token&vanID=${regID.value}',
      );
      if (feedback != null) {
        if (feedback["result"] == 1) {
          UserSimplePreferences.setRouteName(
              feedback['Modelobject'][0]['RouteName']);
          result = RouteListModel.fromJson(feedback);
          routeList.value = result.modelObject;
          await routeControler.deleteTable();
          await routeControler.insertRouteList(routeList: routeList);
          isLoadingRoute.value = false;
          isRouteSuccess.value = true;
        } else {
          isLoadingRoute.value = false;
          isRouteSuccess.value = false;
          errorRoute.value = feedback["msg"].toString();
          isErrorRoute.value = true;
        }
      } else {
        isRouteSuccess.value = false;
        isErrorRoute.value = true;
        errorRoute.value = "Error! Please try again";
      }
    } catch (e) {
      isLoadingRoute.value = false;
      isRouteSuccess.value = false;
      isErrorRoute.value = true;
      errorRoute.value = e.toString();
    } finally {
      isLoadingRoute.value = false;
    }
  }

  syncCustomer({isResyncing = false}) async {
    isErrorCustomer.value = false;
    if (customerToggle.value == false && isResyncing == false) return;

    if (isResyncing) {
      await cashRegisterControler.getCashRegisterList();
      regID.value =
          cashRegisterControler.posCashRegisterList.first.cashRegisterID!;
    }
    isCustomerSyncing.value = true;
    isLoadingCustomer.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    dynamic routeResult;
    dynamic outstandingResult;
    dynamic balanceResult;
    try {
      var feedback = await ApiManager.fetchDataVAN(
        api: 'GetVanCustomersList?token=$token&vanID=${regID.value}',
      );
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = CustomerListModel.fromJson(feedback);
          routeResult = RouteCustomerListModel.fromJson(feedback);
          routeCustomerList.value = routeResult.modelObject;
          customerList.value = result.modelObject;
          await customerControler.deleteTable();
          await customerControler.insertCustomerList(
              customerList: customerList);

          var feedbackOutstanding = await ApiManager.fetchDataVAN(
            api:
                'GetVanCustomersOutstandingInvoicesList?token=$token&vanID=${regID.value}',
          );
          if (feedbackOutstanding != null) {
            if (feedbackOutstanding["result"] == 1) {
              outstandingResult =
                  OutstandingInvoiceListModel.fromJson(feedbackOutstanding);
              //  print(outstandingResult.modelObject);
              // outstandingInvoiceList.value= outstandingResult.modelObject; // !.where((item) => item.amountDue! > 0).toList();
              outstandingInvoiceList.value = outstandingResult.modelObject!
                  .where((OutstandingInvoiceModel item) => item.amountDue! > 0)
                  .toList();

              await outstandingControler.deleteTable();
              await outstandingControler.insertOutstandingInvoiceList(
                  outstandingInvoiceList: outstandingInvoiceList);

              var feedbackBalance = await ApiManager.fetchDataVAN(
                api:
                    'GetVanCustomersSnapBalance?token=$token&vanID=${regID.value}',
              );
              if (feedbackBalance != null) {
                if (feedbackBalance["result"] == 1) {
                  balanceResult =
                      CustomerBalanceListModel.fromJson(feedbackBalance);
                  balanceCustomerList.value = balanceResult.modelObject;
                  var balanceChildCustomerList = <CustomerBalanceModel>[].obs;
                  var balanceParentCustomerList = <CustomerBalanceModel>[].obs;
                  balanceChildCustomerList.value = balanceCustomerList
                      .where((customer) =>
                          customer.parentCustomerID != "" &&
                          customer.creditLimitType ==
                              CreditLimitType.parentsubLimit)
                      .toList();
                  balanceParentCustomerList.value = balanceCustomerList
                      .where((customer) => !(customer.parentCustomerID != "" &&
                          customer.creditLimitType ==
                              CreditLimitType.parentsubLimit))
                      .toList();

                  balanceChildCustomerList.value.forEach((childCustomer) {
                    CustomerBalanceModel? firstCustomer =
                        balanceParentCustomerList.value.firstWhere(
                      (customer) =>
                          customer.customerID == childCustomer.parentCustomerID,
                    );

                    if (firstCustomer != null) {
                      childCustomer.creditAmount = firstCustomer.creditAmount;
                      childCustomer.isInactive = firstCustomer.isInactive;
                      childCustomer.creditLimitType =
                          firstCustomer.creditLimitType;
                      childCustomer.balance = firstCustomer.balance;
                      childCustomer.pdcAmount = firstCustomer.pdcAmount;
                      childCustomer.isHold = firstCustomer.isHold;
                      childCustomer.tempCL = firstCustomer.tempCL;
                      if (firstCustomer.openDNAmount != null) {
                        childCustomer.balance = (childCustomer.balance ?? 0.0) +
                            (firstCustomer.openDNAmount ?? 0.0).toDouble();
                      }
                    }
                  });

                  routeCustomerList.forEach((routeCust) {
                    var cust = balanceCustomerList.firstWhereOrNull(
                        (item) => item.customerID == routeCust.customerID);
                    if (cust != null) {
                      routeCust.inActive = 1;
                      routeCust.creditLimitType = cust.creditLimitType;
                      if (cust.creditLimitType == CreditLimitType.unlimited) {
                        routeCust.noCredit = 0;
                      } else {
                        routeCust.noCredit = (cust.creditLimitType ==
                                    CreditLimitType.noCredit ||
                                (cust.creditAmount! - (cust.balance ?? 0)) <= 0)
                            ? 1
                            : 0;
                      }
                      routeCust.creditAvailable =
                          (cust.creditAmount! - (cust.balance ?? 0));
                      routeCust.isHold = cust.isHold;
                      routeCust.creditAvailable =
                          routeCust.creditAvailable! + (cust.tempCL ?? 0);
                    }
                  });

                  await balanceCustomerControler.deleteTable();
                  await balanceCustomerControler.insertCustomerBalanceList(
                      customerBalanceList: balanceChildCustomerList);
                  await balanceCustomerControler.insertCustomerBalanceList(
                      customerBalanceList: balanceParentCustomerList);
                  await routeCustomerControler.deleteTable();
                  await routeCustomerControler.insertRouteCustomerList(
                      routeCustomerList: routeCustomerList);
                  isLoadingCustomer.value = false;
                  isCustomersSuccess.value = true;
                  print('DONE');
                } else {
                  isLoadingCustomer.value = false;
                  isCustomersSuccess.value = false;
                  errorCustomer.value = feedbackBalance["msg"].toString();
                  isErrorCustomer.value = true;
                }
              } else {
                isLoadingCustomer.value = false;
                isCustomersSuccess.value = false;
                isErrorCustomer.value = true;
              }
            } else {
              isLoadingCustomer.value = false;
              isCustomersSuccess.value = false;
              isErrorCustomer.value = true;
              errorCustomer.value = feedbackOutstanding["msg"].toString();
            }
          } else {
            isLoadingCustomer.value = false;
            isCustomersSuccess.value = false;
            isErrorCustomer.value = true;
          }

          isLoadingCustomer.value = false;
          isCustomersSuccess.value = true;
        } else {
          isLoadingCustomer.value = false;
          isCustomersSuccess.value = false;
          isErrorCustomer.value = true;
          errorCustomer.value = feedback["msg"].toString();
        }
      } else {
        isCustomersSuccess.value = false;
        isErrorCustomer.value = true;
        errorCustomer.value = "Error! Please try again";
      }
    } catch (e) {
      isLoadingCustomer.value = false;
      isCustomersSuccess.value = false;
      errorCustomer.value = e.toString();
      isErrorCustomer.value = true;
    } finally {
      isLoadingCustomer.value = false;
    }
  }

  syncProducts({isResyncing = false}) async {
    isErrorProduct.value = false;
    if (productToggle.value == false && isResyncing == false) return;
    if (isResyncing) {
      await cashRegisterControler.getCashRegisterList();
      regID.value =
          cashRegisterControler.posCashRegisterList.first.cashRegisterID!;
    }
    isProductSyncing.value = true;
    isLoadingProduct.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    dynamic resultProduct;
    dynamic resultRoutePrice;
    try {
      var feedback = await ApiManager.fetchDataVAN(
          api: 'GetProductLotList?token=${token}&vanID=${regID.value}');
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = ProductLotListModel.fromJson(feedback);
          productLotList.value = result.modelObject;
          await productLotControler.deleteTable();
          await productLotControler.insertProductLotList(
              productLotList: productLotList);
          isLoadingProduct.value = false;
          isProductsSuccess.value = true;

          var feedbackProduct = await ApiManager.fetchDataVAN(
              api: 'GetVanProductList?token=$token&vanID=${regID.value}');
          if (feedbackProduct != null) {
            resultProduct = ProductListModel.fromJson(feedbackProduct);

            if (feedbackProduct["result"] == 1) {
              productList.value = resultProduct.products;
              unitList.value = resultProduct.units;
              await productControler.deleteTable();
              await productControler.insertProductList(
                  productList: productList);
              await unitControler.deleteTable();
              await unitControler.insertUnitList(unitList: unitList);

              var feedbackRoutePrice = await ApiManager.fetchDataVAN(
                  api:
                      'GetVanPriceListDetails?token=$token&vanID=${regID.value}');

              if (feedbackRoutePrice != null) {
                resultRoutePrice = PriceListModel.fromJson(feedbackRoutePrice);

                if (feedbackRoutePrice["result"] == 1) {
                  routePriceList.value = resultRoutePrice.routePriceList;
                  vanPriceList.value = resultRoutePrice.vanPriceList;
                  customerPriceList.value = resultRoutePrice.customerPriceList;
                  customerClassPriceList.value =
                      resultRoutePrice.customerClassPriceList;
                  locationPriceList.value = resultRoutePrice.locationPriceList;

                  await routePriceControler.deleteTable();
                  await routePriceControler.insertRoutePriceList(
                      routePriceList: routePriceList);

                  await vanPriceControler.deleteTable();
                  await vanPriceControler.insertVanPriceList(
                      vanPriceList: vanPriceList);

                  await customerPriceControler.deleteTable();
                  await customerPriceControler.insertCustomerPriceList(
                      customerPriceList: customerPriceList);

                  await customerClassPriceControler.deleteTable();
                  await customerClassPriceControler
                      .insertCustomerClassPriceList(
                          customerClassPriceList: customerClassPriceList);

                  await locationPriceControler.deleteTable();
                  await locationPriceControler.insertLocationPriceList(
                      locationPriceList: locationPriceList);

                  isLoadingProduct.value = false;
                  isProductsSuccess.value = true;
                } else {
                  isLoadingProduct.value = false;
                  isProductsSuccess.value = false;
                  errorProduct.value = feedbackRoutePrice["msg"].toString();
                  isErrorProduct.value = true;
                }
              } else {
                isLoadingProduct.value = false;
                isProductsSuccess.value = false;
                isErrorProduct.value = true;
              }
            } else {
              isLoadingProduct.value = false;
              isProductsSuccess.value = false;
              errorProduct.value = feedbackProduct["msg"].toString();
              isErrorProduct.value = true;
            }
          } else {
            isProductsSuccess.value = false;
            errorProduct.value = feedback["msg"].toString();
            isErrorProduct.value = true;
          }
        } else {
          isProductsSuccess.value = false;
          errorProduct.value = "ERROR! Please try again";
          isErrorProduct.value = true;
        }
      }
    } catch (e) {
      isLoadingProduct.value = false;
      isProductsSuccess.value = false;
      errorProduct.value = e.toString();
      isErrorProduct.value = true;
    } finally {
      isLoadingProduct.value = false;
    }
  }

  syncBanks() async {
    isErrorBank.value = false;
    if (bankToggle.value == false) return;
    isBankSyncing.value = true;
    isLoadingBank.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback =
          await ApiManager.fetchDataVAN(api: 'GetBankList?token=${token}');
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = BankListModel.fromJson(feedback);
          bankList.value = result.modelobject;
          await bankControler.deleteTable();
          await bankControler.insertBankList(bankList: bankList);
          isLoadingBank.value = false;
          isBanksSuccess.value = true;
        } else {
          errorBank.value = feedback["msg"].toString();
          isErrorBank.value = true;
          isLoadingBank.value = false;
          isBanksSuccess.value = false;
        }
      } else {
        errorBank.value = "ERROR! Please try again";
        isErrorBank.value = true;
      }
    } catch (e) {
      isLoadingBank.value = false;
      isBanksSuccess.value = false;
      errorBank.value = e.toString();
      isErrorBank.value = true;
    } finally {
      isLoadingBank.value = false;
    }
  }

  syncPaymentMethods() async {
    isErrorPaymentMethod.value = false;
    if (paymentMethodToggle.value == false) return;
    isPaymentMethodSyncing.value = true;
    isLoadingPaymentMethod.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataVAN(
          api:
              'GetVanPaymentMethodsList?token=${token}&cashRegisterID=${regID.value}&showInactive=true');
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = PaymentMethodListModel.fromJson(feedback);
          paymentMethodList.value = result.model;
          await paymentMethodControler.deleteTable();
          await paymentMethodControler.insertPaymentMethodList(
              paymentMethodList: paymentMethodList);
          isLoadingPaymentMethod.value = false;
          isPaymentMethodsSuccess.value = true;
        } else {
          isLoadingPaymentMethod.value = false;
          isPaymentMethodsSuccess.value = false;
          errorPaymentMethod.value = feedback["msg"].toString();
          isErrorPaymentMethod.value = true;
        }
      } else {
        errorPaymentMethod.value = "ERROR! Please try again";
        isErrorPaymentMethod.value = true;
      }
    } catch (e) {
      isLoadingPaymentMethod.value = false;
      isPaymentMethodsSuccess.value = false;
      errorPaymentMethod.value = e.toString();
      isErrorPaymentMethod.value = true;
    } finally {
      isLoadingPaymentMethod.value = false;
    }
  }

  syncTaxes() async {
    isErrorTax.value = false;
    if (taxToggle.value == false) return;
    isTaxSyncing.value = true;
    isLoadingTax.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataVAN(
          api: 'GetTaxGroupDetailList?token=${token}');
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = TaxListModel.fromJson(feedback);
          taxList.value = result.modelObject;
          await taxControler.deleteTable();
          await taxControler.insertTaxList(taxList: taxList);
          isLoadingTax.value = false;
          isTaxSuccess.value = true;
        } else {
          isLoadingTax.value = false;
          isTaxSuccess.value = false;
          errorTax.value = feedback["msg"].toString();
          isErrorTax.value = true;
        }
      } else {
        errorTax.value = "ERROR! Please try again";
        isErrorTax.value = true;
      }
    } catch (e) {
      isLoadingTax.value = false;
      isTaxSuccess.value = false;
      errorTax.value = e.toString();
      isErrorTax.value = true;
    } finally {
      isLoadingTax.value = false;
    }
  }

  syncSecurity() async {
    isErrorSecurity.value = false;
    if (securityToggle.value == false) return;
    isSecuritySyncing.value = true;
    isLoadingSecurity.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataVAN(
          api:
              'GetSecurityList?token=${token}&userid=${UserSimplePreferences.getUsername() ?? ''}');
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = SecurityListModel.fromJson(feedback);
          securityList.value = result.modelObject;
          await securityControler.deleteTable();
          await securityControler.insertSecurityList(
              securityList: securityList);
          isLoadingSecurity.value = false;
          isSecuritySuccess.value = true;
        } else {
          isLoadingSecurity.value = false;
          isSecuritySuccess.value = false;
          errorSecurity.value = feedback["msg"].toString();
          isErrorSecurity.value = true;
        }
      } else {
        errorSecurity.value = "ERROR! Please try again";
        isErrorSecurity.value = true;
      }
    } catch (e) {
      isLoadingSecurity.value = false;
      isSecuritySuccess.value = false;
      errorSecurity.value = e.toString();
      isErrorSecurity.value = true;
    } finally {
      isLoadingSecurity.value = false;
    }
  }

  syncAccount() async {
    isErrorAccount.value = false;
    if (accountToggle.value == false) return;
    isAccountSyncing.value = true;
    isLoadingAccount.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataVAN(
          api:
              'GetExpenseAccountsList?token=${token}&cashRegisterID=${regID.value}');
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = AccountListModel.fromJson(feedback);
          accountList.value = result.modelObject;
          await accountControler.deleteTable();
          await accountControler.insertAccountList(accountList: accountList);
          isLoadingAccount.value = false;
          isAccountSuccess.value = true;
        } else {
          isLoadingAccount.value = false;
          isAccountSuccess.value = false;
          errorAccount.value = feedback["msg"].toString();
          isErrorAccount.value = true;
        }
      } else {
        errorAccount.value = "ERROR! Please try again";
        isErrorAccount.value = true;
      }
    } catch (e) {
      isLoadingAccount.value = false;
      isAccountSuccess.value = false;
      errorAccount.value = e.toString();
      isErrorAccount.value = true;
    } finally {
      isLoadingAccount.value = false;
    }
  }

  bool isSyncingNow = false;
  startInSync() async {
    if (isSyncingNow) {
      return;
    }
    await cashRegisterControler.getCashRegisterList();
    if (cashRegisterControler.posCashRegisterList.isNotEmpty) {
      regID.value = cashRegisterControler.posCashRegisterList.isNotEmpty
          ? cashRegisterControler.posCashRegisterList
              .firstWhereOrNull((item) => true)
              ?.cashRegisterID
          : null;
    }
    if (regID.value.isEmpty && !cashRegisterToggle.value) {
      SnackbarServices.errorSnackbar(
          "Cash Register not solved. please sync Cash register");
      return;
    }
    isSyncingNow = true;
    await syncCashRegister();
    await syncCompany();
    await syncRoute();
    await syncCustomer();
    await syncProducts();
    await syncBanks();
    await syncPaymentMethods();
    await syncTaxes();
    await syncSecurity();
    await syncAccount();
    if (isCashRegisterSyncing.value == true ||
        isCompanySyncing.value == true ||
        isRouteSyncing.value == true ||
        isCustomerSyncing.value == true ||
        isProductSyncing.value == true ||
        isBankSyncing.value == true ||
        isPaymentMethodSyncing.value == true ||
        isTaxSyncing.value == true ||
        isSecuritySyncing.value == true ||
        isAccountSyncing.value == true) {
      if (isErrorCashRegister.value == false &&
          isErrorCompany.value == false &&
          isErrorRoute.value == false &&
          isErrorCustomer.value == false &&
          isErrorProduct.value == false &&
          isErrorBank.value == false &&
          isErrorPaymentMethod.value == false &&
          isErrorTax.value == false &&
          isErrorSecurity.value == false &&
          isErrorAccount.value == false) {
        SnackbarServices.successSnackbar('Syncing Finished Succesfully');
      } else {
        SnackbarServices.errorSnackbar('Syncing Finished With Errors !');
      }
    }
    isSyncingNow = false;
  }

  //sync in end

  checkIsSynced() {
    bool isSynced = UserSimplePreferences.getIsSyncCompleted() ?? false;
    bool status = false;
    if (isSynced == false) {
      if (isCashRegisterSuccess.value &&
          isCompanySuccess.value &&
          isRouteSuccess.value &&
          isCustomersSuccess.value &&
          isProductsSuccess.value &&
          isBanksSuccess.value &&
          isPaymentMethodsSuccess.value &&
          isTaxSuccess.value &&
          isSecuritySuccess.value &&
          isAccountSuccess.value) {
        status = true;
        UserSimplePreferences.setIsSyncCompleted(true);
      } else {
        SnackbarServices.errorSnackbar('Please Complete Syncing to Continue!');
        status = false;
        UserSimplePreferences.setIsSyncCompleted(false);
      }
    } else {
      status = true;
      UserSimplePreferences.setIsSyncCompleted(true);
    }
    return status;
  }

// sync out start

  var salesToggle = false.obs;
  var transactionsToggle = false.obs;
  var expensesToggle = false.obs;
  var salesOrderToggle = false.obs;
  var visitlogToggle = false.obs;
  var activitylogToggle = false.obs;

  var isSalesSyncing = false.obs;
  var isTransactionsSyncing = false.obs;
  var isExpensesSyncing = false.obs;
  var isSalesOrderSyncing = false.obs;
  var isVisitlogSyncing = false.obs;
  var isActivitylogSyncing = false.obs;

  var isSalesSuccess = false.obs;
  var isTransactionSuccess = false.obs;
  var isEquipmentSuccess = false.obs;
  var isExpensesSuccess = false.obs;
  var isSalesOrderSuccess = false.obs;
  var isVisitlogSuccess = false.obs;
  var isActivitylogSuccess = false.obs;

  var isLoadingSales = false.obs;
  var isLoadingTransactions = false.obs;
  var isLoadingExpenses = false.obs;
  var isLoadingSalesOrder = false.obs;
  var isLoadingVisitlog = false.obs;
  var isLoadingActivitylog = false.obs;

  var errorSales = ''.obs;
  var errorTransactions = ''.obs;
  var errorExpenses = ''.obs;
  var errorSalesOrder = ''.obs;
  var errorVisitlog = ''.obs;
  var errorActivitylog = ''.obs;

  var isErrorSales = false.obs;
  var isErrorTransactions = false.obs;
  var isErrorExpenses = false.obs;
  var isErrorSalesOrder = false.obs;
  var isErrorVisitlog = false.obs;
  var isErrorActivitylog = false.obs;

  selectAllOut() {
    isAllSelectOut.value = !isAllSelectOut.value;
    salesToggle.value = isAllSelectOut.value;
    transactionsToggle.value = isAllSelectOut.value;
    expensesToggle.value = isAllSelectOut.value;
    salesOrderToggle.value = isAllSelectOut.value;
    visitlogToggle.value = isAllSelectOut.value;
    activitylogToggle.value = isAllSelectOut.value;
  }

  toggleSales(bool value) {
    salesToggle.value = value;
  }

  toggleTransactions(bool value) {
    transactionsToggle.value = value;
  }

  toggleExpenses(bool value) {
    expensesToggle.value = value;
  }

  toggleSalesOrder(bool value) {
    salesOrderToggle.value = value;
  }

  toggleVisitlog(bool value) {
    visitlogToggle.value = value;
  }

  toggleActivitylog(bool value) {
    activitylogToggle.value = value;
  }

  syncSales() async {
    isErrorSales.value = false;
    if (salesToggle.value == false) return;
    isSalesSyncing.value = true;
    isLoadingSales.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback =
          await ApiManager.fetchDataCommon(api: 'GetSales?token=${token}');
    } finally {
      isLoadingSales.value = false;
    }
  }

  syncTransactions() async {
    isErrorTransactions.value = false;
    if (transactionsToggle.value == false) return;
    isTransactionsSyncing.value = true;
    isLoadingTransactions.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataCommon(
          api: 'GetTransactions?token=${token}');
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  syncExpenses() async {
    isErrorExpenses.value = false;
    if (expensesToggle.value == false) return;
    isExpensesSyncing.value = true;
    // isLoadingExpenses.value = true;
    isExpensesSuccess.value = true;

    // await loginController.getLogin();
    // if (loginController.access.value.isEmpty) {
    //   await loginController.getLogin();
    // }
    // final String token = loginController.access.value;
    // final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    // dynamic result;
    // try {
    //   var feedback =
    //       await ApiManager.fetchDataCommon(api: 'GetExpenses?token=${token}');
    // } finally {
    //   isLoadingExpenses.value = false;
    // }
  }

  syncSalesOrder() async {
    isErrorSalesOrder.value = false;
    if (salesOrderToggle.value == false) return;
    isSalesOrderSyncing.value = true;
    isLoadingSalesOrder.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    final String userRoute = UserSimplePreferences.getRouteId() ?? '';

    dynamic result;
    try {
      var feedback =
          await ApiManager.fetchDataCommon(api: 'GetSalesOrder?token=${token}');
      if (feedback != null && feedback['data'] != null) {}
    } finally {
      isSalesOrderSyncing.value = false;
      isLoadingSalesOrder.value = false;
    }
  }

  syncVisitlog() async {
    isErrorVisitlog.value = false;
    if (visitlogToggle.value == false) return;
    await visitLogLocalController.getAllCustomerVisit();
    if (visitLogLocalController.customerVisits.isEmpty) {
      isVisitlogSyncing.value = true;
      isVisitlogSuccess.value = true;
      return;
    }
    isVisitlogSyncing.value = true;
    isLoadingVisitlog.value = true;
    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    for (var header in visitLogLocalController.customerVisits) {
      if (header.isSynced == 1) {
        isLoadingVisitlog.value = false;
        isVisitlogSuccess.value = true;
        continue;
      } else {
        isVisitlogSyncing.value = true;
        isLoadingVisitlog.value = true;
      }

      final data = jsonEncode({
        "token": token,
        "Description": '',
        "CloseLongitude": header.closeLongitude ?? '',
        "CloseLatitude": header.closeLatitude ?? '',
        "StartLongitude": header.startLongitude ?? '',
        "StartLatitude": header.startLatitude ?? '',
        "GeoLocation": '',
        "VanID": header.vanID ?? '',
        "VisitEnd": header.endTime ?? '',
        "VisitStart": header.startTime ?? '',
        "CustomerID": header.customerId ?? '',
        "RouteID": header.routeID ?? '',
        "VisitID": 0,
        "UserID": UserSimplePreferences.getUsername() ?? ''
      });
      try {
        developer.log(data.toString(), name: 'data passing');
        var feedback = await ApiManager.fetchDataRawBodyVAN(
            api: "CreateCustomerVisitLog", data: data);
        developer.log(feedback.toString(), name: 'data');
        if (feedback != null) {
          if (feedback['res'] == 1) {
            isVisitlogSuccess.value = true;
            isLoadingVisitlog.value = false;
            await visitLogLocalController.updateCustomerVisit(
              startTime: header.startTime ?? '',
              isSynced: 1,
              isError: 0,
              error: '',
            );

            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.other.value,
                    date: DateTime.now().toIso8601String(),
                    description: "OutSynced Visit Logs",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
          } else {
            // developer.log('Getting into else case');
            isLoadingVisitlog.value = false;
            isVisitlogSuccess.value = false;
            errorVisitlog.value = feedback['msg'] ?? feedback['err'];
            isErrorVisitlog.value = true;
            // SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
            await visitLogLocalController.updateCustomerVisit(
              startTime: header.startTime ?? '',
              isSynced: 0,
              isError: 1,
              error: feedback['msg'] ?? feedback['err'],
            );
          }
        }
      } catch (e) {
        // developer.log('Getting into error case');
        isLoadingVisitlog.value = false;
        isVisitlogSuccess.value = false;
        errorVisitlog.value = e.toString();
        isErrorVisitlog.value = true;
      } finally {
        isLoadingVisitlog.value = false;
      }
    }
  }

  syncSalesInvoice() async {
    double taxAmount = 0.0;
    double total = 0.0;
    isErrorSales.value = false;
    if (salesToggle.value == false) return;
    await salesInvoiceLocalController.getsalesInvoiceHeaders();
    if (salesInvoiceLocalController.salesInvoiceHeaders.isEmpty) {
      // SnackbarServices.errorSnackbar("Sales Invoice is empty!");
      isSalesSyncing.value = true;
      isSalesSuccess.value = true;
      return;
    }
    isSalesSyncing.value = true;
    isLoadingSales.value = true;

    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }

    final String token = loginController.access.value;
    for (var header in salesInvoiceLocalController.salesInvoiceHeaders) {
      if (header.isSynced == 1) {
        // isSalesSyncing.value = false;
        isLoadingSales.value = false;
        isSalesSuccess.value = true;

        continue;
      } else {
        isSalesSyncing.value = true;
        isLoadingSales.value = true;
      }
      total = 0.0;
      taxAmount = 0.0;
      List<Map<String, dynamic>> baseCurrency =
          await DBHelper().queryBaseCurrencyId();
      String baseCurrencyId = baseCurrency.isNotEmpty
          ? baseCurrency[0]['${CompanyListLocalImportantNames.baseCurrencyID}']
          : '';
      await salesInvoiceLocalController.getsalesInvoiceDetails(
          voucher: header.voucherid ?? '');
      await salesInvoiceLocalController.getsalesInvoiceLotDetails(
          voucher: header.voucherid ?? '');
      await salesInvoiceLocalController.getsalesInvoiceTaxDetails(
          voucher: header.voucherid ?? '');
      await routeControler.getRouteList();
      List<SalesInvoiceDetailApiModel> detail = [];
      List<SalesInvoiceLotApiModel> lot = [];
      List<TaxGroupDetail> tax = [];
      total = (total - (header.discount ?? 0.0));
      final data = jsonEncode({
        "token": token,
        "IsnewRecord": true,
        "VANSaleDetails": salesInvoiceLocalController.salesInvoiceDetail,
        "TaxGroupDetail": salesInvoiceLocalController.salesInvoiceTaxDetail,
        "VANSaleProductLotDetails":
            salesInvoiceLocalController.salesInvoiceLotDetail,
        "Sysdocid": header.sysdocid,
        "Voucherid": header.voucherid,
        "DivisionID": header.divisionId,
        "CompanyID": header.companyId,
        "ShiftID": header.shiftId,
        "BatchID": header.batchId,
        "CustomerID": header.customerId,
        "TransactionDate": header.transactionDate,
        "registerId": header.registerId,
        "PaymentType": header.paymentType,
        "SalespersonId": header.salespersonId,
        "Note": header.note,
        "Total": header.total,
        "TaxAmount": header.taxAmount,
        "Discount": header.discount,
        "TaxGroupId": header.taxGroupId,
        "Reference": header.reference ?? "",
        "Reference1": header.reference1 ?? "",
        "TaxOption": header.taxOption ?? 0,
        "DateCreated": header.dateCreated,
        "AccountID": header.accountID ?? "",
        "PaymentMethodID": header.paymentMethodID ?? "",
        "CurrencyID": baseCurrencyId
      });
      developer.log("${data}");
      try {
        var feedback = await ApiManager.fetchDataRawBodyVAN(
            api: "CreateVanSalesPOS", data: data);
        developer.log("$feedback", name: "sales invoice feedback");
        if (feedback != null) {
          if (feedback['res'] == 1) {
            isSalesSuccess.value = true;
            isLoadingSales.value = false;
            await salesInvoiceLocalController.updatesalesInvoiceHeaders(
                voucherId: header.voucherid ?? '',
                isSynced: 1,
                isError: 0,
                error: '',
                docNo: feedback['docNo']);
            await salesInvoiceLocalController.updatesalesInvoiceDetails(
                voucherId: header.voucherid ?? '', docNo: feedback['docNo']);
            await salesInvoiceLocalController.updatesalesInvoiceLotDetails(
                voucherId: header.voucherid ?? '', docNo: feedback['docNo']);
            await salesInvoiceLocalController.updatesalesInvoiceTaxDetails(
                voucherId: header.voucherid ?? '', docNo: feedback['docNo']);
            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.other.value,
                    date: DateTime.now().toIso8601String(),
                    description: "OutSynced Sales Invoice",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
          } else {
            isLoadingSales.value = false;
            isSalesSuccess.value = false;
            errorSales.value = feedback['msg'] ?? feedback['err'];
            isErrorSales.value = true;
            // SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
            await salesInvoiceLocalController.updatesalesInvoiceHeaders(
                voucherId: header.voucherid ?? '',
                isSynced: 0,
                isError: 1,
                error: feedback['msg'] ?? feedback['err'],
                docNo: header.voucherid ?? '');
          }
        }
      } catch (e) {
        isLoadingSales.value = false;
        isSalesSuccess.value = false;
        errorSales.value = e.toString();
        isErrorSales.value = true;
      } finally {
        isLoadingSales.value = false;
      }
    }
    // productToggle.value == true;
    isLoadingSales.value = true;
    await syncProducts(isResyncing: true);

    isLoadingSales.value = false;
  }

  // syncActivitylog() async {
  //   isErrorActivitylog.value = false;
  //   if (activitylogToggle.value == false) return;
  //   isActivitylogSyncing.value = true;
  //   // isLoadingActivitylog.value = true;
  //   isActivitylogSuccess.value = true;

  //   // await loginController.getLogin();
  //   // if (loginController.access.value.isEmpty) {
  //   //   await loginController.getLogin();
  //   // }
  //   // final String token = loginController.access.value;
  //   // final String userRoute = UserSimplePreferences.getRouteId() ?? '';

  //   // dynamic result;
  //   // try {
  //   //   var feedback = await ApiManager.fetchDataCommon(
  //   //       api: 'GetActivityLog?token=${token}');
  //   // } finally {
  //   //   isLoadingActivitylog.value = false;
  //   // }
  // }

  synNewOrder() async {
    isErrorSalesOrder.value = false;
    if (salesOrderToggle.value == false) return;
    await newOrderLocalController.getNewOrderHeaders();
    if (newOrderLocalController.newOrderHeaders.isEmpty) {
      isSalesOrderSyncing.value = true;
      isSalesOrderSuccess.value = true;
      return;
    }
    isSalesOrderSyncing.value = true;
    isLoadingSalesOrder.value = true;
    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    for (var header in newOrderLocalController.newOrderHeaders) {
      if (header.isSynced == 1) {
        isLoadingSalesOrder.value = false;
        isSalesOrderSuccess.value = true;
        continue;
      } else {
        isSalesOrderSyncing.value = true;
        isLoadingSalesOrder.value = true;
      }
      await newOrderLocalController.getNewOrderDetails(
          voucher: header.voucherid ?? "");
      await newOrderLocalController.getNewOrderLotDetails(
          voucher: header.voucherid ?? "");
      await newOrderLocalController.getNewOrderTaxDetails(
          voucher: header.voucherid ?? '');
      List<SalesOrderDetail> detail = [];
      List<TaxDetail> tax = [];
      List<VanSaleProductLotDetail> lot = [];
      for (var item in newOrderLocalController.newOrderDetail) {
        detail.add(SalesOrderDetail(
          amount: item.amount ?? 0.0,
          cost: 0.0,
          costcategoryid: "",
          description: item.description ?? '',
          itemcode: item.productId ?? "",
          rowindex: item.rowindex,
          itemtype: 0,
          quantity: item.quantity ?? 0.0,
          equipmentid: "",
          jobid: "",
          locationid: item.locationid ?? '',
          // thisRegister!['LocationID'],
          remarks: "",
          sourcerowindex: "",
          sourcesysdocid: "",
          sourcevoucherid: "",
          specificationid: "",
          styleid: "",
          taxamount: item.taxamount ?? 0.0,
          taxgroupid: item.taxgroupid ?? '',
          taxoption: item.taxoption ?? 0,
          unitid: item.unitid ?? '',
          unitprice: item.unitprice ?? 0.0,
        ));
      }
      if (newOrderLocalController.newOrderLotDetail.isNotEmpty) {
        for (var lots in newOrderLocalController.newOrderLotDetail) {
          lot.add(VanSaleProductLotDetail(
              rowIndex: lots.rowIndex,
              sysDocId: lots.sysDocId,
              voucherId: lots.voucherId,
              lotNumber: lots.lotNumber ?? "",
              locationId: lots.locationId,
              productId: lots.productId ?? "",
              quantity: lots.quantity ?? 0,
              reference2: lots.reference2 ?? "",
              reference: lots.reference ?? "",
              unitPrice: lots.unitPrice ?? 0.0,
              unitid: lots.unitId ?? "",
              binId: "",
              sourceLotNumber: ""));
        }
      }
      if (newOrderLocalController.newOrderTaxDetail.isNotEmpty) {
        for (var item in newOrderLocalController.newOrderTaxDetail) {
          tax.add(TaxDetail(
              accountId: item.accountId ?? "",
              calculationMethod: item.calculationMethod ?? "",
              currencyId: item.currencyId ?? "",
              currencyRate: item.currencyRate ?? 0.0,
              orderIndex: item.orderIndex ?? 0,
              rowIndex: item.rowIndex,
              sysDocId: item.sysDocId ?? "",
              taxAmount: item.taxAmount ?? 0.0,
              taxGroupId: item.taxGroupId ?? "",
              taxItemId: item.taxItemId ?? "",
              taxItemName: item.taxItemName ?? "",
              taxLevel: item.taxLevel ?? 0,
              taxRate: item.taxRate ?? 0.0,
              token: token,
              voucherId: item.voucherId ?? ""));
        }
      }

      Map<String, Map<String, dynamic>> groupedTaxDetails = {};
      newOrderLocalController.newOrderTaxDetail.forEach((taxDetail) {
        if (!groupedTaxDetails.containsKey(taxDetail.taxItemId)) {
          developer.log(taxDetail.taxItemId.toString(), name: 'Tax Item Id');
          groupedTaxDetails[taxDetail.taxItemId] = {
            // 'taxRateSum': 0.0,
            'taxAmountSum': 0.0,
          };
        }

        // Update the sums for tax rate and tax amount
        NewOrderDetailApiModel item = newOrderLocalController.newOrderDetail
            .firstWhere((element) => element.rowindex == taxDetail.orderIndex);
        groupedTaxDetails[taxDetail.taxItemId]?['taxRate'] = taxDetail.taxRate;
        groupedTaxDetails[taxDetail.taxItemId]?['taxAmountSum'] +=
            (taxDetail.taxAmount * item.quantity);
      });
      groupedTaxDetails.forEach((taxItemId, values) {
        // print('Tax Code: $taxCode');
        // print('Total Tax Rate: ${values['taxRate']}');
        // print('Total Tax Amount: ${values['taxAmountSum']}');
        // print('---');

        tax.insert(
            0,
            TaxDetail(
                calculationMethod: "1",
                taxItemId: taxItemId,
                taxRate: values['taxRate'],
                taxLevel: 0,
                accountId: "",
                token: token,
                taxGroupId: header.taxGroupId ?? "",
                currencyId: "",
                taxItemName: "",
                orderIndex: 0,
                currencyRate: 0.0,
                rowIndex: -1,
                sysDocId: header.sysdocid ?? "",
                taxAmount: values['taxAmountSum'],
                voucherId: header.voucherid ?? ""));
      });

      final data = jsonEncode({
        "token": token,
        "Sysdocid": header.sysdocid ?? '',
        "Voucherid": header.voucherid ?? '',
        "Companyid": header.companyid ?? '',
        "Divisionid": "",
        "Customerid": header.customerid ?? '',
        "Transactiondate": header.transactiondate ?? '',
        "Salespersonid": header.salespersonid ?? '',
        "Salesflow": 0,
        "Isexport": true,
        "Requireddate": DateTime.now().toIso8601String(),
        "Duedate": DateTime.now().toIso8601String(),
        "ETD": DateTime.now().toIso8601String(),
        "Shippingaddress": "",
        "Shiptoaddress": "",
        "Billingaddress": "",
        "Customeraddress": header.customeraddress ?? '',
        "Priceincludetax": header.priceincludetax == 0 ? false : true,
        "Status": 0,
        "Currencyid": "",
        "Currencyrate": 0,
        "Currencyname": "",
        "Termid": "",
        "Shippingmethodid": "",
        "Reference": "",
        "Reference2": "",
        "Note": header.note ?? "",
        "POnumber": "",
        "Isvoid": true,
        "Discount": header.discount ?? 0.0,
        "Total": header.total ?? 0.0,
        "Taxamount": header.taxamount ?? 0.0,
        "Sourcedoctype": 0,
        "Jobid": "",
        "Costcategoryid": "",
        "Payeetaxgroupid": header.payeetaxgroupid ?? '',
        "Taxoption": header.taxoption ?? 0,
        "Roundoff": 0,
        "Ordertype": 0,
        "Isnewrecord": true,
        "SalesOrderDetails": detail,
        "TaxDetails": tax,
        "VANSaleProductLotDetails": lot
      });
      developer.log("${data}");
      try {
        var feedback = await ApiManager.fetchCommonDataRawBody(
            api: "CreateSalesOrder", data: data);
        developer.log(feedback.toString(), name: 'data');
        if (feedback != null) {
          if (feedback['res'] == 1) {
            isSalesOrderSuccess.value = true;
            isLoadingSalesOrder.value = false;
            await newOrderLocalController.updateNewOrderHeaders(
                voucherId: header.voucherid ?? '',
                isSynced: 1,
                isError: 0,
                error: '',
                docNo: feedback['docNo']);
            await newOrderLocalController.updateNewOrderDetails(
                voucherId: header.voucherid ?? '', docNo: feedback['docNo']);
            await newOrderLocalController.updateNewOrderLotDetails(
                voucherId: header.voucherid ?? '', docNo: feedback['docNo']);
            await newOrderLocalController.updateNewOrderTaxDetails(
                voucherId: header.voucherid ?? '', docNo: feedback['docNo']);
            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.other.value,
                    date: DateTime.now().toIso8601String(),
                    description: "OutSynced Sales Order",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
          } else {
            isLoadingSalesOrder.value = false;
            isSalesOrderSuccess.value = false;
            errorSalesOrder.value = feedback['msg'] ?? feedback['err'];
            isErrorSalesOrder.value = true;
            // SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
            await newOrderLocalController.updateNewOrderHeaders(
                voucherId: header.voucherid ?? '',
                isSynced: 0,
                isError: 1,
                error: feedback['msg'] ?? feedback['err'],
                docNo: header.voucherid ?? '');
          }
        }
      } catch (e) {
        isLoadingSalesOrder.value = false;
        isSalesOrderSuccess.value = false;
        errorSalesOrder.value = e.toString();
        isErrorSalesOrder.value = true;
      } finally {
        isLoadingSalesOrder.value = false;
      }
    }
  }

  syncPaymentCollection() async {
    isErrorTransactions.value = false;
    if (transactionsToggle.value == false) return;
    await paymentCollectionLocalController.getTransactionHeaders();
    if (paymentCollectionLocalController.transactionHeaders.isEmpty) {
      isTransactionsSyncing.value = true;
      isTransactionSuccess.value = true;
      return;
    }
    isTransactionsSyncing.value = true;
    isLoadingTransactions.value = true;
    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;

    for (var header in paymentCollectionLocalController.transactionHeaders) {
      if (header.isSynced == 1) {
        isLoadingTransactions.value = false;
        isTransactionSuccess.value = true;
        continue;
      } else {
        isTransactionsSyncing.value = true;
        isLoadingTransactions.value = true;
      }
      await paymentCollectionLocalController.getTransactionAllocationDetail(
          voucher: header.voucherId.toString());
      await paymentCollectionLocalController.getTransactionDetails(
          voucher: header.voucherId.toString());
      List<TransactionAllocationDetailModel> allocation = [];
      for (var item
          in paymentCollectionLocalController.transactionAllocationDetail) {
        if (item.isChecked == 1) {
          developer.log("${item.isChecked}");
          allocation.add(item);
        }
      }

      var data = jsonEncode({
        "token": token,
        "SysDocType": header.sysDocType,
        "SysDocID": header.sysDocId,
        "VoucherID": header.voucherId,
        "Reference": header.reference,
        "Description": header.description,
        "TransactionDate": header.transactionDate!.toIso8601String(),
        "DueDate": header.dueDate!.toIso8601String(),
        "RegisterID": header.registerId,
        "DivisionID": header.divisionId,
        "CompanyID": header.companyId,
        "PayeeID": header.payeeId,
        "PayeeType": header.payeeType,
        "CurrencyID": header.currencyId,
        "CurrencyRate": header.currencyRate,
        "Amount": header.amount,
        "IsPOS": header.isPos,
        "IsCheque": header.isCheque,
        "POSShiftID": header.posShiftId,
        "POSBatchID": header.posBatchId,
        "TransactionDetails":
            paymentCollectionLocalController.transactionDetail,
        "TransactionAllocationDetails": allocation,
      });

      try {
        developer.log("${data}", name: "allocation");
        var feedback = await ApiManager.fetchDataRawBodyVAN(
            api: "CreateTransaction", data: data);
        developer.log(feedback.toString(), name: 'data');
        if (feedback != null) {
          if (feedback['res'] == 1) {
            isTransactionSuccess.value = true;
            isLoadingTransactions.value = false;
            await paymentCollectionLocalController.updateCreateTransferHeader(
                voucherId: header.voucherId ?? '',
                isSynced: 1,
                isError: 0,
                error: '',
                docNo: feedback['docNo']);
            await paymentCollectionLocalController
                .updateTransactionAllocationDetails(
                    voucherId: header.voucherId ?? "",
                    docNo: feedback['docNo'],
                    isSynced: 1);
            await paymentCollectionLocalController.updateTransactionDetails(
                voucherId: header.voucherId ?? "", docNo: feedback['docNo']);
            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.other.value,
                    date: DateTime.now().toIso8601String(),
                    description: "OutSynced Payment Transaction",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
          } else {
            isLoadingTransactions.value = false;
            isTransactionSuccess.value = false;
            errorTransactions.value = feedback['err'] ?? feedback['msg'];
            isErrorTransactions.value = true;
            // SnackbarServices.errorSnackbar(feedback['err']);
            await paymentCollectionLocalController.updateCreateTransferHeader(
                voucherId: header.voucherId!,
                isSynced: 0,
                isError: 1,
                error: feedback['err'],
                docNo: header.voucherId!);
          }
        }
      } catch (e) {
        isLoadingTransactions.value = false;
        isTransactionSuccess.value = false;
        errorTransactions.value = e.toString();
        isErrorTransactions.value = true;
      } finally {
        isLoadingTransactions.value = false;
      }
    }
  }

  syncExpenseTransaction() async {
    double taxAmount = 0.0;
    double total = 0.0;
    isErrorExpenses.value = false;
    if (expensesToggle.value == false) return;
    await expenseLocalController.getExpensesHeaders();
    if (expenseLocalController.expenseTransactionHeader.isEmpty) {
      isExpensesSyncing.value = true;
      isExpensesSuccess.value = true;
      return;
    }
    isExpensesSyncing.value = true;
    isLoadingExpenses.value = true;
    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    for (var header in expenseLocalController.expenseTransactionHeader) {
      if (header.isSynced == 1) {
        isLoadingExpenses.value = false;
        isExpensesSuccess.value = true;
        continue;
      } else {
        isExpensesSyncing.value = true;
        isLoadingExpenses.value = true;
      }
      total = 0.0;
      taxAmount = 0.0;
      await expenseLocalController.getExpenseDetails(
          voucher: header.voucherID ?? '');
      await expenseLocalController.getExpenseTaxDetails(
          voucher: header.voucherID ?? '');
      List<SalesPOSTaxGroupDetailApiModel> tax = [];
      for (SalesPOSTaxGroupDetailApiModel item
          in expenseLocalController.salesPOSTaxGroupDetail) {
        tax.add(SalesPOSTaxGroupDetailApiModel(
            calculationMethod: item.calculationMethod,
            currencyID: item.currencyID,
            items: item.items,
            orderIndex: item.orderIndex,
            rowIndex: item.rowIndex,
            sysDocId: item.sysDocId,
            taxAmount: item.taxAmount,
            taxCode: item.taxCode,
            taxGroupId: item.taxGroupId,
            taxRate: item.taxRate,
            voucherId: item.voucherId));
      }
      Map<String, Map<String, dynamic>> groupedTaxDetails = {};
      tax.forEach((taxDetail) {
        if (!groupedTaxDetails.containsKey(taxDetail.taxCode)) {
          groupedTaxDetails[taxDetail.taxCode!] = {
            // 'taxRateSum': 0.0,
            'taxAmountSum': 0.0,
          };
        }
        ExpenseTransactionDetailsAPIModel item = expenseLocalController
            .expenseTransactionDetails
            .firstWhere((element) => element.rowIndex == taxDetail.orderIndex);
        groupedTaxDetails[taxDetail.taxCode]?['taxRate'] = taxDetail.taxRate;
        groupedTaxDetails[taxDetail.taxCode]?['taxAmountSum'] +=
            (taxDetail.taxAmount);
      });
      groupedTaxDetails.forEach((taxCode, values) {
        tax.insert(
            0,
            SalesPOSTaxGroupDetailApiModel(
                calculationMethod: "1",
                taxCode: taxCode,
                taxRate: values['taxRate'],
                taxGroupId: header.taxGroupId ?? "",
                items: "",
                orderIndex: 0,
                rowIndex: -1,
                sysDocId: header.sysDocID ?? "",
                currencyID: "",
                taxAmount: double.parse(
                    InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                            values['taxAmountSum'])
                        .toStringAsFixed(2)),
                voucherId: header.voucherID ?? ""));
        taxAmount += double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                    values['taxAmountSum'])
                .toStringAsFixed(2));
      });
      final data = jsonEncode({
        "token": token,
        "SysDocID": header.sysDocID,
        "VoucherID": header.voucherID,
        "Reference": header.reference,
        "TransactionDate": header.transactionDate,
        "RegisterID": header.registerID,
        "DivisionID": header.divisionID,
        "CompanyID": header.companyID,
        "Amount": (header.amount ?? 0.0) - (taxAmount),
        "TaxGroupId": header.taxGroupId,
        "TaxAmount": double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(taxAmount)
                .toStringAsFixed(2)),
        "TransactionDetails": expenseLocalController.expenseTransactionDetails,
        "ExpenseTaxDetails": tax
      });
      developer.log("${data}");
      try {
        var feedback = await ApiManager.fetchDataRawBodyVAN(
            api: "CreateExpenseTransaction", data: data);
        developer.log("$feedback");
        if (feedback != null) {
          if (feedback['res'] == 1) {
            isExpensesSuccess.value = true;
            isLoadingExpenses.value = false;
            await expenseLocalController.updateExpensesHeaders(
                voucherId: header.voucherID ?? '',
                isSynced: 1,
                isError: 0,
                error: '',
                docNo: feedback['docNo']);
            await expenseLocalController.updateExpensesDetails(
                voucherId: header.voucherID ?? '', docNo: feedback['docNo']);
            await expenseLocalController.updateExpensesTaxDetails(
                voucherId: header.voucherID ?? '', docNo: feedback['docNo']);
            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.other.value,
                    date: DateTime.now().toIso8601String(),
                    description: "OutSynced Expense Transaction",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
          } else {
            isLoadingSales.value = false;
            isSalesSuccess.value = false;
            errorSales.value = feedback['msg'] ?? feedback['err'];
            isErrorExpenses.value = true;
            // SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
            await expenseLocalController.updateExpensesHeaders(
                voucherId: header.voucherID ?? '',
                isSynced: 0,
                isError: 1,
                error: feedback['msg'] ?? feedback['err'],
                docNo: header.voucherID ?? '');
          }
        }
      } catch (e) {
        isLoadingExpenses.value = false;
        isExpensesSuccess.value = false;
        errorExpenses.value = e.toString();
        isErrorExpenses.value = true;
      } finally {
        isLoadingExpenses.value = false;
      }
    }
    // productToggle.value == true;
  }

  syncActivitylog() async {
    isErrorActivitylog.value = false;
    if (activitylogToggle.value == false) return;
    await activityLogLocalController.getActivityLogList();
    if (activityLogLocalController.activityLogList.isEmpty) {
      isActivitylogSyncing.value = true;
      isActivitylogSuccess.value = true;
      return;
    }
    isActivitylogSyncing.value = true;
    isLoadingActivitylog.value = true;
    await loginController.getLogin();
    if (loginController.access.value.isEmpty) {
      await loginController.getLogin();
    }
    final String token = loginController.access.value;
    for (var header in activityLogLocalController.activityLogList) {
      if (header.isSynced == 1) {
        isLoadingActivitylog.value = false;
        isActivitylogSuccess.value = true;
        continue;
      } else {
        isActivitylogSyncing.value = true;
        isLoadingActivitylog.value = true;
      }

      final data = jsonEncode({
        "token": token,
        "SysDocID": header.sysDocId ?? '',
        "VoucherID": header.voucherId ?? '',
        "Description": header.description ?? '',
        "MachineID": header.machine ?? '',
        "ActivityType": header.activityType ?? 0,
        "User": header.userId ?? '',
        "TransactTime": header.date ?? ''
      });
      try {
        var feedback = await ApiManager.fetchDataRawBodyVAN(
            api: "CreateActivityLog", data: data);
        developer.log(feedback.toString(), name: 'data');
        if (feedback != null) {
          if (feedback['res'] == 1) {
            isActivitylogSuccess.value = true;
            isLoadingActivitylog.value = false;
            await activityLogLocalController.updateUserActivity(
                voucherId: header.voucherId ?? '',
                isSynced: 1,
                isError: 0,
                error: '',
                docNo: feedback['docNo']);

            activityLogLocalController.insertactivityLogList(
                activityLog: UserActivityLogModel(
                    sysDocId: "",
                    voucherId: "",
                    activityType: ActivityTypes.other.value,
                    date: DateTime.now().toIso8601String(),
                    description: "OutSynced Acitvity Logs",
                    machine: UserSimplePreferences.getDeviceInfo(),
                    userId: UserSimplePreferences.getUsername(),
                    isSynced: 0));
          } else {
            isLoadingActivitylog.value = false;
            isActivitylogSuccess.value = false;
            errorActivitylog.value = feedback['msg'] ?? feedback['err'];
            isErrorActivitylog.value = true;
            // SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
            await activityLogLocalController.updateUserActivity(
                voucherId: header.voucherId ?? '',
                isSynced: 0,
                isError: 1,
                error: feedback['msg'] ?? feedback['err'],
                docNo: header.voucherId ?? '');
          }
        }
      } catch (e) {
        isLoadingActivitylog.value = false;
        isActivitylogSuccess.value = false;
        errorActivitylog.value = e.toString();
        isErrorActivitylog.value = true;
      } finally {
        isLoadingActivitylog.value = false;
      }
    }
  }

  startOutSync() async {
    // await syncSales();
    // await syncTransactions();
    // await syncExpenses();
    // await syncSalesOrder();
    await syncSalesInvoice();
    await syncPaymentCollection();
    await syncExpenseTransaction();
    await synNewOrder();
    await syncVisitlog();
    await syncActivitylog();
    if (isSalesSyncing.value == true ||
        isTransactionsSyncing.value == true ||
        isExpensesSyncing.value == true ||
        isSalesOrderSyncing.value == true ||
        isVisitlogSyncing.value == true ||
        isActivitylogSyncing.value == true) {
      if (isErrorExpenses.value == false &&
          isErrorVisitlog.value == false &&
          isErrorActivitylog.value == false &&
          isErrorSales.value == false &&
          isErrorTransactions.value == false &&
          isErrorSalesOrder.value == false) {
        SnackbarServices.successSnackbar('Syncing Finished Successfully!');
      } else {
        SnackbarServices.errorSnackbar('Syncing Finished With Errors!');
      }
    }
  }

//sync out end
}
