import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/utils/Calculations/discount_calculation.dart';
import 'package:get/get.dart';

final homeController = Get.put(HomeController());

class TaxHelper {
  static calculateTax(
      {required String taxGroupId,
      required double price,
      required bool isExclusive}) async {
    log(taxGroupId.toString() + price.toString() + isExclusive.toString());
    List<TaxGroupDetail> list = [];
    if (homeController.taxGroupList.isEmpty) {
      await homeController.getTaxGroupDetailList();
    }
    var currentTaxGroupList = homeController.taxGroupList.where((element) =>
        element.taxGroupID?.toLowerCase() == taxGroupId.toLowerCase());

    for (var element in currentTaxGroupList) {
      double itemTax = 0.0;
      if (price != 0.0 && element.taxRate != 0.0) {
        itemTax = (price * element.taxRate) / 100;
      }
      log(itemTax.toString(), name: 'Item Tax');

      TaxGroupDetail tax = TaxGroupDetail(
          taxGroupId: element.taxGroupID,
          taxCode: element.taxCode,
          taxRate: element.taxRate,
          calculationMethod: element.calculationMethod.toString(),
          taxAmount: itemTax,
          taxExcludeDiscount: itemTax);
      list.add(tax);
    }
    return list;
  }
}
