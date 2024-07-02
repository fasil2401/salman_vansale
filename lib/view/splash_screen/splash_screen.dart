
import 'package:axoproject/controller/App%20Controls/splash_screen_controller.dart';
import 'package:axoproject/controller/ui%20controls/package_info_controller.dart';
import 'package:axoproject/utils/constants/asset_paths.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
final _contextKey = GlobalKey();
  final packageInfoCOntroller = Get.put(PackageInfoController());
  final splashScreenController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    splashScreenController.enterApp(context);
    return Scaffold(
      body: Stack(
        key: _contextKey,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: width * 0.9,
              child: Image.asset(
                Images.logo_gif,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      'version :${packageInfoCOntroller.version.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: mutedColor,
                      ),
                    ),
                  ),
                  Text(
                    'License :Evaluation',
                    style: TextStyle(
                      fontSize: 12,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
