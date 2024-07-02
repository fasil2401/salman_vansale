import 'dart:developer';

import 'package:axoproject/model/Pos%20Cash%20Register%20Model/pos_cash_register_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class PosCashRegisterListController extends GetxController {
  final posCashRegisterList = [].obs;
  Future<List<Map<String, dynamic>>> getCashRegisterList() async {
    final List<Map<String, dynamic>> posCashRegisters =
        await DBHelper().queryAllCashRegister();
    posCashRegisterList.assignAll(posCashRegisters
        .map((data) => PosCashRegisterModel.fromMap(data))
        .toList());
    //   log(posCashRegisters[0]['ReceiptDocID'].toString(), name: 'Register list');
    return posCashRegisters;
  }

  insertCashRegisterList(
      {required List<PosCashRegisterModel> posCashRegisterList}) async {
    await DBHelper().insertCashRegisterList(posCashRegisterList);
    getCashRegisterList();
  }

  deleteTable() async {
    await DBHelper().deleteCashRegisterTable();
  }
}
