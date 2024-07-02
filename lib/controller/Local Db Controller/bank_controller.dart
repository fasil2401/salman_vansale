import 'package:axoproject/model/Bank%20Model/bank_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class BankListController extends GetxController {
  final bankList = [].obs;
  Future<void> getBankList() async {
    final List<Map<String, dynamic>> banks =
        await DBHelper().queryAllBank();
    bankList.assignAll(
        banks.map((data) => BankModel.fromMap(data)).toList());
        print(bankList);
  }

  insertBankList({required List<BankModel> bankList}) async {
    await DBHelper().insertBankList(bankList);
  }

  deleteTable() async {
    await DBHelper().deleteBankTable();
  } 
}