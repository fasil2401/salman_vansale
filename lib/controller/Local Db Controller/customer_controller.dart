import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class CustomerListController extends GetxController {
  final customerList = <CustomerModel>[].obs;
  Future<RxList<dynamic>?> getCustomerList() async {
    final List<Map<String, dynamic>> customers =
        await DBHelper().queryAllCustomer();
    customerList.assignAll(
        customers.map((data) => CustomerModel.fromMap(data)).toList());
        print(customerList);
        return customerList;
  }

  insertCustomerList({required List<CustomerModel> customerList}) async {
    await DBHelper().insertCustomerList(customerList);
  }

  deleteTable() async {
    await DBHelper().deleteCustomerTable();
  } 
}
