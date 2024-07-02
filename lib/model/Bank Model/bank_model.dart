import 'dart:convert';

class BankModel {
  String? bankCode;
  String? bankName;
  String? contactName;
  String? phone;
  String? fax;
  int? inactive;

  BankModel({
    this.bankCode,
    this.bankName,
    this.contactName,
    this.phone,
    this.fax,
    this.inactive,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        bankCode: json["Bank Code"],
        bankName: json["Bank Name"],
        contactName: json["Contact Name"],
        phone: json["Phone"],
        fax: json["Fax"],
        inactive: json["Inactive"] ? 1 : 0,
      );

  Map<String, dynamic> toJson() => {
        "Bank Code": bankCode,
        "Bank Name": bankName,
        "Contact Name": contactName,
        "Phone": phone,
        "Fax": fax,
        "Inactive": inactive,
      };
  Map<String, dynamic> toMap() {
    return {
      BankListLocalImportantNames.bankCode: bankCode,
      BankListLocalImportantNames.bankName: bankName,
      BankListLocalImportantNames.contactName: contactName,
      BankListLocalImportantNames.phone: phone,
      BankListLocalImportantNames.fax: fax,
      BankListLocalImportantNames.inactive: inactive,
    };
  }

  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      bankCode: map[BankListLocalImportantNames.bankCode],
      bankName: map[BankListLocalImportantNames.bankName],
      contactName: map[BankListLocalImportantNames.contactName],
      phone: map[BankListLocalImportantNames.phone],
      fax: map[BankListLocalImportantNames.fax],
      inactive: map[BankListLocalImportantNames.inactive],
    );
  }
}

BankListModel bankListModelFromJson(String str) =>
    BankListModel.fromJson(json.decode(str));

String bankListModelToJson(BankListModel data) => json.encode(data.toJson());

class BankListModel {
  int? result;
  List<BankModel>? modelobject;

  BankListModel({
    this.result,
    this.modelobject,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
        result: json["result"],
        modelobject: List<BankModel>.from(
            json["Modelobject"].map((x) => BankModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class BankListLocalImportantNames {
  static const String tableName = 'Bank';
  static const String bankCode = 'BankCode';
  static const String bankName = 'BankName';
  static const String contactName = 'ContactName';
  static const String phone = 'Phone';
  static const String fax = 'Fax';
  static const String inactive = 'Inactive';
}
