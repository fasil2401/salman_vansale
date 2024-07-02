import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/account_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/expenses_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/tax_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/model/Account%20Model/account_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Report%20Type/invoice_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/print_helper.dart';

class ExpensesController extends GetxController {
  @override
  void onInit() {
    getInitialCombos();
    super.onInit();
  }

  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final homeController = Get.put(HomeController());
  final expenseLocalController = Get.put(ExpensesTransactionLocalController());
  final accountController = Get.put(AccountListController());
  final cashRegisterControler = Get.put(PosCashRegisterListController());
  final taxController = Get.put(TaxListController());
  var sysDocIdController = TextEditingController().obs;
  var sysDocSuffixLoading = false.obs;
  var sysDoc = SysDocDetail().obs;
  var voucherIdController = TextEditingController().obs;
  var amountController = TextEditingController().obs;
  var voucherSuffixLoading = false.obs;
  var voucherNumber = ''.obs;
  var selectedItems = [].obs;
  var taxList = [].obs;
  var expensesList = <AccountModel>[].obs;
  var expensesFilterList = <AccountModel>[].obs;
  var totalTax = 0.0.obs;
  var subTotal = 0.0.obs;
  var total = 0.0.obs;
  var taxAmount = 0.0.obs;
  var taxPecentage = 0.obs;
  var isLoading = false.obs;
  var selectedTax = TaxModel().obs;
  var isUpdating = false.obs;
  var isError = false.obs;
  var error = ''.obs;
  clearGrid() {
    selectedItems.clear();
    total.value = 0.0;
    subTotal.value = 0.0;
    totalTax.value = 0.0;
    update();
  }

  getInitialCombos() async {
    if (homeController.sysDocList.isEmpty) {
      await homeController.getSystemDocList();
    }
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }

    sysDoc.value = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.expenseDocID);
    sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
    if (sysDoc.value.nextNumber != null) {
      voucherNumber.value = await homeController.getNextVoucherExpenses(
          nextNumber: sysDoc.value.nextNumber!,
          numberPrefix: sysDoc.value.numberPrefix!,
          sysDoc: sysDoc.value.sysDocID!);
      voucherIdController.value.text = voucherNumber.value;
    }
    update();
  }

  addItem(var item) {
    selectedItems.add(ItemModel(
        expense: item,
        taxAmount: taxAmount.value,
        amount: (double.parse(amountController.value.text)),
        tax: selectedTax.value));
    Get.back();
    calculateTotal();
    update();
  }

  calculateTax() {
    String amount =
        amountController.value.text.isEmpty ? "0" : amountController.value.text;
    if (selectedTax.value.taxRate != null) {
      double taxDouble = selectedTax.value.taxRate;
      int taxInt = taxDouble.round();
      taxPecentage.value = taxInt;
      var tax = (taxPecentage.value / 100) * double.parse(amount);
      taxAmount.value = tax;
    }
    update();
  }

  clearPopup() {
    amountController.value.clear();
    taxPecentage.value = 0;
    taxAmount.value = 0.0;
    selectedTax.value = TaxModel();
    update();
  }

  deleteItem(int index) {
    selectedItems.removeAt(index);
    update();
  }

  updateItem(ItemModel item) {
    String amount =
        amountController.value.text.isEmpty ? "0" : amountController.value.text;
    item.amount = double.parse(amount);
    item.taxAmount = taxAmount.value;
    item.tax = selectedTax.value;
    calculateTotal();
    update();
  }

  getExpensesList() async {
    await accountController.getAccountList();
    await taxController.getTaxList();
    if (accountController.accountList.isNotEmpty) {
      expensesList.value = accountController.accountList;
      expensesFilterList.value = expensesList;
    }
    if (taxController.taxList.isNotEmpty) {
      taxList.value = taxController.taxList;
    }
    update();
  }

  printExpenses(String voucherID, {bool isPreview = false}) async {
    ExpenseTransactionApiModel header = await expenseLocalController
        .getExpenseHeaderUsingVoucher(voucher: voucherID);
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

  calculateTotal() {
    subTotal.value = selectedItems.fold(
        0, (previousValue, item) => previousValue + (item.amount ?? 0.0));
    totalTax.value = selectedItems.fold(
        0,
        (double previousValue, product) =>
            previousValue + (product.taxAmount ?? 0.0));

    total.value = subTotal.value + totalTax.value;
    log("${total.value}");
    update();
  }

  saveExpenseTransaction(BuildContext context) async {
    if (selectedItems.isEmpty) {
      SnackbarServices.errorSnackbar('Please Add items');
      return;
    }
    await expenseLocalController.deleteExpensesDetails(
        voucherId: voucherNumber.value);
    await expenseLocalController.deleteExpensesTaxDetails(
        voucherId: voucherNumber.value);
    await cashRegisterControler.getCashRegisterList();
    int itemRowIndex = 0;
    int taxRowIndex = 0;
    log("${cashRegisterControler.posCashRegisterList.first.cashRegisterID}",
        name: '1');
    List<ExpenseTransactionDetailsAPIModel> detail = [];
    List<SalesPOSTaxGroupDetailApiModel> tax = [];
    for (ItemModel item in selectedItems) {
      detail.add(ExpenseTransactionDetailsAPIModel(
          accountID: item.expense?.accountID ?? "",
          amount: item.amount,
          description: item.expense?.accountName ?? "",
          amountFC: 0,
          rowIndex: itemRowIndex,
          taxAmount: item.taxAmount,
          taxGroupId: item.tax?.taxGroupID ?? "",
          voucherId: voucherNumber.value));

      tax.add(SalesPOSTaxGroupDetailApiModel(
          calculationMethod: "${item.tax?.calculationMethod ?? '1'}",
          currencyID: '',
          items: item.tax?.taxItemName ?? "",
          sysDocId: sysDoc.value.sysDocID,
          taxAmount: item.taxAmount,
          voucherId: voucherNumber.value,
          taxRate: item.tax?.taxRate ?? 0.0,
          orderIndex: itemRowIndex,
          rowIndex: taxRowIndex,
          taxCode: item.tax?.taxCode ?? "",
          taxGroupId: item.tax?.taxGroupID ?? ""));
      taxRowIndex++;
      itemRowIndex++;
    }

    log("${cashRegisterControler.posCashRegisterList.first.cashRegisterID}");
    final ExpenseTransactionApiModel header = ExpenseTransactionApiModel(
        amount: total.value,
        transactionDate: DateTime.now().toIso8601String(),
        sysDocID: sysDoc.value.sysDocID,
        taxAmount: totalTax.value,
        voucherID: voucherNumber.value,
        companyID: "1",
        divisionID: "1",
        reference: "",
        isError: isError.value ? 1 : 0,
        isSynced: 0,
        error: error.value,
        taxGroupId: "",
        footerImage: sysDoc.value.footerImage,
        headerImage: sysDoc.value.headerImage,
        registerID:
            cashRegisterControler.posCashRegisterList.first.cashRegisterID);
    await Future.delayed(const Duration(milliseconds: 1));
    if (isUpdating.value) {
      await expenseLocalController.updateAsNewExpensesHeader(
          voucherId: voucherIdController.value.text, header: header);
    } else {
      await expenseLocalController.insertExpenseHeaders(header: header);
    }
    await expenseLocalController.insertExpenseDetails(detail: detail);
    await expenseLocalController.insertExpenseTaxDetails(tax: tax);
    await expenseLocalController.getExpensesHeaders();
    await expenseLocalController.getExpenseDetails(
        voucher: voucherIdController.value.text);
    await expenseLocalController.getExpenseTaxDetails(
        voucher: voucherIdController.value.text);
    log("${expenseLocalController.expenseTransactionHeader}", name: "header");
    log("${expenseLocalController.expenseTransactionDetails}", name: "detail");
    log("${expenseLocalController.salesPOSTaxGroupDetail}", name: "tax");
    activityLogLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: header.sysDocID,
            voucherId: header.voucherID,
            activityType: isUpdating.value
                ? ActivityTypes.update.value
                : ActivityTypes.add.value,
            date: DateTime.now().toIso8601String(),
            description:
                "${isUpdating.value ? 'Updated' : 'Saved'} Expense Transaction in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    var helper = await printExpenses(voucherIdController.value.text);
    ThermalPrintHeplper.getConnection(
        context, helper, PrintLayouts.ExpenseTransaction);
    clearGrid();
    if (isUpdating.value == false) {
      await homeController.updateSysdocNextNumber(
          sysDoc: sysDoc.value.sysDocID ?? "",
          nextNumber: sysDoc.value.nextNumber ?? 0);
    }
    await getInitialCombos();

    SnackbarServices.successSnackbar('Successfully saved in local');
    if (isUpdating.value) {
      isUpdating.value = false;
      Navigator.pop(context);
    }
  }

  deleteSavedTransaction(String? voucherID, String sysDocId, int index) async {
    await expenseLocalController.deleteExpensesHeader(
        voucherId: voucherID ?? "");
    await expenseLocalController.deleteExpensesDetails(
        voucherId: voucherID ?? "");
    await expenseLocalController.deleteExpensesTaxDetails(
        voucherId: voucherID ?? "");
    activityLogLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: sysDocId,
            voucherId: voucherID,
            activityType: ActivityTypes.delete.value,
            date: DateTime.now().toIso8601String(),
            description: "Deleted Expense Transaction in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    update();
  }

  editExpenseTransaction(ExpenseTransactionApiModel header) async {
    clearGrid();
    getExpensesList();
    await expenseLocalController.getExpenseDetails(
        voucher: header.voucherID ?? "");
    await expenseLocalController.getExpenseTaxDetails(
        voucher: header.voucherID ?? '');
    if (expenseLocalController.expenseTransactionDetails.isEmpty) {
      return;
    }
    voucherNumber.value = header.voucherID ?? '';
    sysDoc.value =
        await homeController.getFirstSysDoc(sysDocId: header.sysDocID!);
    isError.value = header.isError == 1 ? true : false;
    error.value = header.error ?? '';
    sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
    voucherIdController.value.text = voucherNumber.value;
    total.value = header.amount ?? 0.0;
    totalTax.value = header.taxAmount ?? 0.0;
    subTotal.value = (total.value - totalTax.value);
    isUpdating.value = true;
    for (var item in expenseLocalController.expenseTransactionDetails) {
      AccountModel? expense = accountController.accountList.firstWhere(
        (element) => element.accountID == item.accountID,
        orElse: () => AccountModel(
            cashRegisterID: "",
            displayName: "",
            accountID: "",
            accountName: ""), // Handle the case when no element is found
      );

      var tax = taxController.taxList.firstWhere(
        (element) => element.taxGroupID == item.taxGroupId,
        orElse: () => TaxModel(), // Handle the case when no element is found
      );

      selectedItems.add(ItemModel(
        amount: item.amount,
        expense: AccountModel(
          cashRegisterID: expense.accountID,
          displayName: expense.displayName,
          accountID: expense.accountID,
          accountName: expense.accountName,
        ),
        tax: TaxModel(
          calculationMethod: tax.calculationMethod,
          rowIndex: tax.rowIndex,
          taxCode: tax.taxCode,
          taxGroupID: tax.taxGroupID,
          taxItemName: tax.taxItemName,
          taxRate: tax.taxRate,
          taxType: tax.taxType,
        ),
        taxAmount: item.taxAmount,
      ));
    }

    update();
  }
}

class ItemModel {
  AccountModel? expense;
  double? taxAmount;
  double? amount;
  TaxModel? tax;
  ItemModel({this.expense, this.taxAmount, this.tax, this.amount});
}
