import 'dart:developer';

import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final productList = <ProductModel>[].obs;
  Future<void> getProductList() async {
    final List<Map<String, dynamic>> products =
        await DBHelper().queryAllProductBasedOnStock();
    productList
        .assignAll(products.map((data) => ProductModel.fromMap(data)).toList());
  }

  Future<ProductModel> getProductById(
      {required double quantity, required String productId}) async {
    final List<Map<String, dynamic>> products = await DBHelper()
        .queryProductBasedOnStock(quantity: quantity, productId: productId);
    return products.map((data) => ProductModel.fromMap(data)).toList().first;
  }

  insertProductList({required List<ProductModel> productList}) async {
    await DBHelper().insertProductList(productList);
  }

  checkIsMainUnit({required String productId, required String unitId}) async {
    if (productList.isEmpty) {
      await getProductList();
    }
    ProductModel product =
        productList.firstWhere((element) => element.productID == productId);
    return product.unitID == unitId;
  }

  updateProductListWithStocks(
      {required String productId,
      required ProductQuantityCombo quantity,
      required bool isReturn,
      bool isClearing = false,
      bool isUpdating = false,
      required bool isDamage}) async {
    log(isReturn.toString(), name: 'return');
    await DBHelper().updateProductStockDetails(
        productId: productId,
        quantity: quantity,
        isReturn: isReturn,
        isClearing: isClearing,
        isUpdating: isUpdating,
        isDamage: isDamage);
  }

  deleteTable() async {
    await DBHelper().deleteProductTable();
  }
}
