import 'dart:developer';

import 'package:axoproject/model/Pos%20Cash%20Register%20Model/pos_cash_register_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class SysDocDetailListController extends GetxController {
  final sysDocDetailList = [].obs;
  Future<void> getSysDocList() async {
    final List<Map<String, dynamic>> sysDocDetails =
        await DBHelper().queryAllSysDoc();
    sysDocDetailList.assignAll(
        sysDocDetails.map((data) => SysDocDetail.fromMap(data)).toList());
    print(sysDocDetailList);
  }

  insertSysDocList({required List<SysDocDetail> sysDocDetailList}) async {
    await DBHelper().insertSysDocList(sysDocDetailList);
  }

  deleteTable() async {
    await DBHelper().deleteSysDocTable();
  }

  updateSysDoc({required int nextNumber, required String sysDoc}) async {
    await DBHelper()
        .updateSysDocNextNumber(nextNumber: nextNumber, sysDoc: sysDoc);
    getSysDocList();
  }
}
