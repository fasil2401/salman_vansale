import 'package:axoproject/controller/Local%20Db%20Controller/customer_balance_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/outstanding_invoice_controller.dart';
import 'package:axoproject/model/Customer%20Balance%20Model/customer_balance_model.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:get/get.dart';

class CustomerAccountController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  CustomerAccountController(this.customerId);

  var customerList = <dynamic>[].obs;
  final customerControler = Get.put(CustomerListController());
  final customerBalanceControler = Get.put(CustomerBalanceListController());
  final outStandingInvoiceControler =
      Get.put(OutstandingInvoiceListController());

  /// variable required
  String customerId = '';
  RxDouble balance = 0.0.obs;
  RxDouble credit = 0.0.obs;
  RxDouble invoice = 0.0.obs;
  RxDouble receipt = 0.0.obs;
  RxDouble returnTotal = 0.0.obs;
  RxString status = ''.obs;
  RxDouble available = 0.0.obs;
  RxDouble pdc = 0.0.obs;
  RxDouble netAmount = 0.0.obs;

  RxBool showInvoice = false.obs;
  RxBool showReturn = false.obs;
  RxBool showReceipt = false.obs;

  RxList<OutstandingInvoiceModel> invoices = <OutstandingInvoiceModel>[].obs;

  getAllCustomers() async {
    customerList.value = await customerControler.getCustomerList() ?? [];
    update();
  }

  Future<void> fetchData() async {
    await customerBalanceControler.getAvailableCustomerBalance(customerId);
    CustomerBalanceModel? customer =
        customerBalanceControler.customerBalanceList.isNotEmpty
            ? customerBalanceControler.customerBalanceList.first
            : null;
    var sales = <dynamic>[]; // SalesPosModel
    var returns = <dynamic>[]; // SalesReturnModel
    var receipts = <dynamic>[]; // ReceiptModel

    balance.value = (customer != null)
        ? double.parse((customer.balance ?? 0).toStringAsFixed(2))
        : 0.0;

    credit.value = (customer != null)
        ? double.parse((customer.creditAmount ?? 0).toStringAsFixed(2))
        : 0.0;
    invoice.value =
        sales.fold<double>(0, (previousValue, s) => previousValue + s.total);
    receipt.value = receipts.fold<double>(
        0, (previousValue, s) => previousValue + s.amount);
    returnTotal.value =
        returns.fold<double>(0, (previousValue, s) => previousValue + s.total);

    invoice.value =
        sales.fold<double>(0, (previousValue, s) => previousValue + s.total);
    receipt.value = receipts.fold<double>(
        0, (previousValue, s) => previousValue + s.amount);
    returnTotal.value =
        returns.fold<double>(0, (previousValue, s) => previousValue + s.total);

    showInvoice.value = sales.isNotEmpty;
    showReturn.value = returns.isNotEmpty;
    showReceipt.value = receipts.isNotEmpty;
    status.value = customer?.isInactive == 1 ? 'DeActive' : 'Active';
    if (customer?.isHold == 1) {
      status.value = 'Hold';
    }
    available.value = credit.value -
        balance.value -
        invoice.value +
        receipt.value +
        returnTotal.value;
    pdc.value = (customer != null)
        ? double.parse((customer.pdcAmount ?? 0).toStringAsFixed(2))
        : 0;

    netAmount.value = balance.value - pdc.value;

    await outStandingInvoiceControler.getCustomerPendingInvoice(customerId);
    List<OutstandingInvoiceModel> outstandingInvoices =
        outStandingInvoiceControler.outstandingInvoiceList
            .toList()
            .cast<OutstandingInvoiceModel>();

    invoices.clear();
    invoices.addAll(outstandingInvoices);
    update();
  }
}
