import 'package:axoproject/view/Route%20Customer%20Screen/route_customer_screen.dart';
import 'package:axoproject/view/dashboard/home.dart';
import 'package:axoproject/view/login/login_screen.dart';
import 'package:axoproject/view/route%20details/route_details_screen.dart';
import 'package:axoproject/view/server%20connect/server_connect.dart';
import 'package:axoproject/view/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class RouteManager {
  List<GetPage> _routes = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/connection',
      page: () => ServerConnectScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/routeDetails',
      page: () => RouteDetailsScreen(),
      transition: Transition.cupertino,
    ),
    
    GetPage(
      name: '/routeCustomers',
      page: () => RouteCustomerScreen(),
      transition: Transition.cupertino,
    ),
    

  ];

  get routes => _routes;
}
