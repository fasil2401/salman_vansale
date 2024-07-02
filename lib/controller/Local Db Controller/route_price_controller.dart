import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class RoutePriceListController extends GetxController {
  final routePriceList = [].obs;
  Future<void> getRoutePriceList() async {
    final List<Map<String, dynamic>> routePrices =
        await DBHelper().queryAllRoutePrice();
    routePriceList.assignAll(
        routePrices.map((data) => RoutePriceModel.fromMap(data)).toList());
        print(routePriceList);
  }

  insertRoutePriceList({required List<RoutePriceModel> routePriceList}) async {
    await DBHelper().insertRoutePriceList(routePriceList);
  }

  deleteTable() async {
    await DBHelper().deleteRoutePriceTable();
  } 
}
