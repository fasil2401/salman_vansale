import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyConnectionAvailable = 'connection_available';
  static const _keyVersion = 'version';
  static const _keyTheme = 'theme';
  static const _keyDeviceInfo = 'deviceInfo';
  static const _keyServerIp = 'server_ip';
  static const _keyServerPort = 'port';
  static const _keyServerDatabase = 'database';
  static const _keyAccessToken = 'access';
  static const _keyUserName = 'username';
  static const _keyPreviousUserName = 'previousUsername';
  static const _keyUserPassword = 'password';
  static const _keyIslogedIn = 'islogedin';
  static const _keyConnection = 'isConnected';
  static const _keyRoute = 'route';
  static const _keyRouteId = 'routeId';
  static const _keyProductSync = 'productSync';
  static const _keyTransferTypeSync = 'transferTypeSync';
  static const _keySysDocSync = 'sysDocSync';
  static const _keyRouteSync = 'routeSync';
  static const _keyProductSyncDate = 'productSyncDate';
  static const _keyProductSyncDateView = 'productSyncDateView';
  static const _keyProductSyncTransferType = 'productSyncTransferType';
  static const _keyConnectionName = 'connectionName';
  static const _keyRememberPassword = 'rememberPassword';
  static const _keysalesPersonID = 'salesPersonID';
  static const _keyLatitude = 'latitude';
  static const _keyLongitude = 'longitude';
  static const _keybatchID = 'batchID';
  static const _keyisSynced = 'isSynced';
  static const _keyisVisitStarted = 'isVisitStarted';
  static const _keyselectedCustomerID = 'selectedCustomerID';
  static const _keyvisitLogID = 'visitLogID';
  static const _keyPrintTemplate = 'printTemplate';
  static const _keyPrintConnection = 'printConnection';
  static const _keyPrintPaperSize = 'printPaperSize';
  static const _keyPrintMacAddress = 'printMacAddress';
  static const _keyVanName = 'vanName';
  static const _keyCompanyTrn = 'companyTrn';
  static const _keyIsSyncCompleted = 'isSyncCompleted';
  static const _keyCompanyName = 'companyName';
  static const _keyCompanyAddress = 'companyAddress';
  static const _keyRouteName = 'routeName';
  static const _keyPrintCount = 'printCount';
  static const _keyPrintPreference = 'keyPrintPreference';
  static final RxInt batchID = UserSimplePreferences.getBatchID()?.obs ?? 0.obs;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setPrintCount(int count) async =>
      await _preferences!.setInt(_keyPrintCount, count);

  static int? getPrintCount() => _preferences!.getInt(_keyPrintCount);

  static Future setTheme(String theme) async =>
      await _preferences!.setString(_keyTheme, theme);

  static String? getTheme() => _preferences!.getString(_keyTheme);

  static Future setDeviceInfo(String info) async =>
      await _preferences!.setString(_keyDeviceInfo, info);

  static String? getDeviceInfo() => _preferences!.getString(_keyDeviceInfo);

  static Future setVanName(String name) async =>
      await _preferences!.setString(_keyVanName, name);

  static String? getVanName() => _preferences!.getString(_keyVanName);

  static Future setRouteName(String name) async =>
      await _preferences!.setString(_keyRouteName, name);

  static String? getRouteName() => _preferences!.getString(_keyRouteName);

  static Future setProductSync(String sync) async =>
      await _preferences!.setString(_keyProductSync, sync);

  static String? getProductSync() => _preferences!.getString(_keyProductSync);

  static Future setTransferTypeSync(String sync) async =>
      await _preferences!.setString(_keyTransferTypeSync, sync);

  static String? getTransferTypeSync() =>
      _preferences!.getString(_keyTransferTypeSync);

  static Future setSysDocSync(String sync) async =>
      await _preferences!.setString(_keySysDocSync, sync);

  static String? getSysDocSync() => _preferences!.getString(_keySysDocSync);

  static Future setRouteSync(String sync) async =>
      await _preferences!.setString(_keyRouteSync, sync);

  static String? getRouteSync() => _preferences!.getString(_keyRouteSync);

  static Future setVersion(String version) async =>
      await _preferences!.setString(_keyVersion, version);

  static String? getVersion() => _preferences!.getString(_keyVersion);

  static Future setUsername(String userName) async =>
      await _preferences!.setString(_keyUserName, userName);

  static String? getUsername() => _preferences!.getString(_keyUserName);

  static Future setIsConnectionAvailable(String availability) async =>
      await _preferences!.setString(_keyConnectionAvailable, availability);

  static String? getIsConnectionAvailable() =>
      _preferences!.getString(_keyConnectionAvailable);

  static Future setConnectionName(String connectionName) async =>
      await _preferences!.setString(_keyConnectionName, connectionName);

  static String? getConnectionName() =>
      _preferences!.getString(_keyConnectionName);
  static Future setPreviousUsername(String userName) async =>
      await _preferences!.setString(_keyPreviousUserName, userName);

  static String? getPreviousUsername() =>
      _preferences!.getString(_keyPreviousUserName);

  static Future setAccessToken(String access) async =>
      await _preferences!.setString(_keyAccessToken, access);

  static String? getAccessToken() => _preferences!.getString(_keyAccessToken);

  static Future setUserPassword(String password) async =>
      await _preferences!.setString(_keyUserPassword, password);

  static String? getUserPassword() => _preferences!.getString(_keyUserPassword);

  static Future setServerIp(String serverIp) async =>
      await _preferences!.setString(_keyServerIp, serverIp);

  static String? getServerIp() => _preferences!.getString(_keyServerIp);

  static Future setPort(String port) async =>
      await _preferences!.setString(_keyServerPort, port);

  static String? getPort() => _preferences!.getString(_keyServerPort);

  static Future setDatabase(String database) async =>
      await _preferences!.setString(_keyServerDatabase, database);

  static String? getDatabase() => _preferences!.getString(_keyServerDatabase);

  static Future setLogin(String isLogin) async =>
      await _preferences!.setString(_keyIslogedIn, isLogin);

  static String? getLogin() => _preferences!.getString(_keyIslogedIn);

  static Future setConnection(String isConnected) async =>
      await _preferences!.setString(_keyConnection, isConnected);

  static String? getConnection() => _preferences!.getString(_keyConnection);

  static Future setRoute(String route) async =>
      await _preferences!.setString(_keyRoute, route);

  static String? getRoute() => _preferences!.getString(_keyRoute);

  static Future setRouteId(String routeId) async =>
      await _preferences!.setString(_keyRouteId, routeId);

  static String? getRouteId() => _preferences!.getString(_keyRouteId);

  static Future setTransferDate(String date) async =>
      await _preferences!.setString(_keyProductSyncDate, date);

  static String? getTransferDate() =>
      _preferences!.getString(_keyProductSyncDate);

  static Future setTransferDateView(String date) async =>
      await _preferences!.setString(_keyProductSyncDateView, date);

  static String? getTransferDateView() =>
      _preferences!.getString(_keyProductSyncDateView);

  static Future setSyncTransferType(String transferType) async =>
      await _preferences!.setString(_keyProductSyncTransferType, transferType);

  static String? getSyncTransferType() =>
      _preferences!.getString(_keyProductSyncTransferType);
  static Future setRememberPassword(bool isRemember) async =>
      await _preferences!.setBool(_keyRememberPassword, isRemember);

  static bool? getRememberPassword() =>
      _preferences!.getBool(_keyRememberPassword);

  static Future setSalesPersonID(String? salesPersonID) async =>
      await _preferences!.setString(_keysalesPersonID, salesPersonID!);

  static String? getSalesPersonID() =>
      _preferences!.getString(_keysalesPersonID);

  static Future setLatitude(String latitude) async =>
      await _preferences!.setString(_keyLatitude, latitude);

  static String? getLatitude() => _preferences!.getString(_keyLatitude);

  static Future setLongitude(String longitude) async =>
      await _preferences!.setString(_keyLongitude, longitude);

  static String? getLongitude() => _preferences!.getString(_keyLongitude);

  static Future setBatchID(int batchID) async {
    await _preferences!.setInt(_keybatchID, batchID);
    UserSimplePreferences.batchID.value = batchID;
  }

  static Future setPrintTemplate(int template) async =>
      await _preferences!.setInt(_keyPrintTemplate, template);

  static int? getPrintTemplate() => _preferences!.getInt(_keyPrintTemplate);

  static Future setPrintConnection(int connection) async =>
      await _preferences!.setInt(_keyPrintConnection, connection);

  static int? getPrintConnection() => _preferences!.getInt(_keyPrintConnection);

  static Future setPrintPaperSize(int paper) async =>
      await _preferences!.setInt(_keyPrintPaperSize, paper);

  static int? getPrintPaperSize() => _preferences!.getInt(_keyPrintPaperSize);

  static Future setPrintPreference(int print) async =>
      await _preferences!.setInt(_keyPrintPreference, print);

  static int? getPrintPreference() => _preferences!.getInt(_keyPrintPreference);

  static Future setPrintMacAddress(String paper) async =>
      await _preferences!.setString(_keyPrintMacAddress, paper);

  static String? getPrintMacAddress() =>
      _preferences!.getString(_keyPrintMacAddress);

  static int? getBatchID() => _preferences!.getInt(_keybatchID);

  static Future setIsSynced(bool isSynced) async =>
      await _preferences!.setBool(_keyisSynced, isSynced);

  static bool? getIsSynced() => _preferences!.getBool(_keyisSynced);

  static Future setIsVisitStarted(bool isVisitStarted) async =>
      await _preferences!.setBool(_keyisVisitStarted, isVisitStarted);

  static bool? getIsVisitStarted() => _preferences!.getBool(_keyisVisitStarted);

  static Future setSelectedCustomerID(String selectedCustomerID) async =>
      await _preferences!.setString(_keyselectedCustomerID, selectedCustomerID);

  static String? getSelectedCustomerID() =>
      _preferences!.getString(_keyselectedCustomerID);

  static Future setCompanyTRN(String trn) async =>
      await _preferences!.setString(_keyCompanyTrn, trn);

  static String? getCompanyTRN() => _preferences!.getString(_keyCompanyTrn);

  static Future setCompanyName(String name) async =>
      await _preferences!.setString(_keyCompanyName, name);

  static String? getCompanyName() => _preferences!.getString(_keyCompanyName);

  static Future setCompanyAddress(String address) async =>
      await _preferences!.setString(_keyCompanyAddress, address);

  static String? getCompanyAddress() =>
      _preferences!.getString(_keyCompanyAddress);

  static Future setVisitLogID(String visitLogID) async =>
      await _preferences!.setString(_keyvisitLogID, visitLogID);

  static String? getVisitLogID() => _preferences!.getString(_keyvisitLogID);

  static Future setIsSyncCompleted(bool isSynced) async =>
      await _preferences!.setBool(_keyIsSyncCompleted, isSynced);

  static bool? getIsSyncCompleted() =>
      _preferences!.getBool(_keyIsSyncCompleted);
}
