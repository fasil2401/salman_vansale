import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/route_details_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/controller/ui%20controls/version_controller.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/components/common_button_widget.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:axoproject/view/dashboard/components/home_screen_drawer.dart';
import 'package:axoproject/view/route%20details/directions.dart';
import 'package:axoproject/view/route%20details/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../utils/constants/colors.dart';

class RouteDetailsScreen extends StatefulWidget {
  RouteDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
// class RouteDetailsScreen extends StatelessWidget {
  // RouteDetailsScreen({this.isGoingback = true, super.key});
  final homeController = Get.put(HomeController());
  final routeDetailsController = Get.put(RouteDetailsController());
  final versionControl = Get.put(VersionController());
  final connectionSettingsController = Get.put(ConnectionSettingController());
  // final bool isGoingback;
  String username = '';
  var settingsList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    generateUrl();
    getLocalSettings();
  }

  generateUrl() async {
    setState(() {
      username = UserSimplePreferences.getUsername() ?? '';
      // UserSimplePreferences.getHttpPort() ?? '';
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: HomeScreenDrawer(
            width: width,
            username: username,
            settingsList: settingsList,
            height: height),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!
                      .openDrawer(); // Open the drawer on tap
                },
                child: SvgPicture.asset(AppIcons.drawer)),
          ),
          title: const Text('Route Details'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(210),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildAppbarContainer(
                      child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      SvgPicture.asset(AppIcons.route),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Route',
                              style: TextStyle(
                                  color: Color(0xFF009DE2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              UserSimplePreferences.getRouteName() ?? '',
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => DirectionScreen(
                                  list: routeDetailsController.customerList,
                                ));
                          },
                          child: _buildAppbarContainer(
                            child: _buildIconTile(
                              title: 'Directions',
                              icon: AppIcons.direction,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const OvrallReports());
                          },
                          child: _buildAppbarContainer(
                              child: _buildIconTile(
                            title: 'Reports',
                            icon: AppIcons.report_home,
                          )),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.shop_loc,
                  width: 20,
                  height: 20,
                  color: AppColors.mutedColor,
                ),
                const SizedBox(
                  width: 15,
                ),
                GetBuilder<RouteDetailsController>(
                  builder: (_) {
                    return Text(
                      '${_.customerList.length.toString()} Planned Visits',
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mutedColor,
                          fontWeight: FontWeight.w500),
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GetBuilder<RouteDetailsController>(
                builder: (_) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: _.customerList.length,
                    itemBuilder: (context, index) {
                      var customer = _.customerList[index];
                      return Column(
                        children: [
                          Row(
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
                                            customer.customerName.toString(),
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
                                    Text(
                                      customer.address1.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.mutedColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 2,
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CommonWidgets.buildAlertDialog(
                  context: context,
                  title: CommonWidgets.popupTitle(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      title: 'Start Route'),
                  insetPadding: 40,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'You are about to start your route. Please tap the start route button to confirm.',
                        style: TextStyle(
                          color: AppColors.mutedColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => CommonButtonWidget(
                            onPressed: () async {
                              await routeDetailsController.startBatch();
                            },
                            title: 'Start Route',
                            isLoading:
                                routeDetailsController.isStartingRoute.value,
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.white,
                          ))
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          isExtended: true,
          label: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text('Start Route'),
          ),
          icon: SvgPicture.asset(AppIcons.start_route),
        ));
  }

  Padding _buildIconTile({required String title, required String icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 40,
            height: 40,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Container _buildAppbarContainer({required Widget child}) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xFF003579),
            borderRadius: BorderRadius.circular(8)),
        child: child);
  }
}
