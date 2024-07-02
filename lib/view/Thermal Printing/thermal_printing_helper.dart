import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/thermal_print_controller.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThermalPrintingScreen extends StatefulWidget {
  const ThermalPrintingScreen(
    this.printDetail, {
    super.key,
  });

  final PrintHelper printDetail;
  @override
  _ThermalPrintingScreenState createState() => _ThermalPrintingScreenState();
}

class _ThermalPrintingScreenState extends State<ThermalPrintingScreen> {
  final printController = Get.put(ThermalPrintController());
  final homeController = Get.put(HomeController());
  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // 'context' is available here, and you can use it as needed.
  //   final mycontext = context;
  //   if (availableBluetoothDevices.isEmpty) {
  //     this.getBluetooth();

  //     if (UserSimplePreferences.getPrintMacAddress() != null) {
  //       if (availableBluetoothDevices
  //           .contains(UserSimplePreferences.getPrintMacAddress())) {
  //         List list = UserSimplePreferences.getPrintMacAddress()!.split("#");
  //         String mac = list[1];
  //         this.setConnect(mac);
  //         Navigator.pop(context);
  //       } else {
  //         showDialog(
  //             context: mycontext,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: Text('Available Devices'),
  //                 content: Container(
  //                   height: 200,
  //                   width: MediaQuery.of(mycontext).size.width * 0.8,
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: availableBluetoothDevices.length > 0
  //                         ? availableBluetoothDevices.length
  //                         : 0,
  //                     itemBuilder: (mycontext, index) {
  //                       return ListTile(
  //                         onTap: () {
  //                           String select = availableBluetoothDevices[index];
  //                           List list = select.split("#");
  //                           // String name = list[0];
  //                           String mac = list[1];
  //                           this.setConnect(mac);
  //                           UserSimplePreferences.setPrintMacAddress(select);
  //                           Navigator.pop(mycontext);
  //                           Navigator.pop(mycontext);
  //                         },
  //                         title: Text('${availableBluetoothDevices[index]}'),
  //                         subtitle: Text("Click to connect"),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               );
  //             });
  //       }
  //     } else {
  //       showDialog(
  //           context: mycontext,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text('Available Devices'),
  //               content: Container(
  //                 height: 200,
  //                 width: MediaQuery.of(mycontext).size.width * 0.8,
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: availableBluetoothDevices.length > 0
  //                       ? availableBluetoothDevices.length
  //                       : 0,
  //                   itemBuilder: (mycontext, index) {
  //                     return ListTile(
  //                       onTap: () {
  //                         String select = availableBluetoothDevices[index];
  //                         List list = select.split("#");
  //                         // String name = list[0];
  //                         String mac = list[1];
  //                         this.setConnect(mac);
  //                         UserSimplePreferences.setPrintMacAddress(select);
  //                         Navigator.pop(mycontext);
  //                         Navigator.pop(mycontext);
  //                       },
  //                       title: Text('${availableBluetoothDevices[index]}'),
  //                       subtitle: Text("Click to connect"),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             );
  //           });
  //     }
  //   }
  // }

  // bool connected = false;
  // List availableBluetoothDevices = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // log('message for add post frame call back${homeController.printingMacAddress.value}');
      if (homeController.printingMacAddress.value.isEmpty) {
        printController.getBluetooth();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Available Devices'),
                content: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            printController.availableBluetoothDevices.length > 0
                                ? printController
                                    .availableBluetoothDevices.length
                                : 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              String select = printController
                                  .availableBluetoothDevices[index];
                              List list = select.split("#");
                              // String name = list[0];
                              String mac = list[1];
                              homeController.printingMacAddress.value = mac;
                              printController.setConnect(
                                  mac, widget.printDetail);
                              // UserSimplePreferences.setPrintMacAddress(
                              //     select);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            title: Text(
                                '${printController.availableBluetoothDevices[index]}'),
                            subtitle: Text("Click to connect"),
                          );
                        },
                      )),
                ),
              );
            });
      } else {
        // log('message for add post frame call back ${homeController.printingMacAddress.value}');
        await printController.setConnect(
            homeController.printingMacAddress.value, widget.printDetail);
        Navigator.pop(context);
      }
      // if (printController.availableBluetoothDevices.isEmpty) {
      //   await printController.getBluetooth();

      //   if (UserSimplePreferences.getPrintMacAddress() != null) {
      //     if (printController.availableBluetoothDevices
      //         .contains(UserSimplePreferences.getPrintMacAddress())) {
      //       log(UserSimplePreferences.getPrintMacAddress().toString());
      //       List list = UserSimplePreferences.getPrintMacAddress()!.split("#");
      //       String mac = list[1];
      //       homeController.printingMacAddress.value = mac;
      //       await printController.setConnect(mac, widget.printDetail);
      //       Navigator.pop(context);
      //     } else {
      //       showDialog(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return AlertDialog(
      //               title: Text('Available Devices'),
      //               content: Container(
      //                 height: 200,
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Obx(() => ListView.builder(
      //                       shrinkWrap: true,
      //                       itemCount: printController
      //                                   .availableBluetoothDevices.length >
      //                               0
      //                           ? printController
      //                               .availableBluetoothDevices.length
      //                           : 0,
      //                       itemBuilder: (context, index) {
      //                         return ListTile(
      //                           onTap: () {
      //                             String select = printController
      //                                 .availableBluetoothDevices[index];
      //                             List list = select.split("#");
      //                             // String name = list[0];
      //                             String mac = list[1];
      //                             homeController.printingMacAddress.value = mac;
      //                             printController.setConnect(
      //                                 mac, widget.printDetail);
      //                             UserSimplePreferences.setPrintMacAddress(
      //                                 select);
      //                             Navigator.pop(context);
      //                             Navigator.pop(context);
      //                           },
      //                           title: Text(
      //                               '${printController.availableBluetoothDevices[index]}'),
      //                           subtitle: Text("Click to connect"),
      //                         );
      //                       },
      //                     )),
      //               ),
      //             );
      //           });
      //     }
      //   } else {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: Text('Available Devices'),
      //             content: Container(
      //               height: 200,
      //               width: MediaQuery.of(context).size.width * 0.8,
      //               child: Obx(() => ListView.builder(
      //                     shrinkWrap: true,
      //                     itemCount: printController
      //                                 .availableBluetoothDevices.length >
      //                             0
      //                         ? printController.availableBluetoothDevices.length
      //                         : 0,
      //                     itemBuilder: (context, index) {
      //                       return ListTile(
      //                         onTap: () {
      //                           String select = printController
      //                               .availableBluetoothDevices[index];
      //                           List list = select.split("#");
      //                           // String name = list[0];
      //                           String mac = list[1];
      //                           homeController.printingMacAddress.value = mac;
      //                           printController.setConnect(
      //                               mac, widget.printDetail);
      //                           UserSimplePreferences.setPrintMacAddress(
      //                               select);
      //                           Navigator.pop(context);
      //                           Navigator.pop(context);
      //                         },
      //                         title: Text(
      //                             '${printController.availableBluetoothDevices[index]}'),
      //                         subtitle: Text("Click to connect"),
      //                       );
      //                     },
      //                   )),
      //             ),
      //           );
      //         });
      //   }
      // }
    });
    return Scaffold();
    // return const Scaffold(
    // body: Container(
    //   padding: EdgeInsets.all(20),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text("Search Paired Bluetooth"),
    //       TextButton(
    //         onPressed: () {
    //           this.getBluetooth();
    //         },
    //         child: Text("Search"),
    //       ),
    //       Container(
    //         height: 200,
    //         child: ListView.builder(
    //           itemCount: availableBluetoothDevices.length > 0
    //               ? availableBluetoothDevices.length
    //               : 0,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               onTap: () {
    //                 String select = availableBluetoothDevices[index];
    //                 List list = select.split("#");
    //                 // String name = list[0];
    //                 String mac = list[1];
    //                 this.setConnect(mac);
    //               },
    //               title: Text('${availableBluetoothDevices[index]}'),
    //               subtitle: Text("Click to connect"),
    //             );
    //           },
    //         ),
    //       ),
    //       SizedBox(
    //         height: 30,
    //       ),
    //       TextButton(
    //         onPressed: connected ? this.printGraphics : null,
    //         child: Text("Print"),
    //       ),
    //       TextButton(
    //         onPressed: connected ? this.printTicket : null,
    //         child: Text("Print Ticket"),
    //       ),
    //     ],
    //   ),
    // ),
    // );
  }
}
