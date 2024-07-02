import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class PaymentMethodListController extends GetxController {
  final paymentMethodList = <PaymentMethodModel>[].obs;
  Future<void> getPaymentMethodList() async {
    final List<Map<String, dynamic>> paymentMethods =
        await DBHelper().queryAllPaymentMethod();
    paymentMethodList.assignAll(
        paymentMethods.map((data) => PaymentMethodModel.fromMap(data)).toList());
  }

  insertPaymentMethodList({required List<PaymentMethodModel> paymentMethodList}) async {
    await DBHelper().insertPaymentMethodList(paymentMethodList);
  }

  deleteTable() async {
    await DBHelper().deletePaymentMethodTable();
  } 
}