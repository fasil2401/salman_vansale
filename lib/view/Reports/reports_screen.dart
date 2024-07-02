import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Report%20Type/invoice_preview.dart';
import 'package:axoproject/view/Reports/Activity%20Report/activity_logs_report_screen.dart';
import 'package:axoproject/view/Reports/Daily%20report/daily_report_screen.dart';
import 'package:axoproject/view/Reports/Expenses%20Report/expenses_report_screen.dart';
import 'package:axoproject/view/Reports/Invoices%20report/invoices_report_screen.dart';
import 'package:axoproject/view/Reports/Orders%20report/orders_report_screen.dart';
import 'package:axoproject/view/Reports/Overall%20Report/overall_report_screen.dart';
import 'package:axoproject/view/Reports/Payments%20Report/payments_report_screen.dart';
import 'package:axoproject/view/Reports/Price%20Report/price_report_screen.dart';
import 'package:axoproject/view/Reports/Report%20Preview/sales_report_preview.dart';
import 'package:axoproject/view/Reports/Stock%20Report/stock_report_screen.dart';
import 'package:axoproject/view/Reports/Unloads%20Report/unloads_report_screen.dart';
import 'package:axoproject/view/Reports/Visit%20Logs%20Report/visit_logs_screen.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:axoproject/view/route%20details/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'Return Report/return_report_screen.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({this.customerId, this.isCustomerTask = false, super.key});

  String? customerId;
  bool isCustomerTask;
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final reportController = Get.put(ReportController());
  bool isExpanded = false;
  Widget? body;
  String? title;
  int? screenId;

  void toggleFAB() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void printPreview(int screenId, BuildContext context, bool isPreview) async {
    int templateIndex = UserSimplePreferences.getPrintTemplate() ?? 1;
    switch (screenId) {
      case 1:
        var helper = await reportController.printDailySalesReport();
        if (isPreview) {
          await Get.to(() => SalesReportPreviewScreen(
                helper,
                ReportPreviewTemplate.DailySales,
              ));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.DailySales);
        }
        break;
      case 3:
        var helper = await reportController.printSalesInvoiceReport();
        if (helper == null) return;
        if (isPreview) {
          await Get.to(() => SalesReportPreviewScreen(
                helper,
                ReportPreviewTemplate.SalesInvoice,
              ));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.SalesReport);
        }
        break;
      case 5:
        var helper = await reportController.printSalesOrderReport();
        if (helper == null) return;
        if (isPreview) {
          Get.to(() => SalesReportPreviewScreen(
              helper, ReportPreviewTemplate.SalesOrder));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.SalesReport);
        }
        break;
      case 8:
        var helper = await reportController.printStockReport();

        if (helper == null) return;
        if (isPreview) {
          await Get.to(() => SalesReportPreviewScreen(
                helper,
                ReportPreviewTemplate.StockReport,
              ));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.StockReport);
        }
        break;
      case 4:
        var helper = await reportController.printReturnSalesReport();
        if (helper == null) return;
        if (isPreview) {
          await Get.to(() => SalesReportPreviewScreen(
                helper,
                ReportPreviewTemplate.SalesInvoice,
              ));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.SalesReport);
        }
        break;
      case 7:
        var helper = await reportController.printPaymentsReport();
        if (helper == null) return;
        if (isPreview) {
          await Get.to(() => SalesReportPreviewScreen(
                helper,
                ReportPreviewTemplate.Payments,
              ));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.SalesReport);
        }
        break;
      case 11:
        var helper = await reportController.printExpenseReport();
        if (helper == null) return;
        if (isPreview) {
          await Get.to(() => SalesReportPreviewScreen(
                helper,
                ReportPreviewTemplate.Expenses,
              ));
        } else {
          ThermalPrintHeplper.getConnection(
              context, helper, PrintLayouts.ExpenseReport);
        }
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    reportController.setCustomerSelection(
        customerId: widget.customerId ?? '',
        isCustomer:
            (widget.customerId != null && widget.customerId!.isNotEmpty));
    prepareReportScreens();
  }

  prepareReportScreens() {
    if (widget.isCustomerTask) {
      screens.removeWhere((element) =>
          element.screenId == 1 ||
          element.screenId == 2 ||
          element.screenId == 11);
    }
    body = screens[0].body;
    title = screens[0].title;
    screenId = screens[0].screenId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: AppBar(
          title: Text('$title Reports'),
          actions: <Widget>[
            if (screenId != 2)
              PopupMenuButton<int>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(0),
                position: PopupMenuPosition.under,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    onTap: () {
                      printPreview(screenId ?? 1, context, false);
                    },
                    value: 0,
                    padding: const EdgeInsets.all(0),
                    height: 30,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SvgPicture.asset(
                            AppIcons.print,
                            height: 20,
                            color: AppColors.mutedColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Print'),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    onTap: () {
                      printPreview(screenId ?? 1, context, true);
                    },
                    value: 1,
                    padding: const EdgeInsets.all(0),
                    height: 30,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SvgPicture.asset(
                            AppIcons.preview,
                            height: 20,
                            color: AppColors.mutedColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Preview'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: body,
        floatingActionButton: AnimatedContainer(
          margin: EdgeInsets.only(left: 30),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isExpanded)
                Container(
                    constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6),
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              screens[index].title,
                              style: TextStyle(
                                  color: AppColors.mutedColor, fontSize: 14),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            onTap: () {
                              // toggleFAB;
                              setState(() {
                                title = screens[index].title;
                                body = screens[index].body;
                                screenId = screens[index].screenId;
                                isExpanded = !isExpanded;
                              });
                            },
                          );
                        },
                        itemCount: screens.length)),
              FloatingActionButton(
                onPressed: toggleFAB,
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: isExpanded
                        ? Icon(Icons.close)
                        : SvgPicture.asset(AppIcons.reportIcon)),
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ReportScreenModel> screens = [
    ReportScreenModel(title: 'Daily', screenId: 1, body: DailyReportScreen()),
    ReportScreenModel(title: 'Overall', screenId: 2, body: OvrallReports()),
    ReportScreenModel(
        title: 'Invoice', screenId: 3, body: InvoicesReportScreen()),
    ReportScreenModel(title: 'Return', screenId: 4, body: ReturnReportScreen()),
    ReportScreenModel(title: 'Order', screenId: 5, body: OrdersReportScreen()),
    ReportScreenModel(
        title: 'Unload', screenId: 6, body: UnloadsReportScreen()),
    ReportScreenModel(
        title: 'Payment', screenId: 7, body: PaymentsReportScreen()),
    ReportScreenModel(title: 'Stock', screenId: 8, body: StockReportScreen()),
    ReportScreenModel(title: 'Price', screenId: 9, body: PriceReportScreen()),
    ReportScreenModel(
        title: 'Visit Log', screenId: 10, body: VisitLogsReportScreens()),
    ReportScreenModel(
        title: 'Expense', screenId: 11, body: ExpensesReportScreen()),
    ReportScreenModel(
        title: 'Activity Log', screenId: 12, body: ActivityLogsReportScreen()),
  ];
}

class ReportScreenModel {
  String title;
  int screenId;
  Widget body;

  ReportScreenModel(
      {required this.title, required this.body, required this.screenId});
}
