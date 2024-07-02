import 'package:axoproject/model/Company%20Model/company_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class CompanyListController extends GetxController {
  final companyList = [].obs;
  Future<void> getCompanyList() async {
    final List<Map<String, dynamic>> companys =
        await DBHelper().queryAllCompany();
    companyList.assignAll(
        companys.map((data) => CompanyModel.fromMap(data)).toList());
        print(companyList);
  }

  insertCompanyList({required List<CompanyModel> companyList}) async {
    await DBHelper().insertCompanyList(companyList);
  }

  deleteTable() async {
    await DBHelper().deleteCompanyTable();
  } 
}
