import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/route_customer_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/controller/ui%20controls/version_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Customer%20Tasks%20Screen/customer_tasks_screen.dart';
import 'package:axoproject/view/Customer%20Tasks%20Tab%20Screen/customer_tasks_tab_screen.dart';
import 'package:axoproject/view/components/common_button_widget.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:axoproject/view/dashboard/components/home_screen_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class RouteCustomerScreen extends StatefulWidget {
  RouteCustomerScreen({Key? key}) : super(key: key);

  @override
  State<RouteCustomerScreen> createState() => _RouteCustomerScreenState();
}

class _RouteCustomerScreenState extends State<RouteCustomerScreen> {
  final homeController = Get.put(HomeController());
  final routeCustomerController = Get.put(RouteCustomerController());
  final versionControl = Get.put(VersionController());
  final connectionSettingsController = Get.put(ConnectionSettingController());
  String username = '';
  var settingsList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    generateUrl();
    getLocalSettings();
  }

  generateUrl() async {
    setState(() {
      username = UserSimplePreferences.getUsername() ?? '';
    });
  }

  getLocalSettings() async {
    await connectionSettingsController.getLocalSettings();
    List<dynamic> settings = connectionSettingsController.connectionSettings;
    for (var setting in settings) {
      log("m${setting.userName}", name: "User name");
      settingsList.add(setting);
    }
    log("${settingsList}");
  }

  @override
  Widget build(BuildContext context) {
    int status = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      do {
        routeCustomerController.getAllCustomers();
      } while (status == 1);
    });
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeScreenDrawer(
        width: width,
        username: username,
        settingsList: settingsList,
        height: height,
      ),
      appBar: AppBar(
        title: Text('Route Customers'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!
                    .openDrawer(); // Open the drawer on tap
              },
              child: SvgPicture.asset(AppIcons.drawer)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonWidgets.buildExpansionTextFields(
                    controller: TextEditingController(),
                    onTap: () {},
                    onChanged: (val) =>
                        routeCustomerController.searchCustomer(val),
                    focus: _focusNode,
                    disableSuffix: true,
                    hint: 'Search',
                    isSearch: true,
                    isReadOnly: false,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CommonWidgets.buildAlertDialog(
                          context: context,
                          title: CommonWidgets.popupTitle(
                              onTap: () {
                                routeCustomerController.selectedFilter.value =
                                    '';
                                Navigator.of(context).pop();
                              },
                              title: 'Select Sort'),
                          insetPadding: 60,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CommonWidgets.commonRadio('By Name', 'name',
                                  routeCustomerController.selectedFilter.value,
                                  (value) {
                                routeCustomerController.filter(value);
                                Navigator.pop(context);
                              }),
                              CommonWidgets.commonRadio('By Id', 'id',
                                  routeCustomerController.selectedFilter.value,
                                  (value) {
                                routeCustomerController.filter(value);
                                Navigator.pop(context);
                              }),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Card(
                      color: AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          AppIcons.filter,
                          width: 22,
                          height: 22,
                          color: AppColors.mutedColor,
                        ),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GetBuilder<RouteCustomerController>(builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _.filterCustomerList.length,
                  itemBuilder: (context, index) {
                    var customerItem = _.filterCustomerList[index];
                    return InkWell(
                      onTap: () async {
                        CustomerModel customer = await routeCustomerController
                            .getRouteCustomer(customerItem.customerID!);
                        await homeController.getCustomerDetails(customer);
                        Get.to(() => CustomerTaskTabScreen(customer));
                        // routeCustomerController.getAllCustomers();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.1,
                              color: AppColors.mutedColor,
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.lightGrey,
                              child: SvgPicture.asset(
                                AppIcons.customer,
                                color: AppColors.mutedColor,
                                height: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${customerItem.customerName.toString()}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.mutedColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 10,
                                      // ),
                                      // Text(
                                      //   customer.customerID.toString(),
                                      //   style: const TextStyle(
                                      //     fontWeight: FontWeight.w500,
                                      //     color: AppColors.primary,
                                      //     fontSize: 14,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          customerItem.address1.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.mutedColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.asset(
                                        customerItem.isHold == 1 ||
                                                customerItem.noCredit == 1
                                            ? AppIcons.card_inactive
                                            : AppIcons.card_active,
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget sortFilterText(Function() ontap, String txt) => Padding(
        padding: const EdgeInsets.all(1),
        child: InkWell(
          onTap: ontap,
          child: Text(
            txt,
            style: TextStyle(color: AppColors.mutedColor, fontSize: 15),
          ),
        ),
      );
}
