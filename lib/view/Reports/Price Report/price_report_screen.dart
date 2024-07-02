import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PriceReportScreen extends StatelessWidget {
  PriceReportScreen({super.key});
  final reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportController.getProductList();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.textField(
                      context,
                      suffixicon: true,
                      readonly: false,
                      keyboardtype: TextInputType.text,
                      label: 'Search',
                      icon: Icons.search,
                      onchanged: (value) {
                        reportController.searchItems(
                          value,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    dropDown(context),
                  ]),
            ),
            commonDivider(),
            SizedBox(
              height: 10,
            ),
            Obx(() => ListView.builder(
                itemCount: reportController.productFilterList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var item = reportController.productFilterList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: AppColors.lightGrey)),
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.boxBusiness,
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text("${item.description}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text("${item.productID}",
                                              style: TextStyle(
                                                color: AppColors.mutedColor,
                                                fontSize: 15,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Unit",
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                      Text("${item.unitID}",
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Price",
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                      Text("${item.standardPrice}",
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  )
                                ]))),
                  );
                })),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: Icon(Icons.print_outlined),
      // ),
    );
  }

  Widget dropDown(
    BuildContext context,
  ) {
    final lists = ["Standard"];
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: "Standard",
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //isCollapsed: true,
        isDense: true,
        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 7),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: mutedColor, width: 0.1),
        ),
        labelText: "Price Type",
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
      ),
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: AppColors.mutedColor,
        size: 15,
      ),
      // buttonPadding: const EdgeInsets.only(left: 0, right: 0),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: lists
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: AutoSizeText(
                '${item}',
                minFontSize: 10,
                maxFontSize: 14,
                maxLines: 1,
                style: const TextStyle(
                  color: mutedColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {},
      onSaved: (value) {},
    );
  }
}
