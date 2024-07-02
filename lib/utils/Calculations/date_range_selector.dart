import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/model/date_model.dart';
import 'package:axoproject/services/Api%20Services/common_api_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get/get.dart';

class DateRangeSelector {
  final loginController = Get.put(LoginController());
  static List dateRange = [
    DateFilterModel(label: 'Today', value: 1),
    DateFilterModel(label: 'Yesterday', value: 2),
    DateFilterModel(label: 'This Week', value: 3),
    DateFilterModel(label: 'Last Week', value: 4),
    DateFilterModel(label: 'This Month To Date', value: 5),
    DateFilterModel(label: 'Last Month', value: 6),
    DateFilterModel(label: 'Last 30 Days', value: 7),
    DateFilterModel(label: 'This Year To Date', value: 8),
    DateFilterModel(label: 'Last Year', value: 9),
    DateFilterModel(label: 'First Quarter', value: 10),
    DateFilterModel(label: 'Second Quarter', value: 11),
    DateFilterModel(label: 'Third Quarter', value: 12),
    DateFilterModel(label: 'Fourth Quarter', value: 13),
    DateFilterModel(label: 'All Dates', value: 14),
    DateFilterModel(label: 'Date Equal To', value: 15),
    DateFilterModel(label: 'Custom', value: 16),
  ];

  static getDateRange(int range) async {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 00);
    DateTime startDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime firstDayOfTheWeek = now.subtract(Duration(days: now.weekday));
    int dayOfTheWeek = now.weekday;

    int weekDayDifference = dayOfTheWeek - firstDayOfTheWeek.weekday;
    weekDayDifference < 0 ? weekDayDifference += 7 : weekDayDifference;
    int year = now.year;
    int month = now.month;

    DateTimeRange dateTime = DateTimeRange(
        start: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        end: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 23, 59, 00));
    // DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    switch (range) {
      case 1:
        dateTime = dateTime;
        break;
      case 2:
        dateTime = DateTimeRange(
            start: startDate.subtract(Duration(days: 1)),
            end: startDate.subtract(Duration(
              minutes: 1,
            )));
        break;
      case 3:
        dateTime = DateTimeRange(
            start: startDate.subtract(Duration(days: weekDayDifference)),
            end: now);
        break;
      case 4: //last week
        dateTime = DateTimeRange(
            start: startDate.subtract(Duration(days: weekDayDifference + 7)),
            end: startDate
                .subtract(Duration(days: weekDayDifference, minutes: 1)));
        break;
      case 5: //this month to date
        dateTime = DateTimeRange(start: DateTime(year, month, 1), end: now);
        break;
      case 6: //last month
        dateTime = DateTimeRange(
            start: DateTime(year, month - 1, 1),
            end: DateTime(year, month, 1).subtract(Duration(
              minutes: 1,
            )));
        break;
      case 7: //last 30 days
        dateTime = DateTimeRange(
            start: startDate.subtract(Duration(days: 30)), end: now);
        break;
      case 8: //this year to date
        dateTime = DateTimeRange(start: DateTime(year, 1, 1), end: now);
        break;
      case 9: //last year
        dateTime = DateTimeRange(
            start: DateTime(year - 1, 1, 1),
            end: DateTime(year, 1, 1).subtract(Duration(minutes: 1)));
        break;
      case 10: //first quarter
        dateTime = DateTimeRange(
            start: DateTime(year, 1, 1), end: DateTime(year, 3, 31, 23, 59));
        break;
      case 11: //second quarter
        dateTime = DateTimeRange(
            start: DateTime(year, 4, 1), end: DateTime(year, 6, 30, 23, 59));
        break;
      case 12: //third quarter
        dateTime = DateTimeRange(
            start: DateTime(year, 7, 1), end: DateTime(year, 9, 30, 23, 59));
        break;
      case 13: //fourth quarter
        dateTime = DateTimeRange(
            start: DateTime(year, 10, 1), end: DateTime(year, 12, 31, 23, 59));
        break;
      case 14: //all dates
        dateTime = await DateRangeSelector().getAllDates();
        break;
      case 15: //date equal to
        dateTime = DateTimeRange(
            start: DateTime(
              year,
              month,
            ),
            end: now);
        break;

      default:
    }

    developer.log(dateTime.start.toString(),
        name: 'DateRangeSelector startDate');
    developer.log(dateTime.end.toString(), name: 'DateRangeSelector endDate');
    return dateTime;
  }

  getAllDates() async {
    await loginController.getLogin();
    final String token = loginController.access.value;
    dynamic result;
    try {
      var feedback = await ApiManager.fetchDataCommon(
          api: 'GetOpenFiscalYear?token=${token}');
      if (feedback != null) {
        result = AllDateModel.fromJson(feedback);
        print(result);
      }
    } finally {
      if (result.result == 1) {
        developer.log(result.startDate.toString(), name: 'All Dates Start');

        return DateTimeRange(start: result.startDate, end: result.endDate);
      }
    }
  }
}
