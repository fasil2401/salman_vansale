class CustomerBalanceListModel {
  final int? result;
  final List<CustomerBalanceModel>? modelObject;

  CustomerBalanceListModel({required this.result, required this.modelObject});

  factory CustomerBalanceListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<CustomerBalanceModel> items = list.map((i) => CustomerBalanceModel.fromJson(i)).toList();

    return CustomerBalanceListModel(result: json['result'], modelObject: items);
  }
}

class CustomerBalanceModel {
  final String? customerID;
  final String? customerName;
  double? creditAmount;
  int? isInactive;
  int? isHold;
  final dynamic clValidity;
  int? creditLimitType;
  final String? parentCustomerID;
  final int? limitPDCUnsecured;
  final dynamic pdcUnsecuredLimitAmount;
  final double? insApprovedAmount;
  final dynamic openDNAmount;
  dynamic tempCL;
  double? balance;
  double? pdcAmount;
  final int? acceptCheckPayment;
  final int? acceptPDC;
  final String? currencyID;
  final dynamic securityCheque;

  CustomerBalanceModel({
    required this.customerID,
    required this.customerName,
    required this.creditAmount,
    required this.isInactive,
    required this.isHold,
    required this.clValidity,
    required this.creditLimitType,
    required this.parentCustomerID,
    required this.limitPDCUnsecured,
    required this.pdcUnsecuredLimitAmount,
    required this.insApprovedAmount,
    required this.openDNAmount,
    required this.tempCL,
    required this.balance,
    required this.pdcAmount,
    required this.acceptCheckPayment,
    required this.acceptPDC,
    required this.currencyID,
    required this.securityCheque,
  });

  factory CustomerBalanceModel.fromJson(Map<String, dynamic> json) {
    return CustomerBalanceModel(
      customerID: json['CustomerID'],
      customerName: json['CustomerName'],
      creditAmount: json['CreditAmount'].toDouble(),
      isInactive: json['IsInactive']== null
            ? null
            : json["IsInactive"]
                ? 1
                : 0,
      isHold: json['IsHold']== null
            ? null
            : json["IsHold"]
                ? 1
                : 0,
      clValidity: json['CLValidity'],
      creditLimitType: json['CreditLimitType'],
      parentCustomerID: json['ParentCustomerID'],
      limitPDCUnsecured: json['LimitPDCUnsecured']== null
            ? null
            : json["LimitPDCUnsecured"]
                ? 1
                : 0,
      pdcUnsecuredLimitAmount: json['PDCUnsecuredLimitAmount'],
      insApprovedAmount: json['InsApprovedAmount'].toDouble(),
      openDNAmount: json['OpenDNAmount'],
      tempCL: json['TempCL'],
      balance: json['Balance'].toDouble(),
      pdcAmount: json['PDCAmount'].toDouble(),
      acceptCheckPayment: json['AcceptCheckPayment']== null
            ? null
            : json["AcceptCheckPayment"]
                ? 1
                : 0,
      acceptPDC: json['AcceptPDC']== null
            ? null
            : json["AcceptPDC"]
                ? 1
                : 0,
      currencyID: json['CurrencyID'],
      securityCheque: json['SecurityCheque'],
    );
  }

  Map<String, dynamic> toJson() => {
  'CustomerID': customerID,
  'CustomerName': customerName,
  'CreditAmount': creditAmount,
  'IsInactive': isInactive,
  'IsHold': isHold,
  'CLValidity': clValidity,
  'CreditLimitType': creditLimitType,
  'ParentCustomerID': parentCustomerID,
  'LimitPDCUnsecured': limitPDCUnsecured,
  'PDCUnsecuredLimitAmount': pdcUnsecuredLimitAmount,
  'InsApprovedAmount': insApprovedAmount,
  'OpenDNAmount': openDNAmount,
  'TempCL': tempCL,
  'Balance': balance,
  'PDCAmount': pdcAmount,
  'AcceptCheckPayment': acceptCheckPayment,
  'AcceptPDC': acceptPDC,
  'CurrencyID': currencyID,
  'SecurityCheque': securityCheque,
};

Map<String, dynamic> toMap() {
  return {
    'CustomerID': customerID,
    'CustomerName': customerName,
    'CreditAmount': creditAmount,
    'IsInactive': isInactive,
    'IsHold': isHold,
    'CLValidity': clValidity,
    'CreditLimitType': creditLimitType,
    'ParentCustomerID': parentCustomerID,
    'LimitPDCUnsecured': limitPDCUnsecured,
    'PDCUnsecuredLimitAmount': pdcUnsecuredLimitAmount,
    'InsApprovedAmount': insApprovedAmount,
    'OpenDNAmount': openDNAmount,
    'TempCL': tempCL,
    'Balance': balance,
    'PDCAmount': pdcAmount,
    'AcceptCheckPayment': acceptCheckPayment,
    'AcceptPDC': acceptPDC,
    'CurrencyID': currencyID,
    'SecurityCheque': securityCheque,
  };
}

factory CustomerBalanceModel.fromMap(Map<String, dynamic> map) {
  return CustomerBalanceModel(
    customerID: map['CustomerID'],
    customerName: map['CustomerName'],
    creditAmount: map['CreditAmount'],
    isInactive: map['IsInactive'],
    isHold: map['IsHold'],
    clValidity: map['CLValidity'],
    creditLimitType: map['CreditLimitType'] == null ? null : int.tryParse(map['CreditLimitType']),
    parentCustomerID: map['ParentCustomerID'],
    limitPDCUnsecured: map['LimitPDCUnsecured'],
    pdcUnsecuredLimitAmount: map['PDCUnsecuredLimitAmount'],
    insApprovedAmount: map['InsApprovedAmount'],
    openDNAmount: map['OpenDNAmount'],
    tempCL: map['TempCL'],
    balance: map['Balance'],
    pdcAmount: map['PDCAmount'],
acceptCheckPayment: map['AcceptCheckPayment'],
    acceptPDC: map['AcceptPDC'],
    currencyID: map['CurrencyID'],
    securityCheque: map['SecurityCheque'],
  );
}

}

class CustomerBalanceListLocalImportantNames {
  static const String tableName = 'CustomerBalance';
  static const String customerID = 'CustomerID';
  static const String customerName = 'CustomerName';
  static const String creditAmount = 'CreditAmount';
  static const String isInactive = 'IsInactive';
  static const String isHold = 'IsHold';
  static const String clValidity = 'CLValidity';
  static const String creditLimitType = 'CreditLimitType';
  static const String parentCustomerID = 'ParentCustomerID';
  static const String limitPDCUnsecured = 'LimitPDCUnsecured';
  static const String pdcUnsecuredLimitAmount = 'PDCUnsecuredLimitAmount';
  static const String insApprovedAmount = 'InsApprovedAmount';
  static const String openDNAmount = 'OpenDNAmount';
  static const String tempCL = 'TempCL';
  static const String balance = 'Balance';
  static const String pdcAmount = 'PDCAmount';
  static const String acceptCheckPayment = 'AcceptCheckPayment';
  static const String acceptPDC = 'AcceptPDC';
  static const String currencyID = 'CurrencyID';
  static const String securityCheque = 'SecurityCheque';
}
