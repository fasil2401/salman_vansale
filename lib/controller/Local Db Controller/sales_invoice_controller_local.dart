import 'dart:developer';

import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class SalesInvoiceLocalController extends GetxController {
  final salesInvoiceHeaders = <SalesInvoiceApiModel>[].obs;
  final salesInvoiceDetail = [].obs;
  final salesInvoiceLotDetail = [].obs;
  final salesInvoiceTaxDetail = [].obs;

  Future<void> getsalesInvoiceHeaders() async {
    final List<Map<String, dynamic>> headers =
        await DBHelper().queryAllSalesInvoiceHeaders();
    salesInvoiceHeaders.assignAll(
        headers.map((data) => SalesInvoiceApiModel.fromMap(data)).toList());
  }

  Future<SalesInvoiceApiModel> getsalesInvoiceHeaderUsingVoucher(
      {required String voucher}) async {
    final Map<String, dynamic>? header =
        await DBHelper().querySalesInvoiceHeaderUsingVoucher(voucher: voucher);
    return SalesInvoiceApiModel.fromMap(header!);
  }

  Future<int?> getLastVoucher(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    final int? lastNumber = await DBHelper()
        .getLastVoucher(prefix: prefix, sysDoc: sysDoc, nextNumber: nextNumber);
    return lastNumber;
  }

  Future<bool> isVoucherAlreadyPresent({required String voucher}) async {
    final bool status = await DBHelper().isVoucherPresentInTable(voucher);
    return status;
  }

  Future<void> getsalesInvoiceDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().querySalesInvoiceDetails(voucher: voucher);
    salesInvoiceDetail.assignAll(details
        .map((data) => SalesInvoiceDetailApiModel.fromMap(data))
        .toList());
  }

  Future<void> getsalesInvoiceLotDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().querySalesInvoiceLotDetails(voucher: voucher);
    salesInvoiceLotDetail.assignAll(
        details.map((data) => SalesInvoiceLotApiModel.fromMap(data)).toList());
  }

  Future<void> getsalesInvoiceTaxDetails({required String voucher}) async {
    final List<Map<String, dynamic>> details =
        await DBHelper().querySalesInvoiceTaxDetails(voucher: voucher);
    log(details.toString(), name: 'Tax list');
    salesInvoiceTaxDetail.assignAll(
        details.map((data) => TaxGroupDetail.fromMap(data)).toList());
  }

  insertsalesInvoiceHeaders({required SalesInvoiceApiModel header}) async {
    await DBHelper().insertSalesInvoiceHeader(header);
  }

  insertsalesInvoiceDetails(
      {required List<SalesInvoiceDetailApiModel> detail}) async {
    await DBHelper().insertSalesInvoiceDetail(detail);
  }

  insertsalesInvoiceLotDetails(
      {required List<SalesInvoiceLotApiModel> lot}) async {
    await DBHelper().insertSalesInvoiceLotDetail(lot);
  }

  insertsalesInvoiceTaxDetails({required List<TaxGroupDetail> tax}) async {
    log('Inserting tax detailsss', name: 'Tax list');
    await DBHelper().insertSalesInvoiceTaxDetail(tax);
  }

  updateAsNewSalesInvoiceHeader(
      {required String voucherId, required SalesInvoiceApiModel header}) async {
    await DBHelper().updateAsNewSalesInvoiceHeader(voucherId, header);
  }

  updatesalesInvoiceHeaders(
      {required String voucherId,
      required int isSynced,
      required int isError,
      required String error,
      required String docNo}) async {
    await DBHelper()
        .updateSalesInvoiceHeader(voucherId, isSynced, isError, error, docNo);
  }

  updatesalesInvoiceDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateSalesInvoiceDetail(voucherId, docNo);
  }

  updatesalesInvoiceLotDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateSalesInvoiceLotDetail(voucherId, docNo);
  }

  updatesalesInvoiceTaxDetails(
      {required String voucherId, required String docNo}) async {
    await DBHelper().updateSalesInvoiceTaxDetail(voucherId, docNo);
  }

  deletesalesInvoiceHeader({required String voucherId}) async {
    await DBHelper().deleteSalesInvoiceHeader(voucherId);
  }

  deletesalesInvoiceDetails({required String voucherId}) async {
    await DBHelper().deleteSalesInvoiceDetails(voucherId);
  }

  deletesalesInvoiceLotDetails({required String voucherId}) async {
    await DBHelper().deleteSalesInvoiceLotDetails(voucherId);
  }

  deletesalesInvoiceTaxDetails({required String voucherId}) async {
    await DBHelper().deleteSalesInvoiceTaxDetails(voucherId);
    // log(i.toString(), name: 'Tax response');
  }
}
