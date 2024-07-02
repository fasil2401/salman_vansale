import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:get/get.dart';

class UserActivityLogLocalController extends GetxController {
  final activityLogList = <UserActivityLogModel>[].obs;
  Future<void> getActivityLogList() async {
    final List<Map<String, dynamic>> activityLog =
        await DBHelper().queryAllActivities();
    activityLogList.assignAll(
        activityLog.map((data) => UserActivityLogModel.fromMap(data)).toList());
    // print(activityLogList);
  }

  insertactivityLogList({required UserActivityLogModel activityLog}) async {
    await DBHelper().insertUserActivityLog(activityLog);
  }

  deleteTable() async {
    await DBHelper().deleteUserActivityLogTable();
  }

  updateUserActivity(
      {required String voucherId,
      required int isSynced,
      required int isError,
      required String error,
      required String docNo}) async {
    await DBHelper()
        .updateActivityLog(voucherId, isSynced, isError, error, docNo);
  }
}
