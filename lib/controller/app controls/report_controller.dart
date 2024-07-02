import 'dart:developer';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_visit_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/expenses_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/new_order_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/payment_collection_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sales_invoice_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/unit_controller.dart';
import 'package:axoproject/controller/app%20controls/route_details_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/PaymentCollectionModel/payment_collection_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:axoproject/services/Print%20Helper/sales_report_print_helper.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/Calculations/date_range_selector.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Expenses/expenses_screen.dart';
import 'package:axoproject/view/New%20Order/new_order_screen.dart';
import 'package:axoproject/view/Payment%20Collection/payment_collection_screen.dart';
import 'package:axoproject/view/Report%20Type/invoice_preview.dart';
import 'package:axoproject/view/Reports/Report%20Preview/sales_report_preview.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axoproject/view/components/common_filter_controls.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/view/components/payment_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/Local Db Model/user_log_model.dart';
import '../Local Db Controller/user_activity_log_local_controller.dart';

class ReportController extends GetxController {
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  final expenseLocalController = Get.put(ExpensesTransactionLocalController());
  final customerControler = Get.put(CustomerListController());
  final homeController = Get.put(HomeController());
  final newOrderLocalController = Get.put(NewOrderLocalController());
  final unitListController = Get.put(UnitListController());
  final salesInvoiceLocalController = Get.put(SalesInvoiceLocalController());
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final visitLogLocalController = Get.put(CustomerVisitLocalController());
  final routeDetailsController = Get.put(RouteDetailsController());
  final productListController = Get.put(ProductListController());
  final routeControler = Get.put(RouteListController());
  final paymentCollectionLocalController =
      Get.put(PaymentCollectionLocalController());
  final customerListController = Get.put(CustomerListController());
  var requiredOnDate = DateTime.now().obs;
  var newOrdersList = <NewOrderApiModel>[].obs;
  var newOrdersFilterList = <NewOrderApiModel>[].obs;

  var salesInvoiceList = <SalesInvoiceApiModel>[].obs;
  var salesInvoiceFilterList = <SalesInvoiceApiModel>[].obs;
  var returnList = <SalesInvoiceApiModel>[].obs;
  var returnFilterList = <SalesInvoiceApiModel>[].obs;
  var paymentMethodList = <PaymentMethodModel>[].obs;
  var visitLogs = [].obs;
  var expenseList = <ExpenseTransactionApiModel>[].obs;
  var expenseFliterList = <ExpenseTransactionApiModel>[].obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59, 59)
      .obs;
  var isEqualDate = false.obs;
  var dateIndex = 0.obs;
  var activityLogList = <UserActivityLogModel>[].obs;
  var activityLogFilterList = <UserActivityLogModel>[].obs;
  var paymentCollectionList = <CreateTransferHeaderModel>[].obs;
  var paymentCollectionFilterList = <CreateTransferHeaderModel>[].obs;
  var totalInvoice = 0.00.obs;
  var totalOrders = 0.00.obs;
  var totalReturn = 0.00.obs;
  var dailyTotalPayment = 0.0.obs;
  var dailyTotalInvoice = 0.0.obs;
  var dailyTotalReturn = 0.0.obs;
  var productUnitList = <UnitModel>[].obs;
  var isProductsLoading = false.obs;
  var totalPaymentCollection = 0.00.obs;
  var paymentTypeCounts = {"": 0}.obs;
  var latestSalesByDay = <SalesInvoiceApiModel>[].obs;
  var visitedCount = 0.obs;
  var skippedCount = 0.obs;
  var plannedCount = 0.obs;
  var completedCount = 0.obs;
  var isSearching = false.obs;
  var productList = <ProductModel>[].obs;
  var productFilterList = <ProductModel>[].obs;
  var highestValue = 0.0.obs;
  var cashReciepts = DailyReportModel().obs;
  var cashSales = DailyReportModel().obs;
  var cashSalesReturn = DailyReportModel().obs;
  var cashExpenses = DailyReportModel().obs;
  var creditSales = DailyReportModel().obs;
  var creditSalesReturn = DailyReportModel().obs;
  var cheque = DailyReportModel().obs;
  var creditCardSales = DailyReportModel().obs;
  var totalCash = DailyReportModel().obs;
  var totalCredit = DailyReportModel().obs;
  var isCustomerSelected = false.obs;
  var customerId = ''.obs;
  var customerList = [].obs;

  setCustomerSelection({required String customerId, required bool isCustomer}) {
    log('$customerId --- $isCustomer');
    this.customerId.value = customerId;
    isCustomerSelected.value = isCustomer;
    update();
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate.value : toDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: Theme.of(context).primaryColor,
              surface: Theme.of(context).primaryColor,
              onSurface: Theme.of(context).primaryColor,
            ),
            dialogBackgroundColor: Theme.of(context).backgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isFrom
          ? fromDate.value = newDate
          : toDate.value =
              DateTime(newDate.year, newDate.month, newDate.day, 23, 59, 59);
      if (isEqualDate.value) {
        toDate.value = DateTime(fromDate.value.year, fromDate.value.month,
            fromDate.value.day, 23, 59, 59);
      }
    }
    update();
  }

  searchFieldView() {
    isSearching.value = !isSearching.value;
    update();
  }

  selectDateRange(int value, int index) async {
    dateIndex.value = index;
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
  }

  getOrderReport() async {
    totalOrders.value = 0.0;
    newOrdersList.clear();
    newOrdersFilterList.clear();
    await newOrderLocalController.getNewOrderHeaders();
    newOrdersList.value = newOrderLocalController.newOrderHeaders;
    newOrdersFilterList.value = newOrdersList;
    totalOrders.value = newOrderLocalController.newOrderHeaders.fold<double>(
      0,
      (sum, header) => sum + (header.total ?? 0.0),
    );
    filterList(newOrdersFilterList, newOrdersList);
    update();
  }

  printSalesOrderReport() async {
    await getOrderReport();
    if (newOrdersFilterList.isEmpty) {
      SnackbarServices.errorSnackbar('Order List is Empty!');
      return;
    }
    List<SalesReportDetailModel> details = [];
    details = newOrdersFilterList.map((originalObject) {
      return SalesReportDetailModel(
        customerCode: originalObject.customerid,
        voucherNo: originalObject.voucherid,
        total: originalObject.total,
        tax: originalObject.taxamount,
        discount: originalObject.discount ?? 0.0,
      );
    }).toList();
    SalesReportPrintHelper helper = SalesReportPrintHelper(
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      printDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      fromDate: DateFormatter.invoiceDateFormat.format(fromDate.value),
      toDate: DateFormatter.invoiceDateFormat.format(toDate.value),
      items: details,
      headerImage: newOrdersFilterList[0].headerImage,
      footerImage: newOrdersFilterList[0].footerImage,
    );

    return helper;
  }

  getSalesInvoiceReport() async {
    salesInvoiceList.clear();
    salesInvoiceFilterList.clear();
    paymentTypeCounts.clear();
    latestSalesByDay.clear();
    totalInvoice.value = 0.0;
    await salesInvoiceLocalController.getsalesInvoiceHeaders();
    salesInvoiceList.value = salesInvoiceLocalController.salesInvoiceHeaders
        .where((p0) => p0.isReturn == 0)
        .toList();
    salesInvoiceFilterList.value = salesInvoiceList;
// to get total of salesinvoice list
    totalInvoice.value = salesInvoiceList.fold<double>(
      0,
      (sum, header) => sum + (header.total ?? 0.0),
    );
    //to get the current dates total sales invoice list
    dailyTotalInvoice.value = salesInvoiceList.fold<double>(0, (sum, header) {
      var parseDate = DateTime.parse(header.transactionDate!);
      var date = "${parseDate.year} - ${parseDate.month} - ${parseDate.day}";
      var currentDate =
          "${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}";
      if (date == currentDate) {
        return sum + (header.total ?? 0.0);
      } else {
        return sum;
      }
    });
    // for pie chart according payment type
    paymentTypeCounts.addIf(salesInvoiceList.isEmpty, "empty", 10);
    for (var invoice in salesInvoiceList) {
      paymentTypeCounts[invoice.paymentType.toString()] =
          (paymentTypeCounts[invoice.paymentType.toString()] ?? 0) + 1;
    }
    //for line chart total of that particular date
    Map<String, List<SalesInvoiceApiModel>> groupedByDate =
        groupByTransactionDate(salesInvoiceList);
    groupedByDate.forEach((transactionDate, invoices) {
      var total = 0.0;
      invoices.forEach((invoice) {
        total = total + (invoice.total ?? 0.0);
      });
      latestSalesByDay.add(
          SalesInvoiceApiModel(transactionDate: transactionDate, total: total));
    });
    for (var element in latestSalesByDay) {
      if ((element.total ?? 0.0) > (latestSalesByDay.first.total ?? 0.0)) {
        highestValue.value = element.total!;
      }
    }
    filterList(salesInvoiceFilterList, salesInvoiceList);
    update();
  }

  filterList(var filterList, var list) {
    filterList.value = list.where((element) {
      return DateTime.parse(list.runtimeType == (RxList<NewOrderApiModel>)
                  ? element.transactiondate.toString()
                  : list.runtimeType == (RxList<UserActivityLogModel>)
                      ? element.date.toString()
                      : element.transactionDate.toString())
              .isBefore(toDate.value) &&
          DateTime.parse(list.runtimeType == (RxList<NewOrderApiModel>)
                  ? element.transactiondate.toString()
                  : list.runtimeType == (RxList<UserActivityLogModel>)
                      ? element.date.toString()
                      : element.transactionDate.toString())
              .isAfter(fromDate.value);
    }).toList();
    if (isCustomerSelected.value &&
        list.runtimeType != (RxList<UserActivityLogModel>)) {
      filterList.value = filterList.value.where((element) {
        return (list.runtimeType == (RxList<SalesInvoiceApiModel>)
                ? element.customerId
                : list.runtimeType == (RxList<CreateTransferHeaderModel>)
                    ? element.payeeId
                    : element.customerid) ==
            customerId.value;
      }).toList();
    }
    update();
  }

  Map<String, List<SalesInvoiceApiModel>> groupByTransactionDate(
      List<SalesInvoiceApiModel> salesInvoices) {
    Map<String, List<SalesInvoiceApiModel>> groupedByDate = {};

    for (SalesInvoiceApiModel invoice in salesInvoices) {
      // Extract date from the transactionDate (assuming transactionDate is in 'yyyy-MM-dd' format)
      String dateOnly = invoice.transactionDate!.split('T')[0];

      if (groupedByDate.containsKey(dateOnly)) {
        groupedByDate[dateOnly]!.add(invoice);
      } else {
        groupedByDate[dateOnly] = [invoice];
      }
    }

    return groupedByDate;
  }

  bool sameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  printSalesInvoiceReport() async {
    await getSalesInvoiceReport();
    if (salesInvoiceList.isEmpty) {
      SnackbarServices.errorSnackbar('Invoice List is Empty!');
      return;
    }
    await customerListController.getCustomerList();
    List<SalesReportDetailModel> details = [];
    details = salesInvoiceFilterList.map((originalObject) {
      return SalesReportDetailModel(
        customerCode: customerListController.customerList
            .firstWhere(
                (element) => element.customerID == originalObject.customerId)
            .customerName
            .toString(),
        voucherNo: originalObject.voucherid,
        discount: originalObject.discount ?? 0.0,
        total: ((originalObject.total ?? 0.0) -
            (originalObject.taxAmount ?? 0.0) +
            (originalObject.discount ?? 0.0)),
        tax: originalObject.taxAmount,
        netAmount: (originalObject.total ?? 0.0),
      );
    }).toList();
    double total = details.fold(0,
        (double previousValue, SalesReportDetailModel myObject) {
      return previousValue + (myObject.netAmount ?? 0.0);
    });
    SalesReportPrintHelper helper = SalesReportPrintHelper(
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      printDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      fromDate: DateFormatter.invoiceDateFormat.format(fromDate.value),
      toDate: DateFormatter.invoiceDateFormat.format(toDate.value),
      items: details,
      total: total.toStringAsFixed(2),
      headerImage: salesInvoiceList[0].headerImage,
      footerImage: salesInvoiceList[0].footerImage,
    );
    return helper;
    // Get.to(() =>
    //     SalesReportPreviewScreen(helper, ReportPreviewTemplate.SalesInvoice));
  }

  printExpenseReport() async {
    await getExpenseList();
    if (expenseFliterList.isEmpty) {
      SnackbarServices.errorSnackbar('Expense List is Empty!');
      return;
    }
    List<ExpenseTransactionApiModel> details = [];
    details = expenseFliterList.map((originalObject) {
      return ExpenseTransactionApiModel(
        voucherID: originalObject.voucherID,
        taxAmount: originalObject.taxAmount,
        amount: (originalObject.amount ?? 0.0),
      );
    }).toList();
    PrintHelper helper = PrintHelper(
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      printDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      fromDate: DateFormatter.invoiceDateFormat.format(fromDate.value),
      toDate: DateFormatter.invoiceDateFormat.format(toDate.value),
      expenseHeader: details,
      headerImage: expenseFliterList[0].headerImage,
      footerImage: expenseFliterList[0].footerImage,
    );
    return helper;
    // Get.to(() =>
    //     SalesReportPreviewScreen(helper, ReportPreviewTemplate.SalesInvoice));
  }

  printReturnSalesReport() async {
    await getReturnList();
    if (returnList.isEmpty) {
      SnackbarServices.errorSnackbar('Return List is Empty!');
      return;
    }
    await customerListController.getCustomerList();
    List<SalesReportDetailModel> details = [];
    details = returnFilterList.map((originalObject) {
      return SalesReportDetailModel(
        customerCode: customerListController.customerList
            .firstWhere(
                (element) => element.customerID == originalObject.customerId)
            .customerName
            .toString(),
        voucherNo: originalObject.voucherid,
        discount: originalObject.discount ?? 0.0,
        total:
            ((originalObject.total ?? 0.0) - (originalObject.taxAmount ?? 0.0)),
        tax: originalObject.taxAmount,
        netAmount: originalObject.total ?? 0.0,
        // Modification for Spring onion

        // discount:
        //     originalObject.discount != null && originalObject.discount! > 0.0
        //         ? (-1 * originalObject.discount!)
        //         : 0.0,
        // total: (-1 *
        //     ((originalObject.total ?? 0.0) -
        //         (originalObject.taxAmount ?? 0.0))),
        // tax: originalObject.taxAmount != null
        //     ? (-1 * originalObject.taxAmount!)
        //     : 0.0,
        // netAmount:
        //     originalObject.total != null ? (-1 * originalObject.total!) : 0.0,
      );
    }).toList();
    double total = details.fold(0,
        (double previousValue, SalesReportDetailModel myObject) {
      return previousValue + (myObject.netAmount ?? 0.0);
    });
    SalesReportPrintHelper helper = SalesReportPrintHelper(
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      printDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      fromDate: DateFormatter.invoiceDateFormat.format(fromDate.value),
      toDate: DateFormatter.invoiceDateFormat.format(toDate.value),
      items: details,
      total: (total).toStringAsFixed(2),
      headerImage: returnList[0].headerImage,
      footerImage: returnList[0].footerImage,
    );
    return helper;
    // Get.to(() =>
    //     SalesReportPreviewScreen(helper, ReportPreviewTemplate.SalesInvoice));
  }

  getReturnList() async {
    returnList.clear();
    returnFilterList.clear();
    await salesInvoiceLocalController.getsalesInvoiceHeaders();
    totalReturn.value = 0.0;
    returnList.value = salesInvoiceLocalController.salesInvoiceHeaders
        .where((item) => item.isReturn == 1)
        .toList();
    returnFilterList.value = returnList.value;
    totalReturn.value = returnList.fold(0, (previousValue, element) {
      return previousValue + (element.total ?? 0.0);
    });
    dailyTotalReturn.value = returnList.fold<double>(0, (sum, header) {
      var parseDate = DateTime.parse(header.transactionDate!);
      if (sameDate(parseDate, DateTime.now())) {
        return sum + (header.total ?? 0.0);
      } else {
        return sum;
      }
    });
    filterList(returnFilterList, returnList);
    update();
  }

  printPaymentsReport() async {
    await getPaymentCollectionList();
    if (paymentCollectionList.isEmpty) {
      SnackbarServices.errorSnackbar('Payment List is Empty!');
      return;
    }
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }
    await homeController.getSystemDocList();
    SysDocDetail sysDoc = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.receiptDocID);
    await customerListController.getCustomerList();
    List<SalesReportDetailModel> details = [];
    details = paymentCollectionFilterList.map((originalObject) {
      return SalesReportDetailModel(
        customerCode: customerListController.customerList
            .firstWhere(
                (element) => element.customerID == originalObject.payeeId)
            .customerName
            .toString(),
        voucherNo: originalObject.voucherId,
        discount: 0.0,
        total: ((originalObject.amount ?? 0.0)),
        tax: 0.0,
        netAmount: originalObject.amount ?? 0.0,
        paymentMode: originalObject.isCheque! ? 'CHEQUE' : 'CASH',
        date: DateFormatter.invoiceDateFormat
            .format(originalObject.transactionDate!)
            .toString(),
      );
    }).toList();
    double total = details.fold(0,
        (double previousValue, SalesReportDetailModel myObject) {
      return previousValue + (myObject.netAmount ?? 0.0);
    });
    SalesReportPrintHelper helper = SalesReportPrintHelper(
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      printDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      fromDate: DateFormatter.invoiceDateFormat.format(fromDate.value),
      toDate: DateFormatter.invoiceDateFormat.format(toDate.value),
      items: details,
      total: total.toStringAsFixed(2),
      headerImage: sysDoc.headerImage,
      footerImage: sysDoc.footerImage,
    );
    return helper;
    // Get.to(() =>
    //     SalesReportPreviewScreen(helper, ReportPreviewTemplate.SalesInvoice));
  }

  getPaymentCollectionList() async {
    paymentCollectionList.clear();
    paymentCollectionFilterList.clear();
    totalPaymentCollection.value = 0.0;
    await paymentCollectionLocalController.getTransactionHeaders();
    paymentCollectionList.value =
        paymentCollectionLocalController.transactionHeaders;
    paymentCollectionFilterList.value = paymentCollectionList;
    totalPaymentCollection.value =
        paymentCollectionLocalController.transactionHeaders.fold<double>(
      0,
      (sum, header) => sum + header.amount,
    );
    dailyTotalPayment.value =
        paymentCollectionLocalController.transactionHeaders.fold<double>(
      0,
      (sum, header) {
        if (sameDate(header.transactionDate!, DateTime.now())) {
          return sum + header.amount;
        } else {
          return sum;
        }
      },
    );
    filterList(paymentCollectionFilterList, paymentCollectionList);
    update();
  }

  getExpenseList() async {
    await expenseLocalController.getExpensesHeaders();
    if (expenseLocalController.expenseTransactionHeader.isNotEmpty) {
      expenseList.value = expenseLocalController.expenseTransactionHeader;
      expenseFliterList.value = expenseList;
    }
    update;
  }

  Future<void> getVisitLog() async {
    skippedCount.value = 0;
    visitedCount.value = 0;
    customerList.value = await customerControler.getCustomerList() ?? [];
    await visitLogLocalController.getAllCustomerVisit();
    visitLogs.value = visitLogLocalController.customerVisits;
    visitLogLocalController.customerVisits.forEach((element) {
      log("${element.isSkipped}");
      if (element.isSkipped == 1) {
        skippedCount.value++;
      } else {
        visitedCount.value++;
      }
    });
    update();
  }

  getCounts() async {
    if (routeDetailsController.customerList.isEmpty) {
      await routeDetailsController.getAllCustomers();
    }
    plannedCount.value = routeDetailsController.customerList.length;
    completedCount.value =
        ((visitedCount.value / plannedCount.value) * 100).round();
    update();
  }

  deleteSalesInvoiceItem(String voucher) {
    salesInvoiceList.removeWhere((element) => element.voucherid == voucher);
    salesInvoiceFilterList
        .removeWhere((element) => element.voucherid == voucher);
    update();
  }

  deleteSalesReturnItem(String voucher) {
    returnList.removeWhere((element) => element.voucherid == voucher);
    returnFilterList.removeWhere((element) => element.voucherid == voucher);
    update();
  }

  deleteNewOrderItem(String voucher) {
    newOrdersList.removeWhere((element) => element.voucherid == voucher);
    newOrdersFilterList.removeWhere((element) => element.voucherid == voucher);
    update();
  }

  deletePaymentCollectionItem(String voucher) {
    paymentCollectionList
        .removeWhere((element) => element.voucherId == voucher);
    paymentCollectionFilterList
        .removeWhere((element) => element.voucherId == voucher);
    update();
  }

  deleteExpensesItem(String voucher) {
    expenseList.removeWhere((element) => element.voucherID == voucher);
    expenseFliterList.removeWhere((element) => element.voucherID == voucher);
    update();
  }

  getActvityLogList() async {
    await activityLogLocalController.getActivityLogList();
    activityLogList.value = activityLogLocalController.activityLogList;
    activityLogFilterList.value = activityLogList;
    filterList(activityLogFilterList, activityLogList);
    update();
  }

  void navigateSalesInvoice() {
    Get.to(() => SalesInvoiceScreen())?.then(
      (value) {
        getReturnList();
        getSalesInvoiceReport();
        update();
      },
    );
    update();
  }

  void navigateNewOrder() {
    Get.to(() => NewOrderScreen())?.then(
      (value) {
        getOrderReport();
        update();
      },
    );
    update();
  }

  void navigateExpenseTransaction() {
    Get.to(() => ExpensesScreen())?.then(
      (value) {
        getExpenseList();
        update();
      },
    );
    update();
  }

  getProductList() async {
    // if (productList.isEmpty) {
    isProductsLoading.value = true;
    await productListController.getProductList();

    productList.value = productListController.productList
        .where((element) =>
            element.quantity != null && element.openingStock! > 0 ||
            element.quantity! > 0)
        .toList();
    productFilterList.value = productListController.productList
        .where((element) =>
            element.quantity != null && element.openingStock! > 0 ||
            element.quantity! > 0)
        .toList();

    await unitListController.getUnitList();
    productUnitList = unitListController.unitList;
    isProductsLoading.value = false;
    update();
    // } else {
    //   productFilterList.value = productList;
    // }
  }

  printStockReport() async {
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }
    await homeController.getSystemDocList();
    SysDocDetail sysDoc = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.receiptDocID);

    await getProductList();
    PrintHelper helper = PrintHelper(
      vanName: UserSimplePreferences.getVanName() ?? '',
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      transactionDate: DateFormatter.invoiceDateFormat.format(
        DateTime.now(),
      ),
      headerImage: sysDoc.headerImage,
      footerImage: sysDoc.footerImage,
      total: productList
          .fold<double>(
            0,
            (sum, header) => sum + (header.quantity ?? 0.0),
          )
          .toStringAsFixed(2),
      products: productList,
    );
    return helper;
  }

  printDailySalesReport() async {
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }
    await homeController.getSystemDocList();
    SysDocDetail sysDoc = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.receiptDocID);

    PrintHelper helper = PrintHelper(
      vanName: UserSimplePreferences.getVanName() ?? '',
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      transactionDate: DateFormatter.invoiceDateFormat.format(
        DateTime.now(),
      ),
      cashSales: DailyReportModel(
          amount:
              double.parse(cashSales.value.amount?.toStringAsFixed(2) ?? "0"),
          count: cashSales.value.count ?? 0),
      cashReciepts: DailyReportModel(
          amount: double.parse(
              cashReciepts.value.amount?.toStringAsFixed(2) ?? "0"),
          count: cashReciepts.value.count ?? 0),
      cashExpenses: DailyReportModel(
          amount: double.parse(
              cashExpenses.value.amount?.toStringAsFixed(2) ?? "0"),
          count: cashExpenses.value.count ?? 0),
      cheques: DailyReportModel(
          amount: double.parse(cheque.value.amount?.toStringAsFixed(2) ?? "0"),
          count: cheque.value.count ?? 0),
      headerImage: sysDoc.headerImage,
      footerImage: sysDoc.footerImage,
      creditCardSales: DailyReportModel(
          amount: double.parse(
              creditCardSales.value.amount?.toStringAsFixed(2) ?? "0"),
          count: creditCardSales.value.count ?? 0),
      cashSalesReturn: DailyReportModel(
          amount: double.parse(
              cashSalesReturn.value.amount?.toStringAsFixed(2) ?? "0"),
          count: cashSalesReturn.value.count ?? 0),
      creditSales: DailyReportModel(
          amount:
              double.parse(creditSales.value.amount?.toStringAsFixed(2) ?? "0"),
          count: creditSales.value.count ?? 0),
      creditSalesReturn: DailyReportModel(
          amount: double.parse(
              creditSalesReturn.value.amount?.toStringAsFixed(2) ?? "0"),
          count: creditSalesReturn.value.count ?? 0),
      totalCash: DailyReportModel(
          amount:
              double.parse(totalCash.value.amount?.toStringAsFixed(2) ?? "0"),
          count: totalCash.value.count ?? 0),
      totalCredit: DailyReportModel(
          amount:
              double.parse(totalCredit.value.amount?.toStringAsFixed(2) ?? "0"),
          count: totalCredit.value.count ?? 0),
    );
    return helper;
  }

  printSalesReport(SalesInvoiceApiModel header,
      {bool isPreview = false}) async {
    int templateIndex = UserSimplePreferences.getPrintTemplate() ?? 1;
    await salesInvoiceLocalController.getsalesInvoiceDetails(
        voucher: header.voucherid ?? "");
    var customerList = (await customerControler.getCustomerList())!;
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.customerId);

    String taxNumber = customers.taxIDNumber ?? "";
    List<VanSaleDetailModel> items = [];
    for (SalesInvoiceDetailApiModel item
        in salesInvoiceLocalController.salesInvoiceDetail) {
      List<VanSaleDetail> detail = [
        VanSaleDetail(
          productId: item.productId,
          barcode: item.barcode,
          amount: item.amount,
          description: item.description,
          itemType: 0,
          quantity: item.onHand,
          taxAmount: item.taxAmount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          rowIndex: item.rowIndex,
          taxGroupId: item.taxGroupId,
          taxOption: item.taxOption.toString(),
          unitId: item.unitId,
          unitPrice: item.unitPrice,
          availableQty: item.onHand,
        )
      ];
      items.add(VanSaleDetailModel(
          amount: item.amount,
          isTrackLot:
              salesInvoiceLocalController.salesInvoiceLotDetail.isEmpty ? 0 : 1,
          price: item.unitPrice,
          quantity: item.quantity,
          taxGroupDetail: [],
          unitList: [],
          unitTax: item.taxAmount,
          initialQuantity: item.quantity ?? 0.0,
          isDamaged: item.isDamaged,
          isEdited: false,
          updatedUnit: UnitModel(code: item.unitId),
          vanSaleDetails: detail,
          customerProductId: item.customerProductId,
          vanSaleProductLotDetails: []));
    }
    var subTotal = (header.total ?? 0.0) -
        (header.taxAmount ?? 0.0) +
        (header.discount ?? 0.0);
    PrintHelper helper = PrintHelper(
        items: items,
        transactionDate: DateFormatter.invoiceDateFormat.format(
          DateTime.parse(header.transactionDate??''),
        ),
        isReturn: header.isReturn == 1 ? true : false,
        invoiceNo: header.voucherid,
        salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
        vanName: UserSimplePreferences.getVanName() ?? '',
        customer: header.customerName,
        address: header.address,
        phone: header.phone,
        trn: UserSimplePreferences.getCompanyTRN() ?? '',
        customerTrn: taxNumber,
        paymentMode: header.paymentMethodID,
        tax: header.taxAmount?.toStringAsFixed(2),
        total: header.total?.toStringAsFixed(2),
        subTotal: subTotal.toStringAsFixed(2),
        discount: header.discount?.toStringAsFixed(2),
        // Modification for Spring onion

        // tax: header.isReturn == 1
        //     ? (-1 * (header.taxAmount!)).toStringAsFixed(2)
        //     : header.taxAmount!.toStringAsFixed(2),
        // total: header.isReturn == 1
        //     ? (-1 * (header.total!)).toStringAsFixed(2)
        //     : header.total!.toStringAsFixed(2),
        // subTotal: header.isReturn == 1
        //     ? (-1 * (subTotal)).toStringAsFixed(2)
        //     : subTotal.toStringAsFixed(2),
        // discount: header.isReturn == 1
        //     ? (-1 * (header.discount!)).toStringAsFixed(2)
        //     : header.discount!.toStringAsFixed(2),
        headerImage: header.headerImage,
        footerImage: header.footerImage,
        companyName: UserSimplePreferences.getCompanyName() ?? '',
        refNo: header.reference,
        parentCustomer:
            await DBHelper().getParentCustomerName(header.customerId ?? ''),
        amountInWords: PrintHelper.convertAmountToWords(header.total ?? 0.0));
        // Modification for Spring onion

        // amountInWords: PrintHelper.convertAmountToWords(
        //     header.isReturn == 1 ? (-1 * (header.total!)) : header.total!));
    if (isPreview) {
      await Get.to(() => InvoicePreviewScreen(
            helper,
            PreviewTemplate.values
                .firstWhere((element) => element.value == templateIndex),
          ));
    } else {
      return helper;
    }
  }

  printNewOrderReport(NewOrderApiModel header, {bool isPreview = false}) async {
    await salesInvoiceLocalController.getsalesInvoiceDetails(
        voucher: header.voucherid ?? "");
    var customerList = (await customerControler.getCustomerList())!;
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.customerid);

    String taxNumber = customers.taxIDNumber ?? "";
    List<VanSaleDetailModel> items = [];
    for (NewOrderDetailApiModel item
        in newOrderLocalController.newOrderDetail) {
      List<VanSaleDetail> detail = [
        VanSaleDetail(
          productId: item.productId,
          barcode: item.barcode,
          amount: item.amount,
          description: item.description,
          itemType: 0,
          taxAmount: item.taxamount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          rowIndex: item.rowindex,
          taxGroupId: item.taxgroupid,
          taxOption: item.taxoption.toString(),
          unitId: item.unitid,
          unitPrice: item.unitprice,
        )
      ];
      items.add(VanSaleDetailModel(
          amount: item.amount,
          isTrackLot: newOrderLocalController.newOrderLotDetail.isEmpty ? 0 : 1,
          price: item.unitprice,
          quantity: item.quantity,
          taxGroupDetail: [],
          unitList: [],
          unitTax: item.taxamount,
          initialQuantity: item.quantity ?? 0.0,
          isEdited: false,
          updatedUnit: UnitModel(code: item.unitid),
          vanSaleDetails: detail,
          vanSaleProductLotDetails: []));
    }
    var subTotal = (header.total ?? 0.0) -
        (header.taxamount ?? 0.0) +
        (header.discount ?? 0.0);
    PrintHelper helper = PrintHelper(
        items: items,
        transactionDate: DateFormatter.invoiceDateFormat.format(
          DateTime.parse(header.transactiondate??''),
        ),
        invoiceNo: header.voucherid,
        salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
        vanName: UserSimplePreferences.getVanName() ?? '',
        customer: header.customerName,
        address: header.address,
        phone: header.phone,
        trn: UserSimplePreferences.getCompanyTRN() ?? '',
        customerTrn: taxNumber,
        tax: header.taxamount?.toStringAsFixed(2),
        total: header.total?.toStringAsFixed(2),
        subTotal: subTotal.toStringAsFixed(2),
        discount: header.discount?.toStringAsFixed(2),
        headerImage: header.headerImage,
        footerImage: header.footerImage,
        companyName: UserSimplePreferences.getCompanyName() ?? '',
        amountInWords: PrintHelper.convertAmountToWords(header.total ?? 0.0));
    if (isPreview) {
      await Get.to(() => InvoicePreviewScreen(
            helper,
            PreviewTemplate.NewOrder,
          ));
    } else {
      return helper;
    }
  }

  printExpenseTransaction(String voucherId, {bool isPreview = false}) async {
    ExpenseTransactionApiModel header = await expenseLocalController
        .getExpenseHeaderUsingVoucher(voucher: voucherId);
    await expenseLocalController.getExpenseDetails(
        voucher: header.voucherID ?? "");

    double subTotal = (header.amount ?? 0.0) - (header.taxAmount ?? 0.0);
    PrintHelper helper = PrintHelper(
        expense: expenseLocalController.expenseTransactionDetails,
        transactionDate: DateFormatter.invoiceDateFormat.format(
          DateTime.parse(header.transactionDate!),
        ),
        invoiceNo: header.sysDocID,
        salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
        vanName: UserSimplePreferences.getVanName() ?? '',
        trn: UserSimplePreferences.getCompanyTRN() ?? '',
        tax: header.taxAmount?.toStringAsFixed(2),
        total: header.amount?.toStringAsFixed(2),
        subTotal: subTotal.toStringAsFixed(2),
        headerImage: header.headerImage,
        footerImage: header.footerImage,
        amountInWords: PrintHelper.convertAmountToWords(header.amount ?? 0.0));

    if (isPreview) {
      await Get.to(() => InvoicePreviewScreen(
            helper,
            PreviewTemplate.Expenses,
          ));
    } else {
      return helper;
    }
  }

  searchItems(String value) {
    productFilterList.value = productList
        .where((element) =>
            element.productID!.toLowerCase().contains(value.toLowerCase()) ||
            element.description!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  printRecipt(String voucherID, {bool isPreview = false}) async {
    CreateTransferHeaderModel header = await paymentCollectionLocalController
        .getPaymentHeaderUsingVoucher(voucher: voucherID);
    await paymentCollectionLocalController.getTransactionDetails(
        voucher: voucherID);
    var customerList = (await customerControler.getCustomerList())!;

    var item = paymentCollectionLocalController.transactionDetail[0];
    SysDocDetail sysDoc = await homeController.getFirstSysDoc(
        sysDocId: item.paymentMethodtype == 1
            ? homeController.cashRegisterList.first.cashReceiptDocID
            : homeController.cashRegisterList.first.chequeReceiptDocID);

    PrintHelper helper = PrintHelper(
      transactionDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      trn: UserSimplePreferences.getCompanyTRN() ?? '',
      recieptNo: voucherID,
      recieptDate: DateFormatter.invoiceDateFormat.format(header.transactionDate?? DateTime.now()),
      chequeNumber: item.chequeNumber,
      remarks: item.description,
      receivedFrom: header.customerName,
      amount: item.amount.toString(),
      headerImage: sysDoc.headerImage,
      footerImage: sysDoc.footerImage,
      amountInWords: PrintHelper.convertAmountToWords(item.amount),
      isCheque: item.paymentMethodtype == 1 ? false : true,
    );
    if (isPreview) {
      await Get.to(() => InvoicePreviewScreen(
            helper,
            PreviewTemplate.CashCheque,
          ));
    } else {
      return helper;
    }
  }

  void navigatePaymentCollection(BuildContext context) async {
    await routeControler.getRouteList();
    final firstRouteEnabled = routeControler.routeList.isNotEmpty &&
        routeControler.routeList[0].isEnableAllocation == 1;

    if (!firstRouteEnabled) {
      paymentPopup(context);
    } else {
      Get.to(() => PaymentCollectionScreen());
    }
  }

  dailyReport() async {
    creditSales.value = DailyReportModel();
    totalCash.value = DailyReportModel();
    totalCredit.value = DailyReportModel();
    creditSalesReturn.value = DailyReportModel();
    cashSales.value = DailyReportModel();
    cashSalesReturn.value = DailyReportModel();
    cashReciepts.value = DailyReportModel();
    cheque.value = DailyReportModel();
    cashExpenses.value = DailyReportModel();
    if (salesInvoiceLocalController.salesInvoiceHeaders.isEmpty) {
      await salesInvoiceLocalController.getsalesInvoiceHeaders();
    }
    var creditSalesAmount = 0.0;
    var creditSalesCount = 0;
    var creditSalesReturnAmount = 0.0;
    var creditSalesReturnCount = 0;
    var cashSalesAmount = 0.0;
    var cashSalesCount = 0;
    var cashSalesReturnAmount = 0.0;
    var cashSalesReturnCount = 0;
    var cashReceiptsCount = 0;
    var cashReceiptsAmount = 0.0;
    var chequesAmount = 0.0;
    var chequesCount = 0;
    var cashExpensesCount = 0;
    var cashExpensesAmount = 0.0;
    for (var transaction in salesInvoiceLocalController.salesInvoiceHeaders) {
      DateTime date = DateTime.parse(transaction.transactionDate!);
      if (sameDate(date, DateTime.now())) {
        double transactionTotal = transaction.total ?? 0.0;
        if (transaction.paymentType != 5) {
          if (transaction.isReturn == 1) {
            cashSalesReturnAmount = (cashSalesReturnAmount) + transactionTotal;
            cashSalesReturnCount++;
            update();
          } else {
            cashSalesAmount = (cashSalesAmount) + transactionTotal;
            cashSalesCount++;
            update();
          }
        } else {
          if (transaction.isReturn == 1) {
            creditSalesReturnAmount =
                (creditSalesReturnAmount) + transactionTotal;
            creditSalesReturnCount++;
            update();
          } else {
            creditSalesAmount = (creditSalesAmount) + transactionTotal;
            creditSalesCount++;
            update();
          }
        }
      }
      update();
    }
    for (var transaction
        in paymentCollectionLocalController.transactionHeaders) {
      if (sameDate(transaction.transactionDate!, DateTime.now())) {
        double transactionTotal = transaction.amount ?? 0.0;

        if (transaction.isCheque == false) {
          // if (transaction.isReturn == 1) {
          //   cashSalesReturnAmount = (cashSalesReturnAmount) + transactionTotal;
          //   cashSalesReturnCount = (cashSalesReturnCount) + transactionQuantity;
          //   update();
          // } else {
          cashReceiptsAmount = (cashReceiptsAmount) + transactionTotal;
          cashReceiptsCount++;
          update();
          // }
        } else {
          // if (transaction.isReturn == 1) {
          //   creditSalesReturnAmount =
          //       (creditSalesReturnAmount) + transactionTotal;
          //   creditSalesReturnCount =
          //       (creditSalesReturnCount) + transactionQuantity;
          //   update();
          // } else {
          chequesAmount = (chequesAmount) + transactionTotal;
          chequesCount++;
          update();
          // }
        }
      }
      update();
    }
    for (var expense in expenseLocalController.expenseTransactionHeader) {
      if (sameDate(DateTime.parse(expense.transactionDate!), DateTime.now())) {
        double transactionTotal = expense.amount ?? 0.0;

        cashExpensesAmount = (cashExpensesAmount) + -transactionTotal;
        cashExpensesCount++;
        update();
      }
    }
    cashExpenses.value =
        DailyReportModel(amount: cashExpensesAmount, count: cashExpensesCount);
    cheque.value = DailyReportModel(amount: chequesAmount, count: chequesCount);
    cashReciepts.value =
        DailyReportModel(amount: cashReceiptsAmount, count: cashReceiptsCount);
    creditSales.value =
        DailyReportModel(amount: creditSalesAmount, count: creditSalesCount);
    creditSalesReturn.value = DailyReportModel(
        amount: creditSalesReturnAmount, count: creditSalesReturnCount);
    cashSales.value =
        DailyReportModel(amount: cashSalesAmount, count: cashSalesCount);
    cashSalesReturn.value = DailyReportModel(
        amount: cashSalesReturnAmount, count: cashSalesReturnCount);
    totalCash.value = DailyReportModel(
        amount: (cashReciepts.value.amount ?? 0.0) +
            (cashSales.value.amount ?? 0.0) +
            (cashSalesReturn.value.amount ?? 0.0) +
            (cashExpenses.value.amount ?? 0.0),
        count: (cashReciepts.value.count ?? 0) +
            (cashSales.value.count ?? 0) +
            (cashSalesReturn.value.count ?? 0) +
            (cashExpenses.value.count ?? 0));
    totalCredit.value = DailyReportModel(
        amount: (creditSales.value.amount ?? 0.0) +
            (creditSalesReturn.value.amount ?? 0.0) +
            (cheque.value.amount ?? 0.0),
        count: (creditSales.value.count ?? 0) +
            (creditSalesReturn.value.count ?? 0) +
            (cheque.value.count ?? 0));
    update();
  }

  fetchData() async {
    dailyReport();
    getOrderReport();
    getPaymentCollectionList();
    getReturnList();
    getSalesInvoiceReport();
    getExpenseList();
    getActvityLogList();
    await getVisitLog();
    getCounts();
  }
}

class DailyReportModel {
  int? count;
  double? amount;
  DailyReportModel({this.count, this.amount});
}
