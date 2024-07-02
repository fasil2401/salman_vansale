import 'dart:developer';

import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/utils/Calculations/product_price_calculation.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/add_update_popup.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesInvoiceItems extends StatelessWidget {
  SalesInvoiceItems({super.key});

  final salesInvoiceController = Get.put(SalesInvoiceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Invoice Items'),
      ),
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonWidgets.textField(
                    context,
                    suffixicon: true,
                    readonly: false,
                    keyboardtype: TextInputType.text,
                    label: 'Search',
                    icon: Icons.search,
                    onchanged: (p0) {
                      salesInvoiceController.searchItems(
                          p0, salesInvoiceController.productList);
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(
              () => salesInvoiceController.isProductsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: GetBuilder<SalesInvoiceController>(
                        builder: (_) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: _.productFilterList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var product = _.productFilterList[index];
                              return InkWell(
                                  onTap: () async {
                                    // ProductPriceHelper.getLatestPrice();
                                    if (salesInvoiceController
                                        .isItemAvailable(product.productID!)) {
                                      SnackbarServices.errorSnackbar(
                                          'Item already available in grid, Please Update from grid !');
                                      return;
                                    }
                                    salesInvoiceController
                                        .customerProductId.value = '';
                                    PriceModel? latestPrice =
                                        await ProductPriceHelper.getLatestPrice(
                                            productId: product.productID ?? '',
                                            customerId: salesInvoiceController
                                                    .customer
                                                    .value
                                                    .customerID ??
                                                '',
                                            parentCustomerId:
                                                salesInvoiceController
                                                        .customer
                                                        .value
                                                        .parentCustomerID ??
                                                    '',
                                            unitId: product.unitID ?? "");
                                    salesInvoiceController
                                            .customerProductId.value =
                                        latestPrice != null
                                            ? latestPrice.customerProductId
                                            : '';
                                    salesInvoiceController.quantityControl.value
                                        .clear();
                                    salesInvoiceController.resetQuantity();
                                    if (latestPrice != null) {
                                      salesInvoiceController.priceControl.value
                                          .text = latestPrice.price.toString();
                                      product.price = latestPrice.price;
                                    } else {
                                      salesInvoiceController.priceControl.value
                                          .text = product.price.toString();
                                    }

                                    salesInvoiceController.stockControl.value
                                        .text = product.quantity.toString();
                                    // salesInvoiceController
                                    //     .getProductStockById(
                                    //         product.productID ?? '',
                                    //         product.quantity ?? 0.0)
                                    // .toString();
                                    List<UnitModel> unitList =
                                        _.getProductUnits(
                                      isUpdate: false,
                                      productId: product.productID ?? '',
                                      unitId: product.unitID ?? '',
                                    );
                                    if (latestPrice != null &&
                                        latestPrice.unit.code != null) {
                                      unitList.insert(0, latestPrice.unit);
                                    }
                                    if (product.isTrackLot == 1 &&
                                        salesInvoiceController
                                                .returnToggle.value ==
                                            false) {
                                      _.getAvailableProductLots(
                                          product.productID ?? '',
                                          isUpdate: false);
                                    }
                                    _.toggleDamaged(false);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          content: SalesInvoiceAddOrUpdate(
                                            index: index,
                                            isUpdate: false,
                                            product: product,
                                            unitList: unitList,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: _buildRows(
                                    context,
                                    code: '${product.productID}',
                                    name: '${product.description}',
                                    isHeader: false,
                                  ));
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 20,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildRows(context, code: 'Code', name: 'Name', isHeader: true),
      ),
    );
  }

  Row _buildRows(BuildContext context,
      {required String code, required String name, required bool isHeader}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            code,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
