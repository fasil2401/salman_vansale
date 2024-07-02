import 'dart:developer';

import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/Print%20Helper/sales_report_print_helper.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/components/common_button_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class ThermalPrintHeplper {
  static List availableBluetoothDevices = [];
  static bool connected = false;
  static String connectedDevice = '';
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static closeConnection() {
    connected = false;
    connectedDevice = '';
  }

  static getConnection(
      BuildContext context, var print, PrintLayouts layout) async {
    if (!connected && connectedDevice.isEmpty) {
      await getBluetooth();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Available Devices'),
              content: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView.builder(
                  itemCount: availableBluetoothDevices.length > 0
                      ? availableBluetoothDevices.length
                      : 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        String select = availableBluetoothDevices[index];
                        List list = select.split("#");
                        // String name = list[0];
                        String mac = list[1];
                        await setConnect(mac);
                        if (connected) {
                          printTicket(print, layout);
                          Navigator.pop(context);
                        } else {
                          SnackbarServices.errorSnackbar(
                              'Cannot connect to printer');
                          connected = false;
                          connectedDevice = '';
                        }
                      },
                      title: Text('${availableBluetoothDevices[index]}'),
                      subtitle: Text("Click to connect"),
                    );
                  },
                ),
              ),
            );
          });
    } else {
      printTicket(print, layout);
    }
  }

  static Future<bool> reprintDialog() async {
    return await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Do you Want to print more?'),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CommonButtonWidget(
                    onPressed: () {
                      // status = false;
                      Navigator.of(context).pop(false);
                    },
                    backgroundColor: Theme.of(context).backgroundColor,
                    textColor: Theme.of(context).primaryColor,
                    title: 'Cancel',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CommonButtonWidget(
                    onPressed: () {
                      // status = true;
                      Navigator.of(context).pop(true);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: AppColors.white,
                    title: 'Print',
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> initPlatformState() async {
    // TODO here add a permission request using permission_handler
    // if permission is not granted, kzaki's thermal print plugin will ask for location permission
    // which will invariably crash the app even if user agrees so we'd better ask it upfront

    // var statusLocation = Permission.location;
    // if (await statusLocation.isGranted != true) {
    //   await Permission.location.request();
    // }
    // if (await statusLocation.isGranted) {
    // ...
    // } else {
    // showDialogSayingThatThisPermissionIsRequired());
    // }
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          // setState(() {
          // _connected = true;
          print("bluetooth device state: connected");
          // });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: disconnected");
          closeConnection();

          // });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: disconnect requested");
          closeConnection();
          // });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: bluetooth turning off");
          closeConnection();
          // });
          break;
        case BlueThermalPrinter.STATE_OFF:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: bluetooth off");
          closeConnection();
          // });
          break;
        case BlueThermalPrinter.STATE_ON:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: bluetooth on");
          // });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: bluetooth turning on");
          // });
          break;
        case BlueThermalPrinter.ERROR:
          // setState(() {
          // _connected = false;
          print("bluetooth device state: error");
          closeConnection();
          // });
          break;
        default:
          print(state);
          break;
      }
    });

    // if (!mounted) return;
    // setState(() {
    //   // _devices = devices;
    // });

    // if (isConnected == true) {
    //   setState(() {
    //     // _connected = true;
    //   });
    // }
  }

  static Future<void> getBluetooth() async {
    await ThermalPrintHeplper().initPlatformState;
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    // setState(() {
    availableBluetoothDevices = bluetooths!;
    // });
  }

  static Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    print("state conneected $result");

    if (result == "true") {
      // salesInvoiceController.isConnected.value = true;
      await Future.delayed(const Duration(milliseconds: 1));
      // setState(() {
      connected = true;
      connectedDevice = mac;
      // });
    } else {
      closeConnection();
      SnackbarServices.errorSnackbar('Could not Connect to printer!');
    }
  }

  static Future<void> printTicket(var printDetail, PrintLayouts layout) async {
    // List<int> bytes = await getTicket(printDetail);
    print(printDetail);
    int printSize = UserSimplePreferences.getPrintPaperSize() ?? 1;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = [];
      switch (layout) {
        case PrintLayouts.SalesInvoice:
          bytes = await getTicket(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.SalesReturn:
          bytes = await getTicket(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.StockReport:
          bytes = await getStockReport(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.SalesReport:
          bytes = await getSalesReport(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.DailySales:
          bytes =
              await getDailySalesReport(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.PaymentsReport:
          bytes = await getPaymentsReport(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.CashOrChequeReciept:
          bytes = await getCashReceiptVoucherReport(printDetail, layout,
              size: printSize);
          break;
        case PrintLayouts.ExpenseReport:
          bytes = await getExpenseReport(printDetail, layout, size: printSize);
          break;
        case PrintLayouts.ExpenseTransaction:
          bytes = await getExpenseTransactionReport(printDetail, layout,
              size: printSize);
          break;
        case PrintLayouts.SalesOrder:
          bytes = await getTicketForSalesOrder(printDetail, layout,
              size: printSize);
          break;
        default:
      }
      int printCount = UserSimplePreferences.getPrintCount() ?? 1;
      if (layout == PrintLayouts.SalesReturn ||
          layout == PrintLayouts.SalesInvoice) {
        if (printDetail.isMultiPrint) {
          final result = await BluetoothThermalPrinter.writeBytes(bytes);
          await Future.delayed(const Duration(milliseconds: 100));
          for (int i = 1; i < printCount; i++) {
            bool result = await reprintDialog();
            if (result) {
              final result = await BluetoothThermalPrinter.writeBytes(bytes);
              await Future.delayed(const Duration(milliseconds: 100));
            } else {
              break;
            }
          }

          // print("Print $result");
        } else {
          final result = await BluetoothThermalPrinter.writeBytes(bytes);
        }
      } else {
        final result = await BluetoothThermalPrinter.writeBytes(bytes);
        // print("Print $result");
      }

      // salesInvoiceController.isSaveSuccess.value = false;
    } else {
      //Hadnle Not Connected Senario
      closeConnection();
      SnackbarServices.errorSnackbar('Could not connect to printer !');
    }
  }

  static Future<List<int>> getTicket(PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(
        size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile,
        spaceBetweenRows: 10);

    // Uint8List headerBytes = base64Decode(print.headerImage ?? '');
    // Uint8List footerBytes = base64Decode(print.footerImage ?? '');

    // final imagePlug.Image header = imagePlug.decodeImage(headerBytes)!;
    // final imagePlug.Image footer = imagePlug.decodeImage(footerBytes)!;
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(
        print.isReturn != null && print.isReturn == true
            ? "TAX CREDIT NOTE"
            : "TAX INVOICE",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text("TRN : ${print.trn ?? 'TRN : '}",
        styles: PosStyles(align: PosAlign.center));
    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes += generator.text(
      "Customer: ${print.customer}",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    bytes += generator.row([
      PosColumn(
          width: 7,
          text: "Address: ${print.address ?? ""}",
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          width: 5,
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
          width: 7,
          text: "Phone: ${print.phone ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 5,
          text: "SalesMan: ${print.salesPerson ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += generator.row([
      PosColumn(
          width: 7,
          text: "TRN : ${print.customerTrn ?? " TRN : "}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 5, text: "Mobile:", styles: PosStyles(align: PosAlign.left))
    ]);

    bytes += generator.row([
      PosColumn(
          width: 7,
          text: "Payment Mode: ${print.paymentMode ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 5,
          text: "Reference No: ${print.refNo ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);

    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
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
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Unit',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Price',
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
        PosColumn(text: "$index", width: 1),
        PosColumn(
            text: rowData.vanSaleDetails![0].productId!,
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: "${rowData.quantity}",
            width: 1,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: "${rowData.updatedUnit!.code}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.price.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.amount.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);

      final textChunks = splitText(rowData.vanSaleDetails![0].description!, 25);
      for (var element in textChunks) {
        bytes += generator.row([
          PosColumn(
              text: element, width: 8, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 4, styles: PosStyles(align: PosAlign.left))
        ]);
      }

      index++;
    }

    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes +=
        generator.text("Total quantity:  ${getTotalQuantity(print.items!)}",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));

    bytes += (size == 1
        ? generator.hr(ch: '=', linesAfter: 1)
        : generator.hr(ch: '=', linesAfter: 1, len: 69));
    bytes += generator.row([
      PosColumn(
          text: 'Amount in words: ${print.amountInWords}',
          // width: 12,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      // PosColumn(
      //     text: print.amountInWords ?? '',
      //     width: 6,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     )),
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
          text: 'VAT(5%):',
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
              bold: true,
              align: PosAlign.left,
              // height: PosTextSize.size1,
              // width: PosTextSize.size1,
            )),
        PosColumn(
            text: print.total ?? "",
            width: 6,
            styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              // height: PosTextSize.size1,
              // width: PosTextSize.size1,
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
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getTicketForSalesOrder(
      PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);

    // Uint8List headerBytes = base64Decode(print.headerImage ?? '');
    // Uint8List footerBytes = base64Decode(print.footerImage ?? '');

    // final imagePlug.Image header = imagePlug.decodeImage(headerBytes)!;
    // final imagePlug.Image footer = imagePlug.decodeImage(footerBytes)!;
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("SALES REPORT",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text("TRN : ${print.trn ?? 'TRN : '}",
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
          text: "TRN : ${print.customerTrn ?? " TRN : "}",
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
          text: "Reference No: ${print.refNo ?? ""}",
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
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Unit',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Price',
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
        PosColumn(text: "$index", width: 1),
        PosColumn(
            text: rowData.vanSaleDetails![0].productId!,
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: "${rowData.quantity}",
            width: 1,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: "${rowData.updatedUnit!.code}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.price.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.amount.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);

      final textChunks = splitText(rowData.vanSaleDetails![0].description!, 25);
      for (var element in textChunks) {
        bytes += generator.row([
          PosColumn(
              text: element, width: 8, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 4, styles: PosStyles(align: PosAlign.left))
        ]);
      }

      index++;
    }

    bytes += generator.hr();

    bytes +=
        generator.text("Total quantity:  ${getTotalQuantity(print.items!)}",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Amount in words: ${print.amountInWords}',
          // width: 12,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      // PosColumn(
      //     text: print.amountInWords ?? '',
      //     width: 6,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     )),
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
          text: 'VAT(5%):',
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
              bold: true,
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: print.total ?? "",
            width: 6,
            styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
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
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getStockReport(
      PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);

    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("STOCK REPORT",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes += generator.row([
      PosColumn(
          text: 'OpeningStock',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'SalesInvoice',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Returns',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Damages',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'OnHand',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    int index = 1;
    for (var rowData in print.products!) {
      final textChunks = splitText(
          "$index" +
              ' ' +
              (rowData.productID ?? '') +
              '  ' +
              rowData.description!,
          50);
      for (var element in textChunks) {
        bytes += generator.row([
          PosColumn(
              text: element, width: 12, styles: PosStyles(align: PosAlign.left))
        ]);
      }

      bytes += generator.row([
        PosColumn(
            text: "${rowData.openingStock!.toStringAsFixed(2)}",
            width: 3,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: "${rowData.saleQuantity!.toStringAsFixed(2)}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.returnQuantity!.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "0", width: 1, styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.quantity!.toStringAsFixed(2)}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);

      index++;
    }

    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));

    bytes +=
        generator.text("Total quantity:  ${getTotalOnhand(print.products!)}",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));

    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getDailySalesReport(
      PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);

    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("DAILY REPORT",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes += generator.row([
      PosColumn(
          text: '#',
          width: 1,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Type',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Count',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Amount',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += commonBytesInDaily(
        generator,
        1,
        "Cash Sales",
        "${print.cashSales?.count ?? 0}",
        "${(print.cashSales?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        2,
        "Cash Sales Return",
        "${print.cashSalesReturn?.count ?? 0}",
        "${(print.cashSalesReturn?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        3,
        "Cash Receipts",
        "${print.cashReciepts?.count ?? 0}",
        "${(print.cashReciepts?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        4,
        "Cash Expenses",
        "${print.cashExpenses?.count ?? 0}",
        "${(print.cashExpenses?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        4,
        "Total Cash",
        "${print.totalCash?.count ?? 0}",
        "${(print.totalCash?.amount ?? 0.0).toStringAsFixed(2)}",
        true);
    bytes += commonBytesInDaily(
        generator,
        5,
        "Credit Card Sales",
        "${print.creditCardSales?.count ?? 0}",
        "${(print.creditCardSales?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        6,
        "Credit Sales",
        "${print.creditSales?.count ?? 0}",
        "${(print.creditSales?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        7,
        "Credit Sale Returns",
        "${print.creditSalesReturn?.count ?? 0}",
        "${(print.creditSalesReturn?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        8,
        "Cheques Collected",
        "${print.cheques?.count ?? 0}",
        "${(print.cheques?.amount ?? 0.0).toStringAsFixed(2)}",
        false);
    bytes += commonBytesInDaily(
        generator,
        9,
        "Total",
        "${print.totalCredit?.count ?? 0}",
        "${(print.totalCredit?.amount ?? 0.0).toStringAsFixed(2)}",
        true);

    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));

    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static commonBytesInDaily(Generator generator, int slNo, String txt,
      String count, String amount, bool isHead) {
    return generator.row([
      PosColumn(
          text: "$slNo",
          width: 1,
          styles: PosStyles(
            align: PosAlign.right,
          )),
      PosColumn(
          text: txt,
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: isHead)),
      PosColumn(
          text: count,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: isHead)),
      PosColumn(
          text: amount,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: isHead)),
    ]);
  }

  static Future<List<int>> getSalesReport(
      SalesReportPrintHelper print, PrintLayouts layout,
      {required int size}) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);

    // Uint8List headerBytes = base64Decode(print.headerImage ?? '');
    // Uint8List footerBytes = base64Decode(print.footerImage ?? '');

    // final imagePlug.Image header = imagePlug.decodeImage(headerBytes)!;
    // final imagePlug.Image footer = imagePlug.decodeImage(footerBytes)!;
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Print Date: ${print.printDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      "From Date: ${print.fromDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      "To Date: ${print.toDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("Sales Report",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes += generator.row([
      // PosColumn(
      //     text: '#',
      //     width: 1,
      //     styles: PosStyles(align: PosAlign.left, bold: true)),
      // PosColumn(
      //     text: 'Customer',
      //     width: 3,
      //     styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Voucher No.',
          width: 3,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Tax',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Disc.',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'NetAmt',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    int index = 1;
    for (var rowData in print.items!) {
      final textChunks =
          splitText("$index" + ' ' + (rowData.customerCode ?? ''), 50);
      for (var element in textChunks) {
        bytes += generator.row([
          PosColumn(
              text: element, width: 12, styles: PosStyles(align: PosAlign.left))
        ]);
      }
      bytes += generator.row([
        // PosColumn(text: "$index", width: 1),
        // PosColumn(
        //     text: rowData.customerCode!,
        //     width: 3,
        //     styles: PosStyles(
        //       align: PosAlign.left,
        //     )),
        PosColumn(
            text: "${rowData.voucherNo}",
            width: 3,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: "${rowData.total!.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.tax!.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.discount!.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.netAmount!.toStringAsFixed(2)}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      index++;
    }
    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes += generator.text("Total:  ${getTotalSalesAmount(print.items!)}",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getPaymentsReport(
      SalesReportPrintHelper print, PrintLayouts layout,
      {required int size}) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Print Date: ${print.printDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      "From Date: ${print.fromDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      "To Date: ${print.toDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("Sales Report",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Voucher No.',
          width: 3,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Total',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Payment',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Date',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    int index = 1;
    for (var rowData in print.items!) {
      final textChunks =
          splitText("$index" + ' ' + (rowData.customerCode ?? ''), 50);
      for (var element in textChunks) {
        bytes += generator.row([
          PosColumn(
              text: element, width: 12, styles: PosStyles(align: PosAlign.left))
        ]);
      }
      bytes += generator.row([
        PosColumn(
            text: "${rowData.voucherNo}",
            width: 3,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: "${rowData.total!.toStringAsFixed(2)}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.paymentMode}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.date}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      index++;
    }
    bytes += generator.hr();
    bytes += generator.text("Total:  ${getTotalSalesAmount(print.items!)}",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getCashReceiptVoucherReport(
      PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(
        "${(print.isCheque ?? true) ? 'Cheque' : 'Cash'}Reciept Voucher",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("${print.trn}",
        styles: PosStyles(align: PosAlign.center));
    bytes += (size == 1
        ? generator.hr(linesAfter: 1)
        : generator.hr(len: 69, linesAfter: 1));
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Reciept No.: ${print.recieptNo ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "Reciept Date: ${print.salesPerson ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += generator.row([
      if (print.isCheque ?? true)
        PosColumn(
            width: 6,
            text: "Cheque No. : ${print.chequeNumber ?? ""}",
            styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: print.isCheque ?? true ? 6 : 12,
          text: "Remarks: ${print.remarks ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += (size == 1
        ? generator.hr(linesAfter: 1)
        : generator.hr(len: 69, linesAfter: 1));
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Received from: ${print.receivedFrom ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "Reciept Date: ${print.amount ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += (size == 1
        ? generator.hr(linesAfter: 1)
        : generator.hr(len: 69, linesAfter: 1));
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "${print.amountInWords}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "${print.amount ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getExpenseTransactionReport(
      PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Date: ${print.transactionDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("EXPENSE INVOICE",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("${print.trn}",
        styles: PosStyles(align: PosAlign.center));
    bytes += (size == 1
        ? generator.hr(linesAfter: 1)
        : generator.hr(len: 69, linesAfter: 1));
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Invoice: ${print.invoiceNo ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "Date: ${print.transactionDate ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += generator.row([
      PosColumn(
          width: 6,
          text: "Mobile : ${print.mobile ?? ""}",
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 6,
          text: "SalesMan: ${print.salesPerson ?? ""}",
          styles: PosStyles(align: PosAlign.left))
    ]);
    bytes += (size == 1
        ? generator.hr(linesAfter: 1)
        : generator.hr(len: 69, linesAfter: 1));
    bytes += generator.row([
      PosColumn(
          text: '#',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Name',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Amount',
          width: 2,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Tax Amount',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Net Amount',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    int index = 1;
    for (var rowData in print.expense!) {
      double total = (rowData.amount ?? 0.0) + (rowData.taxAmount ?? 0.0);
      bytes += generator.row([
        PosColumn(text: "$index", width: 1),
        PosColumn(
            text: rowData.accountID!,
            width: 5,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: rowData.amount!.toStringAsFixed(2),
            width: 2,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: rowData.taxAmount!.toStringAsFixed(2),
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: total.toStringAsFixed(2),
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
      index++;
    }
    bytes += (size == 1
        ? generator.hr(ch: '=', linesAfter: 1)
        : generator.hr(ch: '=', linesAfter: 1, len: 69));
    bytes += generator.row([
      PosColumn(
          text: 'Amount in words: ${print.amountInWords}',
          // width: 12,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      // PosColumn(
      //     text: print.amountInWords ?? '',
      //     width: 6,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     )),
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
          text: 'VAT(5%):',
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
              bold: true,
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: print.total ?? "",
            width: 6,
            styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
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
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> getExpenseReport(
      PrintHelper print, PrintLayouts layout,
      {required int size}) async {
    log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator =
        Generator(size == 1 ? PaperSize.mm80 : PaperSize.mm100, profile);

    // Uint8List headerBytes = base64Decode(print.headerImage ?? '');
    // Uint8List footerBytes = base64Decode(print.footerImage ?? '');

    // final imagePlug.Image header = imagePlug.decodeImage(headerBytes)!;
    // final imagePlug.Image footer = imagePlug.decodeImage(footerBytes)!;
    bytes += generator.text(getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(getCompanyDetails(CharacterLimit.address80),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true));
    bytes += generator.text(
      "Print Date: ${print.printDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      "From Date: ${print.fromDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      "To Date: ${print.toDate}",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.text("Sales Person: ${print.salesPerson ?? ""}",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Van Name: ${print.vanName}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("Sales Report",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));
    bytes += generator.row([
      // PosColumn(
      //     text: '#',
      //     width: 1,
      //     styles: PosStyles(align: PosAlign.left, bold: true)),
      // PosColumn(
      //     text: 'Customer',
      //     width: 3,
      //     styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Voucher No.',
          width: 6,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Amount',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Tax',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    int index = 1;
    for (var rowData in print.expenseHeader!) {
      double subtotal = (rowData.amount ?? 0.0) - (rowData.taxAmount ?? 0.0);
      bytes += generator.row([
        // PosColumn(text: "$index", width: 1),
        // PosColumn(
        //     text: rowData.customerCode!,
        //     width: 3,
        //     styles: PosStyles(
        //       align: PosAlign.left,
        //     )),
        PosColumn(
            text: "${rowData.voucherID}",
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
        PosColumn(
            text: "${subtotal.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.taxAmount!.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.amount!.toStringAsFixed(2)}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);

      index++;
    }
    bytes += (size == 1 ? generator.hr() : generator.hr(len: 69));

    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  static String getTotalQuantity(List<VanSaleDetailModel> items) {
    double quantity = 0.0;
    for (var element in items) {
      quantity += element.quantity;
    }
    return quantity.toStringAsFixed(2);
  }

  static String getTotalOnhand(List<ProductModel> items) {
    double quantity = 0.0;
    for (var element in items) {
      quantity += element.quantity ?? 0.0;
    }
    return quantity.toStringAsFixed(2);
  }

  static String getTotalSalesAmount(List<SalesReportDetailModel> items) {
    double amount = 0.0;
    for (var element in items) {
      amount += element.netAmount ?? 0.0;
    }
    return amount.toStringAsFixed(2);
  }

  static List<String> splitText(String text, int maxWidth) {
    final List<String> lines = [];
    final List<String> words = text.split(' ');
    String currentLine = '';

    for (final word in words) {
      if ((currentLine.length + word.length) <= maxWidth) {
        currentLine += '$word ';
      } else {
        lines.add(currentLine.trim());
        currentLine = '$word ';
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine.trim());
    }

    return lines;
  }

  static String getCompanyDetails(CharacterLimit type) {
    String companyName = UserSimplePreferences.getCompanyName() ?? '';
    String companyAddress = UserSimplePreferences.getCompanyAddress() ?? '';
    int printSize = UserSimplePreferences.getPrintPaperSize() ?? 1;
    String result = '';
    if (type == CharacterLimit.address80) {
      result = splitSentenceByCharacterLimit(
          companyAddress,
          printSize == 1
              ? CharacterLimit.address80.value
              : CharacterLimit.address100.value);
    } else if (type == CharacterLimit.name80) {
      result = splitSentenceByCharacterLimit(
          companyName,
          printSize == 1
              ? CharacterLimit.name80.value
              : CharacterLimit.name100.value);
    } else {
      result = '';
    }
    return result;
  }

  static String splitSentenceByCharacterLimit(
      String sentence, int characterLimit) {
    List<String> lines = [];
    List<String> words = sentence.split(' ');

    String currentLine = '';

    for (int i = 0; i < words.length; i++) {
      String word = words[i];

      if (currentLine.isEmpty ||
          currentLine.length + word.length <= characterLimit) {
        // Add the word to the current line
        currentLine += (currentLine.isEmpty ? '' : ' ') + word;
      } else {
        // Start a new line with the current word
        lines.add(currentLine);
        currentLine = word;
      }

      // Add a newline character if the word doesn't fit in the remaining characters
      if (i < words.length - 1 &&
          currentLine.length + words[i + 1].length > characterLimit) {
        lines.add(currentLine);
        currentLine = '';
      }
    }

    // Add the last line
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    // Join the lines using '\n'
    return lines.join('\n');
  }
}
