import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/payment_collection_controller.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/Payment%20Collection/payment_collection_screen.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:axoproject/view/components/payment_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../../utils/Calculations/date_range_selector.dart';
import '../../components/common_widgets.dart';

class PaymentsReportScreen extends StatelessWidget {
  PaymentsReportScreen({super.key});
  final reportController = Get.put(ReportController());
  final paymentCollectionController = Get.put(PaymentCollectionController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportController.getPaymentCollectionList();
    });
    return Scaffold(
      body: GetBuilder<ReportController>(
          init: ReportController(),
          initState: (_) {},
          builder: (_) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => GFAccordion(
                        title: 'Filter',
                        showAccordion: false,
                        titleBorderRadius: BorderRadius.circular(5),
                        expandedTitleBackgroundColor:
                            Theme.of(context).primaryColor,
                        collapsedTitleBackgroundColor: Colors.black38,
                        collapsedIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        expandedIcon: const Icon(Icons.keyboard_arrow_up,
                            color: Colors.white),
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        titlePadding: EdgeInsets.only(
                            right: 5, top: 5, bottom: 5, left: 5),
                        contentChild: dateReportFilter(
                            context,
                            _.dateIndex.value,
                            (value) {
                              selectedValue = value;
                              _.selectDateRange(
                                  selectedValue.value,
                                  DateRangeSelector.dateRange
                                      .indexOf(selectedValue));
                            },
                            _.fromDate.value,
                            _.isFromDate.value,
                            () {
                              _.selectDate(context, true);
                            },
                            _.toDate.value,
                            _.isToDate.value,
                            () {
                              _.selectDate(context, false);
                            },
                            () {
                              reportController.filterList(
                                  reportController.paymentCollectionFilterList,
                                  reportController.paymentCollectionList);
                            }),
                      )),
                  commonDivider(),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _.paymentCollectionFilterList.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      itemBuilder: (context, index) {
                        var item = _.paymentCollectionFilterList[index];
                        return slidableWidget(item.isSynced!, (p0) async {
                          var helper =
                              await _.printRecipt(item.voucherId ?? "");
                          ThermalPrintHeplper.getConnection(context, helper,
                              PrintLayouts.CashOrChequeReciept);
                        }, (value) {
                          paymentCollectionController
                              .editPaymentsFromReport(item);

                          _.navigatePaymentCollection(context);
                        }, (p0) async {
                          await _.printRecipt(item.voucherId ?? "",
                              isPreview: true);
                        }, () {
                          paymentCollectionController.deleteSavedRequest(
                              item.voucherId ?? '', item.sysDocId ?? "", index);
                          _.deletePaymentCollectionItem(item.voucherId ?? "");
                          Navigator.pop(context);
                        },
                            context,
                            "payment_report",
                            tile(
                                "${item.sysDocId} - ${item.voucherId}",
                                "Payment Type : ${item.isCheque ?? false ? 'Cheque' : 'Cash'}",
                                "${item.amount}",
                                "${item.transactionDate}",
                                item.isSynced ?? 0),
                            isError: item.isError ?? 0,
                            error: item.error ?? "");
                      }),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            );
          }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       FloatingActionButton(
      //         heroTag: "list",
      //         backgroundColor: Theme.of(context).primaryColor,
      //         onPressed: () {},
      //         child: Icon(Icons.list_alt_sharp),
      //       ),
      //       FloatingActionButton(
      //         heroTag: "print",
      //         onPressed: () {},
      //         backgroundColor: Theme.of(context).primaryColor,
      //         child: Icon(Icons.print_outlined),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
