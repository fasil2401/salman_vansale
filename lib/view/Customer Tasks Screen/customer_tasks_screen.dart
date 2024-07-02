import 'dart:developer';

import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_controller.dart';
import 'package:axoproject/controller/app%20controls/customer_tasks_controller.dart';
import 'package:axoproject/controller/app%20controls/payment_collection_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/controller/ui%20controls/version_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Customer%20Tasks%20Screen/lcation_map_screen.dart';
import 'package:axoproject/view/Customer%20Tasks%20Tab%20Screen/customer_tasks_tab_screen.dart';
import 'package:axoproject/view/New%20Order/new_order_screen.dart';
import 'package:axoproject/view/Payment%20Collection/payment_collection_screen.dart';
import 'package:axoproject/view/Reports/reports_screen.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axoproject/view/components/common_button_widget.dart';
import 'package:axoproject/view/components/common_text_field.dart';
import 'package:axoproject/view/components/payment_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/common_widgets.dart';

class CustomerTasksScreen extends StatefulWidget {
  // CustomerTasksScreen({Key? key}) : super(key: key);

  const CustomerTasksScreen(
    this.currentCust, {
    super.key,
  });

  final CustomerModel currentCust;
  @override
  State<CustomerTasksScreen> createState() => _CustomerTasksScreenState();
}

class _CustomerTasksScreenState extends State<CustomerTasksScreen> {
// class CustomerTasksScreen extends StatelessWidget {
  // CustomerTasksScreen({this.isGoingback = true, super.key});
  final routeControler = Get.put(RouteListController());
  final homeController = Get.put(HomeController());
  final customerTasksController = Get.put(CustomerTasksController());
  final versionControl = Get.put(VersionController());
  final connectionSettingsController = Get.put(ConnectionSettingController());
  final paymentCollectionController = Get.put(PaymentCollectionController());
  // final bool isGoingback;
  String username = '';
  var settingsList = [];

  @override
  void initState() {
    super.initState();
    customerTasksController
        .getRouteCustomer(widget.currentCust.customerID ?? '');
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
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            ListView(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.lightGrey,
                                child: SvgPicture.asset(
                                  AppIcons.customer,
                                  color: AppColors.mutedColor,
                                  height: 40,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.currentCust.customerID.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Obx(() => SvgPicture.asset(
                                        customerTasksController.customer.value
                                                        .isHold ==
                                                    1 ||
                                                customerTasksController.customer
                                                        .value.noCredit ==
                                                    1
                                            ? AppIcons.card_inactive
                                            : AppIcons.card_active,
                                        height: 20,
                                      )),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomerTaskTabScreen.buildDetailRow(
                              title: 'Name',
                              text: widget.currentCust.customerName.toString()),
                          const SizedBox(height: 16),
                          CustomerTaskTabScreen.buildDetailRow(
                              title: 'Address',
                              text: widget.currentCust.address1 != null
                                  ? widget.currentCust.address1!.trim()
                                  : ''),
                          const SizedBox(height: 16),
                          CustomerTaskTabScreen.buildDetailRow(
                              title: 'Contact',
                              text: widget.currentCust.phone1 ?? ''),
                          const SizedBox(height: 16),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CommonButtonWidget(
                                  onPressed: () {
                                    Get.to(() => ReportsScreen(
                                          customerId:
                                              widget.currentCust.customerID,
                                          isCustomerTask: true,
                                        ));
                                  },
                                  title: "Reports",
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.white,
                                  icon: SvgPicture.asset(AppIcons.report_home),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CommonButtonWidget(
                                  onPressed: () {
                                    if (widget.currentCust.latitude != null &&
                                        widget.currentCust.longitude != null) {
                                      Get.to(() => LocationMapScreen(
                                            customer: widget.currentCust,
                                          ));
                                    } else {
                                      SnackbarServices.errorSnackbar(
                                          'Could not find Customer Location');
                                    }
                                  },
                                  title: "Map",
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.white,
                                  icon: SvgPicture.asset(AppIcons.maps),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => Visibility(
                        visible: customerTasksController.isStarted.value,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTaskCard(
                                    onPressed: () {
                                      Get.to(() => SalesInvoiceScreen());
                                    },
                                    label: 'New Invoice',
                                    icon: AppIcons.new_invoice),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: _buildTaskCard(
                                    onPressed: () async {
                                      await paymentCollectionController
                                          .getInitialCombos();
                                      await paymentCollectionController
                                          .paymentVoucher();
                                      await routeControler.getRouteList();
                                      await paymentCollectionController
                                          .getPendingPayments();
                                      log("${routeControler.routeList[0].isEnableAllocation} locations");
                                      final firstRouteEnabled =
                                          routeControler.routeList.isNotEmpty &&
                                              routeControler.routeList[0]
                                                      .isEnableAllocation ==
                                                  1;
                                      final hasPendingInvoices =
                                          paymentCollectionController
                                              .pendingInvoiceList.isNotEmpty;

                                      if (!firstRouteEnabled ||
                                          !hasPendingInvoices) {
                                        paymentPopup(context);
                                      } else {
                                        Get.to(() => PaymentCollectionScreen());
                                      }
                                    },
                                    label: 'Payment',
                                    icon: AppIcons.card_active),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: _buildTaskCard(
                                    onPressed: () {
                                      Get.to(() => NewOrderScreen());
                                    },
                                    label: 'New Order',
                                    icon: AppIcons.cart),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonButtonWidget(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CommonWidgets.buildAlertDialog(
                            context: context,
                            title: CommonWidgets.popupTitle(
                                onTap: () {
                                  customerTasksController
                                      .reasonForSkipping.value
                                      .clear();
                                  Navigator.of(context).pop();
                                },
                                title: 'Skip'),
                            insetPadding: 40,
                            content: Obx(() => SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Please select a reason from list',
                                              style: TextStyle(
                                                color: AppColors.mutedColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            CommonWidgets.commonRadio(
                                                'No Fuel',
                                                'no fuel',
                                                customerTasksController
                                                    .selectedSkipReasons.value,
                                                (value) =>
                                                    customerTasksController
                                                        .skipReasons(value!)),
                                            CommonWidgets.commonRadio(
                                                'Vehicle Damage',
                                                'vehicle damage',
                                                customerTasksController
                                                    .selectedSkipReasons.value,
                                                (value) =>
                                                    customerTasksController
                                                        .skipReasons(value!)),
                                            CommonWidgets.commonRadio(
                                                'No Time',
                                                'no time',
                                                customerTasksController
                                                    .selectedSkipReasons.value,
                                                (value) =>
                                                    customerTasksController
                                                        .skipReasons(value!)),
                                            CommonWidgets.commonRadio(
                                                'Others',
                                                'others',
                                                customerTasksController
                                                    .selectedSkipReasons.value,
                                                (value) =>
                                                    customerTasksController
                                                        .skipReasons(value!)),
                                            const SizedBox(height: 10),
                                            if (customerTasksController
                                                    .selectedSkipReasons
                                                    .value ==
                                                'others')
                                              CommonTextField.multilinetextfield(
                                                  label: "Reasons",
                                                  controller:
                                                      customerTasksController
                                                          .reasonForSkipping
                                                          .value),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonButtonWidget(
                                              onPressed: () async {
                                                customerTasksController
                                                    .reasonForSkipping.value
                                                    .clear();
                                                Navigator.of(context).pop();
                                              },
                                              title: 'Cancel',
                                              backgroundColor:
                                                  AppColors.mutedColor,
                                              textColor: AppColors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: CommonButtonWidget(
                                              onPressed: () async {
                                                await customerTasksController
                                                    .skippedVisit();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              title: 'Skip',
                                              backgroundColor:
                                                  AppColors.primary,
                                              textColor: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    },
                    title: 'Skip',
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                    icon: SvgPicture.asset(AppIcons.skip),
                  ),
                  Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(height, width * 0.05),
                          backgroundColor:
                              customerTasksController.isStarted.value
                                  ? AppColors.error
                                  : AppColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        onPressed: () async {
                          await customerTasksController
                              .startOrEndVisit(widget.currentCust);
                        },
                        child: customerTasksController.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                customerTasksController.isStarted.value
                                    ? 'End Visit'
                                    : 'Start Visit',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                        //  CommonButtonWidget(
                        //                       onPressed: () async {
                        //                         await customerTasksController
                        //                             .startOrEndVisit(widget.currentCust);
                        //                       },
                        //                       title: customerTasksController.isStarted.value
                        //                           ? 'End Visit'
                        //                           : 'Start Visit',
                        //                       backgroundColor: customerTasksController.isStarted.value
                        //                           ? AppColors.error
                        //                           : AppColors.success,
                        //                       textColor: AppColors.white,
                        //                     )),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: AppBottomBar(),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   // String inputSentence =
      //   //     "P.O.Box:116882 | Shop No.16 | Al Aweer,Dubai +97143200077 | www.biogreenfoods.ae biogreen456@gmail.com";

      //   // String result = splitSentenceByCharacterLimit(inputSentence, 44);
      //   String inputSentence = "BIO GREEN FOODSTUFF Trading LLC";

      //   String result = splitSentenceByCharacterLimit(inputSentence, 18);

      //   print(result);
      // }),
    );
  }

  // Function to split the sentence into lines with a maximum character limit
  String splitSentenceByCharacterLimit(String sentence, int characterLimit) {
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

  Widget _buildTaskCard(
      {required Function() onPressed,
      required String icon,
      required String label}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.primary,
              height: 25,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
