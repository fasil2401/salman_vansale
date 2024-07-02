import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:axoproject/controller/Api%20Controllers/batch_sync_controller.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/ui%20controls/version_controller.dart';
import 'package:axoproject/model/Local%20DB%20model/connection_setting_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Backup/backup_screen.dart';
import 'package:axoproject/view/Expenses/expenses_screen.dart';
import 'package:axoproject/view/Report%20Type/report_type.dart';
import 'package:axoproject/view/Reports/reports_screen.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axoproject/view/Settings%20Screen/settings_screen.dart';
import 'package:axoproject/view/Sync%20Screen/sync_screen.dart';
import 'package:axoproject/view/components/custom_drawer.dart';
import 'package:axoproject/view/components/texts.dart';
import 'package:axoproject/view/server%20connect/server_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/Local Db Controller/user_activity_log_local_controller.dart';

class HomeScreenDrawer extends StatefulWidget {
  HomeScreenDrawer({
    Key? key,
    required this.width,
    required this.username,
    required this.settingsList,
    required this.height,
  }) : super(key: key);
  final double width;
  final String username;
  final List settingsList;
  final double height;

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final versionControl = Get.put(VersionController());
  final homeController = Get.put(HomeController());
  final batchSyncController = Get.put(BatchSyncController());
  // final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Row(
                  children: [
                    Obx(() {
                      Uint8List bytes =
                          Base64Codec().decode(homeController.userImage.value);
                      return CircleAvatar(
                        backgroundColor: Theme.of(context).backgroundColor,
                        radius: 40,
                        child: homeController.userImage.value == ''
                            ? CircleAvatar(
                                backgroundColor: commonBlueColor,
                                radius: 35,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/images/user.png',
                                    fit: BoxFit.cover,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: commonBlueColor,
                                radius: 35,
                                backgroundImage: MemoryImage(bytes),
                              ),
                      );
                    }),
                    SizedBox(
                      width: widget.width * 0.05,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserSimplePreferences.getVanName() ?? '',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            UserSimplePreferences.getUsername() ?? '',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: mutedColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              if (UserSimplePreferences.batchID.value != null &&
                  UserSimplePreferences.batchID.value <= 0)
                SizedBox(
                  height: 20,
                ),
              // if (UserSimplePreferences.batchID.value != null &&
              //     UserSimplePreferences.batchID.value <= 0)
              //   InkWell(
              //     onTap: () {
              //       Get.back();
              //       homeController.getRoutePopUp(context);
              //     },
              //     child: DrawerTile(
              //       title: 'Route',
              //       icon: 'assets/icons/drawer/search-location.svg',
              //     ),
              //   ),
              Column(
                children: [
                  Column(
                    children: [
                      Obx(
                        () {
                          if (UserSimplePreferences.batchID.value != null &&
                              UserSimplePreferences.batchID.value > 0) {
                            return SizedBox(
                              height: 20,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      Obx(
                        () {
                          if (UserSimplePreferences.batchID.value != null &&
                              UserSimplePreferences.batchID.value > 0) {
                            return DrawerTile(
                              title: 'Open Map',
                              icon: Images.map,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      Obx(
                        () {
                          if (UserSimplePreferences.batchID.value != null &&
                              UserSimplePreferences.batchID.value > 0) {
                            return SizedBox(
                              height: 20,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back();
                          Get.to(() => ReportsScreen());
                        },
                        child: DrawerTile(
                          title: 'Reports',
                          icon: Images.reports,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back();
                          Get.to(() => SettingsScreen());
                        },
                        child: DrawerTile(
                          title: 'Settings',
                          icon: AppIcons.settings,
                        ),
                      ),
                      Obx(
                        () {
                          if (UserSimplePreferences.batchID.value != null &&
                              UserSimplePreferences.batchID.value > 0) {
                            return SizedBox(
                              height: 20,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      Obx(
                        () {
                          if (UserSimplePreferences.batchID.value != null &&
                              UserSimplePreferences.batchID.value > 0) {
                            return InkWell(
                              onTap: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                        'Are you sure you want to close the route?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          batchSyncController.closeBatch();
                                          showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // Set this to true if you want to close the dialog by tapping outside
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  insetPadding:
                                                      EdgeInsets.all(10),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            10,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            15,
                                                    child: Card(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: DrawerTile(
                                title: 'Close Route',
                                icon: Images.closeRoute,
                                isLoading:
                                    batchSyncController.isBatchClosing.value,
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Get.to(() => SyncScreenView());
                },
                child: DrawerTile(
                  title: 'Synchronization',
                  icon: Images.sync,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Obx(
                () {
                  if (UserSimplePreferences.batchID.value != null &&
                      UserSimplePreferences.batchID.value > 0) {
                    return InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(() => ExpensesScreen());
                      },
                      child: DrawerTile(
                        title: 'Expense',
                        icon: Images.expense,
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              Obx(
                () {
                  if (UserSimplePreferences.batchID.value != null &&
                      UserSimplePreferences.batchID.value > 0) {
                    return SizedBox(
                      height: 20,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              InkWell(
                onTap: () {},
                child: DrawerTile(
                  title: 'Unload Stock',
                  icon: Images.unloadStock,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Get.to(() => ReportTypeScreen());
                },
                child: DrawerTile(
                  title: 'Report Type',
                  icon: 'assets/icons/drawer/privacy.svg',
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     homeController.showPrivacyPolicy();
              //     Get.back();
              //   },
              //   child: DrawerTile(
              //     title: 'Privacy Policy',
              //     icon: 'assets/icons/drawer/privacy.svg',
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => BackUpScreen());
                },
                child: DrawerTile(
                  title: 'Backup',
                  icon: Images.backup,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  if (UserSimplePreferences.getBatchID() != null &&
                      UserSimplePreferences.getBatchID()! > 0) {
                    SnackbarServices.errorSnackbar("Close the batch to logout");
                  } else {
                    Get.back();
                    await UserSimplePreferences.setLogin('logout');
                    activityLogLocalController.insertactivityLogList(
                        activityLog: UserActivityLogModel(
                            sysDocId: "",
                            voucherId: "",
                            activityType: ActivityTypes.logout.value,
                            date: DateTime.now().toIso8601String(),
                            description: "Logged Out",
                            machine: UserSimplePreferences.getDeviceInfo(),
                            userId: UserSimplePreferences.getUsername(),
                            isSynced: 0));
                    Get.offAllNamed('/login');
                  }
                },
                child: DrawerTile(
                  title: 'Logout',
                  isRed: true,
                  icon: Images.logout,
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // InkWell(
              //   onTap: () {
              //     Get.back();
              //   },
              //   child: DrawerTile(
              //     title: 'Local Backup',
              //     icon: 'assets/icons/drawer/backup.svg',
              //   ),
              // ),

              // InkWell(
              //   onTap: () async {
              //     Get.back();
              //     await UserSimplePreferences.setLogin('logout');
              //     Get.offAllNamed('/login');
              //   },
              //   child: DrawerTile(
              //     title: 'Logout',
              //     icon: 'assets/icons/drawer/logout.svg',
              //   ),
              // ),
              //   Theme(
              //     data: Theme.of(context)
              //         .copyWith(dividerColor: Color.fromRGBO(0, 0, 0, 0)),
              //     child: ExpansionTile(
              //       tilePadding: EdgeInsets.only(left: 10, right: 10),
              //       backgroundColor: Colors.transparent,
              //       title: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Icon(
              //             Icons.workspaces_outlined,
              //             color: commonBlueColor,
              //           ),
              //           SizedBox(
              //             width: 15,
              //           ),
              //           LargeText(
              //             title: 'Switch Companies',
              //             color: mutedColor,
              //           ),
              //         ],
              //       ),
              //       children: [
              //         widget.settingsList.isNotEmpty
              //             ? ListView.separated(
              //                 physics: NeverScrollableScrollPhysics(),
              //                 shrinkWrap: true,
              //                 itemCount: widget.settingsList.length,
              //                 itemBuilder: (context, index) {
              //                   var connection =
              //                       UserSimplePreferences.getConnectionName() ??
              //                           '';

              //                   log("${widget.settingsList[index].connectionName}");
              //                   return GestureDetector(
              //                     onTap: () async {
              //                       var connectonName = widget
              //                           .settingsList[index].connectionName;
              //                       var serverIp =
              //                           widget.settingsList[index].serverIp;
              //                       var databaseName =
              //                           widget.settingsList[index].databaseName;
              //                       var port = widget.settingsList[index].port;
              //                       var username =
              //                           widget.settingsList[index].userName;
              //                       var password =
              //                           widget.settingsList[index].password;
              //                       log("mmm ${username}", name: "Username");
              //                       await UserSimplePreferences
              //                           .setConnectionName(connectonName);
              //                       await UserSimplePreferences.setServerIp(
              //                           serverIp);
              //                       await UserSimplePreferences.setDatabase(
              //                           databaseName);
              //                       await UserSimplePreferences.setPort(port);
              //                       await UserSimplePreferences.setUsername(
              //                           username);
              //                       await UserSimplePreferences.setUserPassword(
              //                           password);
              //                       // await homeController.getUserDetails();

              //                       setState(() {});
              //                     },
              //                     child: Stack(
              //                       children: [
              //                         Container(
              //                           color: connection ==
              //                                   widget.settingsList[index]
              //                                       .connectionName
              //                               ? lightGrey
              //                               : Colors.transparent,
              //                           child: Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 2),
              //                             child: ListTile(
              //                               dense: true,
              //                               title: Row(
              //                                 children: [
              //                                   SizedBox(
              //                                     width: 6,
              //                                   ),
              //                                   Text(
              //                                     widget.settingsList[index]
              //                                         .connectionName
              //                                         .toString(),
              //                                     style: TextStyle(
              //                                       fontSize: 16,
              //                                       color: Theme.of(context)
              //                                           .primaryColor,
              //                                       fontWeight: FontWeight.w400,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                         Container(
              //                           margin: const EdgeInsets.only(
              //                               right: 10, top: 18),
              //                           alignment: Alignment.centerRight,
              //                           child: Icon(
              //                             Icons.circle,
              //                             size: 12,
              //                             color: connection ==
              //                                     widget.settingsList[index]
              //                                         .connectionName
              //                                 ? success
              //                                 : Colors.transparent,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   );
              //                 },
              //                 separatorBuilder: (context, index) => SizedBox(
              //                   height: 2,
              //                 ),
              //               )
              //             : Padding(
              //                 padding:
              //                     const EdgeInsets.symmetric(horizontal: 8),
              //                 child: ListTile(
              //                   dense: true,
              //                   title: Row(
              //                     children: [
              //                       SizedBox(
              //                         width: 10,
              //                         height: 10,
              //                         child: CircularProgressIndicator(
              //                           strokeWidth: 1.5,
              //                           valueColor: AlwaysStoppedAnimation(
              //                             commonBlueColor,
              //                           ),
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         width: 6,
              //                       ),
              //                       Text(
              //                         'Please wait...',
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           color: commonBlueColor,
              //                           fontWeight: FontWeight.w400,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //         SizedBox(
              //           height: widget.height * 0.03,
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             Get.to(() => ServerConnectScreen(
              //                 connectionModel: ConnectionModel(
              //                     connectionName: 'New Connection',
              //                     port: '',
              //                     databaseName: '',
              //                     serverIp: '')));
              //           },
              //           child: CircleAvatar(
              //             backgroundColor: commonBlueColor,
              //             radius: widget.height * 0.025,
              //             child: Icon(
              //               Icons.add,
              //               color: Colors.white,
              //               size: widget.height * 0.025,
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: widget.height * 0.03,
              //         )
              //       ],
              //     ),
              //   ),
              // ],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                print(versionControl.version);
                return Text(
                  'Version ${UserSimplePreferences.getVersion() ?? ''}',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
