import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class DailyReportScreen extends StatelessWidget {
  DailyReportScreen({super.key});
  final reportController = Get.put(ReportController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportController.dailyReport();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      Text(
                        DateFormatter.reportDateFormat.format(DateTime.now()),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sales Person",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      Flexible(
                        child: Text(
                          UserSimplePreferences.getSalesPersonID() ?? '',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 7,
              color: AppColors.lightGrey,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildRows(context,
                      cashOrCreditType: 'Cash Type',
                      count: "Count",
                      amount: 'Amount',
                      isHeader: true),
                  SizedBox(
                    height: 13,
                  ),
                  Obx(
                    () => _buildRows(context,
                        cashOrCreditType: "Cash Reciepts",
                        count:
                            "${reportController.cashReciepts.value.count ?? 0}",
                        amount:
                            (reportController.cashReciepts.value.amount ?? 0.00)
                                .toStringAsFixed(2),
                        isHeader: false),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(context,
                      cashOrCreditType: "Cash Sales",
                      count: "${(reportController.cashSales.value.count ?? 0)}",
                      amount: (reportController.cashSales.value.amount ?? 0.00)
                          .toStringAsFixed(2),
                      isHeader: false)),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(context,
                      cashOrCreditType: "Cash Sales Return",
                      count:
                          "${(reportController.cashSalesReturn.value.count ?? 0)}",
                      amount: (reportController.cashSalesReturn.value.amount ??
                              0.00)
                          .toStringAsFixed(2),
                      isHeader: false)),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(context,
                      cashOrCreditType: "Cash Expense",
                      count:
                          "${(reportController.cashExpenses.value.count ?? 0)}",
                      amount:
                          (reportController.cashExpenses.value.amount ?? 0.00)
                              .toStringAsFixed(2),
                      isHeader: false)),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(
                        context,
                        cashOrCreditType: "Total Cash",
                        count:
                            "${(reportController.totalCash.value.count ?? 0)}",
                        amount:
                            (reportController.totalCash.value.amount ?? 0.00)
                                .toStringAsFixed(2),
                        isHeader: true,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Divider(
              thickness: 7,
              color: AppColors.lightGrey,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildRows(context,
                      cashOrCreditType: 'Credit Type',
                      count: "Count",
                      amount: 'Amount',
                      isHeader: true),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRows(context,
                      cashOrCreditType: "Credit card Sales",
                      count: "0",
                      amount: "0.00",
                      isHeader: false),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(context,
                      cashOrCreditType: "Credit Sales",
                      count:
                          "${(reportController.creditSales.value.count ?? 0)}",
                      amount:
                          (reportController.creditSales.value.amount ?? 0.00)
                              .toStringAsFixed(2),
                      isHeader: false)),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(context,
                      cashOrCreditType: "Credit Sale Return",
                      count:
                          "${(reportController.creditSalesReturn.value.count ?? 0)}",
                      amount:
                          (reportController.creditSalesReturn.value.amount ??
                                  0.00)
                              .toStringAsFixed(2),
                      isHeader: false)),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(context,
                      cashOrCreditType: "Cheques",
                      count: "${reportController.cheque.value.count ?? 0}",
                      amount: (reportController.cheque.value.amount ?? 0.00)
                          .toStringAsFixed(2),
                      isHeader: false)),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2,
                  ),
                  Obx(() => _buildRows(
                        context,
                        cashOrCreditType: "Total Credit",
                        count:
                            "${(reportController.totalCredit.value.count ?? 0)}",
                        amount:
                            (reportController.totalCredit.value.amount ?? 0.00)
                                .toStringAsFixed(2),
                        isHeader: true,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {},
      //     backgroundColor: Theme.of(context).primaryColor,
      //     child: Icon(
      //       Icons.print_outlined,
      //     )),
    );
  }

  static Widget _buildRows(
    BuildContext context, {
    required String cashOrCreditType,
    required String count,
    required String amount,
    required bool isHeader,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            cashOrCreditType,
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              color: isHeader ? Colors.black : Colors.black,
              fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            count,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: isHeader ? 15 : 14,
              color: isHeader ? Colors.black : Colors.black,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            amount,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isHeader ? 15 : 14,
              color: isHeader ? Colors.black : Colors.black,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
