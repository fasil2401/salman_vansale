import 'package:axoproject/model/Local%20Db%20Model/Customer%20Visit%20Log%20Model/customer_visit_log_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class CustomerVisitLocalController extends GetxController {
final customerVisits = <CustomerVisitApiModel>[].obs;

  insertCustomerVisit({required CustomerVisitApiModel header}) async {
    await DBHelper().insertCustomerVisit(header);
  }

  getAllCustomerVisit() async {
    final List<Map<String, dynamic>> headers =
        await DBHelper().queryAllCustomerVisits();
    customerVisits.assignAll(
        headers.map((data) => CustomerVisitApiModel.fromMap(data)).toList());
  }

  deleteCustomerVisitTable() async {
    await DBHelper().deleteCustomerVisitTable();
  }
  updateEndVisit({required String endTime,
      required String closeLat,
      required String closeLong,
      required String visitID}) async{
    await DBHelper().updateVisitLog(endTime, closeLat, closeLong, visitID);
  }

  updateCustomerVisit(
      {required String startTime,
      required int isSynced,
      required int isError,
      required String error}) async {
    await DBHelper()
        .updateCustomerVisit(startTime, isSynced, isError, error);
  }
}
