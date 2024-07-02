import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/utils/Calculations/date_range_selector.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

Column dateReportFilter(
    BuildContext context,
    int dateindex,
    Function(Object?) onchanged,
    DateTime fromDate,
    bool isFromDate,
    Function() onTapOfIsFromDate,
    DateTime toDate,
    bool isToDate,
    Function() onTapOfIsToDate,
    Function() onTapOfApply) {
  return Column(
    children: [
      Row(
        children: [
          Flexible(
            child: DropdownButtonFormField2(
              isDense: true,
              value: DateRangeSelector.dateRange[dateindex],
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Dates',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
                // contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
              buttonPadding: const EdgeInsets.only(left: 0, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              items: DateRangeSelector.dateRange
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            item.label,
                            minFontSize: 10,
                            maxLines: 1,
                            maxFontSize: 14,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onchanged,
              onSaved: (value) {},
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Flexible(
            child: _buildTextFeild(
                context: context,
                controller: TextEditingController(
                  text: DateFormatter.dateFormat.format(fromDate).toString(),
                ),
                label: 'From Date',
                enabled: isFromDate,
                isDate: true,
                onTap: onTapOfIsFromDate),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: _buildTextFeild(
                context: context,
                controller: TextEditingController(
                  text: DateFormatter.dateFormat.format(toDate).toString(),
                ),
                label: 'To Date',
                enabled: isToDate,
                isDate: true,
                onTap: onTapOfIsToDate),
          ),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: onTapOfApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: 'Rubik',
            ),
          ),
        ),
      ),
    ],
  );
}

TextField _buildTextFeild(
    {required String label,
    required Function() onTap,
    required bool enabled,
    required bool isDate,
    required BuildContext context,
    required TextEditingController controller,
    var header}) {
  return TextField(
    controller: controller,
    readOnly: true,
    enabled: enabled,
    onTap: onTap,
    style: TextStyle(
      fontSize: 14,
      color: enabled ? Theme.of(context).primaryColor : AppColors.mutedColor,
      fontWeight: FontWeight.w400,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 14,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w400,
      ),
      isCollapsed: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      suffix: Icon(
        isDate ? Icons.calendar_month : Icons.location_pin,
        size: 15,
        color: enabled ? Theme.of(context).primaryColor : AppColors.mutedColor,
      ),
    ),
  );
}

Widget tile(String sysDocVoucher, String qtyOrPaymentType, String total,
    String date, int isSynced) {
  return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AutoSizeText(
                sysDocVoucher,
                maxLines: 2,
                maxFontSize: 14,
                minFontSize: 12,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                qtyOrPaymentType,
                maxLines: 2,
                maxFontSize: 12,
                minFontSize: 10,
              ),
            ),
            Row(
              children: [
                AutoSizeText(
                  "Total : ",
                  maxFontSize: 12,
                  minFontSize: 10,
                ),
                AutoSizeText(
                  total,
                  maxLines: 2,
                  maxFontSize: 12,
                  minFontSize: 10,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              DateFormatter.reportDateFormat.format(DateTime.parse(date)),
              maxLines: 2,
              maxFontSize: 12,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.mutedColor),
            ),
            AutoSizeText(isSynced == 0 ? "Not Synced" : "Synced",
                maxLines: 2,
                maxFontSize: 12,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSynced == 0 ? AppColors.error : AppColors.success,
                ))
          ],
        ),
        SizedBox(
          height: 5,
        ),
        // Row(
        //     mainAxisAlignment:
        //         MainAxisAlignment.spaceBetween,
        //     children: [
        //       AutoSizeText(
        //         "Customer : ${item.customerId ?? ""}",
        //         maxLines: 2,
        //         maxFontSize: 12,
        //         minFontSize: 10,
        //         style: const TextStyle(
        //             color: AppColors.mutedColor),
        //       ),
        //       // if (index % 2 == 0)
        //       Row(
        //         mainAxisAlignment:
        //             MainAxisAlignment.end,
        //         children: [
        //           if (item.isSynced == 0)
        //             InkWell(
        //               onTap: () {
        // salesInvoiceController
        //     .editInvoiceFromReport(
        //         item);
        // reportController
        //     .navigateSalesInvoice();
        //               },
        //               child: Icon(
        //                   Icons
        //                       .mode_edit_outline_outlined,
        //                   color:
        //                       AppColors.primary),
        //             ),
        //           InkWell(
        //             onTap: () async {
        // await salesInvoiceController
        //     .editInvoiceFromReport(
        //         item);
        // salesInvoiceController
        //     .printInvoice();
        //             },
        //             child: Icon(
        //               Icons
        //                   .local_printshop_outlined,
        //               color: Theme.of(context)
        //                   .primaryColor,
        //             ),
        //           ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           if (item.isSynced == 0)
        //             InkWell(
        //               child: Icon(
        //                 Icons.delete_outline,
        //                 size: 18,
        //                 color: AppColors.error,
        //               ),
        //               onTap: () {
        // showDialog<String>(
        //   context: context,
        //   builder: (BuildContext
        //           context) =>
        //       AlertDialog(
        //     title: const Text(
        //       'Delete',
        //       style: TextStyle(
        //           fontSize: 18),
        //     ),
        //     content: const Text(
        //       'Do you want to delete the report ?',
        //       style: TextStyle(
        //           fontSize: 15),
        //     ),
        //     shape: RoundedRectangleBorder(
        //         borderRadius:
        //             BorderRadius
        //                 .circular(
        //                     20)),
        //     actions: <Widget>[
        //       TextButton(
        //         onPressed: () =>
        //             Navigator.pop(
        //           context,
        //         ),
        //         child: const Text(
        //             'Cancel',
        //             style: TextStyle(
        //                 color: AppColors
        //                     .mutedColor)),
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           salesInvoiceController
        //               .deleteSavedRequest(
        //                   item.voucherid ??
        //                       '',
        //                   index);
        //           _.deleteSalesInvoiceItem(
        //               index);
        //           Navigator.pop(
        //               context);
        //         },
        //         child: Text(
        //           'Sure',
        //           style: TextStyle(
        //               color: Theme.of(
        //                       context)
        //                   .primaryColor),
        //         ),
        //       ),
        //     ],
        //   ),
        // );
        //               },
        //             ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           if (item.isError == 1)
        //             InkWell(
        //               onTap: () {
        //                 showDialog(
        //                     context: context,
        //                     builder: (BuildContext
        //                         context) {
        //                       return CommonWidgets
        //                           .buildAlertDialog(
        //                               title: CommonWidgets
        //                                   .popupTitle(
        //                                       onTap:
        //                                           () {
        //                                         Navigator.pop(context);
        //                                       },
        //                                       title:
        //                                           'Error'),
        //                               context:
        //                                   context,
        //                               content: Text(item
        //                                   .error
        //                                   .toString()));
        //                     });
        //               },
        //               child: const Text(
        //                 "Error Log",
        //                 style: TextStyle(
        //                     color:
        //                         AppColors.error,
        //                     fontSize: 12),
        //               ),
        //             )
        //         ],
        //       ),
        //     ]),
        // const SizedBox(
        //   height: 5,
        // ),

        //   Visibility(
        //       visible: inventoryIssueReturnController
        //                       .showErrors.value ==
        //                   true &&
        //               item.isError == 1 &&
        //               index ==
        //                   inventoryIssueReturnController
        //                       .errorIndex.value
        //           ? true
        //           : false,
        //       child: Text(
        //         "${item.error}",
        //         style: TextStyle(
        //             fontSize: 10, color: AppColors.error),
        //       ))
        // ]),
      ]));
}

Divider commonDivider() => Divider(
      thickness: 7,
      color: AppColors.lightGrey,
    );

Widget slidableWidget(
        int isSynced,
        Function(dynamic) onTapOfPrint,
        Function(dynamic) onTapOfEdit,
        Function(dynamic) onTapOfView,
        Function() onTapOfDelete,
        BuildContext context,
        String key,
        Widget child,
        {int isError = 0,
        String error = ""}) =>
    Slidable(
        key: Key(key),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            CustomSlidableAction(
                backgroundColor: AppColors.primary,
                onPressed: onTapOfPrint,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.print),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // if (isError == 0)
                    //   AutoSizeText(
                    //     "Print",
                    //     minFontSize: 10,
                    //     maxFontSize: 12,
                    //   )
                  ],
                )),
            if (isSynced == 0 ? true : false)
              CustomSlidableAction(
                  backgroundColor: AppColors.success,
                  onPressed: onTapOfEdit,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.edit),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // if (isError == 0)
                      //   AutoSizeText(
                      //     "Edit",
                      //     minFontSize: 10,
                      //     maxFontSize: 12,
                      //     style: TextStyle(color: AppColors.white),
                      //   )
                    ],
                  )),
            if (isSynced == 0 ? true : false)
              CustomSlidableAction(
                  backgroundColor: AppColors.error,
                  onPressed: (value) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          'Delete',
                          style: TextStyle(fontSize: 18),
                        ),
                        content: const Text(
                          'Do you want to delete the report ?',
                          style: TextStyle(fontSize: 15),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(
                              context,
                            ),
                            child: const Text('Cancel',
                                style: TextStyle(color: AppColors.mutedColor)),
                          ),
                          TextButton(
                            onPressed: onTapOfDelete,
                            child: Text(
                              'Sure',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.delete),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // if (isError == 0)
                      //   AutoSizeText(
                      //     "Delete",
                      //     minFontSize: 8,
                      //     maxFontSize: 10,
                      //     maxLines: 1,
                      //   )
                    ],
                  )),
            CustomSlidableAction(
                backgroundColor: AppColors.white,
                onPressed: onTapOfView,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.preview,
                      color: AppColors.primary,
                      height: 18,
                    ),
                  ],
                )),
            if (isError == 1)
              CustomSlidableAction(
                  backgroundColor: Colors.orange.shade700,
                  onPressed: (val) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CommonWidgets.buildAlertDialog(
                              title: CommonWidgets.popupTitle(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  title: 'Error'),
                              context: context,
                              content: Text(error.toString()));
                        });
                  },
                  child: SvgPicture.asset(AppIcons.info)),
          ],
        ),
        child: child);
Divider listDivider(BuildContext context) => Divider(
      indent: MediaQuery.of(context).size.width *
          0.49, // Indent to move it to the right
      endIndent: 0.0, // No end indent
      thickness: 1, // Adjust the thickness as needed
    );
