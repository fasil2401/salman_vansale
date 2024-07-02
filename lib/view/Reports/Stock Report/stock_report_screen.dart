import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/report_controller.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/Reports/components.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StockReportScreen extends StatelessWidget {
  StockReportScreen({super.key});
  final reportController = Get.put(ReportController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportController.getProductList();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
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
              Obx(() => ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: reportController.productFilterList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var item = reportController.productFilterList[index];
                    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.lightBlue),
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
                                            child: Text("${item.description} ",
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
                                    height: 6,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          commonStockReportText(
                                              "Opening Stock"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText(
                                              "Sale Quantity"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText(
                                              "Return Quantity"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText("Damage"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText("On Hand"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          commonStockReportText(
                                              "${item.openingStock}"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText(
                                              "${item.saleQuantity}"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          // commonStockReportText(
                                          //     "${((item.returnQuantity ?? 0.0) - ((item.openingStock! + item.returnQuantity!) - (item.quantity! + item.saleQuantity!)))}"),
                                          commonStockReportText(
                                              "${((item.returnQuantity ?? 0.0))}"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText(
                                              "${((item.damageQuantity ?? 0.0))}"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          commonStockReportText(
                                              "${item.quantity}"),
                                        ],
                                      )
                                    ],
                                  )
                                ])));
                  })),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Theme.of(context).primaryColor,
      //     onPressed: () {},
      //     child: Icon(Icons.print_outlined)),
    );
  }
}

Widget commonStockReportText(String txt) => Text(
      txt,
      style: TextStyle(
          color: AppColors.mutedColor,
          fontSize: 16,
          fontWeight: FontWeight.w400),
    );
