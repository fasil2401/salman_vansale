import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/services/date_formatter.dart';
import 'package:axoproject/utils/Calculations/date_range_selector.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class VisitLogsReportScreens extends StatefulWidget {
  VisitLogsReportScreens({super.key});

  @override
  State<VisitLogsReportScreens> createState() => _VisitLogsReportScreensState();
}

class _VisitLogsReportScreensState extends State<VisitLogsReportScreens> {
  final reportController = Get.put(ReportController());

  var selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportController.getVisitLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Obx(() => GFAccordion(
                  title: 'Filter',
                  showAccordion: false,
                  titleBorderRadius: BorderRadius.circular(5),
                  expandedTitleBackgroundColor: Theme.of(context).primaryColor,
                  collapsedTitleBackgroundColor: Colors.black38,
                  collapsedIcon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
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
                      () {}),
                )),
            commonDivider(),
            SizedBox(
              height: 10,
            ),
            Obx(() => ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: reportController.visitLogs.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                itemBuilder: (context, index) {
                  var item = reportController.visitLogs[index];
                  String customer = reportController.customerList
                      .firstWhere(
                          (element) => element.customerID == item.customerId)
                      .customerName
                      .toString();
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: AppColors.lightBlue),
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.reportPerson),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(customer,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text("${item.customerId ?? ""}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.mutedColor)),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        commonVisitLogText(
                                          "Start",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "End",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "Start Latitude",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "Start Longitude",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "End Latitude",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "End Longitude",
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        commonVisitLogText(
                                          DateTime.parse(item.startTime ??
                                                  DateTime.now()
                                                      .toIso8601String())
                                              .toString()
                                              .substring(0, 19),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          DateTime.parse(item.endTime ??
                                                  DateTime.now()
                                                      .toIso8601String())
                                              .toString()
                                              .substring(0, 19),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "${item.startLatitude ?? ""}",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "${item.startLongitude ?? ""}",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "${item.closeLatitude ?? ""}",
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        commonVisitLogText(
                                          "${item.closeLongitude ?? ""}",
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ])));
                })),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: Icon(Icons.print_outlined),
      // ),
    );
  }
}

Text commonVisitLogText(txt) {
  return Text(
    txt,
    style: TextStyle(
        color: AppColors.mutedColor, fontSize: 14, fontWeight: FontWeight.w400),
  );
}
