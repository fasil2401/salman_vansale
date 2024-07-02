import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class ReportTypeController extends GetxController {
  var selectedOption = getSelectedTemplate().obs;

  saveDefaultTemplate() {
    int printTemplate = 0;
    switch (selectedOption.value) {
      case 'Default 1':
        printTemplate = 1;
        break;
      case 'Default 2':
        printTemplate = 2;
        break;
      case 'Default 3':
        printTemplate = 3;
        break;
      case 'Default 4':
        printTemplate = 4;
        break;
      case 'Default 5':
        printTemplate = 5;
        break;
      case 'Default 6':
        printTemplate = 10;
        break;
      case 'Default 7':
        printTemplate = 11;
        break;
      default:
    }
    UserSimplePreferences.setPrintTemplate(printTemplate);
    SnackbarServices.successSnackbar(
        'Print Template Saved as ${selectedOption.value}');
  }

  static String getSelectedTemplate() {
    String template = '';
    int index = UserSimplePreferences.getPrintTemplate() ?? 1;

    switch (index) {
      case 1:
        template = 'Default 1';
        break;
      case 2:
        template = 'Default 2';
        break;
      case 3:
        template = 'Default 3';
        break;
      case 4:
        template = 'Default 4';
        break;
      case 5:
        template = 'Default 5';
        break;
      case 10:
        template = 'Default 6';
        break;
      case 11:
        template = 'Default 7';
        break;
      default:
    }
    return template;
  }
}
