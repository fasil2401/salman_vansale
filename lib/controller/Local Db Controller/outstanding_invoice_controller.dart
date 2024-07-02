import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class OutstandingInvoiceListController extends GetxController {
  final outstandingInvoiceList = <OutstandingInvoiceModel>[].obs;
  final salesInvoiceList = <SalesInvoiceApiModel>[].obs;
  Future<void> getOutstandingInvoiceList() async {
    final List<Map<String, dynamic>> outstandingInvoices =
        await DBHelper().queryAllOutStandingInvoice();
    outstandingInvoiceList.assignAll(outstandingInvoices
        .map((data) => OutstandingInvoiceModel.fromMap(data))
        .toList());
    print(outstandingInvoiceList);
  }

  Future<void> getCustomerPendingInvoice(String customerId) async {
    final List<Map<String, dynamic>> outStandingInvoice =
        await DBHelper().queryCustomerOutStanding(customerId);
    outstandingInvoiceList.assignAll(outStandingInvoice
        .map((data) => OutstandingInvoiceModel.fromMap(data))
        .toList());
  }

  Future<void> getCustomerCreditInvoice(String customerId) async {
    final List<Map<String, dynamic>> salesinvoice =
        await DBHelper().queryAllocationFromSalesInvoiceCredit(customerId);
    salesInvoiceList.assignAll(salesinvoice
        .map((data) => SalesInvoiceApiModel.fromMap(data))
        .toList());
  }

  insertOutstandingInvoiceList(
      {required List<OutstandingInvoiceModel> outstandingInvoiceList}) async {
    await DBHelper().insertOutStandingInvoiceList(outstandingInvoiceList);
  }

  deleteTable() async {
    await DBHelper().deleteOutStandingInvoiceTable();
  } 
}
