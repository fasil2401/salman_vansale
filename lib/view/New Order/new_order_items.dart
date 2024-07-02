import 'package:axoproject/controller/app%20controls/new_order_controller.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/New%20Order/add_update_popup.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewOrderItems extends StatelessWidget {
  NewOrderItems({super.key});

  final newOrderController = Get.put(NewOrderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order Items'),
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
                    onchanged: (value) {
                      newOrderController.searchItems(
                          value, newOrderController.productList);
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(
              () => newOrderController.isProductsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: GetBuilder<NewOrderController>(
                        builder: (_) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: _.productFilterList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var product = _.productFilterList[index];
                              return InkWell(
                                  onTap: () {
                                    newOrderController.quantityControl.value
                                        .clear();
                                    newOrderController.resetQuantity();
                                    newOrderController.priceControl.value.text =
                                        product.price.toString();
                                    newOrderController.stockControl.value.text =
                                        product.quantity.toString();
                                    List<UnitModel> unitList =
                                        _.getProductUnits(
                                      isUpdate: false,
                                      productId: product.productID ?? '',
                                      unitId: product.unitID ?? '',
                                    );
                                    if (product.isTrackLot == 1) {
                                      _.getAvailableProductLots(
                                          product.productID ?? '');
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          content: NewOrderAddOrUpdate(
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
