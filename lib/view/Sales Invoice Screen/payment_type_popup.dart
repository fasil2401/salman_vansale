import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/components/common_text_field.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentTypePopup extends StatelessWidget {
  PaymentTypePopup({
    super.key,
  });
  final salesInvoiceController = Get.put(SalesInvoiceController());
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        'Select Payment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      salesInvoiceController.selectedPaymentMethod.value =
                          salesInvoiceController.paymentMethodList.first;
                      salesInvoiceController.remarksController.value.clear();
                      salesInvoiceController.descriptionController.value
                          .clear();
                      Navigator.pop(context);
                    },
                    child: const Card(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.close,
                          color: AppColors.mutedColor,
                          size: 15,
                        ),
                      ),
                    ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        // width: MediaQuery.of(context).size.width / 2.5,
                        child: Obx(
                          () => dropDown(
                            context,
                            value: salesInvoiceController
                                .selectedPaymentMethod.value,
                            values: salesInvoiceController.paymentMethodList,
                            onChanged: (value) {
                              salesInvoiceController
                                  .selectedPaymentMethod.value = value;
                            },
                            title: "Payment Type",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CommonWidgets.textField(context,
                      suffixicon: false,
                      readonly: true,
                      controller: TextEditingController(
                          text:
                              "${salesInvoiceController.total.value.toStringAsFixed(2)}"),
                      keyboardtype: TextInputType.number,
                      label: 'Amount'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CommonTextField.multilinetextfield(
              controller: salesInvoiceController.remarksController.value,
              label: 'Remarks',
            ),
            const SizedBox(
              height: 20,
            ),
            CommonTextField.multilinetextfield(
              controller: salesInvoiceController.descriptionController.value,
              label: 'Description',
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child:
                        CommonWidgets.elevatedButton(context, onTap: () async {
                  await salesInvoiceController.saveNewInvoice(context);
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 1));
                  int printPreference =
                      UserSimplePreferences.getPrintPreference() ?? 1;
                  if (printPreference == 1) {
                    ThermalPrintHeplper.getConnection(
                        context,
                        salesInvoiceController.helper.value,
                        PrintLayouts.SalesInvoice);
                  }
                }, type: ButtonTypes.Primary, text: 'Save')),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDown(BuildContext context,
      {String? title,
      required List<dynamic> values,
      required var value,
      required Function(dynamic) onChanged}) {
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: value,
      // value: salesInvoiceController.selectedUnit.value,
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
                '${item.displayName ?? ''}',
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
