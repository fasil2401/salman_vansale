import 'dart:developer';

import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/controller/app%20controls/splash_screen_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/date_formatter.dart';

class OverallReportScreen extends StatefulWidget {
  const OverallReportScreen({super.key});

  @override
  State<OverallReportScreen> createState() => _OverallReportScreenState();
}

class _OverallReportScreenState extends State<OverallReportScreen> {
  final reportController = Get.put(ReportController());
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    reportController.getSalesInvoiceReport();
    reportController.getOrderReport();
    reportController.getReturnList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
            bottom: 10,
            top: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.routes,
                              height: 50,
                              width: 45,
                              fit: BoxFit.fill,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Routes",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  "Completed (%)",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "Planned",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "Visited",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "Skipped At",
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                commonText(
                                  "3.13",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "31.00",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "1.00",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "0.00",
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  mainAxisSpacing: 14,
                  crossAxisCount: 2,
                  children: <Widget>[
                    overallCard(
                        context,
                        AppIcons.invoice,
                        "Invoices",
                        "${reportController.totalInvoice.value}",
                        "${reportController.salesInvoiceList.length}"),
                    overallCard(
                        context,
                        AppIcons.orders,
                        "Orders",
                        "${reportController.totalOrders.value}",
                        "${reportController.newOrdersList.length}"),
                    overallCard(
                        context,
                        AppIcons.returns,
                        "Returns",
                        "${reportController.totalReturn.value}",
                        "${reportController.returnList.length}"),
                    overallCard(context, AppIcons.payments, "Payments",
                        "113.00", "2.00"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Text("Daily",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  "Total Invoice",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "Total Return",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "Total Collection",
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                commonText(
                                  "${reportController.totalInvoice.value}",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "${reportController.totalReturn.value}",
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                commonText(
                                  "113.00",
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      // child: SfCartesianChart(
                      //     primaryYAxis: NumericAxis(
                      //       axisLine: AxisLine(width: 0),
                      //       majorGridLines: MajorGridLines(width: 0),
                      //       borderWidth: 0,
                      //       isVisible: false,
                      //       axisBorderType:
                      //           AxisBorderType.withoutTopAndBottom,
                      //       majorTickLines: MajorTickLines(width: 0),
                      //     ),
                      //     primaryXAxis: DateTimeAxis(
                      //         axisLine: AxisLine(width: 0),
                      //         majorGridLines: MajorGridLines(width: 0)),
                      //     borderColor: Colors.transparent,
                      //     borderWidth: 0,
                      //     crosshairBehavior: CrosshairBehavior(
                      //         enable: true,
                      //         lineColor: Theme.of(context).primaryColor),
                      //     margin: EdgeInsets.all(10),
                      //     title: ChartTitle(
                      //       text: 'Latest Sales By Day',
                      //       alignment: ChartAlignment.near,
                      //       textStyle: TextStyle(
                      //         fontFamily: 'Rubik',
                      //         color: AppColors.mutedColor,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //     series: <ChartSeries>[
                      //       // Renders line chart
                      //       LineSeries<SalesData, DateTime>(
                      //           dataSource: chartData,
                      //           xValueMapper: (SalesData sales, _) =>
                      //               sales.year,
                      //           yValueMapper: (SalesData sales, _) =>
                      //               sales.sales)
                      //     ])
                    )),
                SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Sales By Payment',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(
                            fontFamily: 'Rubik',
                            color: AppColors.mutedColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap),
                        series: <DoughnutSeries<MapEntry<String, int>, String>>[
                          DoughnutSeries<MapEntry<String, int>, String>(
                            dataSource: reportController
                                .paymentTypeCounts.entries
                                .toList(),
                            xValueMapper: (entry, _) {
                              if (reportController
                                  .salesInvoiceList.isNotEmpty) {
                                if (entry.key == "1") {
                                  return "Cash";
                                } else {
                                  return "Account Receivable";
                                }
                              } else {
                                return "No Data";
                              }
                            },
                            yValueMapper: (entry, _) => entry.value.toDouble(),
                          ),
                        ],
                        tooltipBehavior: _tooltip,
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Widget overallCard(BuildContext context, String icon, String txt,
      String total, String count) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 35,
                width: 35,
                fit: BoxFit.fill,
                color: AppColors.mutedBlueColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                txt,
                style: TextStyle(
                    color: AppColors.mutedBlueColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                total,
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Count",
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                count,
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              )
            ],
          )
        ],
      ),
    );
  }
}

Text commonText(String txt) {
  return Text(
    txt,
    style: TextStyle(color: AppColors.mutedColor),
  );
}
