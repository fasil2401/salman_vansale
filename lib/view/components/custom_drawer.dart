import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/components/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 25.w,
                  width: 25.w,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // SizedBox(
                //   width: 2.w,
                // ),
                LargeText(
                  title: 'User',
                  color: mutedColor,
                )
              ],
            ),
            SizedBox(
              height: 10.w,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const DrawerTile(
                title: 'Scan',
                icon: 'assets/icons/drawer/line-scan.svg',
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: DrawerTile(
                title: 'Location',
                icon: 'assets/icons/drawer/search-location.svg',
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: DrawerTile(
                title: 'Synchronization',
                icon: 'assets/icons/drawer/cloud.svg',
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: DrawerTile(
                title: 'Privacy Policy',
                icon: 'assets/icons/drawer/privacy.svg',
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: DrawerTile(
                title: 'Local Backup',
                icon: 'assets/icons/drawer/backup.svg',
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: DrawerTile(
                title: 'Logout',
                icon: 'assets/icons/drawer/logout.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final String icon;
  final bool isRed;
  final bool isLoading;
  const DrawerTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.isRed = false,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      strokeWidth: 2,
                    ),
                  )
                : SvgPicture.asset(
                    icon,
                    height: 25,
                    width: 25,
                    color: isRed == true
                        ? AppColors.redPrimary
                        : Theme.of(context).primaryColor,
                  ),
          ),
          SizedBox(
            width: 15,
          ),
          LargeText(
            title: title,
            color: isRed == true ? AppColors.redPrimary : mutedColor,
          ),
        ],
      ),
    );
  }
}
