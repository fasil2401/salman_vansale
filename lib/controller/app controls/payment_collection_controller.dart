import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/bank_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/outstanding_invoice_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/payment_collection_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sales_invoice_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/model/Bank%20Model/bank_model.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/PaymentCollectionModel/payment_collection_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Report%20Type/invoice_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

import 'package:get/get_connect/http/src/utils/utils.dart';

class PaymentCollectionController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getInitialCombos();
    getPendingPayments();
  }

  final bankListController = Get.put(BankListController());
  final customerControler = Get.put(CustomerListController());
  final cashRegisterControler = Get.put(PosCashRegisterListController());
  final salesInvoiceLocalController = Get.put(SalesInvoiceLocalController());
  final paymentCollectionLocalController =
      Get.put(PaymentCollectionLocalController());
  final loginController = Get.put(LoginController());
  final outstandingInvoiceListController =
      Get.put(OutstandingInvoiceListController());
  final reportController = Get.put(ReportController());

  final activityLocalController = Get.put(UserActivityLogLocalController());
  final homeController = Get.put(HomeController());
  var pendingInvoiceList = <OutstandingInvoiceModel>[].obs;
  var pendingFilterInvoiceList = <OutstandingInvoiceModel>[].obs;
  var selectedTotal = 0.0.obs;
  var amountController = TextEditingController().obs;
  var chequeNumberController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var selected = "Cash".obs;
  var customer = CustomerModel().obs;
  var selectedPaymentMethod = PaymentMethodModel().obs;
  var selectedBank = BankModel().obs;
  var voucherIdController = TextEditingController().obs;
  var sysDoc = SysDocDetail().obs;
  var isUpdating = false.obs;
  var voucherNumber = ''.obs;
  var bankList = [].obs;
  var helper = PrintHelper().obs;
  getInitialCombos() async {
    bankList.clear();
    if (homeController.sysDocList.isEmpty) {
      await homeController.getSystemDocList();
    }
    if (homeController.paymentMethodList.isEmpty) {
      await homeController.getPaymentMethodList();
    }
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }

    customer.value = homeController.customer.value;
    sysDoc.value = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.cashReceiptDocID);
    voucherNumber.value = await homeController.getNextVoucherPaymentCollection(
        nextNumber: sysDoc.value.nextNumber!,
        numberPrefix: sysDoc.value.numberPrefix!,
        sysDoc: sysDoc.value.sysDocID!);
    if (bankListController.bankList.isEmpty) {
      await bankListController.getBankList();
      bankList.addAll(bankListController.bankList);
    } else {
      bankList.addAll(bankListController.bankList);
    }
    update();
  }

  checkPayment(int index, var val) {
    pendingInvoiceList[index].isChecked = val;
    if (val) {
      pendingInvoiceList[index].controller?.text = pendingInvoiceList[index]
                  .availableAmount ==
              null
          ? "0.0"
          : pendingInvoiceList[index].availableAmount.toString().contains(".")
              ? pendingInvoiceList[index].availableAmount!.toStringAsFixed(2)
              : InventoryCalculations.formatPrice(
                  pendingInvoiceList[index].availableAmount ?? 0.0);
    } else {
      pendingInvoiceList[index].controller?.text =
          InventoryCalculations.formatPrice(0.0);
    }
    calculateSelectedTotal();
    update();
  }

  select(String val) async {
    selected.value = val;
    // await Future.delayed(Duration(seconds: 0));
    update();
  }

  calculateSelectedTotal() {
    selectedTotal.value = pendingInvoiceList.fold(
      0,
      (previousValue, element) =>
          previousValue +
          (element.controller!.text.isEmpty
              ? 0.0
              : double.parse(element.controller!.text)),
    );
    amountController.value.text =
        InventoryCalculations.formatPrice(selectedTotal.value);
    update();
  }

  changeSelectedAmount(int index) {
    if ((pendingInvoiceList[index].availableAmount ?? 0.0) <
        double.parse(pendingInvoiceList[index].controller!.text)) {
      pendingInvoiceList[index].isError = true;
    } else {
      pendingInvoiceList[index].isError = false;
    }
    calculateSelectedTotal();
    update();
  }

  bool isAmountEditable() {
    return selectedTotal.value <= 0.0;
  }

  Future<void> getPendingPayments() async {
    pendingInvoiceList.clear();
    if (homeController.paymentMethodList.isEmpty) {
      await homeController.getPaymentMethodList();

      selectedPaymentMethod.value = homeController.paymentMethodList[0];
    } else {
      selectedPaymentMethod.value = homeController.paymentMethodList[0];
    }

    // Fetch pending invoices for the customer
    await outstandingInvoiceListController.getCustomerPendingInvoice(
        homeController.customer.value.customerID ?? '');
    // Fetch sales invoice headers
    await outstandingInvoiceListController.getCustomerCreditInvoice(
        homeController.customer.value.customerID ?? '');

    if (outstandingInvoiceListController.outstandingInvoiceList.isNotEmpty) {
      pendingInvoiceList.value =
          outstandingInvoiceListController.outstandingInvoiceList;
    }
    if (outstandingInvoiceListController.salesInvoiceList.isNotEmpty) {
      for (var item in outstandingInvoiceListController.salesInvoiceList) {
        pendingInvoiceList.add(OutstandingInvoiceModel(
            amountDue: item.total,
            arDate: DateTime.now().toIso8601String(),
            controller: TextEditingController(
              text: InventoryCalculations.formatPrice(0.0),
            ),
            currencyID: "",
            currencyRate: 0,
            description: "",
            customerID: customer.value.parentCustomerID ?? item.customerId,
            dueDate: DateTime.now().toIso8601String(),
            job: "",
            voucherID: item.voucherid ?? "",
            sysDocID: item.sysdocid ?? "",
            reference: "",
            overdueDays: 0,
            originalAmount: item.total,
            journalID: 0,
            availableAmount: item.availableAmount,
            isChecked: false,
            isError: false));
      }
    }

    // Check if salesInvoiceHeaders is not empty
    // if (salesInvoiceLocalController.salesInvoiceHeaders.isNotEmpty) {
    //   for (var item in salesInvoiceLocalController.salesInvoiceHeaders) {
    //     if (item.paymentType == 5 &&
    //         item.customerId == homeController.customer.value.customerID) {
    //       bool hasMatchingVoucher = outstandingInvoiceListController
    //           .outstandingInvoiceList
    //           .any((invoice) {
    //         return invoice.voucherID == item.voucherid;
    //       });
    //       if (hasMatchingVoucher == false) {
    //         var newInvoice = OutstandingInvoiceModel(
    // amountDue: item.total,
    // arDate: DateTime.now().toIso8601String(),
    // controller: TextEditingController(
    //   text: InventoryCalculations.formatPrice(0.0),
    // ),
    // currencyID: "",
    // currencyRate: 0,
    // description: "",
    // customerID: item.customerId ?? "",
    // dueDate: DateTime.now().toIso8601String(),
    // job: "",
    // voucherID: item.voucherid ?? "",
    // sysDocID: item.sysdocid ?? "",
    // reference: "",
    // overdueDays: 0,
    // originalAmount: item.total,
    // journalID: 0,
    //         );

    //         pendingInvoiceList.add(newInvoice);
    //       }
    //     }
    //   }
    // } else {
    //   // Handle the case when salesInvoiceHeaders is empty
    //   print('Sales Invoice Headers is empty!');
    // }

    // Iterate over outstandingInvoiceListController.outstandingInvoiceList
    update();
  }

  paymentVoucher() async {
    sysDoc.value = await homeController.getFirstSysDoc(
        sysDocId: selected.value == "Cash"
            ? homeController.cashRegisterList.first.cashReceiptDocID
            : homeController.cashRegisterList.first.chequeReceiptDocID);
    String voucherNumber = await homeController.getNextVoucherPaymentCollection(
      numberPrefix: sysDoc.value.numberPrefix!,
      nextNumber: sysDoc.value.nextNumber!,
      sysDoc: sysDoc.value.sysDocID!,
    );
    this.voucherNumber.value = voucherNumber;
    update();
  }

  savePaymentCollection(BuildContext context) async {
    // if (pendingInvoiceList.isEmpty) {
    //   return;
    // }
    int? batchID = UserSimplePreferences.getBatchID();
    await paymentCollectionLocalController.deleteTransactionAllocationDetails(
        voucherId: voucherNumber.value);
    await paymentCollectionLocalController.deleteTransactionDetails(
        voucherId: voucherNumber.value);
    final header = CreateTransferHeaderModel(
        amount: double.parse(amountController.value.text.replaceAll(",", "")),
        companyId: "1",
        currencyId: "",
        currencyRate: 0.0,
        description: "",
        registerId:
            cashRegisterControler.posCashRegisterList.first.cashRegisterID,
        isPos: true,
        isCheque: selected.value == "Cash" ? false : true,
        divisionId: "",
        dueDate: DateTime.now(),
        voucherId: voucherNumber.value,
        transactionDate: DateTime.now(),
        sysDocType: selected.value == "Cash"
            ? SysdocType.CashReceipt.value
            : SysdocType.ChequeReceipt.value,
        customerName: customer.value.customerName,
        sysDocId: sysDoc.value.sysDocID,
        reference: "",
        isSynced: 0,
        isError: 0,
        error: "",
        posShiftId: 1,
        posBatchId: batchID,
        payeeType: "C",
        payeeId: customer.value.parentCustomerID ?? customer.value.customerID,
        footerImage: sysDoc.value.footerImage,
        headerImage: sysDoc.value.headerImage);
    // List<OutstandingInvoiceModel> outstanding = [];
    List<TransactionAllocationDetailModel> transactionAllocationDetail = [];
    List<TransactionDetailModel> transactionDetail = [];
    for (var item in pendingInvoiceList) {
      // if (item.isChecked == false ||
      //     item.isChecked &&
      //         double.parse(item.controller!.text) < (item.amountDue ?? 0.0) ||
      //     item.isChecked &&
      //         double.parse(item.controller!.text) == (item.amountDue ?? 0.0)) {
      // double amountDue =
      //     double.parse(item.controller!.text) < (item.amountDue ?? 0.0) ||
      //             item.isChecked &&
      //                 double.parse(item.controller!.text) ==
      //                     (item.amountDue ?? 0.0)
      //         ? (item.amountDue ?? 0.0) - double.parse(item.controller!.text)
      //         : item.amountDue ?? 0.0;
      transactionAllocationDetail.add(TransactionAllocationDetailModel(
          allocationDate: DateTime.parse(item.arDate!),
          arJournalId: item.journalID,
          customerId: item.customerID,
          dueAmount: item.amountDue,
          invoiceSysDocId: item.sysDocID,
          invoiceVoucherId: item.voucherID,
          isSynced: false,
          paymentAmount: double.parse(item.controller!.text),
          paymentArid: 0,
          isChecked: item.isChecked ? 1 : 0,
          paymentSysDocId: sysDoc.value.sysDocID,
          paymentVoucherId: voucherNumber.value));
      // }
      // if (item.isChecked == false ||
      //     item.isChecked &&
      //         double.parse(item.controller!.text) < (item.amountDue ?? 0.0) ||
      //     item.isChecked &&
      //         double.parse(item.controller!.text) == (item.amountDue ?? 0.0)) {
      //   double amountDue =
      //       double.parse(item.controller!.text) < (item.amountDue ?? 0.0) ||
      //               item.isChecked &&
      //                   double.parse(item.controller!.text) ==
      //                       (item.amountDue ?? 0.0)
      //           ? (item.amountDue ?? 0.0) - double.parse(item.controller!.text)
      //           : item.amountDue ?? 0.0;
      //   outstanding.add(OutstandingInvoiceModel(
      //       amountDue: amountDue,
      //       arDate: item.arDate,
      //       controller: item.controller,
      //       currencyID: item.currencyID,
      //       currencyRate: item.currencyRate,
      //       customerID: item.customerID,
      //       description: item.description,
      //       dueDate: item.dueDate,
      //       isChecked: item.isChecked,
      //       isError: item.isError,
      //       job: item.job,
      //       journalID: item.journalID,
      //       originalAmount: item.originalAmount,
      //       overdueDays: item.overdueDays,
      //       reference: item.reference,
      //       sysDocID: item.sysDocID,
      //       voucherID: item.voucherID));
      // }
    }
    transactionDetail.add(TransactionDetailModel(
        amount: double.parse(amountController.value.text.replaceAll(",", "")),
        amountFc: 0,
        bankId: selected.value == "Cheque" ? selectedBank.value.bankCode : "",
        chequeDate: DateTime.now(),
        chequeNumber:
            selected.value == "Cheque" ? chequeNumberController.value.text : "",
        description: remarksController.value.text,
        isSynced: false,
        paymentMethodtype: selected.value == "Cash" ? 1 : 2,
        paymentMethodId: selected.value == "Cash"
            ? selectedPaymentMethod.value.paymentMethodID
            : selectedBank.value.bankCode,
        voucherId: voucherNumber.value));
    await paymentCollectionLocalController.insertTransactionAllocationDetails(
        detail: transactionAllocationDetail);
    await paymentCollectionLocalController.insertTransactionDetails(
        detail: transactionDetail);
    if (isUpdating.value) {
      await paymentCollectionLocalController
          .updateAsNewPaymentTransactionHeader(
              voucherId: voucherNumber.value,
              header: header,
              sysDocId: header.sysDocId ?? '');
    } else {
      await paymentCollectionLocalController.insertTransactionHeaders(
          header: header);
    }
    // await outstandingInvoiceListController.deleteTable();
    // await outstandingInvoiceListController.insertOutstandingInvoiceList(
    //     outstandingInvoiceList: outstanding);
    await paymentCollectionLocalController.getTransactionHeaders();
    await paymentCollectionLocalController.getTransactionAllocationDetail(
        voucher: voucherNumber.value);
    await paymentCollectionLocalController.getTransactionDetails(
        voucher: voucherNumber.value);
    dev.log("${paymentCollectionLocalController.transactionAllocationDetail}",
        name: "allocation detail");
    dev.log("${paymentCollectionLocalController.transactionHeaders}",
        name: "header");
    dev.log("${paymentCollectionLocalController.transactionDetail}",
        name: "detail");
    // printCashChequeReceipt(voucherNumber.value);
    activityLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: header.sysDocId,
            voucherId: voucherIdController.value.text,
            activityType: isUpdating.value
                ? ActivityTypes.update.value
                : ActivityTypes.add.value,
            date: DateTime.now().toIso8601String(),
            description:
                "${isUpdating.value ? 'Updated' : 'Saved'} Payment Transaction in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    printRecipt(voucherNumber.value);
    if (isUpdating.value) {
      reportController.getPaymentCollectionList();
    }
    clearDatas();
    if (isUpdating.value == false) {
      await homeController.updateSysdocNextNumber(
          sysDoc: sysDoc.value.sysDocID ?? "",
          nextNumber: sysDoc.value.nextNumber ?? 0);
    }
    if (isUpdating.value) {
      isUpdating.value = false;
      // Navigator.pop(context);
    }
    await getInitialCombos();
    SnackbarServices.successSnackbar('Successfully saved in local');
  }

  printRecipt(String voucherID) async {
    CreateTransferHeaderModel header = await paymentCollectionLocalController
        .getPaymentHeaderUsingVoucher(voucher: voucherID);
    await paymentCollectionLocalController.getTransactionDetails(
        voucher: voucherID);
    var customerList = (await customerControler.getCustomerList())!;
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.payeeId);

    String taxNumber = customers.taxIDNumber ?? "";
    var item = paymentCollectionLocalController.transactionDetail[0];
    PrintHelper helper = PrintHelper(
      transactionDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      trn: taxNumber,
      recieptNo: voucherID,
      recieptDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      chequeNumber: item.chequeNumber,
      remarks: item.description,
      receivedFrom: header.customerName,
      amount: item.amount.toString(),
      amountInWords: PrintHelper.convertAmountToWords(item.amount),
      isCheque: item.paymentMethodtype == 1 ? false : true,
      headerImage: header.headerImage,
      footerImage: header.footerImage,
    );
    this.helper.value = helper;
  }

  editPaymentsFromReport(CreateTransferHeaderModel header) async {
    pendingInvoiceList.clear();
    // clearDatas();
    // await getPendingPayments();
    if (homeController.paymentMethodList.isEmpty) {
      await homeController.getPaymentMethodList();
    }
    await paymentCollectionLocalController.getTransactionDetails(
        voucher: header.voucherId.toString());

    selectedTotal.value = header.amount;
    amountController.value.text = "${header.amount}";
    isUpdating.value = true;
    voucherNumber.value = header.voucherId.toString();
    sysDoc.value = homeController.sysDocList
        .firstWhere((element) => element.sysDocID == header.sysDocId);
    customer.value = CustomerModel(
        customerName: header.customerName, customerID: header.payeeId);
    await paymentCollectionLocalController
        .getTransactionAllocationDetailUsingCustomeId(
            customerId: header.payeeId ?? '',
            paymentVoucherId: header.voucherId.toString());
    // await outstandingInvoiceListController.getAllocationListForEditCredit(
    //     header.payeeId ?? '', header.voucherId.toString());
    if (paymentCollectionLocalController
        .transactionAllocationDetail.isNotEmpty) {
      for (var item
          in paymentCollectionLocalController.transactionAllocationDetail) {
        pendingInvoiceList.add(OutstandingInvoiceModel(
            amountDue: item.dueAmount,
            arDate: item.allocationDate!.toIso8601String(),
            availableAmount: item.availableAmount,
            controller: TextEditingController(text: "${item.paymentAmount}"),
            currencyID: "",
            currencyRate: 0,
            customerID: item.customerId,
            description: "",
            dueDate: DateTime.now().toIso8601String(),
            isChecked: item.isChecked == 1 ? true : false,
            isError: false,
            job: "",
            journalID: item.arJournalId,
            originalAmount: item.dueAmount,
            overdueDays: 0,
            reference: "",
            sysDocID: item.invoiceSysDocId,
            voucherID: item.invoiceVoucherId));
      }
    }
    for (var item in paymentCollectionLocalController.transactionDetail) {
      dev.log("${item.chequeNumber}");
      remarksController.value.text = item.description ?? "";
      chequeNumberController.value.text = "${item.chequeNumber}";
      selectedPaymentMethod.value = PaymentMethodModel(
        paymentMethodID: item.paymentMethodId,
        methodType: item.paymentMethodtype,
      );
      selected.value = item.paymentMethodtype == 1 ? "Cash" : "Cheque";
      selectedBank.value = BankModel(
        bankCode: item.bankId,
      );
    }

    update();
  }

  clearDatas() {
    amountController.value.clear();
    chequeNumberController.value.clear();
    remarksController.value.clear();
    for (var item in pendingInvoiceList) {
      item.isChecked = false;
      item.controller!.text = "0.0";
    }
    selected.value = "Cash";
  }

  printCashChequeReceipt(String voucherID) async {
    CreateTransferHeaderModel header = await paymentCollectionLocalController
        .getPaymentHeaderUsingVoucher(voucher: voucherID);
    await paymentCollectionLocalController.getTransactionDetails(
        voucher: voucherID);
    var customerList = (await customerControler.getCustomerList())!;
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.payeeId);

    String taxNumber = customers.taxIDNumber ?? "";
    var item = paymentCollectionLocalController.transactionDetail[0];
    double amount = item.amount ?? 0.0;

    PrintHelper helper = PrintHelper(
      transactionDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
      vanName: UserSimplePreferences.getVanName() ?? '',
      trn: taxNumber,
      recieptNo: voucherID,
      recieptDate: DateFormatter.invoiceDateFormat.format(DateTime.now()),
      chequeNumber: item.chequeNumber,
      headerImage: header.headerImage,
      footerImage: header.footerImage,
      remarks: item.description,
      receivedFrom: header.customerName,
      amount: amount.toStringAsFixed(2),
      amountInWords: PrintHelper.convertAmountToWords(item.amount),
      isCheque: item.paymentMethodtype == 1 ? false : true,
    );

    this.helper.value = helper;
  }

  deleteSavedRequest(String voucher, String sysDocId, int index) async {
    await paymentCollectionLocalController.deleteCreateTransferHeader(
        voucherId: voucher);
    await paymentCollectionLocalController.deleteTransactionAllocationDetails(
        voucherId: voucher);
    await paymentCollectionLocalController.deleteTransactionDetails(
        voucherId: voucher);
    await activityLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: sysDocId,
            voucherId: voucher,
            activityType: ActivityTypes.delete.value,
            date: DateTime.now().toIso8601String(),
            description: "Deleted Payment Transaction in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    update();
  }
}
