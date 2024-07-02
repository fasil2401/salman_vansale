class AccountModel {
  final String? cashRegisterID;
  final String? displayName;
  final String? accountID;
  final String? accountName;

  AccountModel({
    required this.cashRegisterID,
    required this.displayName,
    required this.accountID,
    required this.accountName,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      cashRegisterID: json['CashRegisterID'],
      displayName: json['DisplayName'],
      accountID: json['AccountID'],
      accountName: json['AccountName'],
    );
  }

factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      cashRegisterID: map['CashRegisterID'],
      displayName: map['DisplayName'],
      accountID: map['AccountID'],
      accountName: map['AccountName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'CashRegisterID': cashRegisterID,
        'DisplayName': displayName,
        'AccountID': accountID,
        'AccountName': accountName,
      };

  Map<String, dynamic> toMap() {
    return {
      'CashRegisterID': cashRegisterID,
      'DisplayName': displayName,
      'AccountID': accountID,
      'AccountName': accountName,
    };
  }

}

class AccountListModel {
  final int? result;
  final List<AccountModel>? modelObject;

  AccountListModel({
    required this.result,
    required this.modelObject,
  });

  factory AccountListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<AccountModel> items = list.map((item) => AccountModel.fromJson(item)).toList();

    return AccountListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class AccountListLocalImportantNames {
  static const String tableName = 'Account';
  static const String cashRegisterID = "CashRegisterID";
  static const String displayName = "DisplayName";
  static const String accountID = "AccountID";
  static const String accountName = "AccountName";
}
