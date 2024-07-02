import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/payment_collection_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/Payment%20Collection/payment_collection_popup.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

paymentPopup(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Center(
          child: Text(
            'Select Payment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        content: PaymentCollectionPopup(),
      );
    },
  );
}

Widget dropDown(
  BuildContext context,
) {
  final lists = ["Cash", "Credit"];
  return DropdownButtonFormField2(
    isDense: true,
    alignment: Alignment.centerLeft,
    value: "Cash",
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isCollapsed: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: mutedColor, width: 0.1),
      ),
      labelText: "Select Payment Type",
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
    items: lists
        .map(
          (item) => DropdownMenuItem(
            value: item,
            child: AutoSizeText(
              '${item}',
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
    onChanged: (value) {},
    onSaved: (value) {},
  );
}
