import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class CommonWidgets {
  static Widget textField(BuildContext context,
          {Function()? ontap,
          String? label,
          int? maxLines,
          int? maxLenth,
          TextEditingController? controller,
          IconData? icon,
          required bool suffixicon,
          required bool readonly,
          Function(dynamic)? onchanged,
          required TextInputType keyboardtype}) =>
      SizedBox(
        // height: 35.0,
        child: TextField(
          maxLines: maxLines ?? 1,
          controller: controller,
          maxLength: maxLenth,
          // enabled: false,
          readOnly: readonly,
          onTap: ontap,
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          onChanged: onchanged,
          keyboardType: keyboardtype,
          inputFormatters: keyboardtype ==
                  TextInputType.numberWithOptions(decimal: false)
              ? [
                  FilteringTextInputFormatter.deny(RegExp('[\\.,]')),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ]
              : keyboardtype ==
                          TextInputType.numberWithOptions(decimal: true) ||
                      keyboardtype == TextInputType.number
                  ? [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ]
                  : [],
          style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            isCollapsed: true,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: mutedColor, width: 0.1),
            ),
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: suffixicon == true
                ? Icon(
                    icon != null ? icon : Icons.more_vert,
                    color: Theme.of(context).primaryColor,
                    size: 15,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            suffixIconConstraints:
                BoxConstraints.tightFor(height: 30, width: 20),
          ),
        ),
      );

  static Widget elevatedButton(BuildContext context,
      {required Function() onTap,
      String? text,
      required ButtonTypes type,
      bool isLoading = false}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: type == ButtonTypes.Primary
                ? Theme.of(context).primaryColor
                : type == ButtonTypes.Secondary
                    ? Theme.of(context).backgroundColor
                    : Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: type == ButtonTypes.Outlined ? 1.0 : 0.0,
                    color: type == ButtonTypes.Outlined
                        ? Theme.of(context).primaryColor
                        : Colors.white),
                borderRadius: BorderRadius.circular(8))),
        onPressed: onTap,
        child: isLoading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    type == ButtonTypes.Primary
                        ? Colors.white
                        : type == ButtonTypes.Secondary
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                  ),
                ))
            : Text(
                '$text',
                style: TextStyle(
                  color: type == ButtonTypes.Primary
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ));
  }

  static Widget dropDown(BuildContext context,
      {String? title,
      bool isDate = false,
      required dynamic selectedValue,
      required List<dynamic> values,
      required Function(dynamic) onChanged}) {
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: values.firstWhere((element) => element == selectedValue),
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
        // suffixIcon: Icon(
        //   Icons.arrow_drop_down_circle_outlined,
        //   color: Theme.of(context).primaryColor,
        //   size: 15,
        // ),
        // suffixIconConstraints: BoxConstraints.tightFor(height: 30, width: 30),
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
                isDate ? '${item.code}' : '${item.name}',
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

  static TextField buildCheckBoxField(BuildContext context,
      {required TextEditingController controller,
      required Function() onTap,
      String? label,
      required bool checkBoxValue,
      required Function(dynamic) onChanged}) {
    return TextField(
      onChanged: (p0) {},
      controller: controller,
      onTap: onTap,
      readOnly: true,
      style: TextStyle(fontSize: 12, color: mutedColor),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isCollapsed: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: mutedColor, width: 0.1),
        ),
        labelText: label ?? "Required On",
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
        suffix: SizedBox(
          height: 15,
          width: 15,
          child: Checkbox(
            value: checkBoxValue,
            activeColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
              (states) => BorderSide(
                  width: 1.75, color: Theme.of(context).primaryColor),
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  static Future<DateTime?> getCalender(
      BuildContext context, DateTime initialDate) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: Theme.of(context).primaryColor,
              surface: Theme.of(context).primaryColor,
              onSurface: Theme.of(context).primaryColor,
            ),
            dialogBackgroundColor: Theme.of(context).backgroundColor,
          ),
          child: child!,
        );
      },
    );
    return newDate;
  }

  static Future<dynamic> popDialogWithAction(
    BuildContext context, {
    Widget? titleWidget,
    required Widget content,
    required String confirmText,
    required String declineText,
    required Function() onConfirm,
    required Function() onDecline,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 16.0,
            color: Colors.black,
          ),
          child: AlertDialog(
            title: titleWidget,
            titlePadding: titleWidget == null ? EdgeInsets.zero : null,
            content: content,
            contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 0),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            buttonPadding: EdgeInsets.symmetric(horizontal: 8),
            actions: [
              TextButton(child: Text(declineText), onPressed: onDecline),
              TextButton(child: Text(confirmText), onPressed: onConfirm),
            ],
          ),
        );
      },
    );
  }

  static AlertDialog buildAlertDialog(
      {required Widget title,
      required BuildContext context,
      double? insetPadding,
      required Widget content}) {
    return AlertDialog(
      title: title,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.all(insetPadding ?? 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: content,
      ),
    );
  }

  static Row popupTitle({required Function() onTap, required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedColor,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.mutedColor,
            child: Icon(
              Icons.close,
              color: AppColors.white,
              size: 15,
            ),
          ),
        )
      ],
    );
  }

  static Widget popShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "",
              style: TextStyle(
                color: mutedColor,
              ),
            ),
          ));
        },
        separatorBuilder: (context, index) => SizedBox(
          height: 5,
        ),
      ),
    );
  }

  static Widget commonRadio(String title, String val, String groupValue,
          Function(dynamic) onChanged) =>
      Theme(
        data: ThemeData(backgroundColor: Colors.transparent),
        child: RadioListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 14, color: AppColors.mutedColor),
          ),
          value: val,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          tileColor: AppColors.white,
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      );
  static ClipRRect buildExpansionTextFields(
      {required TextEditingController controller,
      required Function() onTap,
      String? hint,
      bool? isReadOnly,
      bool? isSearch,
      bool? isClosing,
      bool? disableSuffix,
      FocusNode? focus,
      bool? isDropdown,
      bool? isTime,
      Function(String)? onChanged,
      Function()? onEditingComplete}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
            fontSize: 12,
            color:
                isClosing != null ? AppColors.primary : AppColors.mutedColor),
        maxLines: 1,
        onTap: onTap,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        readOnly: isReadOnly ?? true,
        autofocus: false,
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          filled: true,
          hintText: hint ?? '',
          // enabled: false,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          fillColor: AppColors.lightGrey.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: disableSuffix != null
                ? Container()
                : Icon(
                    isTime != null
                        ? Icons.schedule
                        : isDropdown != null
                            ? Icons.keyboard_arrow_down
                            : isClosing != null
                                ? Icons.cancel_rounded
                                : isSearch != null
                                    ? Icons.search
                                    : Icons.calendar_month_outlined,
                    color: isClosing != null
                        ? AppColors.primary
                        : AppColors.mutedColor,
                    size: 20,
                  ),
          ),
          suffixIconConstraints: BoxConstraints.tightFor(height: 20, width: 30),
        ),
      ),
    );
  }
}
