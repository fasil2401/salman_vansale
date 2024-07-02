
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';

String inventoryBaseUrl =
    'http://${UserSimplePreferences.getServerIp()}/V1/Inventory/';

class ApiConstants {
  static getBaseUrl() {
    String serverIp = UserSimplePreferences.getServerIp() ?? '';
    String baseUrl = 'http://$serverIp/V1/Api/';
    return baseUrl;
  }

  static getInventoryBaseUrl() {
    String serverIp = UserSimplePreferences.getServerIp() ?? '';
    String inventoryBaseUrl ='http://$serverIp/V1/Inventory/';
    return inventoryBaseUrl;
  }

   static getQCBaseUrl() {
    String serverIp = UserSimplePreferences.getServerIp() ?? '';
    String qcBaseUrl ='http://$serverIp/V1/QC/';
    return qcBaseUrl;
  }
  static getVendorBaseUrl() {
    String serverIp = UserSimplePreferences.getServerIp() ?? '';
    String qcBaseUrl ='http://$serverIp/V1/Vendor/';
    return qcBaseUrl;
  }

  static getCRMBaseUrl() {
    String serverIp = UserSimplePreferences.getServerIp() ?? '';
    String qcBaseUrl ='http://$serverIp/V1/CRM/';
    return qcBaseUrl;
  }

  static getVANBaseUrl() {
    String serverIp = UserSimplePreferences.getServerIp() ?? '';
    String qcBaseUrl ='http://$serverIp/V1/VanSale/';
    return qcBaseUrl;
  }

}
