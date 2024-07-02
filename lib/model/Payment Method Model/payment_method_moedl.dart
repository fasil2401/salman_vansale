class PaymentMethodModel {
  final String? cashRegisterID;
  final bool? inactive;
  final String? paymentMethodID;
  final String? displayName;
  final String? accountID;
  final String? accountName;
  final int? methodType;

  PaymentMethodModel({
    this.cashRegisterID,
    this.inactive,
    this.paymentMethodID,
    this.displayName,
    this.accountID,
    this.accountName,
    this.methodType,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      cashRegisterID: json['CashRegisterID'],
      inactive: json['Inactive'],
      paymentMethodID: json['PaymentMethodID'],
      displayName: json['DisplayName'],
      accountID: json['AccountID'],
      accountName: json['AccountName'],
      methodType: json['MethodType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'CashRegisterID': cashRegisterID,
        'Inactive': inactive,
        'PaymentMethodID': paymentMethodID,
        'DisplayName': displayName,
        'AccountID': accountID,
        'AccountName': accountName,
        'MethodType': methodType,
      };

  Map<String, dynamic> toMap() {
    return {
      'CashRegisterID': cashRegisterID,
      'Inactive': inactive,
      'PaymentMethodID': paymentMethodID,
      'DisplayName': displayName,
      'AccountID': accountID,
      'AccountName': accountName,
      'MethodType': methodType,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      cashRegisterID: map['CashRegisterID'],
      inactive: map['Inactive'] == 1 ? true : false,
      paymentMethodID: map['PaymentMethodID'],
      displayName: map['DisplayName'],
      accountID: map['AccountID'],
      accountName: map['AccountName'],
      methodType: map['MethodType'],
    );
  }
}

class PaymentMethodListModel {
  final int? result;
  final List<PaymentMethodModel>? model;

  PaymentMethodListModel({
    required this.result,
    required this.model,
  });

  factory PaymentMethodListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<PaymentMethodModel> items =
        list.map((item) => PaymentMethodModel.fromJson(item)).toList();

    return PaymentMethodListModel(
      result: json['result'],
      model: items,
    );
  }
}

class PaymentMethodLocalImportantNames {
  static const String tableName = 'PaymentMethod';
  static const String cashRegisterID = 'CashRegisterID';
  static const String inactive = 'Inactive';
  static const String paymentMethodID = 'PaymentMethodID';
  static const String displayName = 'DisplayName';
  static const String accountID = 'AccountID';
  static const String accountName = 'AccountName';
  static const String methodType = 'MethodType';
}
