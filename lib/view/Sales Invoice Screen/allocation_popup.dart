import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/extensions.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LotAllocation extends StatelessWidget {
  LotAllocation({
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
        tableHeader(context),
        Flexible(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GetBuilder<SalesInvoiceController>(
            builder: (_) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: _.availableProductLots.length,
                itemBuilder: (context, index) {
                  var item = _.availableProductLots[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildRows(context,
                        lotNo: item.lotNumber.toString(),
                        isError: item.isError ?? false,
                        available: item.availableQty.toString(),
                        controller: item.controller,
                        onChangedOfQuantity: (value) {
                      if (value.trim().isEmpty) {
                        salesInvoiceController.updateLotQuantity(
                            qty: 0.0, index: index);
                      } else {
                        salesInvoiceController.updateLotQuantity(
                            qty: double.parse(value.trim().toString()),
                            index: index);
                      }
                      //  if (items.controller?.text == "") {
                      // if (item.controller?.text == "" ||
                      //     item.availableQty! <
                      //         int.parse(item.controller!.text)) {
                      //   item.isError = true;
                      //   salesInvoiceController.lotQuantityError.value = true;
                      //   salesInvoiceController.lotAllocationQuantityError(true);

                      //   //   error = true;
                      //   // }
                      // } else {
                      //   item.isError = false;
                      //   salesInvoiceController
                      //       .lotAllocationQuantityError(false);
                      // }
                    }),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
              );
            },
          ),
        )),
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
              // for (var item in salesInvoiceController.availableProductLots) {
              //   if (item.controller?.text == "") {
              //     salesInvoiceController.lotAllocationQuantityError(true);
              //     SnackbarServices.errorSnackbar("Quantity error");
              //   }
              // }
              if (isQuantityQualified(
                  salesInvoiceController.availableProductLots,
                  salesInvoiceController.quantity.value)) {
                isUpdate
                    ? salesInvoiceController.updateItem(product, index)
                    : salesInvoiceController.addItem(product, unitList);
                salesInvoiceController.resetQuantity();
                Navigator.pop(context);
                Navigator.pop(context);
                if (!isUpdate) {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                }
              } else {
                SnackbarServices.errorSnackbar(
                    "Quantity Must be equal to ${salesInvoiceController.quantity.value}");
              }
              // if (!salesInvoiceController.lotQuantityError.value) {
              //   isUpdate
              //       ? salesInvoiceController.updateItem(product, index)
              //       : salesInvoiceController.addItem(product, unitList);
              //   salesInvoiceController.resetQuantity();
              //   Navigator.pop(context);
              //   Navigator.pop(context);
              //   if (!isUpdate) {
              //     Navigator.pop(context);
              //     // Navigator.pop(context);
              //   }
              // }
            }, type: ButtonTypes.Primary, text: 'Save')),
          ],
        ),
      ],
    );
  }

  bool isQuantityQualified(List<ProductLotModel> list, double quantity) {
    double sum = list.fold(
        0,
        (double previousValue, ProductLotModel element) =>
            previousValue + element.lotQty);
    return sum == quantity;
  }

  Container tableHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildRows(
          context,
          lotNo: 'Lot Number',
          available: 'Available',
          quantity: 'Quantity',
          isHeader: true,
        ),
      ),
    );
  }

  Row _buildRows(
    BuildContext context, {
    required String lotNo,
    required String available,
    Function(dynamic)? onChangedOfQuantity,
    String? quantity,
    bool isHeader = false,
    bool isError = false,
    TextEditingController? controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              lotNo,
              style: TextStyle(
                fontSize: 12,
                color: isHeader
                    ? Theme.of(context).primaryColor
                    : AppColors.mutedColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (isHeader) VerticalDivider(color: Theme.of(context).primaryColor),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              available,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isHeader
                    ? Theme.of(context).primaryColor
                    : AppColors.mutedColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (isHeader) VerticalDivider(color: Theme.of(context).primaryColor),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: isHeader
                ? Text(
                    quantity ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isHeader
                          ? Theme.of(context).primaryColor
                          : AppColors.mutedColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: controller,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          isCollapsed: true,
                        ),
                        onTap: () {
                          controller!.selectAll();
                        },
                        onChanged: onChangedOfQuantity,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$')),
                        ],
                      ),
                      if (isError)
                        AutoSizeText(
                          "*Quantity error",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
