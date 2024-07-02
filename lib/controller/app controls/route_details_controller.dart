import 'package:axoproject/controller/Api%20Controllers/batch_sync_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/controller/app%20controls/sync_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class RouteDetailsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  var customerList = <CustomerModel>[].obs;
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final customerControler = Get.put(CustomerListController());
  final batchSyncController = Get.put(BatchSyncController());
  final syncController = Get.put(SyncController());
  var isStartingRoute = false.obs;

  getAllCustomers() async {
    customerList.value = (await customerControler.getCustomerList())!.value
        as List<CustomerModel>;
    update();
  }

  startBatch() async {
    try {
      isStartingRoute.value = true;
      await batchSyncController.openBatch();
      if (UserSimplePreferences.getBatchID() != null &&
          UserSimplePreferences.getBatchID()! > 0) {
        await syncController.syncCashRegister(isResyncing: true);
        await syncController.syncCustomer(isResyncing: true);
        await syncController.syncProducts(isResyncing: true);
        await activityLogLocalController.insertactivityLogList(
            activityLog: UserActivityLogModel(
                sysDocId: "",
                voucherId: "",
                activityType: ActivityTypes.other.value,
                date: DateTime.now().toIso8601String(),
                description: "Start Route",
                machine: UserSimplePreferences.getDeviceInfo(),
                userId: UserSimplePreferences.getUsername(),
                isSynced: 0));
        Get.offAllNamed('/routeCustomers');

        // Get.to(() => RouteCustomerScreen());
      } else {
        SnackbarServices.errorSnackbar("Batch not opened");
      }
    } catch (e) {
    } finally {
      isStartingRoute.value = false;
    }
  }
}
