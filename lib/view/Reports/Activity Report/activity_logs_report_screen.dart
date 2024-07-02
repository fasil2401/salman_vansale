import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/utils/Calculations/date_range_selector.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class ActivityLogsReportScreen extends StatelessWidget {
  ActivityLogsReportScreen({super.key});
  final reportController = Get.put(ReportController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await reportController.getActvityLogList();
      reportController.filterList(reportController.activityLogFilterList,
          reportController.activityLogList);
    });
    return Scaffold(
      body: SingleChildScrollView(
          child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GFAccordion(
              title: 'Filter',
              showAccordion: false,
              titleBorderRadius: BorderRadius.circular(5),
              expandedTitleBackgroundColor: Theme.of(context).primaryColor,
              collapsedTitleBackgroundColor: Colors.black38,
              collapsedIcon:
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              expandedIcon:
                  const Icon(Icons.keyboard_arrow_up, color: Colors.white),
              textStyle: TextStyle(
                color: Colors.white,
              ),
              titlePadding:
                  EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
              contentChild: dateReportFilter(
                  context,
                  reportController.dateIndex.value,
                  (value) {
                    selectedValue = value;
                    reportController.selectDateRange(selectedValue.value,
                        DateRangeSelector.dateRange.indexOf(selectedValue));
                  },
                  reportController.fromDate.value,
                  reportController.isFromDate.value,
                  () {
                    reportController.selectDate(context, true);
                  },
                  reportController.toDate.value,
                  reportController.isToDate.value,
                  () {
                    reportController.selectDate(context, false);
                  },
                  () {
                    reportController.filterList(
                        reportController.activityLogFilterList,
                        reportController.activityLogList);
                  }),
            ),
            commonDivider(),
            if (reportController.activityLogList.isNotEmpty)
              listDivider(context),
            ListView.separated(
                separatorBuilder: (context, index) {
                  return listDivider(context);
                },
                itemCount: reportController.activityLogFilterList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                itemBuilder: (context, index) {
                  var item = reportController.activityLogFilterList[index];
                  return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              "${item.description}",
                              maxLines: 2,
                              maxFontSize: 14,
                              minFontSize: 12,
                              style: TextStyle(
                                  color: AppColors.mutedColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${DateFormatter.dateFormat.format(DateTime.parse(item.date.toString()))}",
                                      style: TextStyle(
                                          color: AppColors.mutedColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                AutoSizeText(
                                    item.isSynced == 0
                                        ? "Not Synced"
                                        : "Synced",
                                    maxLines: 2,
                                    maxFontSize: 12,
                                    minFontSize: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: item.isSynced == 0
                                          ? AppColors.error
                                          : AppColors.success,
                                    )),
                              ]),
                        ],
                      ));
                }),
            if (reportController.activityLogList.isNotEmpty)
              listDivider(context),
            SizedBox(
              height: 70,
            )
          ],
        ),
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: Icon(Icons.print_outlined),
      // ),
    );
  }
}
