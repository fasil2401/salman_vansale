import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class LocationPriceListController extends GetxController {
  final locationPriceList = [].obs;
  Future<void> getLocationPriceList() async {
    final List<Map<String, dynamic>> locationPrices =
        await DBHelper().queryAllLocationPrice();
    locationPriceList.assignAll(
        locationPrices.map((data) => LocationPriceModel.fromMap(data)).toList());
        print(locationPriceList);
  }

  insertLocationPriceList({required List<LocationPriceModel> locationPriceList}) async {
    await DBHelper().insertLocationPriceList(locationPriceList);
  }

  deleteTable() async {
    await DBHelper().deleteLocationPriceTable();
  } 
}
