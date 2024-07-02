import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/expenses_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/extensions.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpensesPopUpScreen extends StatelessWidget {
  ExpensesPopUpScreen({
    super.key,
    required this.expenses,
    required this.isUpdate,
    required this.index,
    required this.taxList,
  });
  final expensesController = Get.put(ExpensesController());
  final expenses;
  final bool isUpdate;
  final int index;
  final List<dynamic> taxList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isUpdate ? "${expenses.expense?.accountName}" : expenses.accountName,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor),
        ),
        const Divider(),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => CommonWidgets.textField(context,
                          suffixicon: false,
                          readonly: false,
                          keyboardtype: TextInputType.number,
                          onchanged: (value) {
                        expensesController.calculateTax();
                      }, ontap: () {
                        expensesController.amountController.value.selectAll();
                      },
                          controller: expensesController.amountController.value,
                          label: "Amount"))
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
                      controller: TextEditingController(
                          text: expensesController.taxAmount.value.toString()),
                      suffixicon: true,
                      readonly: true,
                      label: 'Tax Amount',
                      ontap: () {},
                      keyboardtype: TextInputType.number))
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: dropDown(
                context,
                values: isUpdate ? expensesController.taxList : taxList,
                onChanged: (value) {
                  log("${value}");
                  expensesController.selectedTax.value = value;
                  expensesController.calculateTax();
                },
                title: "Tax Group",
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
                      controller: TextEditingController(
                          text: "${expensesController.taxPecentage.value}%"),
                      suffixicon: false,
                      readonly: true,
                      label: 'Tax Percentage',
                      keyboardtype: TextInputType.text))
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
              expensesController.clearPopup();
              Navigator.pop(context);
            }, type: ButtonTypes.Secondary, text: 'Cancel')),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: CommonWidgets.elevatedButton(context, onTap: () {
              isUpdate
                  ? expensesController.updateItem(expenses)
                  : expensesController.addItem(expenses);

              Navigator.pop(context);
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
    var value;
    if (isUpdate) {
      value = values.firstWhere(
        (element) =>
            element.taxCode == expensesController.selectedTax.value.taxCode,
        orElse: () => null,
      );
    }
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: value,
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
                '${item.taxCode ?? ''}',
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
