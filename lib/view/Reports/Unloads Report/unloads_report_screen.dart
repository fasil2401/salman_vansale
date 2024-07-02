import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/utils/Calculations/date_range_selector.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class UnloadsReportScreen extends StatelessWidget {
  UnloadsReportScreen({super.key});
  final reportController = Get.put(ReportController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Obx(() => GFAccordion(
              title: 'Filter',
              showAccordion: false,
              titleBorderRadius: BorderRadius.circular(5),
              expandedTitleBackgroundColor: Theme.of(context).primaryColor,
              collapsedTitleBackgroundColor: Colors.black38,
              collapsedIcon:
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              expandedIcon:
                  const Icon(Icons.keyboard_arrow_up, color: Colors.white),
              textStyle: TextStyle(
                color: Colors.white,
              ),
              titlePadding:
                  EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
              contentChild: dateReportFilter(
                  context,
                  reportController.dateIndex.value,
                  (value) {
                    selectedValue = value;
                    reportController.selectDateRange(selectedValue.value,
                        DateRangeSelector.dateRange.indexOf(selectedValue));
                  },
                  reportController.fromDate.value,
                  reportController.isFromDate.value,
                  () {
                    reportController.selectDate(context, true);
                  },
                  reportController.toDate.value,
                  reportController.isToDate.value,
                  () {
                    reportController.selectDate(context, false);
                  },
                  () {}),
            )),
        commonDivider(),
        Expanded(
          child: Center(
            child: Text(
              "No Data",
              style: TextStyle(color: AppColors.lightGrey),
            ),
          ),
        )
      ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       FloatingActionButton(
      //         backgroundColor: Theme.of(context).primaryColor,
      //         onPressed: () {},
      //         child: Icon(Icons.list_alt_sharp),
      //       ),
      //       FloatingActionButton(
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
