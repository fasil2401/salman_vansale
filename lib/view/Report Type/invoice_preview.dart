import 'dart:convert';
import 'dart:developer';
import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
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

class InvoicePreviewScreen extends StatefulWidget {
  const InvoicePreviewScreen(
    this.printDetail,
    this.template, {
    super.key,
  });

  final PrintHelper printDetail;
  final PreviewTemplate template;
  @override
  _InvoicePreviewScreenState createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen>
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
    if (widget.template == PreviewTemplate.Expenses) {
      _loadHtmlFromAssetsForExpense();
    } else if (widget.template == PreviewTemplate.CashCheque) {
      _loadHtmlFromAssetsForPayment();
    } else {
      _loadHtmlFromAssets();
    }
  }

  Future<void> _loadHtmlFromAssets() async {
    final htmlContent = await rootBundle.loadString(widget.template.path);
    String title = widget.template.value == 10 || widget.template.value == 11
        ? (widget.printDetail.isReturn ?? false)
            ? "مذكرة الائتمان الضريبي TAX CREDIT NOTE"
            : "فاتورة ضريبية TAX INVOICE"
        : (widget.printDetail.isReturn ?? false)
            ? "TAX CREDIT NOTE"
            : "TAX INVOICE";
    String parentCustomerName = widget.printDetail.parentCustomer != null &&
            widget.printDetail.parentCustomer!.isNotEmpty
        ? widget.printDetail.parentCustomer!
        : widget.printDetail.customer ?? '';
    _htmlContent = htmlContent
        .replaceAll('{{date}}', widget.printDetail.transactionDate ?? '')
        .replaceAll('{{title}}', title)
        .replaceAll('{{salesPerson}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{vanName}}', widget.printDetail.vanName ?? '')
        .replaceAll('{{trn}}', widget.printDetail.trn ?? '')
        .replaceAll('{{customer}}', widget.printDetail.customer ?? '')
        .replaceAll('{{parentCustomer}}', parentCustomerName)
        .replaceAll('{{customertrn}}', widget.printDetail.customerTrn ?? '')
        .replaceAll('{{address}}', widget.printDetail.address ?? '')
        .replaceAll('{{voucherId}}', widget.printDetail.invoiceNo ?? '')
        .replaceAll('{{phone}}', widget.printDetail.phone ?? '')
        .replaceAll('{{salesMan}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{paymentMode}}', widget.printDetail.paymentMode ?? '')
        .replaceAll('{{reference}}', widget.printDetail.refNo ?? '')
        .replaceAll('{{amountInWords}}', widget.printDetail.amountInWords ?? '')
        .replaceAll('{{subTotal}}', widget.printDetail.subTotal ?? '')
        .replaceAll('{{discount}}', widget.printDetail.discount ?? '')
        .replaceAll('{{tax}}', widget.printDetail.tax ?? '')
        .replaceAll('{{total}}', widget.printDetail.total ?? '')
        .replaceAll('{{headerImage}}', widget.printDetail.headerImage ?? '')
        .replaceAll('{{footerImage}}', widget.printDetail.footerImage ?? '')
        .replaceAll('{{totalQty}}',
            widget.printDetail.items != null ? getTotalQuantity() : '21')
        .replaceAll('{{tableRows}}', generateTableRows(widget.template.value));
    setState(() {});
  }

  Future<void> _loadHtmlFromAssetsForPayment() async {
    final htmlContent = await rootBundle.loadString(widget.template.path);
    String title = (widget.printDetail.isCheque ?? false) ? "CHEQUE" : "CASH";
    _htmlContent = htmlContent
        .replaceAll('{{printDate}}', widget.printDetail.transactionDate ?? '')
        .replaceAll('{{title}}', title)
        .replaceAll('{{salesPerson}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{Cheque No:}}',
            widget.printDetail.isCheque == true ? "Cheque No:" : "")
        .replaceAll('{{vanName}}', widget.printDetail.vanName ?? '')
        .replaceAll('{{trn}}', widget.printDetail.trn ?? '')
        .replaceAll('{{receiptNo}}', widget.printDetail.recieptNo ?? '')
        .replaceAll('{{receiptDate}}', widget.printDetail.recieptDate ?? '')
        .replaceAll('{{chequeNo}}', widget.printDetail.chequeNumber ?? '')
        .replaceAll('{{remarks}}', widget.printDetail.remarks ?? '')
        .replaceAll('{{receivedFrom}}', widget.printDetail.receivedFrom ?? '')
        .replaceAll('{{amount}}', widget.printDetail.amount ?? '')
        .replaceAll('{{amountInWords}}', widget.printDetail.amountInWords ?? '')
        .replaceAll('{{amount}}', widget.printDetail.amount ?? '')
        .replaceAll('{{headerImage}}', widget.printDetail.headerImage ?? '')
        .replaceAll('{{footerImage}}', widget.printDetail.footerImage ?? '');
    setState(() {});
  }

  Future<void> _loadHtmlFromAssetsForExpense() async {
    final htmlContent = await rootBundle.loadString(widget.template.path);
    _htmlContent = htmlContent
        .replaceAll('{{printDate}}', widget.printDetail.transactionDate ?? '')
        .replaceAll('{{salesPerson}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{vanName}}', widget.printDetail.vanName ?? '')
        .replaceAll('{{trn}}', widget.printDetail.trn ?? '')
        .replaceAll('{{voucherId}}', widget.printDetail.invoiceNo ?? '')
        .replaceAll('{{date}}', widget.printDetail.transactionDate ?? '')
        .replaceAll('{{mobile}}', widget.printDetail.mobile ?? '')
        .replaceAll('{{salesMan}}', widget.printDetail.salesPerson ?? '')
        .replaceAll('{{amountInWords}}', widget.printDetail.amountInWords ?? '')
        .replaceAll('{{subTotal}}', widget.printDetail.subTotal ?? '')
        .replaceAll('{{tax}}', widget.printDetail.tax ?? '')
        .replaceAll('{{total}}', widget.printDetail.total ?? '')
        .replaceAll('{{headerImage}}', widget.printDetail.headerImage ?? '')
        .replaceAll('{{footerImage}}', widget.printDetail.footerImage ?? '')
        .replaceAll('{{tableRows}}', generateTableRows(widget.template.value));
    setState(() {});
  }

  String getTotalQuantity() {
    double quantity = 0.0;
    for (var element in widget.printDetail.items!) {
      quantity += element.quantity;
    }
    return quantity.toString();
  }

  generateTableRows(int template) {
    String tableRows = '';
    log(template.toString(), name: 'Template');

    switch (template) {
      case 1:
        tableRows = generateTableRowsTemplate1();
        break;
      case 2:
        tableRows = generateTableRowsTemplate2();
        break;
      case 3:
        tableRows = generateTableRowsTemplate3();
        break;
      case 4:
        tableRows = generateTableRowsTemplate4();
        break;
      case 6:
        tableRows = generateTableRowsTemplate6();
        break;
      case 7:
        tableRows = generateTableRowsExpenses();
        break;
      case 5:
        tableRows = generateTableRowsTemplate5();
        break;
      case 10:
        tableRows = generateTableRowsTemplate7();
        break;
      case 11:
        tableRows = generateTableRowsTemplate8();
        break;
      default:
    }
    return tableRows;
  }

  String generateTableRowsTemplate1() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].productId}</br>${rowData.vanSaleDetails![0].description}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '<td>${rowData.updatedUnit!.code}</td>';
        row += '<td>${rowData.price}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td >1</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >2</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >3</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >3.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >4</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >4.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >5</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >6</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate2() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].productId}</br>${rowData.vanSaleDetails![0].description}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '<td>${rowData.updatedUnit!.code}</td>';
        row += '<td>${rowData.price}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td >1</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >2</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >3</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >3.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >4</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >4.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >5</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >6</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate3() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row +=
            '<td  style="text-align:center;width:6.4%">${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="width:44.1%;text-align:left">${rowData.vanSaleDetails![0].description}</td>';
        row += '<td style = "width:6.3%">${rowData.updatedUnit!.code}</td>';
        row += '<td style ="width:10.8%">${rowData.quantity}</td>';
        row += '<td style ="width:9.9%">${rowData.price}</td>';
        row += '<td style = "width:8.1%">${rowData.amount}</td>';
        row += '<td style = "width:14.4%">0.00</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td  style='text-align:center;width:6.4%' >1</td>
                <td style = 'width:44.1%;text-align:left' > Test Description </td >
    <td style = 'width:6.3%'  >Test Unit</td>
                                  <td style = 'width:10.8%'  >1.00</td>
                                  
                                  <td style = 'width:9.9%'  >0.00</td>
    <td style = 'width:8.1%'  >0.00</td>
                                  <td style = 'width:14.4%'  >0.00</td></tr><tr><td  style='text-align:center;width:6.4%' >2</td>
                <td style = 'width:44.1%;text-align:left' > Test Description </td >
    <td style = 'width:6.3%'  >Test Unit</td>
                                  <td style = 'width:10.8%'  >2.00</td>
                                  
                                  <td style = 'width:9.9%'  >0.00</td>
    <td style = 'width:8.1%'  >0.00</td>
                                  <td style = 'width:14.4%'  >0.00</td></tr><tr><td  style='text-align:center;width:6.4%' >3</td>
                <td style = 'width:44.1%;text-align:left' > Test Description </td >
    <td style = 'width:6.3%'  >Test Unit</td>
                                  <td style = 'width:10.8%'  >3.00</td>
                                  
                                  <td style = 'width:9.9%'  >0.00</td>
    <td style = 'width:8.1%'  >0.00</td>
                                  <td style = 'width:14.4%'  >0.00</td></tr><tr><td  style='text-align:center;width:6.4%' >4</td>
                <td style = 'width:44.1%;text-align:left' > Test Description </td >
    <td style = 'width:6.3%'  >Test Unit</td>
                                  <td style = 'width:10.8%'  >4.00</td>
                                  
                                  <td style = 'width:9.9%'  >0.00</td>
    <td style = 'width:8.1%'  >0.00</td>
                                  <td style = 'width:14.4%'  >0.00</td></tr><tr><td  style='text-align:center;width:6.4%' >5</td>
                <td style = 'width:44.1%;text-align:left' > Test Description </td >
    <td style = 'width:6.3%'  >Test Unit</td>
                                  <td style = 'width:10.8%'  >5.00</td>
                                  
                                  <td style = 'width:9.9%'  >0.00</td>
    <td style = 'width:8.1%'  >0.00</td>
                                  <td style = 'width:14.4%'  >0.00</td></tr><tr><td  style='text-align:center;width:6.4%' >6</td>
                <td style = 'width:44.1%;text-align:left' > Test Description </td >
    <td style = 'width:6.3%'  >Test Unit</td>
                                  <td style = 'width:10.8%'  >6.00</td>
                                  
                                  <td style = 'width:9.9%'  >0.00</td>
    <td style = 'width:8.1%'  >0.00</td>
                                  <td style = 'width:14.4%'  >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate4() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row +=
            '<td style="text-align:center;padding-right:10px;padding-left:10px">${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].productId}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].description}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '<td>${rowData.updatedUnit!.code}</td>';
        row += '<td>${rowData.price}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows +=
          """ <tr><td  style='text-align:center;padding-right:10px;padding-left:10px'>1</td>
            <td style="text-align:left">Test Product ID</td><td style="text-align:left">Test Description</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td  style='text-align:center;padding-right:10px;padding-left:10px'>2</td>
            <td style="text-align:left">Test Product ID</td><td style="text-align:left">Test Description</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td  style='text-align:center;padding-right:10px;padding-left:10px'>3</td>
            <td style="text-align:left">Test Product ID</td><td style="text-align:left">Test Description</td>
                              <td >3.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td  style='text-align:center;padding-right:10px;padding-left:10px'>4</td>
            <td style="text-align:left">Test Product ID</td><td style="text-align:left">Test Description</td>
                              <td >4.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td  style='text-align:center;padding-right:10px;padding-left:10px'>5</td>
            <td style="text-align:left">Test Product ID</td><td style="text-align:left">Test Description</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td  style='text-align:center;padding-right:10px;padding-left:10px'>6</td>
            <td style="text-align:left">Test Product ID</td><td style="text-align:left">Test Description</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate6() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].productId}</br>${rowData.vanSaleDetails![0].description}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '<td>${rowData.updatedUnit!.code}</td>';
        row += '<td>${rowData.price}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td >1</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >2</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >3</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >3.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >4</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >4.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >5</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >6</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate5() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row +=
            '<td class="center-align">${tableData.indexOf(rowData) + 1}</td>';
        row += '<td class="center-align">${rowData.customerProductId}</td>';
        row += '<td>${rowData.vanSaleDetails![0].description}</td>';
        row +=
            '<td class="center-align">${rowData.vanSaleDetails![0].barcode}</td>';
        row +=
            '<td class="price-right">${(widget.printDetail.isReturn! ? (-1 * (rowData.quantity)) : rowData.quantity).toInt()}</td>';
        row +=
            '<td class="price-right">${(rowData.price).toStringAsFixed(2)}</td>';
        row += '<td class="price-right">5%</td>';
        row +=
            '<td class="price-right">${(widget.printDetail.isReturn! ? (-1 * (rowData.unitTax)) : rowData.unitTax).toStringAsFixed(2)}</td>';
        row +=
            '<td class="price-right">${(widget.printDetail.isReturn! ? (-1 * (rowData.amount)) : rowData.amount).toStringAsFixed(2)}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr>
                <td>1</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>
            <tr>
              <td>2</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>
            <tr>
              <td>3</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>
            <tr>
              <td>4</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            <tr>
              <td>5</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>
           <tr>
          <td>6</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>
            
            <tr>
              <td>7</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>
            <tr>
              <td>8</td>
               <td>1001</td>
                <td>CZ CHOCO STREUSEL STRAWBERRY</td>
                <td>ABC123456789</td>
                <td>12.00 NOS</td>
                <td  class="price-right">9.75</td>
                <td  class="price-right">5%</td>
                <td  class="price-right">11.70</td>
                <td class="price-right">117.00</td>
            </tr>""";
    }

    return tableRows;
  }

  String generateTableRowsExpenses() {
    final List<ExpenseTransactionDetailsAPIModel> tableData =
        widget.printDetail.expense ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        double total = (rowData.amount ?? 0.0) + (rowData.taxAmount ?? 0.0);
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.accountID}</br>${rowData.description}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '<td>${rowData.taxAmount}</td>';
        row += '<td>$total</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td >1</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >2</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >3</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >3.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >4</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >4.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >5</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >6</td>
            <td style="text-align:left">Test Product ID</br>Test Description</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate7() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].productId}</br>${rowData.vanSaleDetails![0].description}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '<td>${rowData.updatedUnit!.code}</td>';
        row += '<td>${rowData.price}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td >1</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >2</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>  <tr><td >5</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >6</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
    }

    return tableRows;
  }

  String generateTableRowsTemplate8() {
    final List<VanSaleDetailModel> tableData = widget.printDetail.items ?? [];
    String tableRows = '';
    if (tableData.isNotEmpty) {
      for (var rowData in tableData) {
        String row = '<tr>';
        row += '<td>${tableData.indexOf(rowData) + 1}</td>';
        row +=
            '<td style="text-align:left">${rowData.vanSaleDetails![0].productId}</br>${rowData.vanSaleDetails![0].description}</td>';
        row += '<td>${rowData.quantity}</td>';
        row += '<td>${rowData.updatedUnit!.code}</td>';
        row += '<td>${rowData.price}</td>';
        row += '<td>${rowData.amount}</td>';
        row += '</tr>';
        tableRows += row;
      }
    } else {
      tableRows += """<tr><td >1</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >1.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >2</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >2.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>  <tr><td >5</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >5.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr> <tr><td >6</td>
            <td style="text-align:left">Test Product ID</br>Test Description</br>Test Description 2</td>
                              <td >6.00</td>
                              <td >Test Unit</td>
                              <td >0.00</td>
                              <td >0.00</td></tr>""";
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
