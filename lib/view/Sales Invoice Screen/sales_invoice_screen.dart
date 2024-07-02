import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_controller.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/extensions.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/add_update_popup.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/payment_type_popup.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/sales_invoice_items.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:axoproject/view/components/discount_form.dart';
import 'package:axoproject/view/components/dragging_button.dart';
import 'package:axoproject/view/components/summary_card.dart';
import 'package:axoproject/view/components/sysdoc_row.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imagePlug;

class SalesInvoiceScreen extends StatefulWidget {
  SalesInvoiceScreen({super.key});

  @override
  State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> {
  final salesInvoiceController = Get.put(SalesInvoiceController());
  final productListController = Get.put(ProductListController());

  final homeController = Get.put(HomeController());
  TextEditingController _discountAmountController = TextEditingController();
  TextEditingController _discountPercentageController = TextEditingController();
  FocusNode _discountAmountFocusNode = FocusNode();
  FocusNode _discountPercentageFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await salesInvoiceController.clearGrid();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sales Invoice'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<SalesInvoiceController>(
                    builder: (_) {
                      return SysDocRow(
                          onTap: () async {
                            // await _.selectSysDoc(context);
                          },
                          sysDocIdController: _.sysDocIdController.value,
                          sysDocSuffixLoading: _.sysDocSuffixLoading.value,
                          voucherIdController: _.voucherIdController.value,
                          voucherSuffixLoading: _.voucherSuffixLoading.value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, right: 10, left: 10, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Obx(() => Text(salesInvoiceController
                                  .customer.value.customerName ??
                              "")),
                        ),
                      ],
                    ),
                  ),
                  CommonWidgets.textField(
                    context,
                    suffixicon: false,
                    label: 'Reference No',
                    maxLenth: 19,
                    readonly: false,
                    controller:
                        salesInvoiceController.referenceNoController.value,
                    keyboardtype: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // tableHeader(context),
                  Obx(() => Text(
                      'Items ${salesInvoiceController.selectedItems.length}')),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Expanded(
                    child: GetBuilder<SalesInvoiceController>(
                      builder: (_) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _.selectedItems.length,
                          itemBuilder: (context, index) {
                            var item = _.selectedItems[index];
                            return Slidable(
                              key: const Key('sales_invoice_list'),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                      backgroundColor: Colors.green[100]!,
                                      foregroundColor: Colors.green,
                                      icon: Icons.mode_edit_outlined,
                                      onPressed: (_) async {
                                        salesInvoiceController
                                            .quantityControl
                                            .value
                                            .text = item.quantity.toString();
                                        salesInvoiceController.quantity.value =
                                            item.quantity;
                                        salesInvoiceController.priceControl
                                            .value.text = item.price.toString();
                                        ProductModel product =
                                            await productListController
                                                .getProductById(
                                                    quantity:
                                                        item.initialQuantity,
                                                    productId: item
                                                        .vanSaleDetails![0]
                                                        .productId!);
                                        salesInvoiceController
                                            .stockControl
                                            .value
                                            .text = product.quantity.toString();
                                        List<UnitModel> unitList =
                                            salesInvoiceController
                                                .getProductUnits(
                                                    isUpdate: true,
                                                    productId: item
                                                        .vanSaleDetails![0]
                                                        .productId!,
                                                    unitId: item
                                                            .vanSaleDetails![0]
                                                            .unitId ??
                                                        '',
                                                    currentUnitList:
                                                        item.unitList);
                                        if (item.isTrackLot == 1 &&
                                            salesInvoiceController
                                                    .returnToggle.value ==
                                                false) {
                                          salesInvoiceController
                                              .getAvailableProductLots(
                                                  item.vanSaleDetails![0]
                                                          .productId ??
                                                      '',
                                                  lots: item
                                                      .vanSaleProductLotDetails,isUpdate: true);
                                        }
                                        salesInvoiceController
                                                .quantityCombo.value =
                                            ProductQuantityCombo(
                                                initialQuantity: item.quantity,
                                                finalQuantity: 0.0);
                                        salesInvoiceController.toggleDamaged(
                                            item.isDamaged == 1 ? true : false);
                                        // int productIndex =
                                        //     await salesInvoiceController
                                        //         .getProductById(item
                                        //                 .vanSaleDetails![0]
                                        //                 .productId ??
                                        //             '');
                                        // salesInvoiceController
                                        //     .productFilterList[productIndex]
                                        //     .quantity = ((salesInvoiceController
                                        //             .productFilterList[
                                        //                 productIndex]
                                        //             .quantity ??
                                        //         0.0) +
                                        //     item.quantity);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                              content: SalesInvoiceAddOrUpdate(
                                                index: index,
                                                isUpdate: true,
                                                product: item,
                                                unitList: unitList,
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.red[100]!,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (_) {
                                      salesInvoiceController
                                          .removeSelectedItem(index);
                                    },
                                  ),
                                ],
                              ),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.vanSaleDetails![0].productId ?? ''} - ${item.vanSaleDetails![0].description ?? ''}'
                                                .trim(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.mutedColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Quantity : ${salesInvoiceController.returnToggle.value ? (-1 * item.quantity) : item.quantity} ${item.updatedUnit?.code ?? ''} x ${item.price.toStringAsFixed(2)} = ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.mutedColor),
                                              ),
                                              Text(
                                                ' ${(salesInvoiceController.returnToggle.value ? -1 * (item.quantity * item.price) : (item.quantity * item.price)).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.mutedColor),
                                              ),
                                              //  Text(
                                              //   'Quantity : ${item.quantity} ${item.updatedUnit?.code ?? ''} x ${item.price.toStringAsFixed(2)} = ${(item.quantity * item.price).toStringAsFixed(2)}',
                                              //   style: TextStyle(
                                              //       fontSize: 14,
                                              //       fontWeight: FontWeight.w400,
                                              //       color: AppColors.mutedColor),
                                              // ),
                                              //  Text(
                                              //   'Quantity : ${item.quantity} ${item.updatedUnit?.code ?? ''} x ${item.price.toStringAsFixed(2)} = ${(item.quantity * item.price).toStringAsFixed(2)}',
                                              //   style: TextStyle(
                                              //       fontSize: 14,
                                              //       fontWeight: FontWeight.w400,
                                              //       color: AppColors.mutedColor),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )

                                  // _buildRows(context,
                                  //     code: item.vanSaleDetails![0].productId ?? '',
                                  //     name:
                                  //         item.vanSaleDetails![0].description ?? '',
                                  //     unit: item.updatedUnit?.code ?? '',
                                  //     quantity: item.quantity.toString(),
                                  //     isHeader: false),
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<SalesInvoiceController>(
                    builder: (_) {
                      return SummaryCard(
                          isSalesInvoice: true,
                          onTap: () {
                            if (_.returnToggle.value ||
                                _.selectedItems.isEmpty) {
                              return;
                            }
                            _discountAmountController.text =
                                salesInvoiceController.discount
                                    .toStringAsFixed(2)
                                    .toString();
                            _discountPercentageController.text =
                                InventoryCalculations.formatPrice(
                                    salesInvoiceController
                                        .discountPercentage.value
                                        .toDouble());
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                context: context,
                                builder: (context) => DiscountSheet(
                                    onTapPercent: () {
                                      _discountPercentageController.selectAll();
                                      _discountPercentageFocusNode
                                          .requestFocus();
                                    },
                                    onTapAmount: () {
                                      _discountAmountController.selectAll();
                                      _discountAmountFocusNode.requestFocus();
                                    },
                                    onChangePercent: (value) {
                                      salesInvoiceController.calculateDiscount(
                                          value, true);
                                      setState(() {
                                        _discountAmountController.text =
                                            InventoryCalculations.formatPrice(
                                                salesInvoiceController
                                                    .discount.value
                                                    .toDouble());
                                      });
                                    },
                                    onChangeAmount: (value) {
                                      salesInvoiceController.calculateDiscount(
                                          value, false);
                                      setState(() {
                                        _discountPercentageController.text =
                                            InventoryCalculations.formatPrice(
                                                salesInvoiceController
                                                    .discountPercentage.value
                                                    .toDouble());
                                      });
                                    },
                                    amountFocus: _discountAmountFocusNode,
                                    percentFocus: _discountPercentageFocusNode,
                                    amountController: _discountAmountController,
                                    percentController:
                                        _discountPercentageController));
                          },
                          onSave: () async {
                            if (salesInvoiceController
                                    .referenceNoController.value.text.length >
                                19) {
                              SnackbarServices.errorSnackbar(
                                  'Reference Number cannot exceed 19 characters!');
                            }
                            if (salesInvoiceController.selectedItems.isEmpty) {
                              SnackbarServices.errorSnackbar(
                                  'Please add any item');
                              return;
                            }

                            if (salesInvoiceController.creditToggle.value ==
                                true) {
                              await _.saveNewInvoice(context);
                              await Future.delayed(Duration(milliseconds: 1));
                              int printPreference =
                                  UserSimplePreferences.getPrintPreference() ??
                                      1;
                                if(printPreference == 1){
                                  await ThermalPrintHeplper.getConnection(
                                  context,
                                  salesInvoiceController.helper.value,
                                  PrintLayouts.SalesInvoice);
                                }
                              
                            } else {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    content: PaymentTypePopup(),
                                  );
                                },
                              );
                            }

                            // this.printTicket(salesInvoiceController.helper.value);
                            // await Future.delayed(Duration(milliseconds: 1));
                            // if (salesInvoiceController.isConnected.value ==
                            //         false &&
                            //     salesInvoiceController.isSaveSuccess.value ==
                            //         true) {
                            // log('Entering dialog');
                            //   await getBluetooth();
                            //   showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           title: Text('Available Devices'),
                            //           content: Container(
                            //             height: 200,
                            //             width: MediaQuery.of(context).size.width *
                            //                 0.8,
                            //             child: ListView.builder(
                            //               itemCount:
                            //                   availableBluetoothDevices.length > 0
                            //                       ? availableBluetoothDevices
                            //                           .length
                            //                       : 0,
                            //               itemBuilder: (context, index) {
                            //                 return ListTile(
                            //                   onTap: () {
                            //                     String select =
                            //                         availableBluetoothDevices[
                            //                             index];
                            //                     List list = select.split("#");
                            //                     // String name = list[0];
                            //                     String mac = list[1];
                            //                     this.setConnect(mac);
                            //                   },
                            //                   title: Text(
                            //                       '${availableBluetoothDevices[index]}'),
                            //                   subtitle: Text("Click to connect"),
                            //                 );
                            //               },
                            //             ),
                            //           ),
                            //           actions: [
                            //             Obx(() => ElevatedButton(
                            //                   onPressed: salesInvoiceController
                            //                           .isConnected.value
                            //                       ? () {
                            //                           this.printTicket(
                            //                               salesInvoiceController
                            //                                   .helper.value);
                            //                         }
                            //                       : null,
                            //                   child: Text('Print'),
                            //                   style: ElevatedButton.styleFrom(
                            //                       backgroundColor:
                            //                           salesInvoiceController
                            //                                   .isConnected.value
                            //                               ? AppColors.primary
                            //                               : AppColors.mutedColor),
                            //                 ))
                            //           ],
                            //         );
                            //       });
                            // } else {
                            //   // log('message for add post frame call back ${homeController.printingMacAddress.value}');
                            //   log('Entering else${salesInvoiceController.isSaveSuccess.value}');
                            //   salesInvoiceController.isConnected.value &&
                            //           salesInvoiceController.isSaveSuccess.value
                            //       ? this.printTicket(
                            //           salesInvoiceController.helper.value)
                            //       : salesInvoiceController.isSaveSuccess.value
                            //           ? SnackbarServices.errorSnackbar(
                            //               'Printer Not Connected')
                            //           : null;
                            // }
                          },
                          onClear: () {
                            _.clearGrid();
                          },
                          creditToggle: _.creditToggle.value,
                          returnToggle: _.returnToggle.value,
                          onCreditToggle: (value) {
                            _.toggleCredit(value);
                          },
                          onReturnToggle: (value) {
                            _.toggleReturn(value);
                          },
                          isLoading: false,
                          subTotal: InventoryCalculations.formatPrice(
                              _.subTotal.value.toDouble()),
                          tax: InventoryCalculations
                                  .roundHalfAwayFromZeroToDecimal(
                                      _.totalTax.value.toDouble())
                              .toStringAsFixed(2),
                          discount: InventoryCalculations
                                  .roundHalfAwayFromZeroToDecimal(
                                      _.discount.value.toDouble())
                              .toStringAsFixed(2),
                          total: InventoryCalculations.formatPrice(
                              _.total.value.toDouble()),
                          isSaveActive: true);
                    },
                  )
                ],
              ),
            ),
            DragableButton(
              onTap: () {
                salesInvoiceController.getProductList();
                // Get.to(() => SalesInvoiceItems());
                showDialog(
                  context: context,
                  barrierDismissible:
                      true, // Set this to true if you want to close the dialog by tapping outside
                  builder: (BuildContext context) {
                    return Dialog(
                      // Optional: You can customize the dialog's shape, background color, etc.
                      // elevation: 0, // Remove shadow
                      insetPadding: EdgeInsets.zero,
                      backgroundColor:
                          Colors.transparent, // Make background transparent
                      child: Container(
                          color: AppColors.darkGreen,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: SalesInvoiceItems()),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container tableHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildRows(
          context,
          code: 'Code',
          name: 'Name',
          unit: 'Unit',
          quantity: 'Quantity',
          isHeader: true,
        ),
      ),
    );
  }

  Row _buildRows(BuildContext context,
      {required String code,
      required String name,
      required String unit,
      required String quantity,
      required bool isHeader}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            code,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 4,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            unit,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            quantity,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  List availableBluetoothDevices = [];
  bool connected = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // List<BluetoothDevice> _devices = [];
  // BluetoothDevice? _device;
  // bool _connected = false;
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
          setState(() {
            // _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            // _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            // _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            // _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            // _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            // _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            // _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            // _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      // _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        // _connected = true;
      });
    }
  }

  Future<void> getBluetooth() async {
    // await initPlatformState;
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths!;
    });
  }

  Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    print("state conneected $result");

    if (result == "true") {
      salesInvoiceController.isConnected.value = true;
      await Future.delayed(const Duration(milliseconds: 1));
      setState(() {
        connected = true;
      });
    } else {
      SnackbarServices.errorSnackbar('Could not Connect to printer!');
    }
  }

  Future<void> printTicket(PrintHelper printDetail) async {
    // List<int> bytes = await getTicket(printDetail);
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(printDetail);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      salesInvoiceController.isSaveSuccess.value = false;
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
      SnackbarServices.errorSnackbar('Could not connect to printer !');
    }
  }

  Future<List<int>> getTicket(PrintHelper print) async {
    // log('get Ticket working');
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Uint8List headerBytes = base64Decode(print.headerImage ?? '');
    // Uint8List footerBytes = base64Decode(print.footerImage ?? '');

    // final imagePlug.Image header = imagePlug.decodeImage(headerBytes)!;
    // final imagePlug.Image footer = imagePlug.decodeImage(footerBytes)!;
    bytes += generator.text(
        ThermalPrintHeplper.getCompanyDetails(CharacterLimit.name80),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(
        ThermalPrintHeplper.getCompanyDetails(CharacterLimit.address80),
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
    bytes += generator.text("TAX INVOICE",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          underline: true,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text("${print.trn ?? 'TRN : '}",
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
          text: "${print.customerTrn ?? " TRN : "}",
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
            text: "${rowData.price}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "${rowData.amount}",
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

    bytes += generator.text("Total quantity:  ${getTotalQuantity()}",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Amount in words:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: print.amountInWords ?? '',
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
            )),
        PosColumn(
            text: print.total ?? "",
            width: 6,
            styles: PosStyles(
              bold: true,
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
    // bytes += generator.image(footer);
    bytes += generator.cut();
    return bytes;
  }

  String getTotalQuantity() {
    double quantity = 0.0;
    for (var element in salesInvoiceController.helper.value.items!) {
      quantity += element.quantity;
    }
    return quantity.toString();
  }

  List<String> splitText(String text, int maxWidth) {
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
}
