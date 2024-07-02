import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/controller/ui%20controls/version_controller.dart';
import 'package:axoproject/services/Themes/app_theme.dart';
import 'package:axoproject/services/Themes/custom_theme.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/components/heights.dart';
import 'package:axoproject/view/components/small_text.dart';
import 'package:axoproject/view/dashboard/components/home_screen_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/home_grid_tile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final versionControl = Get.put(VersionController());
  final connectionSettingsController = Get.put(ConnectionSettingController());
  // final routeController = Get.put(RouteController());
  final homeController = Get.put(HomeController());
  String username = '';
  var settingsList = [];
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: context.theme.primaryColor,
          leadingWidth: 47,
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: GestureDetector(
          //       onTap: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //       child: SvgPicture.asset(
          //         'assets/icons/menu.svg',
          //       )),
          // ),
          title: SizedBox(
            // width: width * 0.32,
            height: 30,
            child: Image.asset(
              'assets/images/axolon_logo.png',
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),

          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Transactions",
              ),
              Tab(
                text: "Settings",
              ),
            ],
          ),
        ),
        drawer: HomeScreenDrawer(
            width: width,
            username: username,
            settingsList: settingsList,
            height: height),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SmallText(
                            title: 'Warehouse Route: ',
                          ),
                          Flexible(
                            child: UserSimplePreferences.getRoute() == null
                                ? //Obx(() => 
                                Text(
                                      'Here Comes route',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Rubik',
                                          color: commonBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )
                                    // )
                                : Text(
                                    UserSimplePreferences.getRoute() ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        color: commonBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  commonHeight1,
                  commonHeight5,
                  Padding(
                    // padding: commonHorizontalPadding,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.to(() => ItemDetails());
                          },
                          child: HomeGridTile(
                            title: 'Item Details',
                            image: 'assets/icons/page.svg',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Get.to(() => InTransfer());
                          },
                          child: HomeGridTile(
                            title: 'In-Transfer',
                            image: 'assets/icons/in.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                  commonHeight5,
                  Padding(
                    // padding: commonHorizontalPadding,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // databbaseTry();
                            // Get.to(() => OutTransfer());
                          },
                          child: HomeGridTile(
                            title: 'Out Transfer',
                            image: 'assets/icons/out.svg',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Get.to(() => RecieveScreen());
                            print(
                                'height ${MediaQuery.of(context).size.height}');
                            print('width ${MediaQuery.of(context).size.width}');
                          },
                          child: HomeGridTile(
                            title: 'Recieve',
                            image: 'assets/icons/recieve.svg',
                            isDisable: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  commonHeight5,
                  Padding(
                    // padding: commonHorizontalPadding,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.to(() => StockTakeScreen());
                          },
                          child: HomeGridTile(
                            title: 'Stock Take',
                            image: 'assets/icons/stock.svg',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Get.to(() => MyCustomWidget());
                            // Get.to(() => VoiceTest());
                          },
                          child: HomeGridTile(
                            title: 'Print Labels',
                            image: 'assets/icons/print.svg',
                            isDisable: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  commonHeight5,
                  Padding(
                    // padding: commonHorizontalPadding,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.to(() => QualityControlScreen());
                          },
                          child: HomeGridTile(
                            title: 'Quality Control',
                            image: 'assets/icons/high-quality.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
                 SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Color'),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  CustomTheme.instanceOf(context)
                                      .changeTheme(MyThemes.blueTheme);
                                },
                                child: Card(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: commonBlueColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  CustomTheme.instanceOf(context)
                                      .changeTheme(MyThemes.redTheme);
                                },
                                child: Card(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    
         ],
        ),
      ),
    );
  }
}
