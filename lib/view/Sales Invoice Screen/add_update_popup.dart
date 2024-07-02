import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/extensions.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/allocation_popup.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesInvoiceAddOrUpdate extends StatelessWidget {
  SalesInvoiceAddOrUpdate({
    super.key,
    required this.product,
    required this.isUpdate,
    required this.index,
    required this.unitList,
  });
  final salesInvoiceController = Get.put(SalesInvoiceController());
  final product;
  final bool isUpdate;
  final int index;
  final List<dynamic> unitList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isUpdate
              ? product.vanSaleDetails![0].description
              : product.description ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor),
        ),
        const Divider(),
        if (salesInvoiceController.returnToggle.value)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'is Damaged',
                style: TextStyle(color: AppColors.mutedColor, fontSize: 14),
              ),
              Obx(() => Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: Theme.of(context).primaryColor,
                      value: salesInvoiceController.isDamagedToggle.value,
                      onChanged: (value) {
                        salesInvoiceController.toggleDamaged(value);
                      },
                    ),
                  )),
            ],
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Quantity',
                    style: TextStyle(color: AppColors.mutedColor, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          salesInvoiceController.decrementQuantity();
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 15,
                          child: const Center(child: Icon(Icons.remove)),
                        ),
                      ),
                      Obx(
                        () {
                          salesInvoiceController
                                  .quantityControl.value.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: salesInvoiceController
                                      .quantityControl.value.text.length));
                          return Flexible(
                            child: salesInvoiceController
                                    .isEditingQuantity.value
                                ? TextField(
                                    autofocus: false,
                                    controller: salesInvoiceController
                                        .quantityControl.value,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ''),
                                    onChanged: (value) {
                                      salesInvoiceController.setQuantity(value);
                                    },
                                    onTap: () {
                                      salesInvoiceController
                                          .quantityControl.value
                                          .selectAll();
                                    },
                                  )
                                : Obx(() => InkWell(
                                      onTap: () {
                                        salesInvoiceController.editQuantity();
                                        salesInvoiceController
                                                .quantityControl.value.text =
                                            salesInvoiceController
                                                .quantity.value
                                                .toString();
                                      },
                                      child: Text(salesInvoiceController
                                          .quantity.value
                                          .toString()),
                                    )),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          salesInvoiceController.incrementQuantity();
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 15,
                          child: const Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: dropDown(
                    context,
                    values: isUpdate ? product.unitList : unitList,
                    onChanged: (value) {
                      salesInvoiceController.changeUnit(value,
                          priceAvailable: isUpdate
                              ? product.vanSaleDetails![0].basePrice
                              : product.price,
                          stockAvailable: isUpdate
                              ? product.vanSaleDetails![0].quantity
                              : product.quantity);
                      salesInvoiceController.selectedUnit.value = value;
                    },
                    title: "Unit",
                  ),
                ),
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => CommonWidgets.textField(context,
                          controller: salesInvoiceController.priceControl.value,
                          suffixicon: false,
                          readonly: false,
                          label: 'Unit Price', ontap: () {
                        salesInvoiceController.priceControl.value.selectAll();
                      },
                          keyboardtype: const TextInputType.numberWithOptions(
                              decimal: true)))
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => CommonWidgets.textField(context,
                      controller: salesInvoiceController.stockControl.value,
                      suffixicon: false,
                      readonly: true,
                      label: 'Stock',
                      keyboardtype:
                          const TextInputType.numberWithOptions(decimal: true)))
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: CommonWidgets.elevatedButton(context, onTap: () {
              Navigator.pop(context);
            }, type: ButtonTypes.Secondary, text: 'Cancel')),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: CommonWidgets.elevatedButton(context, onTap: () {
              bool isStockAvailable =
                  salesInvoiceController.checkIfStockAvailable(
                      stock: double.parse(
                          salesInvoiceController.stockControl.value.text),
                      quantity: salesInvoiceController.quantity.value);
              if (!isStockAvailable &&
                  salesInvoiceController.returnToggle.value == false) {
                SnackbarServices.errorSnackbar(
                    'Quantity should not Ecxceed Stock !');
                return;
              }
              if (isUpdate) {
                if (product.isTrackLot == 1 &&
                    salesInvoiceController.returnToggle.value == false) {
                  if (salesInvoiceController.availableProductLots.isNotEmpty) {
                    // salesInvoiceController.distributeProductLots();
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        content: LotAllocation(
                          index: index,
                          isUpdate: isUpdate,
                          product: product,
                          unitList: unitList,
                        ),
                      );
                    },
                  );
                } else {
                  salesInvoiceController.updateItem(product, index);
                  salesInvoiceController.resetQuantity();
                  Navigator.pop(context);
                }
              } else {
                if (product.isTrackLot == 1 &&
                    salesInvoiceController.returnToggle.value == false) {
                  if (salesInvoiceController.availableProductLots.isNotEmpty) {
                    salesInvoiceController.distributeProductLots();
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        content: LotAllocation(
                          index: index,
                          isUpdate: isUpdate,
                          product: product,
                          unitList: unitList,
                        ),
                      );
                    },
                  );
                } else {
                  salesInvoiceController.addItem(product, unitList);
                  salesInvoiceController.resetQuantity();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }
              // isUpdate
              //     ? salesInvoiceController.updateItem(product, index)
              //     : salesInvoiceController.addItem(product, unitList);
              // salesInvoiceController.resetQuantity();
              // Navigator.pop(context);
              // if (!isUpdate) {
              //   Navigator.pop(context);
              // }
            }, type: ButtonTypes.Primary, text: isUpdate ? 'Update' : 'Add')),
          ],
        ),
      ],
    );
  }

  Widget dropDown(BuildContext context,
      {String? title,
      required List<dynamic> values,
      required Function(dynamic) onChanged}) {
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: salesInvoiceController.selectedUnit.value,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isCollapsed: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: mutedColor, width: 0.1),
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
      ),
      isExpanded: true,
      icon: Icon(
        Icons.arrow_drop_down_circle_outlined,
        color: Theme.of(context).primaryColor,
        size: 15,
      ),
      // buttonPadding: const EdgeInsets.only(left: 0, right: 0),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: values
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: AutoSizeText(
                '${item.code ?? ''}',
                minFontSize: 10,
                maxFontSize: 14,
                maxLines: 1,
                style: const TextStyle(
                  color: mutedColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      onSaved: (value) {},
    );
  }
}
