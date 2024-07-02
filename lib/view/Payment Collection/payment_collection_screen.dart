import 'dart:developer' as dev;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/payment_collection_controller.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:axoproject/view/components/payment_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:axoproject/utils/extensions.dart';

class PaymentCollectionScreen extends StatefulWidget {
  const PaymentCollectionScreen({super.key});

  @override
  State<PaymentCollectionScreen> createState() =>
      _PaymentCollectionScreenState();
}

class _PaymentCollectionScreenState extends State<PaymentCollectionScreen> {
  final paymentCollectionController = Get.put(PaymentCollectionController());
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Collection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Name : ",
                  style: TextStyle(
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Obx(() => Text(
                        paymentCollectionController
                                .customer.value.customerName ??
                            "",
                        style: const TextStyle(
                            color: AppColors.mutedColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CommonWidgets.textField(
              context,
              suffixicon: true,
              readonly: false,
              keyboardtype: TextInputType.text,
              label: 'Search',
              icon: Icons.search,
              onchanged: (p0) {},
            ),
            const SizedBox(
              height: 10,
            ),
            tableHeader(context),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GetBuilder<PaymentCollectionController>(
                builder: (_) {
                  return ListView.builder(
                    itemCount: _.pendingInvoiceList.length,
                    itemBuilder: (context, index) {
                      OutstandingInvoiceModel item =
                          _.pendingInvoiceList[index];
                      return CheckboxListTile(
                        activeColor: AppColors.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: item.isChecked,
                        onChanged: (value) {
                          paymentCollectionController.checkPayment(
                              index, value);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                item.voucherID ?? '',
                                minFontSize: 12,
                                maxFontSize: 15,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                InventoryCalculations.formatPrice(
                                    item.availableAmount ?? 0.0),
                                minFontSize: 12,
                                maxFontSize: 15,
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextField(
                                    enabled: item.isChecked,
                                    controller: item.controller,
                                    textAlign: TextAlign.end,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      isCollapsed: true,
                                    ),
                                    onTap: () => item.controller?.selectAll(),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        _.changeSelectedAmount(index);
                                      } else {
                                        item.controller!.text =
                                            InventoryCalculations.formatPrice(
                                                0.0);
                                        _.changeSelectedAmount(index);
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*$')),
                                    ],
                                  ),
                                  Visibility(
                                    visible: item.isError,
                                    child: const AutoSizeText(
                                      "Amount should not exeed more than due amount",
                                      minFontSize: 9,
                                      style: TextStyle(color: AppColors.error),
                                      textAlign: TextAlign.end,
                                      maxFontSize: 10,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Selected Total",
                    style: TextStyle(
                        color: AppColors.mutedColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                Obx(() => Text(
                    InventoryCalculations.formatPrice(
                        paymentCollectionController.selectedTotal.value),
                    style: const TextStyle(
                        color: AppColors.mutedColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonWidgets.elevatedButton(context,
                      onTap: () {}, type: ButtonTypes.Secondary, text: "Skip"),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CommonWidgets.elevatedButton(context, onTap: () async {
                    if (paymentCollectionController.isUpdating.value == false) {
                      paymentCollectionController.paymentVoucher();
                    }
                    Navigator.pop(context);
                    paymentPopup(context);
                  }, type: ButtonTypes.Primary, text: "Save"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tableHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 55, right: 5),
        child: _buildRows(
          context,
          voucherID: 'Voucher Id',
          dueAmount: 'Due Amount',
          selectedAmount: 'Selected Amount',
          isHeader: true,
        ),
      ),
    );
  }

  static Widget _buildRows(BuildContext context,
      {required String voucherID,
      required String dueAmount,
      required String selectedAmount,
      required bool isHeader}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            voucherID,
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
            flex: 1,
            child: Text(
              dueAmount,
              style: TextStyle(
                fontSize: 14,
                color: isHeader
                    ? Theme.of(context).primaryColor
                    : AppColors.mutedColor,
                fontWeight: FontWeight.w400,
              ),
            )),
        Expanded(
          flex: 1,
          child: Text(
            selectedAmount,
            textAlign: TextAlign.center,
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
