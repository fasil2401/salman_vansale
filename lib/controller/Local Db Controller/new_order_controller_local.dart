import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class NewOrderLocalController extends GetxController {
  final newOrderHeaders = <NewOrderApiModel>[].obs;
  final newOrderDetail = [].obs;
  final newOrderLotDetail = [].obs;
  final newOrderTaxDetail = [].obs;

  Future<void> getNewOrderHeaders() async {
    final List<Map<String, dynamic>> headers =
        await DBHelper().queryAllNewOrderHeaders();
    newOrderHeaders.assignAll(
        headers.map((data) => NewOrderApiModel.fromMap(data)).toList());
  }
Future<NewOrderApiModel> getNewOrderHeaderUsingVoucher(
      {required String voucher}) async {
    final Map<String, dynamic>? header =
        await DBHelper().queryNewOrderHeaderUsingVoucher(voucher: voucher);
    return NewOrderApiModel.fromMap(header!);
  }
  Future<int?> getLastVoucher(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    final int? lastNumber = await DBHelper().getLastVoucherNewOrder(
        prefix: prefix, sysDoc: sysDoc, nextNumber: nextNumber);
    return lastNumber;
  }

  Future<bool> isVoucherAlreadyPresent({required String voucher}) async {
    final bool status =
        await DBHelper().isVoucherPresentInTableNewOrder(voucher);
    return status;
  }

  Future<void> getNewOrderDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryNewOrderDetails(voucher: voucher);
    newOrderDetail.assignAll(
        details.map((data) => NewOrderDetailApiModel.fromMap(data)).toList());
  }

  Future<void> getNewOrderLotDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryNewOrderLotDetails(voucher: voucher);
    newOrderLotDetail.assignAll(
        details.map((data) => NewOrderLotApiModel.fromMap(data)).toList());
  }

  Future<void> getNewOrderTaxDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().queryNewOrderTaxDetails(voucher: voucher);
    newOrderTaxDetail
        .assignAll(details.map((data) => TaxDetail.fromMap(data)).toList());
  }

  insertNewOrderHeaders({required NewOrderApiModel header}) async {
    await DBHelper().insertNewOrderHeader(header);
  }

  insertNewOrderDetails({required List<NewOrderDetailApiModel> detail}) async {
    await DBHelper().insertNewOrderDetail(detail);
  }

  insertNewOrderLotDetails({required List<NewOrderLotApiModel> lot}) async {
    await DBHelper().insertNewOrderLotDetail(lot);
  }

  insertNewOrderTaxDetails({required List<TaxDetail> tax}) async {
    await DBHelper().insertNewOrderTaxDetail(tax);
  }
  updateAsNewNewOrdersHeader(
      {required String voucherId, required NewOrderApiModel header}) async {
    await DBHelper().updateAsNewNewOrderHeader(voucherId, header);
  }
  updateNewOrderHeaders(
      {required String voucherId,
      required int isSynced,
      required int isError,
      required String error,
      required String docNo}) async {
    await DBHelper()
        .updateNewOrderHeader(voucherId, isSynced, isError, error, docNo);
  }

  updateNewOrderDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateNewOrderDetail(voucherId, docNo);
  }

  updateNewOrderLotDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateNewOrderLotDetail(voucherId, docNo);
  }

  updateNewOrderTaxDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateNewOrderTaxDetail(voucherId, docNo);
  }

  deleteNewOrderHeader({required String voucherId}) async {
    await DBHelper().deleteNewOrderHeader(voucherId);
  }

  deleteNewOrderDetails({required String voucherId}) async {
    await DBHelper().deleteNewOrderDetails(voucherId);
  }

  deleteNewOrderLotDetails({required String voucherId}) async {
    await DBHelper().deleteNewOrderLotDetails(voucherId);
  }

  deleteNewOrderTaxDetails({required String voucherId}) async {
    await DBHelper().deleteNewOrderTaxDetails(voucherId);
  }
}
