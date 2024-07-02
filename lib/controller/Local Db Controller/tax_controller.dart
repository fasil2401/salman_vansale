import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class TaxListController extends GetxController {
  final taxList = <TaxModel>[].obs;
  Future<void> getTaxList() async {
    final List<Map<String, dynamic>> taxs =
        await DBHelper().queryAllTax();
    taxList.assignAll(
        taxs.map((data) => TaxModel.fromMap(data)).toList());
        print(taxList);
  }

  insertTaxList({required List<TaxModel> taxList}) async {
    await DBHelper().insertTaxList(taxList);
  }

  deleteTable() async {
    await DBHelper().deleteTaxTable();
  } 
}