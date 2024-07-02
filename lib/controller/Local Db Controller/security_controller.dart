import 'package:axoproject/model/Security%20Model/security_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class SecurityListController extends GetxController {
  final securityList = [].obs;
  Future<void> getSecurityList() async {
    final List<Map<String, dynamic>> securitys =
        await DBHelper().queryAllSecurity();
    securityList.assignAll(
        securitys.map((data) => SecurityModel.fromMap(data)).toList());
        print(securityList);
  }

  insertSecurityList({required List<SecurityModel> securityList}) async {
    await DBHelper().insertSecurityList(securityList);
  }

  deleteTable() async {
    await DBHelper().deleteSecurityTable();
  } 
}