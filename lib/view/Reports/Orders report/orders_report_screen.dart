import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/new_order_controller.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/New%20Order/new_order_screen.dart';
import 'package:axoproject/view/Reports/Invoices%20report/invoices_report_screen.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../../utils/Calculations/date_range_selector.dart';

class OrdersReportScreen extends StatefulWidget {
  const OrdersReportScreen({super.key});

  @override
  State<OrdersReportScreen> createState() => _OrdersReportScreenState();
}

class _OrdersReportScreenState extends State<OrdersReportScreen> {
  final reportController = Get.put(ReportController());

  final newOrderController = Get.put(NewOrderController());

  var selectedValue;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportController.getOrderReport();
    });
    return Scaffold(
      body: GetBuilder<ReportController>(
          init: ReportController(),
          initState: (_) {},
          builder: (_) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => GFAccordion(
                        title: 'Filter',
                        showAccordion: false,
                        titleBorderRadius: BorderRadius.circular(5),
                        expandedTitleBackgroundColor:
                            Theme.of(context).primaryColor,
                        collapsedTitleBackgroundColor: Colors.black38,
                        collapsedIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        expandedIcon: const Icon(Icons.keyboard_arrow_up,
                            color: Colors.white),
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        titlePadding: EdgeInsets.only(
                            right: 5, top: 5, bottom: 5, left: 5),
                        contentChild: dateReportFilter(
                            context,
                            _.dateIndex.value,
                            (value) {
                              selectedValue = value;
                              _.selectDateRange(
                                  selectedValue.value,
                                  DateRangeSelector.dateRange
                                      .indexOf(selectedValue));
                            },
                            _.fromDate.value,
                            _.isFromDate.value,
                            () {
                              _.selectDate(context, true);
                            },
                            _.toDate.value,
                            _.isToDate.value,
                            () {
                              _.selectDate(context, false);
                            },
                            () {
                              reportController.filterList(
                                  reportController.newOrdersFilterList,
                                  reportController.newOrdersList);
                            }),
                      )),
                  commonDivider(),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _.newOrdersFilterList.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      itemBuilder: (context, index) {
                        var item = _.newOrdersFilterList[index];
                        return slidableWidget(item.isSynced!, (value) async {
                          var helper =
                              await reportController.printNewOrderReport(
                            item,
                          );
                          ThermalPrintHeplper.getConnection(
                              context, helper, PrintLayouts.SalesOrder);
                        }, (value) {
                          newOrderController.editOrderFromReport(item);
                          _.navigateNewOrder();
                        }, (p0) {
                          _.printNewOrderReport(item, isPreview: true);
                        }, () {
                          newOrderController.deleteSavedRequest(
                              item.voucherid ?? "", item.sysdocid ?? "", index);
                          _.deleteNewOrderItem(item.voucherid ?? "");
                          Navigator.pop(context);
                        },
                            context,
                            "orders_list",
                            tile(
                              "${item.sysdocid} - ${item.voucherid}",
                              "Qty  : ${item.quantity}",
                              "${item.total}",
                              "${item.transactiondate}",
                              item.isSynced ?? 0,
                            ),
                            isError: item.isError ?? 0,
                            error: item.error ?? "");
                      }),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            );
          }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       FloatingActionButton(
      //         heroTag: "list",
      //         backgroundColor: Theme.of(context).primaryColor,
      //         onPressed: () {},
      //         child: Icon(Icons.list_alt_sharp),
      //       ),
      //       FloatingActionButton(
      //         heroTag: "print",
      //         onPressed: () {},
      //         backgroundColor: Theme.of(context).primaryColor,
      //         child: Icon(Icons.print_outlined),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
