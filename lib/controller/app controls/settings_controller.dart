import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class SettingsScreenController extends GetxController {
  // var printConnection = (UserSimplePreferences.getPrintConnection() ?? 0).obs;
  // var printPaper = (UserSimplePreferences.getPrintPaperSize() ?? 0).obs;
  var printConnection = 0.obs;
  var printPaper = (PaperOptions.values.indexOf(PaperOptions.values.firstWhere(
      (element) =>
          element.value ==
          (UserSimplePreferences.getPrintPaperSize() ?? 1)))).obs;
  var printPreference = (PrintPreference.values.indexOf(PrintPreference.values
      .firstWhere((element) =>
          element.value ==
          (UserSimplePreferences.getPrintPreference() ?? 1)))).obs;
  var printCount = (UserSimplePreferences.getPrintCount() ?? 1).obs;

  incrementCount() async {
    printCount.value++;
    await UserSimplePreferences.setPrintCount(printCount.value);
    update();
  }

  decrementCount() async {
    if (printCount.value > 1) {
      printCount.value--;
      await UserSimplePreferences.setPrintCount(printCount.value);
      update();
    }
  }
}
