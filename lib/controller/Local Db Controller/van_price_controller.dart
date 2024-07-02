import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class VanPriceListController extends GetxController {
  final vanPriceList = [].obs;
  Future<void> getVanPriceList() async {
    final List<Map<String, dynamic>> vanPrices =
        await DBHelper().queryAllVanPrice();
    vanPriceList.assignAll(
        vanPrices.map((data) => VanPriceModel.fromMap(data)).toList());
        print(vanPriceList);
  }

  insertVanPriceList({required List<VanPriceModel> vanPriceList}) async {
    await DBHelper().insertVanPriceList(vanPriceList);
  }

  deleteTable() async {
    await DBHelper().deleteVanPriceTable();
  } 
}
