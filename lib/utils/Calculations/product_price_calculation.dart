import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

final homeController = Get.put(HomeController());

class ProductPriceHelper {
  static Future<PriceModel?> getLatestPrice(
      {required String productId,
      required String customerId,
      required String unitId,
      required String parentCustomerId}) async {
    PriceModel? priceObject = PriceModel(unit: UnitModel(), price: 0.0);
    if (homeController.customerPriceList.isEmpty) {
      await homeController.getCustomerPriceList();
    }
    CustomerPriceModel? price;
    var list = homeController.customerPriceList
        .where((element) =>
            element.productID == productId && element.customerID == customerId)
        .toList();
    if (list.isNotEmpty) {
      price = list[0];
    } else {
      price = null;
    }
    if (price != null) {
      priceObject = PriceModel(
          unit: UnitModel(
              code: unitId == price.unitID ? null : price.unitID,
              factor: price.unitFactor,
              isMainUnit: 0,
              productID: productId,
              factorType: price.factorType,
              name: unitId == price.unitID ? null : price.unitID),
          price: price.unitPrice ?? 0.0,
          customerProductId: price.customerProductID ?? '');
    } else {
      // CustomerPriceModel? price;
      var list = homeController.customerPriceList
          .where((element) =>
              element.productID == productId &&
              element.customerID == parentCustomerId &&
              (element.applicableToChild ?? false))
          .toList();
      if (list.isNotEmpty) {
        price = list[0];
      } else {
        price = null;
      }
      if (price != null) {
        priceObject = PriceModel(
            unit: UnitModel(
                code: unitId == price.unitID ? null : price.unitID,
                factor: price.unitFactor,
                isMainUnit: 0,
                productID: productId,
                factorType: price.factorType,
                name: unitId == price.unitID ? null : price.unitID),
            price: price.unitPrice ?? 0.0,
            customerProductId: price.customerProductID ?? '');
      } else {
        priceObject = null;
      }
    }
    return priceObject;
  }
}

class PriceModel {
  UnitModel unit;
  double price;
  String customerProductId;

  PriceModel(
      {required this.unit, required this.price, this.customerProductId = ''});
}
