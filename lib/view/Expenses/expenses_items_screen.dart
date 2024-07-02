import 'package:axoproject/controller/app%20controls/expenses_controller.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/Expenses/expenses_popup.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class ExpensesItemsScreen extends StatelessWidget {
  ExpensesItemsScreen({super.key});
  final expensesController = Get.put(ExpensesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Items'),
      ),
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonWidgets.textField(
                    context,
                    suffixicon: true,
                    readonly: false,
                    keyboardtype: TextInputType.text,
                    label: 'Search',
                    icon: Icons.search,
                    onchanged: (p0) {},
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(
              () => expensesController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: GetBuilder<ExpensesController>(
                        builder: (_) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                expensesController.expensesFilterList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var expenses = _.expensesFilterList[index];
                              return InkWell(
                                  onTap: () async {
                                    _.clearPopup();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          content: ExpensesPopUpScreen(
                                            index: index,
                                            isUpdate: false,
                                            expenses: expenses,
                                            taxList: _.taxList,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: _buildRows(
                                    context,
                                    code: "${expenses.accountID}",
                                    name: '${expenses.accountName}',
                                    isHeader: false,
                                  ));
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 20,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildRows(context, code: 'Code', name: 'Name', isHeader: true),
      ),
    );
  }

  Row _buildRows(BuildContext context,
      {required String code, required String name, required bool isHeader}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            code,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: isHeader
                  ? Theme.of(context).primaryColor
                  : AppColors.mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
