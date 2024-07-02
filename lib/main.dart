import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:axoproject/services/Themes/app_theme.dart';
import 'package:axoproject/services/Themes/custom_theme.dart';
import 'package:axoproject/utils/Routes/route_manger.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  await DBHelper().database;
  await UserSimplePreferences.init();
  String themeKey = UserSimplePreferences.getTheme() ?? MyThemes.blueTheme;
  runApp(CustomTheme(
    initialThemeKey: themeKey,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Axolon Vansale',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.of(context),
        initialRoute: RouteManager().routes[0].name,
        getPages: RouteManager().routes,
        // home: SplashScreen(),
      );
    });
  }
}
