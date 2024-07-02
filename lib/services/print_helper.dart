import 'dart:developer';
import 'dart:io';

import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/model/Local%20Db%20Model/Expense%20Transaction%20Model/expense_transaction_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

class PrintHelper {
  String? transactionDate;
  String? printDate;
  String? fromDate;
  String? toDate;
  String? salesPerson;
  String? vanName;
  String? customer;
  String? address;
  String? invoiceNo;
  String? phone;
  String? paymentMode;
  String? trn;
  String? customerTrn;
  String? mobile;
  String? refNo;
  String? amountInWords;
  String? subTotal;
  String? discount;
  String? tax;
  String? total;
  String? headerImage;
  String? footerImage;
  String? companyName;
  String? recieptNo;
  String? recieptDate;
  String? remarks;
  String? receivedFrom;
  String? amount;
  String? chequeNumber;
  bool? isCheque;
  String? parentCustomer;
  DailyReportModel? cashSales;
  DailyReportModel? cashSalesReturn;
  DailyReportModel? creditSales;
  DailyReportModel? creditSalesReturn;
  DailyReportModel? cashReciepts;
  DailyReportModel? cashExpenses;
  DailyReportModel? creditCardSales;
  DailyReportModel? cheques;
  DailyReportModel? totalCash;
  DailyReportModel? totalCredit;
  bool? isReturn;
  List<ExpenseTransactionApiModel>? expenseHeader;
  List<VanSaleDetailModel>? items;
  List<ProductModel>? products;
  bool isMultiPrint;
  List<ExpenseTransactionDetailsAPIModel>? expense;

  PrintHelper(
      {this.transactionDate,
      this.salesPerson,
      this.vanName,
      this.customer,
      this.address,
      this.invoiceNo,
      this.phone,
      this.paymentMode,
      this.trn,
      this.customerTrn,
      this.mobile,
      this.refNo,
      this.amountInWords,
      this.subTotal,
      this.discount,
      this.tax,
      this.total,
      this.headerImage,
      this.footerImage,
      this.companyName,
      this.cashSales,
      this.cashSalesReturn,
      this.creditSales,
      this.creditSalesReturn,
      this.cashExpenses,
      this.cashReciepts,
      this.cheques,
      this.creditCardSales,
      this.totalCash,
      this.totalCredit,
      this.isReturn,
      this.items,
      this.products,
      this.amount,
      this.receivedFrom,
      this.recieptDate,
      this.recieptNo,
      this.remarks,
      this.chequeNumber,
      this.isCheque,
      this.isMultiPrint = false,
      this.expense,
      this.printDate,
      this.fromDate,
      this.toDate,
      this.expenseHeader,
      this.parentCustomer});

  static Future<void> generateAndPrintPDF(String htmlContent) async {
    await Printing.layoutPdf(
        format: PdfPageFormat.standard,
        onLayout: (PdfPageFormat format) async {
          var pdf = await Printing.convertHtml(
            format: format,
            html: htmlContent,
          );
          // Printing.sharePdf(bytes: pdf);

          return pdf;
        });
    // final pdf = await Printing.convertHtml(
    //   format: PdfPageFormat.a4,
    //   html: htmlContent,
    // );

    // if (pdf != null) {
    //   // Print the PDF using the device's printing capabilities
    //   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf);
    // } else {
    //   print("Error generating PDF");
    // }
  }

  static sharePdf(PdfPageFormat format, String htmlContent) async {
    final pdf = await Printing.convertHtml(
      format: format,
      html: htmlContent,
    );
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/Preview.pdf';
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdf);

    // Share the saved PDF file
    await Share.shareXFiles([XFile(pdfFile.path)]);
  }

  static Future<void> generateAndSharePDF(String htmlContent) async {
    // sharePdf(PdfPageFormat.standard, htmlContent);
    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
    //   final pdf = await Printing.convertHtml(
    //     format: format,
    //     html: htmlContent,
    //   );
    //   final directory = await getApplicationDocumentsDirectory();
    //   final filePath = '${directory.path}/Preview.pdf';
    //   final pdfFile = File(filePath);
    //   await pdfFile.writeAsBytes(pdf);

    //   // Share the saved PDF file
    //   await Share.shareXFiles([XFile(pdfFile.path)]);
    //   return pdf;
    // });

    // await Printing.sharePdf(
    //   bytes: await Printing.convertHtml(
    //     format: PdfPageFormat.a4,
    //     html: htmlContent,
    //   ),
    //   filename: 'Preview.pdf',
    // );
    // String base64String = base64Encode(utf8.encode(htmlContent));
    // Uint8List pdf = base64Decode(base64String);
    Printing.directPrintPdf(
        printer: Printer(url: ''),
        onLayout: (PdfPageFormat format) async {
          var pdf = await Printing.convertHtml(
            format: format,
            html: htmlContent,
          );
          Printing.sharePdf(bytes: pdf);

          return Uint8List(0);
        });
    // log('Ready', name: 'PDF Accessing');
    // await Permission.storage.request();
    // PrintingInfo info = await Printing.info();
    // log(info.canConvertHtml.toString(), name: 'is Conversion possible');
    // final pdf = await Printing.convertHtml(
    //   format: PdfPageFormat.standard,
    //   // baseUrl: '',
    //   html: htmlContent,
    // );
    // log(pdf.toString(), name: 'PDF Accessing');

    // if (pdf != null) {
    //   // Save the PDF to a file
    //   final directory = await getApplicationDocumentsDirectory();
    //   final filePath = '${directory.path}/Preview.pdf';
    //   final pdfFile = File(filePath);
    //   await pdfFile.writeAsBytes(pdf);

    //   // Share the saved PDF file
    //   await Share.shareXFiles([XFile(pdfFile.path)]);
    // } else {
    //   print("Error generating PDF");
    // }
  }

  static String convertAmountToWords(double amount) {
    final List<String> units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine'
    ];

    final List<String> teens = [
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    final List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    final List<String> thousands = ['', 'Thousand', 'Million', 'Billion'];

    if (amount == 0) {
      return 'Zero Only';
    }

    String result = '';
    int num = amount.toInt();

    // Handle the whole number part
    int thousandsIndex = 0;
    while (num > 0) {
      int chunk = num % 1000;
      if (chunk != 0) {
        String chunkResult = _convertChunkToWords(chunk, units, teens, tens);
        if (thousandsIndex > 0 && chunkResult.isNotEmpty) {
          chunkResult += ' ${thousands[thousandsIndex]}';
        }
        result = result.isEmpty ? chunkResult : '$chunkResult, $result';
      }
      num ~/= 1000;
      thousandsIndex++;
    }

    // Handle the fractional part for fils
    int fraction = ((amount - amount.toInt()) * 100).round();
    if (fraction > 0) {
      String fractionWords = _convertChunkToWords(fraction, units, teens, tens);
      result = result + ' and ' + fractionWords + ' Fils';
    }

    return '$result Only';
  }

  static String _convertChunkToWords(
      int chunk, List<String> units, List<String> teens, List<String> tens) {
    String chunkResult = '';

    int hundreds = chunk ~/ 100;
    if (hundreds > 0) {
      chunkResult += '${units[hundreds]} Hundred';
      if (chunk % 100 != 0) {
        chunkResult += ' ';
      }
    }

    int tensAndUnits = chunk % 100;
    if (tensAndUnits >= 10 && tensAndUnits <= 19) {
      chunkResult += '${teens[tensAndUnits - 10]}';
    } else {
      int tensDigit = tensAndUnits ~/ 10;
      int unitsDigit = tensAndUnits % 10;
      if (tensDigit > 0) {
        chunkResult += '${tens[tensDigit]}';
      }
      if (unitsDigit > 0) {
        if (tensDigit > 0) {
          chunkResult += ' ';
        }
        chunkResult += '${units[unitsDigit]}';
      }
    }

    return chunkResult;
  }
}
