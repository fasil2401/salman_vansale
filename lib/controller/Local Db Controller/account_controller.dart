import 'package:axoproject/model/Account%20Model/account_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class AccountListController extends GetxController {
  final accountList = <AccountModel>[].obs;
  Future<void> getAccountList() async {
    final List<Map<String, dynamic>> accounts =
        await DBHelper().queryAllAccount();
    accountList.assignAll(
        accounts.map((data) => AccountModel.fromMap(data)).toList());
        print(accountList);
  }

  insertAccountList({required List<AccountModel> accountList}) async {
    await DBHelper().insertAccountList(accountList);
  }

  deleteTable() async {
    await DBHelper().deleteAccountTable();
  } 
}