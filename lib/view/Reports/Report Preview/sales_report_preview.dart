import 'dart:convert';
import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Print%20Helper/sales_report_print_helper.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/File%20Save%20Helper/file_save_helper.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

class SalesReportPreviewScreen extends StatefulWidget {
  const SalesReportPreviewScreen(
    this.printDetail,
    this.template, {
    super.key,
  });

  final dynamic printDetail;
  final ReportPreviewTemplate template;
  @override
  _SalesReportPreviewScreenState createState() =>
      _SalesReportPreviewScreenState();
}

class _SalesReportPreviewScreenState extends State<SalesReportPreviewScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  void toggleFAB() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  late WebViewController _controller;
  String _htmlContent = '';

  @override
  void initState() {
    super.initState();
    if (widget.template.value == 3) {
      _loadHtmlFromAssetsForDailySales();
    } else if (widget.template.value == 4) {
      _loadHtmlFromAssetsForStockReport();
    } else {
      _loadHtmlFromAssets();
    }
  }

  Future<void> _loadHtmlFromAssets() async {
    final htmlContent = await rootBundle.loadString(widget.template.path);
    _htmlContent = htmlContent
        .replaceAll('{{printDate}}', widget.printDetail.printDate ?? '')
        .replaceAll('{{fromDate}}', widget.printDetail.fromDate ?? '')
        .replaceAll('{{toDate}}', widget.printDetail.toDate ?? '')
        .replaceAll('{{salesPerson}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{vanName}}', widget.printDetail.vanName ?? '')
        .replaceAll('{{total}}', widget.printDetail.total ?? '0.00')
        .replaceAll('{{headerImage}}', widget.printDetail.headerImage ?? '')
        .replaceAll('{{footerImage}}', widget.printDetail.footerImage ?? '')
        .replaceAll('{{tableRows}}', generateTableRows(widget.template.value));
    setState(() {});
  }

  Future<void> _loadHtmlFromAssetsForStockReport() async {
    final htmlContent = await rootBundle.loadString(widget.template.path);
    _htmlContent = htmlContent
        .replaceAll('{{printDate}}', widget.printDetail.transactionDate ?? '')
        .replaceAll('{{salesPerson}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{vanName}}', widget.printDetail.vanName ?? '')
        .replaceAll('{{totalQty}}', widget.printDetail.total ?? '0.00')
        .replaceAll('{{headerImage}}', widget.printDetail.headerImage ?? '')
        .replaceAll('{{footerImage}}', widget.printDetail.footerImage ?? '')
        .replaceAll('{{tableRows}}', generateTableRows(widget.template.value));
    setState(() {});
  }

  Future<void> _loadHtmlFromAssetsForDailySales() async {
    final htmlContent = await rootBundle.loadString(widget.template.path);
    _htmlContent = htmlContent
        .replaceAll('{{printDate}}', widget.printDetail.transactionDate ?? '')
        .replaceAll('{{salesPerson}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{vanName}}', widget.printDetail.vanName ?? '')
        .replaceAll('{{total}}', widget.printDetail.total ?? '0.00')
        .replaceAll('{{headerImage}}', widget.printDetail.headerImage ?? '')
        .replaceAll('{{footerImage}}', widget.printDetail.footerImage ?? '')
        .replaceAll('{{cashSalesCount}}',
            widget.printDetail.cashSales!.count.toString())
        .replaceAll('{{cashSalesAmount}}',
            widget.printDetail.cashSales!.amount.toString())
        .replaceAll('{{cashSaleReturnCount}}',
            widget.printDetail.cashSalesReturn!.count.toString())
        .replaceAll('{{cashSaleReturnAmount}}',
            widget.printDetail.cashSalesReturn!.amount.toString())
        .replaceAll('{{cashRecieptCount}}',
            widget.printDetail.cashReciepts!.count.toString())
        .replaceAll('{{cashRecieptAmount}}',
            widget.printDetail.cashReciepts!.amount.toString())
        .replaceAll('{{cashExpenseCount}}',
            widget.printDetail.cashExpenses!.count.toString())
        .replaceAll('{{cashExpenseAmount}}',
            widget.printDetail.cashExpenses!.amount.toString())
        .replaceAll('{{totalCashCount}}',
            widget.printDetail.totalCash!.count.toString())
        .replaceAll('{{totalCashAmount}}',
            widget.printDetail.totalCash!.amount.toString())
        .replaceAll('{{creditCardCount}}',
            widget.printDetail.creditCardSales!.count.toString())
        .replaceAll('{{creditCardAmount}}',
            widget.printDetail.creditCardSales!.amount.toString())
        .replaceAll('{{creditSalesCount}}',
            widget.printDetail.creditSales!.count.toString())
        .replaceAll('{{creditSalesAmount}}',
            widget.printDetail.creditSales!.amount.toString())
        .replaceAll('{{creditSaleReturnCount}}',
            widget.printDetail.creditSalesReturn!.count.toString())
        .replaceAll('{{creditSaleReturnAmount}}',
            widget.printDetail.creditSalesReturn!.amount.toString())
        .replaceAll('{{chequeCollectedCount}}',
            widget.printDetail.cheques!.count.toString())
        .replaceAll('{{chequeCollectedAmount}}',
            widget.printDetail.cheques!.amount.toString())
        .replaceAll(
            '{{totalCount}}', widget.printDetail.totalCredit!.count.toString())
        .replaceAll('{{totalAmount}}',
            widget.printDetail.totalCredit!.amount.toString());
    setState(() {});
  }

  String getNetAmount() {
    double total = 0.0;
    for (var element in widget.printDetail.items!) {
      total += element.netAmount ?? 0.0;
    }
    return total.toString();
  }

  generateTableRows(int template) {
    String tableRows = '';

    switch (template) {
      case 1:
        tableRows = generateTableRowsSalesInvoiceTemplate();
        break;
      case 2:
        tableRows = generateTableRowsSalesOrderTemplate();
        break;
      case 3:
        tableRows = generateTableRowsDailySalesTemplate();
        break;
      case 4:
        tableRows = generateTableRowsStockReportTemplate();
        break;
      case 5:
        tableRows = generateTableRowsPaymentsTemplate();
        break;
      case 6:
        tableRows = generateTableRowsExpensesTemplate();
        break;
      // case 3:
      //   tableRows = generateTableRowsTemplate3();
      //   break;
      // case 4:
      //   tableRows = generateTableRowsTemplate4();
      //   break;
      // case 6:
      //   tableRows = generateTableRowsTemplate6();
      //   break;
      default:
    }
    return tableRows;
  }

  String generateTableRowsSalesInvoiceTemplate() {
    final List<SalesReportDetailModel> tableData =
        widget.printDetail.items ?? [];
    String tableRows = '';

    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row += '<td style="text-align:left">${rowData.customerCode}</td>';
        row += '<td>${rowData.voucherNo}</td>';
        row += '<td>${rowData.total!.toStringAsFixed(2)}</td>';
        row += '<td>${rowData.tax!.toStringAsFixed(2)}</td>';
        row += '<td>${rowData.discount!.toStringAsFixed(2)}</td>';
        row += '<td>${rowData.netAmount!.toStringAsFixed(2)}</td>';
        row += '</tr>';
        tableRows += row;
      }
    }

    return tableRows;
  }

  String generateTableRowsPaymentsTemplate() {
    final List<SalesReportDetailModel> tableData =
        widget.printDetail.items ?? [];
    String tableRows = '';

    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row += '<td style="text-align:left">${rowData.customerCode}</td>';
        row += '<td>${rowData.voucherNo}</td>';
        row += '<td>${rowData.total!.toStringAsFixed(2)}</td>';
        row += '<td>${rowData.paymentMode}</td>';
        row += '<td>${rowData.date}</td>';
        row += '</tr>';
        tableRows += row;
      }
    }

    return tableRows;
  }

  String generateTableRowsStockReportTemplate() {
    final List<ProductModel> tableData = widget.printDetail.products ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.productID}</br>${rowData.description}</td>';
        row += '<td>${rowData.openingStock}</td>';
        row += '<td>${rowData.saleQuantity}</td>';
        row += '<td>${rowData.returnQuantity}</td>';
        row += '<td>${rowData.damageQuantity}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '</tr>';
        tableRows += row;
      }
    }

    return tableRows;
  }

  String generateTableRowsDailySalesTemplate() {
    final List<SalesReportDetailModel> tableData =
        widget.printDetail.items ?? [];
    String tableRows = '';

    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row += '<td style="text-align:left">${rowData.customerCode}</td>';
        row += '<td>${rowData.voucherNo}</td>';
        row += '<td>${rowData.total!.toStringAsFixed(2)}</td>';
        row += '<td>${rowData.tax!.toStringAsFixed(2)}</td>';
        row += '<td>${rowData.netAmount!.toStringAsFixed(2)}</td>';
        row += '</tr>';
        tableRows += row;
      }
    }

    return tableRows;
  }

  String generateTableRowsSalesOrderTemplate() {
    final List<SalesReportDetailModel> tableData =
        widget.printDetail.items ?? [];
    String tableRows = '';

    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row += '<td style="text-align:left">${rowData.customerCode}</td>';
        row += '<td>${rowData.voucherNo}</td>';
        row += '<td>${rowData.total}</td>';
        row += '<td>${rowData.tax}</td>';
        row += '<td>${rowData.discount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    }

    return tableRows;
  }

  String generateTableRowsExpensesTemplate() {
    final List<ExpenseTransactionApiModel> tableData =
        widget.printDetail.expenseHeader ?? [];
    String tableRows = '';

    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        double subtotal = (rowData.amount ?? 0.0) - (rowData.taxAmount ?? 0.0);
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row += '<td style="text-align:left">${rowData.voucherID}</td>';
        row += '<td>$subtotal</td>';
        row += '<td>${rowData.taxAmount}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    }

    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preview ${widget.template.value}'),
        ),
        body: WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _controller.loadUrl(
              Uri.dataFromString(
                _htmlContent,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ).toString(),
            );
          },
        ),
        floatingActionButton: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isExpanded)
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          PrintHelper.generateAndSharePDF(_htmlContent);
                        },
                        mini: true,
                        heroTag: 'share',
                        child: Icon(Icons.share_outlined, size: 17),
                      ),
                      FloatingActionButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          PrintHelper.generateAndPrintPDF(_htmlContent);
                        },
                        heroTag: 'print',
                        mini: true,
                        child: Icon(Icons.print_outlined, size: 17),
                      ),
                    ],
                  ),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: toggleFAB,
                  heroTag: 'expand',
                  child: Icon(Icons.more_horiz_outlined, size: 17),
                  mini: true,
                ),
              ],
            )));
  }
}
