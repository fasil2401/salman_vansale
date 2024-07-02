import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetCheck {
  static Future<bool> isInternetAvailable() async {
    bool result;
    try {
      result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
      } else {}
    } catch (_) {
      return false;
    }
    return result;
  }

  static showInternetToast(BuildContext context) {
    return GFToast.showToast('No internet Available', context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: TextStyle(fontSize: 12, color: GFColors.LIGHT),
        backgroundColor: GFColors.DANGER,
        toastBorderRadius: 10.0);
  }
}
