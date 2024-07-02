import 'dart:convert';

ConnectionQrModel connectionQrModelFromJson(String str) =>
    ConnectionQrModel.fromJson(json.decode(str));

String connectionQrModelToJson(ConnectionQrModel data) =>
    json.encode(data.toJson());

class ConnectionQrModel {
  ConnectionQrModel({
    this.connectionName,
    this.serverIp,
    this.port,
    this.databaseName,
  });

  String? connectionName;
  String? serverIp;
  String? port;
  String? databaseName;

  factory ConnectionQrModel.fromJson(Map<String, dynamic> json) =>
      ConnectionQrModel(
        connectionName: json["connectionName"],
        serverIp: json["serverIp"],
        port: json["port"],
        databaseName: json["databaseName"],
      );

  Map<String, dynamic> toJson() => {
        "connectionName": connectionName,
        "serverIp": serverIp,
        "port": port,
        "databaseName": databaseName,
      };
}
