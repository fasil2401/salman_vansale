import 'package:axoproject/model/Customer%20Balance%20Model/customer_balance_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class CustomerBalanceListController extends GetxController {
  final customerBalanceList = [].obs;
  Future<void> getCustomerBalanceList() async {
    final List<Map<String, dynamic>> customerBalances =
        await DBHelper().queryAllCustomerBalance();
    customerBalanceList.assignAll(
        customerBalances.map((data) => CustomerBalanceModel.fromMap(data)).toList());
        print(customerBalanceList);
  }

  Future<void> getAvailableCustomerBalance(String customerId) async {
    final List<Map<String, dynamic>> customerBalance =
        await DBHelper().queryCustomerBalance(customerId);
    customerBalanceList.assignAll(
        customerBalance.map((data) => CustomerBalanceModel.fromMap(data)).toList());
  }

  insertCustomerBalanceList({required List<CustomerBalanceModel> customerBalanceList}) async {
    await DBHelper().insertCustomerBalanceList(customerBalanceList);
  }

  deleteTable() async {
    await DBHelper().deleteCustomerBalanceTable();
  } 
}
