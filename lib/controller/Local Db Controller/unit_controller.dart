import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class UnitListController extends GetxController {
  final unitList = <UnitModel>[].obs;
  Future<void> getUnitList() async {
    final List<Map<String, dynamic>> units =
        await DBHelper().queryAllUnit();
    unitList.assignAll(
        units.map((data) => UnitModel.fromMap(data)).toList());
        // print(unitList);
  }

  insertUnitList({required List<UnitModel> unitList}) async {
    await DBHelper().insertUnitList(unitList);
  }

  deleteTable() async {
    await DBHelper().deleteUnitTable();
  } 
}