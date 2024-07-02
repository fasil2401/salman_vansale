import 'dart:developer';

import 'package:axoproject/model/Local%20Db%20Model/PaymentCollectionModel/payment_collection_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class PaymentCollectionLocalController extends GetxController {
  final transactionHeaders = <CreateTransferHeaderModel>[].obs;
  final transactionAllocationDetail = <TransactionAllocationDetailModel>[].obs;
  final transactionDetail = <TransactionDetailModel>[].obs;

  Future<void> getTransactionHeaders() async {
    final List<Map<String, dynamic>> headers =
        await DBHelper().queryAllTransactions();
    transactionHeaders.assignAll(headers
        .map((data) => CreateTransferHeaderModel.fromMap(data))
        .toList());
  }

  Future<CreateTransferHeaderModel> getPaymentHeaderUsingVoucher(
      {required String voucher}) async {
    final Map<String, dynamic>? header =
        await DBHelper().queryPaymenteHeaderUsingVoucher(voucher: voucher);
    return CreateTransferHeaderModel.fromMap(header ?? {});
  }

  Future<int?> getLastVoucher(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    final int? lastNumber = await DBHelper().getLastVoucherPaymentCollection(
        prefix: prefix, sysDoc: sysDoc, nextNumber: nextNumber);
    return lastNumber;
  }

  Future<bool> isVoucherAlreadyPresent({required String voucher}) async {
    final bool status =
        await DBHelper().isVoucherPresentInTablePaymentCollection(voucher);
    return status;
  }

  Future<void> getTransactionAllocationDetail({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryAllTransactionAllocationDetails(voucher: voucher);
    transactionAllocationDetail.assignAll(details
        .map((data) => TransactionAllocationDetailModel.fromMap(data))
        .toList());
  }

  Future<void> getTransactionAllocationDetailUsingCustomeId(
      {required String customerId, required String paymentVoucherId}) async {
    final List<Map<String, dynamic>> details = await DBHelper()
        .queryTransactionAllocationDetail(customerId, paymentVoucherId);
    transactionAllocationDetail.assignAll(details
        .map((data) => TransactionAllocationDetailModel.fromMap(data))
        .toList());
  }

  Future<void> getTransactionDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryAllTransactionDetails(voucher: voucher);
    transactionDetail.assignAll(
        details.map((data) => TransactionDetailModel.fromMap(data)).toList());
  }

  insertTransactionHeaders({required CreateTransferHeaderModel header}) async {
    await DBHelper().insertCreateTransferHeader(header);
  }

  insertTransactionAllocationDetails(
      {required List<TransactionAllocationDetailModel> detail}) async {
    await DBHelper().insertTransactionAllocationDetail(detail);
  }

  insertTransactionDetails(
      {required List<TransactionDetailModel> detail}) async {
    await DBHelper().insertTransactionDetail(detail);
  }

  updateAsNewPaymentTransactionHeader(
      {required String voucherId,
      required CreateTransferHeaderModel header,
      required String sysDocId}) async {
    await DBHelper()
        .updateAsNewPaymentTransactionHeader(voucherId, header, sysDocId);
  }

  updateCreateTransferHeader(
      {required String voucherId,
      required int isSynced,
      required int isError,
      required String error,
      required String docNo}) async {
    await DBHelper()
        .updateCreateTransferHeader(voucherId, isSynced, isError, error, docNo);
  }

  updateTransactionAllocationDetails(
      {required String voucherId,
      required String docNo,
      required int isSynced}) async {
    await DBHelper()
        .updateTransactionAllocationDetails(voucherId, docNo, isSynced);
  }

  updateTransactionDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateTransactionDetails(voucherId, docNo);
  }

  deleteCreateTransferHeader({required String voucherId}) async {
    await DBHelper().deleteCreateTransferHeader(voucherId);
  }

  deleteTransactionAllocationDetails({required String voucherId}) async {
    await DBHelper().deleteTransactionAllocationDetails(voucherId);
  }

  deleteTransactionDetails({required String voucherId}) async {
    await DBHelper().deleteTransactionDetails(voucherId);
  }
}
