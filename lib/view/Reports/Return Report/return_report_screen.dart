import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/new_order_controller.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../../utils/Calculations/date_range_selector.dart';

class ReturnReportScreen extends StatelessWidget {
  ReturnReportScreen({super.key});
  final salesInvoiceController = Get.put(SalesInvoiceController());
  final reportController = Get.put(ReportController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await reportController.getReturnList();
      reportController.filterList(
          reportController.returnFilterList, reportController.returnList);
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
                  Obx(
                    () => GFAccordion(
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
                      titlePadding:
                          EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
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
                            _.toDate.value = _.selectDate(context, false);
                          },
                          () {
                            reportController.filterList(
                                reportController.returnFilterList,
                                reportController.returnList);
                          }),
                    ),
                  ),
                  commonDivider(),
                  ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: _.returnFilterList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      itemBuilder: (context, index) {
                        var item = _.returnFilterList[index];
                        return slidableWidget(item.isSynced!, (value) async {
                          var helper = await reportController.printSalesReport(
                            item,
                          );
                          ThermalPrintHeplper.getConnection(
                              context, helper, PrintLayouts.SalesReturn);
                        }, (value) {
                          salesInvoiceController.editInvoiceFromReport(item);
                          reportController.navigateSalesInvoice();
                        }, (p0) {
                          _.printSalesReport(item, isPreview: true);
                        }, () {
                          salesInvoiceController.deleteSavedRequest(
                              item.voucherid ?? "", item.sysdocid ?? "", index);
                          _.deleteSalesReturnItem(item.voucherid!);
                          Navigator.pop(context);
                        },
                            context,
                            'return_list',
                            tile(
                                "${item.sysdocid} - ${item.voucherid}",
                                "Qty  : ${item.quantity}",
                                "${item.total}",
                                "${item.transactionDate}",
                                item.isSynced ?? 0),
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
    );
  }
}
