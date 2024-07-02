import 'package:axoproject/controller/app%20controls/expenses_controller.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/view/Expenses/expenses_items_screen.dart';
import 'package:axoproject/view/Expenses/expenses_popup.dart';
import 'package:axoproject/view/components/dragging_button.dart';
import 'package:axoproject/view/components/summary_card.dart';
import 'package:axoproject/view/components/sysdoc_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({super.key});
  final expensesController = Get.put(ExpensesController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await expensesController.clearGrid();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Expenses'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<ExpensesController>(
                    builder: (_) {
                      return SysDocRow(
                          onTap: () async {
                            // await _.selectSysDoc(context);
                          },
                          sysDocIdController: _.sysDocIdController.value,
                          sysDocSuffixLoading: _.sysDocSuffixLoading.value,
                          voucherIdController: _.voucherIdController.value,
                          voucherSuffixLoading: _.voucherSuffixLoading.value);
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  // tableHeader(context),
                  Obx(() => Text(
                      'Expense Detail ${expensesController.selectedItems.length}')),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Expanded(
                    child: GetBuilder<ExpensesController>(
                      builder: (_) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _.selectedItems.length,
                          itemBuilder: (context, index) {
                            ItemModel item = _.selectedItems[index];
                            return Slidable(
                                key: const Key('expenses_list'),
                                startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                        backgroundColor: Colors.green[100]!,
                                        foregroundColor: Colors.green,
                                        icon: Icons.mode_edit_outlined,
                                        onPressed: (val) async {
                                          _.amountController.value.text =
                                              "${item.amount}";
                                          _.taxAmount.value =
                                              item.taxAmount ?? 0.0;
                                          _.selectedTax.value =
                                              item.tax ?? TaxModel();
                                          double tax =
                                              _.selectedTax.value.taxRate ??
                                                  0.0;
                                          int selectedTax = tax.round();
                                          _.taxPecentage.value = selectedTax;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                content: ExpensesPopUpScreen(
                                                  index: index,
                                                  isUpdate: true,
                                                  expenses: item,
                                                  taxList: _.taxList,
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red[100]!,
                                      foregroundColor: Colors.red,
                                      icon: Icons.delete,
                                      onPressed: (val) {
                                        _.deleteItem(index);
                                      },
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.expense?.accountID ?? ''} - ${item.expense?.accountName ?? ''}'
                                                .trim(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.mutedColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Amount : ${item.amount} + ${item.taxAmount?.toStringAsFixed(2)} = ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.mutedColor),
                                              ),
                                              Text(
                                                ' ${((item.amount ?? 0.0) + (item.taxAmount ?? 0.0)).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.mutedColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<ExpensesController>(
                    builder: (_) {
                      return SummaryCard(
                        discount: '',
                        isDiscount: false,
                        onTap: () {},
                        onSave: () {
                          _.saveExpenseTransaction(context);
                        },
                        onClear: () {
                          _.clearGrid();
                        },
                        creditToggle: false,
                        returnToggle: false,
                        onCreditToggle: (value) {},
                        onReturnToggle: (value) {},
                        isLoading: false,
                        subTotal:
                            InventoryCalculations.formatPrice(_.subTotal.value),
                        tax:
                            InventoryCalculations.formatPrice(_.totalTax.value),
                        total: InventoryCalculations.formatPrice(_.total.value),
                        isSaveActive: true,
                        isSyncAvailable: false,
                      );
                    },
                  )
                ],
              ),
            ),
            DragableButton(
              onTap: () {
                expensesController.getExpensesList();
                showDialog(
                  context: context,
                  barrierDismissible:
                      true, // Set this to true if you want to close the dialog by tapping outside
                  builder: (BuildContext context) {
                    return Dialog(
                      // Optional: You can customize the dialog's shape, background color, etc.
                      // elevation: 0, // Remove shadow
                      insetPadding: EdgeInsets.zero,
                      backgroundColor:
                          Colors.transparent, // Make background transparent
                      child: Container(
                          color: AppColors.darkGreen,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ExpensesItemsScreen()),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
