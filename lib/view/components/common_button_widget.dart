import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonButtonWidget extends StatelessWidget {
  CommonButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.backgroundColor,
      required this.textColor,
      this.isLoading = false,
      this.icon})
      : super(key: key);

  final Function() onPressed;
  final Color backgroundColor;
  final String title;
  final Color textColor;
  final bool isLoading;
  Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // <-- Radius
        ),
      ),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) SizedBox(height: 15, width: 15, child: icon!),
          if (icon != null)
            const SizedBox(
              width: 8,
            ),
          isLoading
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.white),
                    strokeWidth: 2,
                  ))
              : Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ],
      ),
    );
  }
}
