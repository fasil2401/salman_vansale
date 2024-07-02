import 'package:axoproject/model/Route%20Model/route_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class RouteListController extends GetxController {
  final routeList = [].obs;
  Future<RxList<dynamic>?> getRouteList() async {
    final List<Map<String, dynamic>> routes =
        await DBHelper().queryAllRoute();
    routeList.assignAll(
        routes.map((data) => RouteModel.fromMap(data)).toList());
        print(routeList);
        return routeList;
  }

  insertRouteList({required List<RouteModel> routeList}) async {
    await DBHelper().insertRouteList(routeList);
  }

  deleteTable() async {
    await DBHelper().deleteRouteTable();
  } 
}
