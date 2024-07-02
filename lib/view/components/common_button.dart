import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final String callback;
  bool isLoading;
  final Function() onPressed;
  CommonButton(
      {Key? key,
      required this.title,
      required this.callback,
      this.isLoading = false,
      required this.onPressed})
      : super(key: key);

  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ))
            : Text(
                title,
                style: const TextStyle(
                  color: textFieldColor,
                  fontSize: 18,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
