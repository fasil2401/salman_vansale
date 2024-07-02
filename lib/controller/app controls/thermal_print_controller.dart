import 'dart:developer';

import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class ThermalPrintController extends GetxController {
  var connected = false.obs;
  var availableBluetoothDevices = [].obs;
  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");

    availableBluetoothDevices.value = bluetooths!;
  }

  Future<void> setConnect(String mac, PrintHelper printDetail) async {
    log(mac, name: 'MacAddress');
    log(printDetail.items!.length.toString(), name: 'Print Detail');
    try {
      //////////
      final String? result = await BluetoothThermalPrinter.connect(mac);
      log(result.toString(), name: 'result');
      if (result == "true") {

        await printTicket(printDetail);
      } else {
        SnackbarServices.errorSnackbar('Cannot Connect to printer!');
      }
    } catch (e) {
      log(e.toString(), name: 'Error log');
    }
  }

  Future<void> printTicket(PrintHelper printDetail) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(printDetail);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<void> printGraphics() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getGraphicsTicket();
      // Printing.layoutPdf(onLayout: Pdf)
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getGraphicsTicket() async {
    List<int> bytes = [];

    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Print QR Code using native function
    bytes += generator.qrcode('example.com');

    bytes += generator.hr();

    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.cut();

    return bytes;
  }

  // Future<List<int>> getTicket() async {
  //   List<int> bytes = [];
  //   CapabilityProfile profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile);

  //   bytes += generator.text("Demo Shop",
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);

  //   bytes += generator.text(
  //       "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('Tel: +919591708470',
  //       styles: PosStyles(align: PosAlign.center));

  //   bytes += generator.hr();
  //   bytes += generator.row([
  //     PosColumn(
  //         text: 'No',
  //         width: 1,
  //         styles: PosStyles(align: PosAlign.left, bold: true)),
  //     PosColumn(
  //         text: 'Item',
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.left, bold: true)),
  //     PosColumn(
  //         text: 'Price',
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.center, bold: true)),
  //     PosColumn(
  //         text: 'Qty',
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.center, bold: true)),
  //     PosColumn(
  //         text: 'Total',
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.right, bold: true)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "1", width: 1),
  //     PosColumn(
  //         text: "Tea",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "10",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "10", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "2", width: 1),
  //     PosColumn(
  //         text: "Sada Dosa",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "30",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "30", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "3", width: 1),
  //     PosColumn(
  //         text: "Masala Dosa",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "50",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "50", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "4", width: 1),
  //     PosColumn(
  //         text: "Rova Dosa",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "70",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "70", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.hr();

  //   bytes += generator.row([
  //     PosColumn(
  //         text: 'TOTAL',
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size4,
  //           width: PosTextSize.size4,
  //         )),
  //     PosColumn(
  //         text: "160",
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size4,
  //           width: PosTextSize.size4,
  //         )),
  //   ]);

  //   bytes += generator.hr(ch: '=', linesAfter: 1);

  //   // ticket.feed(2);
  //   bytes += generator.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));

  //   bytes += generator.text("26-11-2020 15:22:45",
  //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);

  //   bytes += generator.text(
  //       'Note: Goods once sold will not be taken back or exchanged.',
  //       styles: PosStyles(align: PosAlign.center, bold: false));
  //   bytes += generator.cut();
  //   return bytes;
  // }
  // Future<void> printTicket() async {
  //   String? isConnected = await BluetoothThermalPrinter.connectionStatus;
  //   if (isConnected == "true") {

  //     double tax = 2.0;
  //     List<int> bytes = await getTicket(PrintHelper(
  //         vanName: "Demo dynamic",
  //         address: "addresses",
  //         phone: "9876543210",
  //         total: "",
  //         amountInWords: "",
  //         customer: "name",
  //         discount: "",
  //         footerImage: "",
  //         headerImage: "",
  //         invoiceNo: "",
  //         mobile: "9842222",
  //         paymentMode: "Cash",
  //         salesPerson: "person",
  //         refNo: "",
  //         tax: "$tax",
  //         subTotal: "",
  //         transactionDate: DateTime.now().toIso8601String(),
  //         trn: "",
  //         items: list));
  //     final result = await BluetoothThermalPrinter.writeBytes(bytes);
  //     print("Print $result");
  //   } else {
  //     //Hadnle Not Connected Senario
  //   }
  // }

  Future<List<int>> getTicket(PrintHelper print) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );

    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text("TAX INVOICE",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text("TRN #TRN : ${print.trn}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(linesAfter: 1);
    bytes += generator.text(
      "Customer: ${print.customer}",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Address: ${print.address ?? ""}",
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          width: 6,
          text: "Date: ${print.transactionDate ?? ""}",
          styles: PosStyles(
            align: PosAlign.left,
          ))
    ]);
    bytes += generator.text(
      "Invoice#: ${print.invoiceNo}",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Phone: ${print.phone ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "SalesMan: ${print.salesPerson ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "TRN: ${print.customerTrn ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6, text: "Mobile:", styles: PosStyles(align: PosAlign.left))
    ]);

    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Payment Mode: ${print.paymentMode ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "Reference No:",
          styles: PosStyles(align: PosAlign.left))
    ]);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: '#',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Name',
          width: 4,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 1,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Unit',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Unit Price',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Amount',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    int index = 1;
    for (var rowData in print.items!) {
      bytes += generator.row([
        PosColumn(text: "${index}", width: 1),
        PosColumn(
            text:
                "${rowData.vanSaleDetails![0].productId} ${rowData.vanSaleDetails![0].description}",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: "${rowData.quantity}",
            width: 1,
            styles: PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(
            text: "${rowData.updatedUnit!.code}",
            width: 2,
            styles: PosStyles(align: PosAlign.center)),
        PosColumn(
            text: "${rowData.price}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.amount}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      index++;
    }

    bytes += generator.hr();

    bytes += generator.text("Total quantity:  21",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: ' Amount in words:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Sub Total:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: print.subTotal ?? "",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Discount:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: print.discount ?? "",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'VAT(0%):',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: print.tax ?? "",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row(
      [
        PosColumn(
            text: 'Total:',
            width: 6,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: print.total ?? "",
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
            text: "Receiver's Sign",
            width: 6,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: "Salesman's Sign",
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
      ],
    );

    // ticket.feed(2);
    // bytes += generator.text('Thank you!',
    //     styles: PosStyles(align: PosAlign.center, bold: true));

    // bytes += generator.text("26-11-2020 15:22:45",
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    // bytes += generator.text(
    //     'Note: Goods once sold will not be taken back or exchanged.',
    //     styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }
}
