import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/payment_collection_controller.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Bank%20Model/bank_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/thermal_print_helper.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/extensions.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Report%20Type/invoice_preview.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentCollectionPopup extends StatelessWidget {
  PaymentCollectionPopup({
    super.key,
  });

  final paymentCollectionController = Get.put(PaymentCollectionController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Voucher No.",
                style: TextStyle(
                    fontSize: 15,
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400),
              ),
              Obx(() => Text(
                    paymentCollectionController.voucherNumber.value,
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.mutedColor,
                        fontWeight: FontWeight.w500),
                  ))
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Payment Type  :",
                style: TextStyle(
                    fontSize: 15,
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Obx(() => ListTileTheme(
                            horizontalTitleGap: 0,
                            child: RadioListTile(
                              // contentPadding: EdgeInsets.only(left: width * 0.04),
                              visualDensity:
                                  const VisualDensity(horizontal: -4.0),
                              dense: true,
                              title: Row(
                                children: [
                                  Text(
                                    "Cash",
                                    style: TextStyle(),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              value: "Cash",
                              activeColor: Theme.of(context).primaryColor,
                              groupValue:
                                  paymentCollectionController.selected.value,
                              onChanged: (value) async {
                                if (paymentCollectionController
                                        .isUpdating.value ==
                                    false) {
                                  await paymentCollectionController
                                      .select(value.toString());
                                  paymentCollectionController.paymentVoucher();
                                }
                              },
                            ),
                          )),
                    ),
                    Flexible(
                      child: Obx(() => ListTileTheme(
                            // <-- add this
                            horizontalTitleGap: 0,
                            child: RadioListTile(
                              // contentPadding: EdgeInsets.only(left: width * 0.01),
                              visualDensity:
                                  const VisualDensity(horizontal: -4.0),
                              dense: true,
                              title: Row(
                                children: [
                                  Text(
                                    "Cheque",
                                    style: TextStyle(),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              value: "Cheque",
                              activeColor: Theme.of(context).primaryColor,
                              groupValue:
                                  paymentCollectionController.selected.value,
                              onChanged: (value) async {
                                if (paymentCollectionController
                                        .isUpdating.value ==
                                    false) {
                                  await paymentCollectionController
                                      .select(value.toString());
                                  paymentCollectionController.paymentVoucher();
                                }
                              },
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Row(
                            children: [
                              Visibility(
                                visible: paymentCollectionController
                                        .selected.value ==
                                    "Cash",
                                child: Flexible(
                                  child: cashDropDown(
                                    context,
                                    values: homeController.paymentMethodList,
                                    onChanged: (value) {
                                      paymentCollectionController
                                          .selectedPaymentMethod.value = value;
                                    },
                                    title: "Payment Type",
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: paymentCollectionController
                                        .selected.value ==
                                    "Cheque",
                                child: Flexible(
                                  child: chequeDropDown(context,
                                      values: paymentCollectionController
                                          .bankList, onChanged: (value) {
                                    paymentCollectionController
                                        .selectedBank.value = value;
                                    paymentCollectionController
                                        .selectedPaymentMethod
                                        .value = PaymentMethodModel();
                                  }, title: "Bank"),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Obx(
                  () => CommonWidgets.textField(
                    context,
                    controller:
                        paymentCollectionController.amountController.value,
                    suffixicon: false,
                    readonly: !paymentCollectionController.isAmountEditable(),
                    keyboardtype: TextInputType.number,
                    ontap: () => paymentCollectionController
                        .amountController.value
                        .selectAll(),
                    label: 'Amount',
                  ),
                ),
              ),
            ],
          ),
          Obx(() => Visibility(
                visible: paymentCollectionController.selected.value == "Cash"
                    ? false
                    : true,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CommonWidgets.textField(context,
                        suffixicon: false,
                        readonly: false,
                        controller: paymentCollectionController
                            .chequeNumberController.value,
                        keyboardtype:
                            TextInputType.numberWithOptions(decimal: true),
                        label: "Cheque No."),
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          CommonWidgets.textField(context,
              suffixicon: false,
              readonly: false,
              controller: paymentCollectionController.remarksController.value,
              keyboardtype: TextInputType.text,
              label: "Remarks"),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CommonWidgets.elevatedButton(context, onTap: () {
                  paymentCollectionController.clearDatas();
                  Navigator.pop(context);
                }, type: ButtonTypes.Secondary, text: "Cancel"),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CommonWidgets.elevatedButton(context, onTap: () async {
                  if (paymentCollectionController.selected.value == "Cheque" &&
                      paymentCollectionController
                          .chequeNumberController.value.text.isEmpty) {
                    SnackbarServices.errorSnackbar(
                        "Please Enter Cheque Number");
                    return;
                  }
                  await paymentCollectionController
                      .savePaymentCollection(context);
                  int printPreference =
                      UserSimplePreferences.getPrintPreference() ?? 1;
                  if (printPreference == 1) {
                    ThermalPrintHeplper.getConnection(
                        context,
                        paymentCollectionController.helper.value,
                        PrintLayouts.CashOrChequeReciept);
                  }else if(printPreference == 2){
                    await Get.to(() => InvoicePreviewScreen(
                        paymentCollectionController.helper.value,
                        PreviewTemplate.CashCheque,
                      ));
                  }
                  
                  Navigator.pop(context);
                }, type: ButtonTypes.Primary, text: "Save"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget cashDropDown(BuildContext context,
      {String? title,
      required List<dynamic> values,
      required Function(dynamic) onChanged}) {
    var value;
    if (paymentCollectionController.selected.value == "Cash") {
      if (paymentCollectionController.isUpdating.value) {
        value = values.firstWhere(
          (element) =>
              element.paymentMethodID ==
              paymentCollectionController
                  .selectedPaymentMethod.value.paymentMethodID,
          orElse: () => values.first as PaymentMethodModel,
        );
      } else {
        value = values.first;
      }
    }
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: value,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isCollapsed: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: mutedColor, width: 0.1),
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
      ),
      isExpanded: true,
      icon: Icon(
        Icons.arrow_drop_down_circle_outlined,
        color: Theme.of(context).primaryColor,
        size: 15,
      ),
      // buttonPadding: const EdgeInsets.only(left: 0, right: 0),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: values
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: AutoSizeText(
                '${item.displayName ?? ''}',
                minFontSize: 10,
                maxFontSize: 14,
                maxLines: 2,
                style: const TextStyle(
                  color: mutedColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      onSaved: (value) {},
    );
  }

  Widget chequeDropDown(BuildContext context,
      {String? title,
      required List<dynamic> values,
      required Function(dynamic) onChanged}) {
    var value;
    if (paymentCollectionController.selected.value == "Cheque") {
      if (paymentCollectionController.isUpdating.value == true) {
        value = values.firstWhere(
          (element) =>
              element.bankCode ==
              paymentCollectionController.selectedBank.value.bankCode,
          orElse: () => BankModel(),
        );
      }
    }
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft, dropdownFullScreen: true,
      dropdownWidth: MediaQuery.of(context).size.width * 0.8,
      value: value,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isCollapsed: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: mutedColor, width: 0.1),
        ),
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
      ),
      isExpanded: true,
      icon: Icon(
        Icons.arrow_drop_down_circle_outlined,
        color: Theme.of(context).primaryColor,
        size: 15,
      ),
      // buttonPadding: const EdgeInsets.only(left: 0, right: 0),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: values
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: AutoSizeText(
                '${item.bankCode ?? ''} - ${item.bankName ?? ''}',
                minFontSize: 10,
                maxFontSize: 14,
                maxLines: 2,
                style: const TextStyle(
                  color: mutedColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      onSaved: (value) {},
    );
  }
}
