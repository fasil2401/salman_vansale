import 'package:axoproject/utils/package_info/package_info.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class PackageInfoController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  var _packageInfo = ''.obs;
  get version => _packageInfo;

  Map<String, dynamic> packageInfo = {};

  Future init() async {
    final packageInfo = await PackageInfoApi.getInfo();

    print(packageInfo);

    final newPackageInfo = {
      ...packageInfo,
    };

    this.packageInfo = newPackageInfo;
    _packageInfo.value = packageInfo['version'];
    await UserSimplePreferences.setVersion( _packageInfo.value);
  }
}
