import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class ExpensesTransactionLocalController extends GetxController {
  final expenseTransactionHeader = <ExpenseTransactionApiModel>[].obs;
  final expenseTransactionDetails = <ExpenseTransactionDetailsAPIModel>[].obs;
  final salesPOSTaxGroupDetail = <SalesPOSTaxGroupDetailApiModel>[].obs;
  Future<void> getExpensesHeaders() async {
    final List<Map<String, dynamic>> headers =
        await DBHelper().queryAllExpenseHeaders();
    expenseTransactionHeader.assignAll(headers
        .map((data) => ExpenseTransactionApiModel.fromMap(data))
        .toList());
  }

  Future<ExpenseTransactionApiModel> getExpenseHeaderUsingVoucher(
      {required String voucher}) async {
    final Map<String, dynamic>? header =
        await DBHelper().queryExpenseHeaderUsingVoucher(voucher: voucher);
    return ExpenseTransactionApiModel.fromMap(header!);
  }

  Future<int?> getLastVoucher(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    final int? lastNumber = await DBHelper().getLastVoucherExpense(
        prefix: prefix, sysDoc: sysDoc, nextNumber: nextNumber);
    return lastNumber;
  }

  Future<void> getExpenseDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryExpenseDetails(voucher: voucher);
    expenseTransactionDetails.assignAll(details
        .map((data) => ExpenseTransactionDetailsAPIModel.fromMap(data))
        .toList());
  }

  Future<void> getExpenseTaxDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryExpenseTaxDetails(voucher: voucher);
    salesPOSTaxGroupDetail.assignAll(details
        .map((data) => SalesPOSTaxGroupDetailApiModel.fromMap(data))
        .toList());
  }

  insertExpenseHeaders({required ExpenseTransactionApiModel header}) async {
    await DBHelper().insertExpenseHeader(header);
  }

  insertExpenseDetails(
      {required List<ExpenseTransactionDetailsAPIModel> detail}) async {
    await DBHelper().insertExpenseDetail(detail);
  }

  insertExpenseTaxDetails(
      {required List<SalesPOSTaxGroupDetailApiModel> tax}) async {
    await DBHelper().insertExpenseTaxDetail(tax);
  }

  updateAsNewExpensesHeader(
      {required String voucherId,
      required ExpenseTransactionApiModel header}) async {
    await DBHelper().updateAsNewExpensesHeader(voucherId, header);
  }

  updateExpensesHeaders(
      {required String voucherId,
      required int isSynced,
      required int isError,
      required String error,
      required String docNo}) async {
    await DBHelper()
        .updateExpensesHeader(voucherId, isSynced, isError, error, docNo);
  }

  updateExpensesDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateExpensesDetail(voucherId, docNo);
  }

  updateExpensesTaxDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateExpensesTaxDetail(voucherId, docNo);
  }

  deleteExpensesHeader({required String voucherId}) async {
    await DBHelper().deleteExpensesHeader(voucherId);
  }

  deleteExpensesDetails({required String voucherId}) async {
    await DBHelper().deleteExpensesDetails(voucherId);
  }

  deleteExpensesTaxDetails({required String voucherId}) async {
    await DBHelper().deleteExpensesTaxDetails(voucherId);
  }
}
