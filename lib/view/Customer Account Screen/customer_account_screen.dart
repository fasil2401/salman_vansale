import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/app%20controls/customer_account_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAccountScreen extends StatefulWidget {
  const CustomerAccountScreen(
    this.currentCust, {
    Key? key,
  }) : super(key: key);

  final CustomerModel currentCust;

  @override
  State<CustomerAccountScreen> createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> {
  final homeController = Get.put(HomeController());
  late final CustomerAccountController customerAccountController;
  String username = '';

  @override
  void initState() {
    super.initState();
    customerAccountController =
        Get.put(CustomerAccountController(widget.currentCust.customerID!));

    generateUrl();
  }

  generateUrl() async {
    setState(() {
      username = UserSimplePreferences.getUsername() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(
                () => customerAccountController.invoices.isEmpty
                    ? const Center(
                        child: Text(
                        'No Outstanding Invoices',
                        style: TextStyle(
                            color: AppColors.mutedColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ))
                    : GetBuilder<CustomerAccountController>(builder: (_) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _.invoices.length,
                          itemBuilder: (context, index) {
                            var item = _.invoices[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lightGrey),
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    AppColors.mutedBlueColor.withOpacity(0.3),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  children: [
                                    _buildItem(
                                      item.voucherID.toString(),
                                      DateFormatter.dateFormat.format(
                                          DateTime.parse("${item.arDate}")),
                                    ),
                                    _buildItem(
                                      'Original Amount',
                                      item.originalAmount.toString(),
                                      isBlack: true,
                                    ),
                                    _buildItem(
                                      'Amount Due',
                                      item.amountDue.toString(),
                                      isBlack: true,
                                    ),
                                    _buildItem(
                                      'Over Due Days',
                                      item.overdueDays.toString(),
                                      isBlack: true,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightGrey,
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Obx(() => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildItem('Credit Limit',
                            customerAccountController.credit.value.toString(),
                            isBlack: true),
                        _buildItem('Balance',
                            customerAccountController.balance.value.toString(),
                            isBlack: true),
                        if (customerAccountController.showInvoice.value)
                          _buildItem(
                              'Invoice',
                              customerAccountController.balance.value
                                  .toString(),
                              isBlack: true),
                        if (customerAccountController.showReturn.value)
                          _buildItem(
                              'Return',
                              customerAccountController.returnTotal.value
                                  .toString(),
                              isBlack: true),
                        if (customerAccountController.showReceipt.value)
                          _buildItem(
                              'Receipt',
                              customerAccountController.receipt.value
                                  .toString(),
                              isBlack: true),
                        _buildItem(
                            'Available',
                            customerAccountController.available.value
                                .toString(),
                            isBlack: true),
                        _buildItem('PDC amount',
                            customerAccountController.pdc.value.toString(),
                            isBlack: true),
                        _buildItem(
                            'Net Amount',
                            customerAccountController.netAmount.value
                                .toString(),
                            isBlack: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.mutedColor),
                              ),
                              Text(
                                customerAccountController.status.value,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: customerAccountController
                                                .status.value
                                                .trim()
                                                .toLowerCase() ==
                                            'active'
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ));
  }
}

Widget _buildItem(String title, String content, {bool isBlack = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: isBlack
                  ? title == 'Net Amount'
                      ? FontWeight.w500
                      : FontWeight.w400
                  : FontWeight.w500,
              color: isBlack ? AppColors.mutedColor : AppColors.primary),
        ),
        Text(
          content,
          style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedColor,
              fontWeight:
                  title == 'Net Amount' ? FontWeight.w500 : FontWeight.w400),
        ),
      ],
    ),
  );
}
