import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class CustomerPriceListController extends GetxController {
  final customerPriceList = <CustomerPriceModel>[].obs;
  Future<void> getCustomerPriceList() async {
    final List<Map<String, dynamic>> customerPrices =
        await DBHelper().queryAllCustomerPrice();
    customerPriceList.assignAll(
        customerPrices.map((data) => CustomerPriceModel.fromMap(data)).toList());
        print(customerPriceList);
  }

  insertCustomerPriceList({required List<CustomerPriceModel> customerPriceList}) async {
    await DBHelper().insertCustomerPriceList(customerPriceList);
  }

  deleteTable() async {
    await DBHelper().deleteCustomerPriceTable();
  } 
}
