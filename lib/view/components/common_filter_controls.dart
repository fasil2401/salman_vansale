
import 'package:flutter/material.dart';

class CommonFilterControls {
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
}
