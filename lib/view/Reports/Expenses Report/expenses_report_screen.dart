import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/expenses_controller.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/Calculations/date_range_selector.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class ExpensesReportScreen extends StatelessWidget {
  ExpensesReportScreen({super.key});
  final reportController = Get.put(ReportController());
  final expenseController = Get.put(ExpensesController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
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
                                reportController.dateIndex.value,
                                (value) {
                                  selectedValue = value;
                                  reportController.selectDateRange(
                                      selectedValue.value,
                                      DateRangeSelector.dateRange
                                          .indexOf(selectedValue));
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
                                      reportController.expenseFliterList,
                                      reportController.expenseList);
                                }),
                          )),
                      commonDivider(),
                      ListView.builder(
                          itemCount: _.expenseFliterList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          itemBuilder: (context, index) {
                            var item = _.expenseFliterList.value[index];
                            return slidableWidget(item.isSynced ?? 0,
                                (p0) async {
                              var helper = await _.printExpenseTransaction(
                                  item.voucherID ?? "");
                              ThermalPrintHeplper.getConnection(context, helper,
                                  PrintLayouts.ExpenseTransaction);
                            }, (value) {
                              expenseController.editExpenseTransaction(item);
                              _.navigateExpenseTransaction();
                            }, (value) {
                              _.printExpenseTransaction(item.voucherID ?? "",
                                  isPreview: true);
                            }, () async {
                              expenseController.deleteSavedTransaction(
                                  item.voucherID, item.sysDocID ?? "", index);
                              _.deleteExpensesItem(item.voucherID ?? '');
                              Navigator.pop(context);
                            },
                                context,
                                "expense_list",
                                tile(
                                    "${item.sysDocID} - ${item.voucherID}",
                                    "",
                                    "${item.amount}",
                                    "${item.transactionDate}",
                                    item.isSynced ?? 0),
                                isError: item.isError ?? 0,
                                error: item.error ?? "");
                          }),
                      SizedBox(
                        height: 70,
                      )
                    ]),
              );
            }));
  }
}
