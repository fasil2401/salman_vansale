import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Customer%20Tasks%20Screen/customer_tasks_screen.dart';
import 'package:axoproject/view/Customer%20Tasks%20Tab%20Screen/customer_tasks_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomerContactScreen extends StatefulWidget {
  const CustomerContactScreen(
    this.currentCust, {
    Key? key,
  }) : super(key: key);

  final CustomerModel currentCust;

  @override
  State<CustomerContactScreen> createState() => _CustomerContactScreenState();
}

class _CustomerContactScreenState extends State<CustomerContactScreen> {
  final homeController = Get.put(HomeController());
  String username = '';

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.lightGrey,
                    child: SvgPicture.asset(
                      AppIcons.customer,
                      color: AppColors.mutedColor,
                      height: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.currentCust.customerID.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'Name',
                      text: widget.currentCust.customerName.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'Address 1',
                      text: widget.currentCust.address1 != null
                          ? widget.currentCust.address1!.trim()
                          : ''),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'Address 2',
                      text: widget.currentCust.address2 != null
                          ? widget.currentCust.address2!.trim()
                          : ''),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'City', text: widget.currentCust.city ?? ''),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'Phone', text: widget.currentCust.phone1 ?? ''),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'Mobile', text: widget.currentCust.phone2 ?? ''),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerTaskTabScreen.buildDetailRow(
                      title: 'Email', text: widget.currentCust.email ?? ''),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
