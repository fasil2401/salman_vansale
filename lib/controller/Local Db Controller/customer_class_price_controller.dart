import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class CustomerClassPriceListController extends GetxController {
  final customerClassPriceList = [].obs;
  Future<void> getCustomerClassPriceList() async {
    final List<Map<String, dynamic>> customerClassPrices =
        await DBHelper().queryAllCustomerClassPrice();
    customerClassPriceList.assignAll(
        customerClassPrices.map((data) => CustomerClassPriceModel.fromMap(data)).toList());
        print(customerClassPriceList);
  }

  insertCustomerClassPriceList({required List<CustomerClassPriceModel> customerClassPriceList}) async {
    await DBHelper().insertCustomerClassPriceList(customerClassPriceList);
  }

  deleteTable() async {
    await DBHelper().deleteCustomerClassPriceTable();
  } 
}
