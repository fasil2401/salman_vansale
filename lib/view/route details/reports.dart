import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Reports/Daily%20report/daily_report_screen.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../utils/constants/asset_paths.dart';
import '../../utils/constants/colors.dart';

class OvrallReports extends StatefulWidget {
  const OvrallReports({super.key});

  @override
  State<OvrallReports> createState() => _OvrallReportsState();
}

class _OvrallReportsState extends State<OvrallReports> {
  final reportController = Get.put(ReportController());
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    reportController.fetchData();
    super.initState();
  }

  bool isExpanded = false;

  void toggleFAB() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      // appBar: AppBar(
      //   title: const Text("Report"),
      //   actions: [
      //     IconButton(onPressed: () {}, icon: Icon(Icons.print_outlined))
      //   ],
      // ),
      body: ListView(
        children: [
          _buildContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppbarContainer(
                    child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      AppIcons.route,
                      color: AppColors.primary,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Route',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            UserSimplePreferences.getRouteName() ?? '',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCountTiles(
                            title: 'Completed',
                            count: '${reportController.completedCount.value}%'),
                        _buildVerticalDivider(),
                        _buildCountTiles(
                            title: 'Planned',
                            count: '${reportController.plannedCount.value}'),
                        _buildVerticalDivider(),
                        _buildCountTiles(
                            title: 'Visited',
                            count: '${reportController.visitedCount.value}'),
                        _buildVerticalDivider(),
                        _buildCountTiles(
                            title: 'Skipped At',
                            count: '${reportController.skippedCount.value}'),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headText('Data Count'),
              Obx(() => GridView.count(
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
                          "${reportController.totalInvoice.value.toStringAsFixed(2)}",
                          "${reportController.salesInvoiceList.length}"),
                      overallCard(
                          context,
                          AppIcons.orders,
                          "Orders",
                          "${reportController.totalOrders.value.toStringAsFixed(2)}",
                          "${reportController.newOrdersList.length}"),
                      overallCard(
                          context,
                          AppIcons.returns,
                          "Returns",
                          "${reportController.totalReturn.value.toStringAsFixed(2)}",
                          "${reportController.returnList.length}"),
                      overallCard(
                          context,
                          AppIcons.card_active,
                          "Payments",
                          "${reportController.totalPaymentCollection.value.toStringAsFixed(2)}",
                          "${reportController.paymentCollectionList.length}"),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              _buildAppbarContainer(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(() => _buildDailyText(
                      text: 'Total Invoice',
                      amount:
                          '${reportController.totalInvoice.value.toStringAsFixed(2)}')),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(() => _buildDailyText(
                      text: 'Total Return',
                      amount:
                          '${reportController.totalReturn.value.toStringAsFixed(2)}')),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => _buildDailyText(
                        text: 'Total Collections',
                        amount:
                            '${reportController.totalPaymentCollection.value.toStringAsFixed(2)}'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ))
            ],
          )),
          const SizedBox(
            height: 10,
          ),
          _buildContainer(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _headText('Latest Sales By Day'),
                Obx(() => SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                          labelRotation: 90,
                          axisLine: AxisLine(width: 0),
                          majorTickLines: MajorTickLines(width: 0)),
                      primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        borderWidth: 0,
                        isVisible: true,
                        maximum: reportController.highestValue.value + 60,
                        axisBorderType: AxisBorderType.withoutTopAndBottom,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      series: <ChartSeries>[
                        SplineAreaSeries<SalesInvoiceApiModel, String>(
                          dataSource: reportController.latestSalesByDay.value,
                          xValueMapper: (SalesInvoiceApiModel data, _) =>
                              DateFormatter.reportDateFormat.format(
                                  DateTime.parse(data.transactionDate ?? "")),
                          yValueMapper: (SalesInvoiceApiModel data, _) =>
                              data.total,
                          color: AppColors.mutedBlueColor,
                          borderColor: AppColors.primary,
                          borderWidth: 2,
                          dataLabelSettings: DataLabelSettings(
                            angle: 90,
                            isVisible: true,
                            margin: EdgeInsets.only(bottom: 10),
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(fontSize: 12),
                            labelPosition: ChartDataLabelPosition.outside,
                            alignment: ChartAlignment.far,
                            offset: Offset(0, 10),
                            connectorLineSettings: ConnectorLineSettings(
                              color: AppColors.mutedBlueColor,
                              width: 1.5,
                            ),
                          ),
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            color: AppColors.primary,
                            width: 8,
                          ),
                        ),
                      ],
                    )),
              ])),
          _buildContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headText('Sales By Payment'),
              Obx(() => SfCircularChart(
                    // title: ChartTitle(
                    //   text: 'Sales By Payment',
                    //   alignment: ChartAlignment.near,
                    //   textStyle: TextStyle(
                    //     fontFamily: 'Rubik',
                    //     color: AppColors.mutedColor,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    series: <DoughnutSeries<MapEntry<String, int>, String>>[
                      DoughnutSeries<MapEntry<String, int>, String>(
                        dataSource:
                            reportController.paymentTypeCounts.entries.toList(),
                        xValueMapper: (entry, _) {
                          if (reportController.salesInvoiceList.isNotEmpty) {
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
                  ))
            ],
          ))
        ],
      )
      // Obx(() => Padding(
      //       padding: const EdgeInsets.only(
      //         right: 10,
      //         left: 10,
      //         bottom: 10,
      //         top: 15,
      //       ),
      //       child: SingleChildScrollView(
      //         child: Column(
      //           children: [
      //             Card(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               shadowColor: Colors.black,
      //               elevation: 5,
      //               child: Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 10, right: 10, top: 15, bottom: 10),
      //                     child: Row(
      //                       children: [
      //                         SvgPicture.asset(
      //                           AppIcons.routes,
      //                           height: 50,
      //                           width: 45,
      //                           fit: BoxFit.fill,
      //                           color: Theme.of(context).primaryColor,
      //                         ),
      //                         SizedBox(
      //                           width: 10,
      //                         ),
      //                         Text("Routes",
      //                             style: TextStyle(
      //                                 fontSize: 17,
      //                                 fontWeight: FontWeight.w500))
      //                       ],
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         right: 15, left: 15, bottom: 15),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Column(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             commonText(
      //                               "Completed (%)",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "Planned",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "Visited",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "Skipped At",
      //                             )
      //                           ],
      //                         ),
      //                         Column(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           crossAxisAlignment: CrossAxisAlignment.end,
      //                           children: [
      //                             commonText(
      //                               "3.13",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "31.00",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "1.00",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "0.00",
      //                             )
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             GridView.count(
      //               primary: false,
      //               shrinkWrap: true,
      //               crossAxisSpacing: 12,
      //               childAspectRatio: 1.4,
      //               mainAxisSpacing: 14,
      //               crossAxisCount: 2,
      //               children: <Widget>[
      //                 overallCard(
      //                     context,
      //                     AppIcons.invoice,
      //                     "Invoices",
      //                     "${reportController.totalInvoice.value}",
      //                     "${reportController.salesInvoiceList.length}"),
      //                 overallCard(
      //                     context,
      //                     AppIcons.orders,
      //                     "Orders",
      //                     "${reportController.totalOrders.value}",
      //                     "${reportController.newOrdersList.length}"),
      //                 overallCard(
      //                     context,
      //                     AppIcons.returns,
      //                     "Returns",
      //                     "${reportController.totalReturn.value}",
      //                     "${reportController.returnList.length}"),
      //                 overallCard(
      //                     context, AppIcons.payments, "Payments", "0.00", "0"),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Card(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               shadowColor: Colors.black,
      //               elevation: 5,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(left: 14),
      //                     child: Text("Daily",
      //                         style: TextStyle(
      //                             fontSize: 17, fontWeight: FontWeight.w500)),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.all(13),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Column(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             commonText(
      //                               "Total Invoice",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "Total Return",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "Total Collection",
      //                             ),
      //                           ],
      //                         ),
      //                         Column(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           crossAxisAlignment: CrossAxisAlignment.end,
      //                           children: [
      //                             commonText(
      //                               "${reportController.totalInvoice.value}",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "${reportController.totalReturn.value}",
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             commonText(
      //                               "0.00",
      //                             ),
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //                 shadowColor: Colors.black,
      //                 elevation: 5,
      //                 child: Container(
      //                   padding: const EdgeInsets.all(10),
      //                   width: double.infinity,
      //                   // child: SfCartesianChart(
      //                   //     primaryYAxis: NumericAxis(
      //                   //       axisLine: AxisLine(width: 0),
      //                   //       majorGridLines: MajorGridLines(width: 0),
      //                   //       borderWidth: 0,
      //                   //       isVisible: false,
      //                   //       axisBorderType:
      //                   //           AxisBorderType.withoutTopAndBottom,
      //                   //       majorTickLines: MajorTickLines(width: 0),
      //                   //     ),
      //                   //     primaryXAxis: DateTimeAxis(
      //                   //         axisLine: AxisLine(width: 0),
      //                   //         majorGridLines: MajorGridLines(width: 0)),
      //                   //     borderColor: Colors.transparent,
      //                   //     borderWidth: 0,
      //                   //     crosshairBehavior: CrosshairBehavior(
      //                   //         enable: true,
      //                   //         lineColor: Theme.of(context).primaryColor),
      //                   //     margin: EdgeInsets.all(10),
      //                   //     title: ChartTitle(
      //                   //       text: 'Latest Sales By Day',
      //                   //       alignment: ChartAlignment.near,
      //                   //       textStyle: TextStyle(
      //                   //         fontFamily: 'Rubik',
      //                   //         color: AppColors.mutedColor,
      //                   //         fontWeight: FontWeight.w500,
      //                   //       ),
      //                   //     ),
      //                   //     series: <ChartSeries>[
      //                   //       // Renders line chart
      //                   //       LineSeries<SalesData, DateTime>(
      //                   //           dataSource: chartData,
      //                   //           xValueMapper: (SalesData sales, _) =>
      //                   //               sales.year,
      //                   //           yValueMapper: (SalesData sales, _) =>
      //                   //               sales.sales)
      //                   //     ])
      //                 )),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Card(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               shadowColor: Colors.black,
      //               elevation: 5,
      //               child: Container(
      //                   padding: const EdgeInsets.all(10),
      //                   width: double.infinity,
      //                   child: SfCircularChart(
      //                     title: ChartTitle(
      //                       text: 'Sales By Payment',
      //                       alignment: ChartAlignment.near,
      //                       textStyle: TextStyle(
      //                         fontFamily: 'Rubik',
      //                         color: AppColors.mutedColor,
      //                         fontWeight: FontWeight.w500,
      //                       ),
      //                     ),
      //                     legend: Legend(
      //                         isVisible: true,
      //                         overflowMode: LegendItemOverflowMode.wrap),
      //                     series: <
      //                         DoughnutSeries<MapEntry<String, int>, String>>[
      //                       DoughnutSeries<MapEntry<String, int>, String>(
      //                         dataSource: reportController
      //                             .paymentTypeCounts.entries
      //                             .toList(),
      //                         xValueMapper: (entry, _) {
      //                           if (reportController
      //                               .salesInvoiceList.isNotEmpty) {
      //                             if (entry.key == "1") {
      //                               return "Cash";
      //                             } else {
      //                               return "Account Receivable";
      //                             }
      //                           } else {
      //                             return "No Data";
      //                           }
      //                         },
      //                         yValueMapper: (entry, _) =>
      //                             entry.value.toDouble(),
      //                       ),
      //                     ],
      //                     tooltipBehavior: _tooltip,
      //                   )),
      //             )
      //           ],
      //         ),
      //       ),
      //     )),

      ,
      // floatingActionButton: AnimatedContainer(
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeInOut,
      //   alignment: Alignment.bottomRight,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       if (isExpanded)
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: _buildContainer(
      //               child: Column(
      //             children: [
      //               ListTile(
      //                 title: Text(
      //                   'Daily',
      //                   style: TextStyle(
      //                       color: AppColors.mutedColor, fontSize: 14),
      //                 ),
      //                 trailing: Icon(
      //                   Icons.arrow_forward_ios,
      //                   size: 15,
      //                 ),
      //                 onTap: () {
      //                   Get.to(() => DailyReportScreen());
      //                 },
      //               )
      //             ],
      //           )),
      //         ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       FloatingActionButton(
      //         onPressed: toggleFAB,
      //         child: SizedBox(
      //             height: 25,
      //             width: 25,
      //             child: SvgPicture.asset(AppIcons.report_home)),
      //         backgroundColor: AppColors.primary,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Row _buildDailyText({required String text, required String amount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
              color: AppColors.mutedColor,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        Text(
          amount,
          style: const TextStyle(
              color: AppColors.mutedColor,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Padding _headText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedColor),
      ),
    );
  }

  Container _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 50,
      color: AppColors.lightGrey,
    );
  }

  Padding _buildCountTiles({required String title, required String count}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            title,
            maxFontSize: 14,
            minFontSize: 8,
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: AppColors.mutedColor),
          ),
          const SizedBox(
            height: 5,
          ),
          AutoSizeText(
            count,
            maxFontSize: 18,
            minFontSize: 12,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget overallCard(BuildContext context, String icon, String txt,
      String total, String count) {
    return _buildAppbarContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                height: 20,
                width: 20,
                fit: BoxFit.fill,
                color: AppColors.primary,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                txt,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        color: AppColors.mutedColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    total,
                    style: TextStyle(
                        color: AppColors.mutedColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Count",
                    style: TextStyle(
                        color: AppColors.mutedColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    count,
                    style: TextStyle(
                        color: AppColors.mutedColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Container _buildAppbarContainer({required Widget child}) {
  return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.mutedBlueColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)),
      child: child);
}

Container _buildContainer({required Widget child}) {
  return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: child);
}

Text commonText(String txt) {
  return Text(
    txt,
    style: TextStyle(color: AppColors.mutedColor),
  );
}

class ChartData {
  ChartData(this.month, this.value);
  final String month;
  final double value;
}
