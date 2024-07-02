import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Customer%20Account%20Screen/customer_account_screen.dart';
import 'package:axoproject/view/Customer%20Contact%20Screen/customer_contact_screen.dart';
import 'package:axoproject/view/Customer%20Tasks%20Screen/customer_tasks_screen.dart';
import 'package:flutter/material.dart';

class CustomerTaskTabScreen extends StatefulWidget {
  // const CustomerTaskTabScreen({Key? key}) : super(key: key);

  static Row buildDetailRow({required String title, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.mutedColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedColor,
                fontWeight: title.toLowerCase() == 'name'
                    ? FontWeight.w500
                    : FontWeight.w400),
          ),
        ),
      ],
    );
  }

  const CustomerTaskTabScreen(
    this.currentCust, {
    super.key,
  });
  final CustomerModel currentCust;

  @override
  _CustomerTaskTabScreenState createState() => _CustomerTaskTabScreenState();
}

class _CustomerTaskTabScreenState extends State<CustomerTaskTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isVisitStarted =
            UserSimplePreferences.getIsVisitStarted() ?? false;
        if (isVisitStarted) {
          SnackbarServices.errorSnackbar('Please End Visit before leaving!');
        }
        return !isVisitStarted;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Details'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              color: AppColors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.mutedColor,
                tabs: const [
                  Tab(
                    text: 'Tasks',
                    icon: Icon(Icons.task_alt),
                  ),
                  Tab(text: 'Account', icon: Icon(Icons.credit_card)),
                  Tab(text: 'Contact', icon: Icon(Icons.contact_mail)),
                ],
              ),
            ),
          ),
        ),
        body: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 13.0,
            color: Colors.black,
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              CustomerTasksScreen(
                widget.currentCust,
              ),
              CustomerAccountScreen(widget.currentCust),
              CustomerContactScreen(widget.currentCust),
            ],
          ),
        ),
        // bottomNavigationBar:
      ),
    );
  }
}
