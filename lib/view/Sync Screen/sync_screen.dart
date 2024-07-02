import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/sync_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/internet_check.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../controller/Local Db Controller/user_activity_log_local_controller.dart';

class SyncScreenView extends StatefulWidget {
  SyncScreenView({super.key});

  @override
  State<SyncScreenView> createState() => _SyncScreenViewState();
}

class _SyncScreenViewState extends State<SyncScreenView>
    with SingleTickerProviderStateMixin {
  final syncController = Get.put(SyncController());

  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synchronisation'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: AppColors.white,
            child: SizedBox(
              height: 60,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.mutedColor,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(
                    text: 'In Sync',
                    icon: Icon(Icons.cloud_download_outlined),
                  ),
                  Tab(
                      text: 'Out Sync',
                      icon: Icon(Icons.cloud_upload_outlined)),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String dbFilePath = join(await getDatabasesPath(),
                    "axoVan.db"); //'/path/to/your/db/file.db3';
                shareDBFile(dbFilePath);
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInSync(context),
          _buildOutSync(context),
        ],
      ),

      // SafeArea(
      //   child: ListView(
      //     children: [
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       GFAccordion(
      //         title: 'In Sync',
      //         showAccordion: false,
      //         titleBorderRadius: BorderRadius.circular(5),
      //         expandedTitleBackgroundColor: Theme.of(context).primaryColor,
      //         collapsedTitleBackgroundColor: Colors.black38,
      //         collapsedIcon:
      //             const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      //         expandedIcon:
      //             const Icon(Icons.keyboard_arrow_up, color: Colors.white),
      //         textStyle: TextStyle(
      //           color: Colors.white,
      //         ),
      //         titlePadding:
      //             EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
      //         contentChild: Column(
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     syncController.selectAllIn();
      //                   },
      //                   splashColor: lightGrey,
      //                   splashFactory: InkRipple.splashFactory,
      //                   child: Container(
      //                     width: 20,
      //                     height: 20,
      //                     decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: Colors.white,
      //                       border: Border.all(
      //                         color: mutedColor,
      //                         width: 1,
      //                       ),
      //                     ),
      //                     child: Center(
      //                       child: Obx(() => Icon(
      //                             Icons.check,
      //                             size: 15,
      //                             color: syncController.isAllSelectIn.value
      //                                 ? Theme.of(context).primaryColor
      //                                 : Colors.transparent,
      //                           )),
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   width: 10,
      //                 ),
      //                 AutoSizeText(
      //                   'Select All',
      //                   minFontSize: 16,
      //                   maxFontSize: 20,
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.w500,
      //                     color: mutedColor,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             tableHeader(context),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingCashRegister.value,
      //                 isSuccess: syncController.isCashRegisterSuccess.value,
      //                 isSyncing: syncController.isCashRegisterSyncing.value,
      //                 title: 'Cash Register',
      //                 onChanged: (value) {
      //                   syncController.toggleCashRegister(value);
      //                 },
      //                 toggleValue: syncController.cashRegisterToggle.value,
      //                 errorMsg: syncController.errorCashRegister.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingCompany.value,
      //                 isSuccess: syncController.isCompanySuccess.value,
      //                 isSyncing: syncController.isCompanySyncing.value,
      //                 title: 'Company',
      //                 onChanged: (value) {
      //                   syncController.toggleCompany(value);
      //                 },
      //                 toggleValue: syncController.companyToggle.value,
      //                 errorMsg: syncController.errorCompany.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingRoute.value,
      //                 isSuccess: syncController.isRouteSuccess.value,
      //                 isSyncing: syncController.isRouteSyncing.value,
      //                 title: 'Routes',
      //                 onChanged: (value) {
      //                   syncController.toggleRoute(value);
      //                 },
      //                 toggleValue: syncController.routeToggle.value,
      //                 errorMsg: syncController.errorRoute.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingCustomer.value,
      //                 isSuccess: syncController.isCustomersSuccess.value,
      //                 isSyncing: syncController.isCustomerSyncing.value,
      //                 title: 'Customers',
      //                 onChanged: (value) {
      //                   syncController.toggleCustomer(value);
      //                 },
      //                 toggleValue: syncController.customerToggle.value,
      //                 errorMsg: syncController.errorCustomer.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingProduct.value,
      //                 isSuccess: syncController.isProductsSuccess.value,
      //                 isSyncing: syncController.isProductSyncing.value,
      //                 title: 'Products',
      //                 onChanged: (value) {
      //                   syncController.toggleProduct(value);
      //                 },
      //                 toggleValue: syncController.productToggle.value,
      //                 errorMsg: syncController.errorProduct.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingBank.value,
      //                 isSuccess: syncController.isBanksSuccess.value,
      //                 isSyncing: syncController.isBankSyncing.value,
      //                 title: 'Banks',
      //                 onChanged: (value) {
      //                   syncController.toggleBank(value);
      //                 },
      //                 toggleValue: syncController.bankToggle.value,
      //                 errorMsg: syncController.errorBank.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingPaymentMethod.value,
      //                 isSuccess: syncController.isPaymentMethodsSuccess.value,
      //                 isSyncing: syncController.isPaymentMethodSyncing.value,
      //                 title: 'Payment Methods',
      //                 onChanged: (value) {
      //                   syncController.togglePaymentMethod(value);
      //                 },
      //                 toggleValue: syncController.paymentMethodToggle.value,
      //                 errorMsg: syncController.errorPaymentMethod.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingTax.value,
      //                 isSuccess: syncController.isTaxSuccess.value,
      //                 isSyncing: syncController.isTaxSyncing.value,
      //                 title: 'Taxes',
      //                 onChanged: (value) {
      //                   syncController.toggleTax(value);
      //                 },
      //                 toggleValue: syncController.taxToggle.value,
      //                 errorMsg: syncController.errorTax.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingSecurity.value,
      //                 isSuccess: syncController.isSecuritySuccess.value,
      //                 isSyncing: syncController.isSecuritySyncing.value,
      //                 title: 'Security',
      //                 onChanged: (value) {
      //                   syncController.toggleSecurity(value);
      //                 },
      //                 toggleValue: syncController.securityToggle.value,
      //                 errorMsg: syncController.errorSecurity.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingAccount.value,
      //                 isSuccess: syncController.isAccountSuccess.value,
      //                 isSyncing: syncController.isAccountSyncing.value,
      //                 title: 'Account',
      //                 onChanged: (value) {
      //                   syncController.toggleAccount(value);
      //                 },
      //                 toggleValue: syncController.accountToggle.value,
      //                 errorMsg: syncController.errorAccount.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     InternetCheck.isInternetAvailable().then((value) {
      //                       if (value) {
      //                         syncController.startInSync();
      //                       } else {
      //                         InternetCheck.showInternetToast(context);
      //                       }
      //                     });
      //                   },
      //                   child: Text(
      //                     'Start Sync',
      //                   ),
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor: Theme.of(context).primaryColor,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                   ),
      //                 ),
      //                 TextButton(
      //                   onPressed: () {},
      //                   child: Text(
      //                     'Sync Log',
      //                     style: TextStyle(
      //                       color: Theme.of(context).primaryColor,
      //                     ),
      //                   ),
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     // Navigator.pop(context);
      //                     activityLogLocalController.insertactivityLogList(
      //                         activityLog: UserActivityLogModel(
      //                             activityType: "Synced",
      //                             date: DateTime.now().toIso8601String(),
      //                             description: "",
      //                             machine: "",
      //                             userId: UserSimplePreferences.getUsername(),
      //                             isSynced: 0));
      //                     Get.offAllNamed('/routeDetails');
      //                     // syncController.continueToHome();
      //                   },
      //                   child: Text(
      //                     'Continue',
      //                     style: TextStyle(
      //                       color: Theme.of(context).primaryColor,
      //                     ),
      //                   ),
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor: Theme.of(context).backgroundColor,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //       GFAccordion(
      //         title: 'Out Sync',
      //         showAccordion: false,
      //         titleBorderRadius: BorderRadius.circular(5),
      //         expandedTitleBackgroundColor: Theme.of(context).primaryColor,
      //         collapsedTitleBackgroundColor: Colors.black38,
      //         collapsedIcon:
      //             const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      //         expandedIcon:
      //             const Icon(Icons.keyboard_arrow_up, color: Colors.white),
      //         textStyle: TextStyle(
      //           color: Colors.white,
      //         ),
      //         titlePadding:
      //             EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
      //         contentChild: Column(
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     syncController.selectAllOut();
      //                   },
      //                   splashColor: lightGrey,
      //                   splashFactory: InkRipple.splashFactory,
      //                   child: Container(
      //                     width: 20,
      //                     height: 20,
      //                     decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: Colors.white,
      //                       border: Border.all(
      //                         color: mutedColor,
      //                         width: 1,
      //                       ),
      //                     ),
      //                     child: Center(
      //                       child: Obx(() => Icon(
      //                             Icons.check,
      //                             size: 15,
      //                             color: syncController.isAllSelectOut.value
      //                                 ? Theme.of(context).primaryColor
      //                                 : Colors.transparent,
      //                           )),
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   width: 10,
      //                 ),
      //                 AutoSizeText(
      //                   'Select All',
      //                   minFontSize: 16,
      //                   maxFontSize: 20,
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.w500,
      //                     color: mutedColor,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             tableHeader(context),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingSales.value,
      //                 isSuccess: syncController.isSalesSuccess.value,
      //                 isSyncing: syncController.isSalesSyncing.value,
      //                 title: 'Sales',
      //                 onChanged: (value) {
      //                   syncController.toggleSales(value);
      //                 },
      //                 toggleValue: syncController.salesToggle.value,
      //                 errorMsg: syncController.errorSales.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingTransactions.value,
      //                 isSuccess: syncController.isTransactionSuccess.value,
      //                 isSyncing: syncController.isTransactionsSyncing.value,
      //                 title: 'Transactions',
      //                 onChanged: (value) {
      //                   syncController.toggleTransactions(value);
      //                 },
      //                 toggleValue: syncController.transactionsToggle.value,
      //                 errorMsg: syncController.errorTransactions.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingExpenses.value,
      //                 isSuccess: syncController.isExpensesSuccess.value,
      //                 isSyncing: syncController.isExpensesSyncing.value,
      //                 title: 'Expenses',
      //                 onChanged: (value) {
      //                   syncController.toggleExpenses(value);
      //                 },
      //                 toggleValue: syncController.expensesToggle.value,
      //                 errorMsg: syncController.errorExpenses.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingSalesOrder.value,
      //                 isSuccess: syncController.isSalesOrderSuccess.value,
      //                 isSyncing: syncController.isSalesOrderSyncing.value,
      //                 title: 'Sales Order',
      //                 onChanged: (value) {
      //                   syncController.toggleSalesOrder(value);
      //                 },
      //                 toggleValue: syncController.salesOrderToggle.value,
      //                 errorMsg: syncController.errorSalesOrder.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingVisitlog.value,
      //                 isSuccess: syncController.isVisitlogSuccess.value,
      //                 isSyncing: syncController.isVisitlogSyncing.value,
      //                 title: 'Visit Log',
      //                 onChanged: (value) {
      //                   syncController.toggleVisitlog(value);
      //                 },
      //                 toggleValue: syncController.visitlogToggle.value,
      //                 errorMsg: syncController.errorVisitlog.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Obx(
      //               () => _buildSyncRow(
      //                 context,
      //                 isLoading: syncController.isLoadingActivitylog.value,
      //                 isSuccess: syncController.isActivitylogSuccess.value,
      //                 isSyncing: syncController.isActivitylogSyncing.value,
      //                 title: 'Activity Log',
      //                 onChanged: (value) {
      //                   syncController.toggleActivitylog(value);
      //                 },
      //                 toggleValue: syncController.activitylogToggle.value,
      //                 errorMsg: syncController.errorActivitylog.value,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     InternetCheck.isInternetAvailable().then((value) {
      //                       if (value) {
      //                         syncController.startOutSync();
      //                       } else {
      //                         InternetCheck.showInternetToast(context);
      //                       }
      //                     });
      //                   },
      //                   child: Text(
      //                     'Start Sync',
      //                   ),
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor: Theme.of(context).primaryColor,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                   ),
      //                 ),
      //                 TextButton(
      //                   onPressed: () {},
      //                   child: Text(
      //                     'Sync Log',
      //                     style: TextStyle(
      //                       color: Theme.of(context).primaryColor,
      //                     ),
      //                   ),
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     // Navigator.pop(context);
      //                     Get.offAllNamed('/routeDetails');
      //                     // syncController.continueToHome();
      //                   },
      //                   child: Text(
      //                     'Continue',
      //                     style: TextStyle(
      //                       color: Theme.of(context).primaryColor,
      //                     ),
      //                   ),
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor: Theme.of(context).backgroundColor,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //       Container(
      //         width: double.infinity,
      //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //         child: ElevatedButton(
      //           onPressed: () {
      //             // Get.offAllNamed(RoutesClass.getDeliveryListRoute());
      //             Navigator.pop(context);
      //           },
      //           child: Text(
      //             'Go to Home',
      //           ),
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Theme.of(context).primaryColor,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildOutSync(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  syncController.selectAllOut();
                },
                splashColor: lightGrey,
                splashFactory: InkRipple.splashFactory,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: mutedColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Obx(() => Icon(
                          Icons.check,
                          size: 15,
                          color: syncController.isAllSelectOut.value
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              AutoSizeText(
                'Select All',
                minFontSize: 16,
                maxFontSize: 20,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: mutedColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          tableHeader(context),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingSales.value,
              isSuccess: syncController.isSalesSuccess.value,
              isError: syncController.isErrorSales.value,
              isSyncing: syncController.isSalesSyncing.value,
              title: 'Sales',
              onChanged: (value) {
                syncController.toggleSales(value);
              },
              toggleValue: syncController.salesToggle.value,
              errorMsg: syncController.errorSales.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingTransactions.value,
              isSuccess: syncController.isTransactionSuccess.value,
              isError: syncController.isErrorTransactions.value,
              isSyncing: syncController.isTransactionsSyncing.value,
              title: 'Transactions',
              onChanged: (value) {
                syncController.toggleTransactions(value);
              },
              toggleValue: syncController.transactionsToggle.value,
              errorMsg: syncController.errorTransactions.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingExpenses.value,
              isSuccess: syncController.isExpensesSuccess.value,
              isError: syncController.isErrorExpenses.value,
              isSyncing: syncController.isExpensesSyncing.value,
              title: 'Expenses',
              onChanged: (value) {
                syncController.toggleExpenses(value);
              },
              toggleValue: syncController.expensesToggle.value,
              errorMsg: syncController.errorExpenses.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingSalesOrder.value,
              isSuccess: syncController.isSalesOrderSuccess.value,
              isError: syncController.isErrorSalesOrder.value,
              isSyncing: syncController.isSalesOrderSyncing.value,
              title: 'Sales Order',
              onChanged: (value) {
                syncController.toggleSalesOrder(value);
              },
              toggleValue: syncController.salesOrderToggle.value,
              errorMsg: syncController.errorSalesOrder.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingVisitlog.value,
              isSuccess: syncController.isVisitlogSuccess.value,
              isError: syncController.isErrorVisitlog.value,
              isSyncing: syncController.isVisitlogSyncing.value,
              title: 'Visit Log',
              onChanged: (value) {
                syncController.toggleVisitlog(value);
              },
              toggleValue: syncController.visitlogToggle.value,
              errorMsg: syncController.errorVisitlog.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingActivitylog.value,
              isSuccess: syncController.isActivitylogSuccess.value,
              isError: syncController.isErrorActivitylog.value,
              isSyncing: syncController.isActivitylogSyncing.value,
              title: 'Activity Log',
              onChanged: (value) {
                syncController.toggleActivitylog(value);
              },
              toggleValue: syncController.activitylogToggle.value,
              errorMsg: syncController.errorActivitylog.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  InternetCheck.isInternetAvailable().then((value) {
                    if (value) {
                      if (UserSimplePreferences.getBatchID() != null &&
                          UserSimplePreferences.getBatchID()! > 0) {
                        SnackbarServices.errorSnackbar(
                            "Close the batch to Out Sync");
                      } else {
                        syncController.startOutSync();
                      }
                    } else {
                      InternetCheck.showInternetToast(context);
                    }
                  });
                },
                child: Text(
                  'Start Sync',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Sync Log',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                  if (syncController.checkIsSynced()) {
                    if (UserSimplePreferences.getBatchID() != null &&
                        UserSimplePreferences.getBatchID()! > 0) {
                      Navigator.pop(context);
                    } else {
                      Get.offAllNamed('/routeDetails');
                    }
                  }

                  // syncController.continueToHome();
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Get.offAllNamed(RoutesClass.getDeliveryListRoute());
                if (syncController.checkIsSynced()) {
                  if (UserSimplePreferences.getBatchID() != null &&
                      UserSimplePreferences.getBatchID()! > 0) {
                    Navigator.pop(context);
                  } else {
                    Get.offAllNamed('/routeDetails');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Go to Home',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInSync(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  syncController.selectAllIn();
                },
                splashColor: lightGrey,
                splashFactory: InkRipple.splashFactory,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: mutedColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Obx(() => Icon(
                          Icons.check,
                          size: 15,
                          color: syncController.isAllSelectIn.value
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              AutoSizeText(
                'Select All',
                minFontSize: 16,
                maxFontSize: 20,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: mutedColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          tableHeader(context),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingCashRegister.value,
              isSuccess: syncController.isCashRegisterSuccess.value,
              isError: syncController.isErrorCashRegister.value,
              isSyncing: syncController.isCashRegisterSyncing.value,
              title: 'Cash Register',
              onChanged: (value) {
                syncController.toggleCashRegister(value);
              },
              toggleValue: syncController.cashRegisterToggle.value,
              errorMsg: syncController.errorCashRegister.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingCompany.value,
              isSuccess: syncController.isCompanySuccess.value,
              isError: syncController.isErrorCompany.value,
              isSyncing: syncController.isCompanySyncing.value,
              title: 'Company',
              onChanged: (value) {
                syncController.toggleCompany(value);
              },
              toggleValue: syncController.companyToggle.value,
              errorMsg: syncController.errorCompany.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingRoute.value,
              isSuccess: syncController.isRouteSuccess.value,
              isError: syncController.isErrorRoute.value,
              isSyncing: syncController.isRouteSyncing.value,
              title: 'Routes',
              onChanged: (value) {
                syncController.toggleRoute(value);
              },
              toggleValue: syncController.routeToggle.value,
              errorMsg: syncController.errorRoute.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingCustomer.value,
              isSuccess: syncController.isCustomersSuccess.value,
              isError: syncController.isErrorCustomer.value,
              isSyncing: syncController.isCustomerSyncing.value,
              title: 'Customers',
              onChanged: (value) {
                syncController.toggleCustomer(value);
              },
              toggleValue: syncController.customerToggle.value,
              errorMsg: syncController.errorCustomer.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingProduct.value,
              isSuccess: syncController.isProductsSuccess.value,
              isError: syncController.isErrorProduct.value,
              isSyncing: syncController.isProductSyncing.value,
              title: 'Products',
              onChanged: (value) {
                syncController.toggleProduct(value);
              },
              toggleValue: syncController.productToggle.value,
              errorMsg: syncController.errorProduct.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingBank.value,
              isSuccess: syncController.isBanksSuccess.value,
              isError: syncController.isErrorBank.value,
              isSyncing: syncController.isBankSyncing.value,
              title: 'Banks',
              onChanged: (value) {
                syncController.toggleBank(value);
              },
              toggleValue: syncController.bankToggle.value,
              errorMsg: syncController.errorBank.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingPaymentMethod.value,
              isSuccess: syncController.isPaymentMethodsSuccess.value,
              isError: syncController.isErrorPaymentMethod.value,
              isSyncing: syncController.isPaymentMethodSyncing.value,
              title: 'Payment Methods',
              onChanged: (value) {
                syncController.togglePaymentMethod(value);
              },
              toggleValue: syncController.paymentMethodToggle.value,
              errorMsg: syncController.errorPaymentMethod.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingTax.value,
              isSuccess: syncController.isTaxSuccess.value,
              isError: syncController.isErrorTax.value,
              isSyncing: syncController.isTaxSyncing.value,
              title: 'Taxes',
              onChanged: (value) {
                syncController.toggleTax(value);
              },
              toggleValue: syncController.taxToggle.value,
              errorMsg: syncController.errorTax.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingSecurity.value,
              isSuccess: syncController.isSecuritySuccess.value,
              isError: syncController.isErrorSecurity.value,
              isSyncing: syncController.isSecuritySyncing.value,
              title: 'Security',
              onChanged: (value) {
                syncController.toggleSecurity(value);
              },
              toggleValue: syncController.securityToggle.value,
              errorMsg: syncController.errorSecurity.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => _buildSyncRow(
              context,
              isLoading: syncController.isLoadingAccount.value,
              isSuccess: syncController.isAccountSuccess.value,
              isError: syncController.isErrorAccount.value,
              isSyncing: syncController.isAccountSyncing.value,
              title: 'Account',
              onChanged: (value) {
                syncController.toggleAccount(value);
              },
              toggleValue: syncController.accountToggle.value,
              errorMsg: syncController.errorAccount.value,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  InternetCheck.isInternetAvailable().then((value) {
                    if (value) {
                      syncController.startInSync();
                    } else {
                      InternetCheck.showInternetToast(context);
                    }
                  });
                },
                child: Text(
                  'Start Sync',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Sync Log',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);

                  if (syncController.checkIsSynced()) {
                    if (UserSimplePreferences.getBatchID() != null &&
                        UserSimplePreferences.getBatchID()! > 0) {
                      Navigator.pop(context);
                    } else {
                      activityLogLocalController.insertactivityLogList(
                          activityLog: UserActivityLogModel(
                              sysDocId: "",
                              voucherId: "",
                              activityType: ActivityTypes.other.value,
                              date: DateTime.now().toIso8601String(),
                              description: "Synced",
                              machine: UserSimplePreferences.getDeviceInfo(),
                              userId: UserSimplePreferences.getUsername(),
                              isSynced: 0));
                      Get.offAllNamed('/routeDetails');
                    }
                  }

                  // syncController.continueToHome();
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Get.offAllNamed(RoutesClass.getDeliveryListRoute());

                if (syncController.checkIsSynced()) {
                  if (UserSimplePreferences.getBatchID() != null &&
                      UserSimplePreferences.getBatchID()! > 0) {
                    Navigator.pop(context);
                  } else {
                    Get.offAllNamed('/routeDetails');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Go to Home',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void shareDBFile(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      Share.shareFiles([filePath], text: 'Sharing .db3 file');
    } else {
      // Handle file not found error
      print('File not found');
    }
  }

  Row _buildSyncRow(
    BuildContext context, {
    required String title,
    required bool toggleValue,
    required Function(dynamic) onChanged,
    required bool isSyncing,
    required bool isLoading,
    required bool isSuccess,
    required bool isError,
    required String errorMsg,
  }) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: AutoSizeText(
              title,
              minFontSize: 14,
              maxFontSize: 18,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: mutedColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            width: 70,
            child: Center(
              child: Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  activeColor: Theme.of(context).primaryColor,
                  value: toggleValue,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            width: 70,
            child: Center(
                child: isSyncing
                    ? isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              if (isError)
                                SnackbarServices.errorSnackbar(errorMsg);
                            },
                            child: SvgPicture.asset(
                              isSuccess == true && isError == false
                                  ? AppIcons.check
                                  : AppIcons.cancel,
                              color: isSuccess == true && isError == false
                                  ? AppColors.darkGreen
                                  : AppColors.darkRed,
                              width: 20,
                              height: 20,
                            ),
                          )
                    : Container()),
          ),
        ),
      ],
    );
  }

  Container tableHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Data',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: 70,
                child: Text(
                  'Required',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: 70,
                child: Center(
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
