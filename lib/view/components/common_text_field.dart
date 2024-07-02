import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonTextField {
  static Widget textfield(
          {required BuildContext context,
          Function()? ontap,
          String? label,
          TextEditingController? controller,
          IconData? icon,
          required bool suffixicon,
          required bool readonly,
          Function(dynamic)? onchanged,
          required TextInputType keyboardtype}) =>
      SizedBox(
        // height: 35.0,
        child: TextField(
          maxLines: 1,
          controller: controller,
          // enabled: false,
          readOnly: readonly,
          onTap: ontap,
          onChanged: onchanged,

          keyboardType: keyboardtype,
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
                BoxConstraints.tightFor(height: 30, width: 30),
          ),
        ),
      );
  static Widget multilinetextfield({
    String? label,
    TextEditingController? controller,
  }) =>
      TextField(
        style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
        decoration: InputDecoration(
          isCollapsed: true,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.mutedColor, width: 0.1),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
        ),
        autofocus: false,
        maxLines: null,
        controller: controller,
        keyboardType: TextInputType.text,
      );
}
