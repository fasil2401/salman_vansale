import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class ProductLotListController extends GetxController {
  final productLotList = <ProductLotModel>[].obs;
  Future<void> getProductLotList() async {
    final List<Map<String, dynamic>> productLots =
        await DBHelper().queryAllProductLot();
    productLotList.assignAll(
        productLots.map((data) => ProductLotModel.fromMap(data)).toList());
  }

  Future<void> getAvailableProductLotList({required String productId,required String voucher}) async {
    final List<Map<String, dynamic>> productLots =
        await DBHelper().queryAvailableProductLots(productId:productId,voucher: voucher);
    productLotList.assignAll(
        productLots.map((data) => ProductLotModel.fromMap(data)).toList());
  }

  insertProductLotList({required List<ProductLotModel> productLotList}) async {
    await DBHelper().insertProductLotList(productLotList);
  }

  deleteTable() async {
    await DBHelper().deleteProductLotTable();
  } 
}