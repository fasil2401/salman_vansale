class ConnectionModelImpNames {
  static const String connectionName = 'connectionName';
  static const String serverIp = 'serverIp';
  static const String port = 'port';
  static const String databaseName = 'databaseName';
  static const String userName = 'userName';
  static const String password = 'password';
   static const String tableName = 'connectionSetting';
}

class ConnectionModel {
  String? connectionName;
  String? serverIp;
  String? port;
  String? databaseName;
  String? userName;
  String? password;

  ConnectionModel({
    this.connectionName,
    this.serverIp,
    this.port,
    this.databaseName,
    this.userName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'connectionName': connectionName,
      'serverIp': serverIp,
      'port': port,
      'databaseName': databaseName,
      'userName': userName,
      'password': password,
    };
  }

  ConnectionModel.fromMap(Map<String, dynamic> map) {
    connectionName = map['connectionName'];
    serverIp = map['serverIp'];
    port = map['port'];
    databaseName = map['databaseName'];
     userName = map['userName'];
    password = map['password'];
  }
}
