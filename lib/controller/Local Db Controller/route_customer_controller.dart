import 'package:axoproject/model/Pos%20Cash%20Register%20Model/pos_cash_register_model.dart';
import 'package:axoproject/model/Route%20Customer%20Model/route_customer_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class RouteCustomerListController extends GetxController {
  final routeCustomerList = <RouteCustomerModel>[].obs;
  Future<RxList<dynamic>?> getRouteCustomerList() async {
    final List<Map<String, dynamic>> routeCustomers =
        await DBHelper().queryAllRouteCustomer();
    routeCustomerList.assignAll(
        routeCustomers.map((data) => RouteCustomerModel.fromMap(data)).toList());
        print(routeCustomerList);
  }

  insertRouteCustomerList({required List<RouteCustomerModel> routeCustomerList}) async {
    await DBHelper().insertRouteCustomerList(routeCustomerList);
  }

  deleteTable() async {
    await DBHelper().deleteRouteCustomerTable();
  } 
}
