class ExpenseTransactionApiModelNames {
  static const String tablename = 'ExpenseTransaction';
  static const String sysDocID = 'sysDocID';
  static const String voucherID = 'voucherID';
  static const String reference = 'reference';
  static const String transactionDate = 'transactionDate';
  static const String divisionID = 'divisionID';
  static const String companyID = 'companyID';
  static const String amount = 'amount';
  static const String taxGroupId = 'taxGroupId';
  static const String taxAmount = 'taxAmount';
  static const String registerID = 'registerID';
  static const String headerImage = 'headerImage';
  static const String footerImage = 'footerImage';
  static const String isSynced = 'isSynced';
  static const String isError = 'isError';
  static const String error = 'error';
}

class ExpenseTransactionApiModel {
  String? sysDocID;
  String? voucherID;
  String? reference;
  String? transactionDate;
  String? divisionID;
  String? companyID;
  double? amount;
  String? taxGroupId;
  double? taxAmount;
  String? registerID;
  String? headerImage;
  String? footerImage;
  int? isSynced;
  int? isError;
  String? error;
  ExpenseTransactionApiModel({
    this.sysDocID,
    this.voucherID,
    this.reference,
    this.transactionDate,
    this.divisionID,
    this.companyID,
    this.amount,
    this.taxGroupId,
    this.taxAmount,
    this.registerID,
    this.headerImage,
    this.footerImage,
    this.isSynced,
    this.isError,
    this.error,
  });
  Map<String, dynamic> toMap() {
    return {
      ExpenseTransactionApiModelNames.sysDocID: sysDocID,
      ExpenseTransactionApiModelNames.voucherID: voucherID,
      ExpenseTransactionApiModelNames.reference: reference,
      ExpenseTransactionApiModelNames.transactionDate: transactionDate,
      ExpenseTransactionApiModelNames.divisionID: divisionID,
      ExpenseTransactionApiModelNames.companyID: companyID,
      ExpenseTransactionApiModelNames.amount: amount,
      ExpenseTransactionApiModelNames.taxGroupId: taxGroupId,
      ExpenseTransactionApiModelNames.taxAmount: taxAmount,
      ExpenseTransactionApiModelNames.registerID: registerID,
      ExpenseTransactionApiModelNames.headerImage: headerImage,
      ExpenseTransactionApiModelNames.footerImage: footerImage,
      ExpenseTransactionApiModelNames.isSynced: isSynced,
      ExpenseTransactionApiModelNames.isError: isError,
      ExpenseTransactionApiModelNames.error: error,
    };
  }

  ExpenseTransactionApiModel.fromMap(Map<String, dynamic> map) {
    sysDocID = map[ExpenseTransactionApiModelNames.sysDocID];
    voucherID = map[ExpenseTransactionApiModelNames.voucherID];
    reference = map[ExpenseTransactionApiModelNames.reference];
    transactionDate = map[ExpenseTransactionApiModelNames.transactionDate];
    divisionID = map[ExpenseTransactionApiModelNames.divisionID];
    companyID = map[ExpenseTransactionApiModelNames.companyID];
    amount = map[ExpenseTransactionApiModelNames.amount];
    taxGroupId = map[ExpenseTransactionApiModelNames.taxGroupId];
    taxAmount = map[ExpenseTransactionApiModelNames.taxAmount];
    registerID = map[ExpenseTransactionApiModelNames.registerID];
    headerImage = map[ExpenseTransactionApiModelNames.headerImage];
    footerImage = map[ExpenseTransactionApiModelNames.footerImage];
    isSynced = map[ExpenseTransactionApiModelNames.isSynced];
    isError = map[ExpenseTransactionApiModelNames.isError];
    error = map[ExpenseTransactionApiModelNames.error];
  }
}

class ExpenseTransactionDetailModelNames {
  static const String tablename = 'ExpenseTransactionDetailsAPIModel';
  static const String voucherId = 'voucherId';
  static const String accountID = 'accountID';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String amountFC = 'amountFC';
  static const String taxGroupId = 'taxGroupId';
  static const String taxAmount = 'taxAmount';
  static const String rowIndex = 'rowIndex';
}

class ExpenseTransactionDetailsAPIModel {
  String? voucherId;
  String? accountID;
  String? description;
  double? amount;
  double? amountFC;
  String? taxGroupId;
  double? taxAmount;
  int? rowIndex;
  ExpenseTransactionDetailsAPIModel({
    this.voucherId,
    this.accountID,
    this.description,
    this.amount,
    this.amountFC,
    this.taxGroupId,
    this.taxAmount,
    this.rowIndex,
  });
  Map<String, dynamic> toMap() {
    return {
      ExpenseTransactionDetailModelNames.voucherId: voucherId,
      ExpenseTransactionDetailModelNames.accountID: accountID,
      ExpenseTransactionDetailModelNames.description: description,
      ExpenseTransactionDetailModelNames.amount: amount,
      ExpenseTransactionDetailModelNames.amountFC: amountFC,
      ExpenseTransactionDetailModelNames.taxGroupId: taxGroupId,
      ExpenseTransactionDetailModelNames.taxAmount: taxAmount,
      ExpenseTransactionDetailModelNames.rowIndex: rowIndex,
    };
  }

  ExpenseTransactionDetailsAPIModel.fromMap(Map<String, dynamic> map) {
    voucherId = map[ExpenseTransactionDetailModelNames.voucherId];
    accountID = map[ExpenseTransactionDetailModelNames.accountID];
    description = map[ExpenseTransactionDetailModelNames.description];
    amount = map[ExpenseTransactionDetailModelNames.amount];
    amountFC = map[ExpenseTransactionDetailModelNames.amountFC];
    taxGroupId = map[ExpenseTransactionDetailModelNames.taxGroupId];
    taxAmount = map[ExpenseTransactionDetailModelNames.taxAmount];
    rowIndex = map[ExpenseTransactionDetailModelNames.rowIndex];
  }
  factory ExpenseTransactionDetailsAPIModel.fromJson(
          Map<String, dynamic> json) =>
      ExpenseTransactionDetailsAPIModel(
        accountID: json["AccountID"],
        description: json["Description"],
        amount: json["Amount"],
        amountFC: json["AmountFC"],
        taxGroupId: json["TaxGroupId"],
        taxAmount: json["TaxAmount"],
        rowIndex: json["RowIndex"],
      );

  Map<String, dynamic> toJson() => {
        "AccountID": accountID,
        "Description": description,
        "Amount": amount,
        "AmountFC": amountFC,
        "TaxGroupId": taxGroupId,
        "TaxAmount": taxAmount,
        "RowIndex": rowIndex,
      };
}

class SalesPOSTaxGroupDetailApiModelNames {
  static const String tablename = 'SalesPOSTaxGroupDetailApiModel';
  static const String sysDocId = 'sysDocId';
  static const String voucherId = 'voucherId';
  static const String taxGroupId = 'taxGroupId';
  static const String taxCode = 'taxCode';
  static const String items = 'items';
  static const String taxRate = 'taxRate';
  static const String calculationMethod = 'calculationMethod';
  static const String taxAmount = 'taxAmount';
  static const String currencyID = 'currencyID';
  static const String rowIndex = 'rowIndex';
  static const String orderIndex = 'orderIndex';
}

class SalesPOSTaxGroupDetailApiModel {
  String? sysDocId;
  String? voucherId;
  String? taxGroupId;
  String? taxCode;
  String? items;
  double? taxRate;
  String? calculationMethod;
  double? taxAmount;
  String? currencyID;
  int? rowIndex;
  int? orderIndex;
  SalesPOSTaxGroupDetailApiModel({
    this.sysDocId,
    this.voucherId,
    this.taxGroupId,
    this.taxCode,
    this.items,
    this.taxRate,
    this.calculationMethod,
    this.taxAmount,
    this.currencyID,
    this.rowIndex,
    this.orderIndex,
  });
  Map<String, dynamic> toMap() {
    return {
      SalesPOSTaxGroupDetailApiModelNames.sysDocId: sysDocId,
      SalesPOSTaxGroupDetailApiModelNames.voucherId: voucherId,
      SalesPOSTaxGroupDetailApiModelNames.taxGroupId: taxGroupId,
      SalesPOSTaxGroupDetailApiModelNames.taxCode: taxCode,
      SalesPOSTaxGroupDetailApiModelNames.items: items,
      SalesPOSTaxGroupDetailApiModelNames.taxRate: taxRate,
      SalesPOSTaxGroupDetailApiModelNames.calculationMethod: calculationMethod,
      SalesPOSTaxGroupDetailApiModelNames.taxAmount: taxAmount,
      SalesPOSTaxGroupDetailApiModelNames.currencyID: currencyID,
      SalesPOSTaxGroupDetailApiModelNames.rowIndex: rowIndex,
      SalesPOSTaxGroupDetailApiModelNames.orderIndex: orderIndex,
    };
  }

  SalesPOSTaxGroupDetailApiModel.fromMap(Map<String, dynamic> map) {
    sysDocId = map[SalesPOSTaxGroupDetailApiModelNames.sysDocId];
    voucherId = map[SalesPOSTaxGroupDetailApiModelNames.voucherId];
    taxGroupId = map[SalesPOSTaxGroupDetailApiModelNames.taxGroupId];
    taxCode = map[SalesPOSTaxGroupDetailApiModelNames.taxCode];
    items = map[SalesPOSTaxGroupDetailApiModelNames.items];
    taxRate = map[SalesPOSTaxGroupDetailApiModelNames.taxRate];
    calculationMethod =
        map[SalesPOSTaxGroupDetailApiModelNames.calculationMethod];
    taxAmount = map[SalesPOSTaxGroupDetailApiModelNames.taxAmount];
    currencyID = map[SalesPOSTaxGroupDetailApiModelNames.currencyID];
    rowIndex = map[SalesPOSTaxGroupDetailApiModelNames.rowIndex];
    orderIndex = map[SalesPOSTaxGroupDetailApiModelNames.orderIndex];
  }
  factory SalesPOSTaxGroupDetailApiModel.fromJson(Map<String, dynamic> json) =>
      SalesPOSTaxGroupDetailApiModel(
        sysDocId: json["SysDocId"],
        voucherId: json["VoucherId"],
        taxGroupId: json["TaxGroupId"],
        taxCode: json["TaxCode"],
        items: json["Items"],
        taxRate: json["TaxRate"],
        calculationMethod: json["CalculationMethod"],
        taxAmount: json["TaxAmount"],
        currencyID: json["CurrencyID"],
        rowIndex: json["RowIndex"],
        orderIndex: json["OrderIndex"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocId": sysDocId,
        "VoucherId": voucherId,
        "TaxGroupId": taxGroupId,
        "TaxCode": taxCode,
        "Items": items,
        "TaxRate": taxRate,
        "CalculationMethod": calculationMethod,
        "TaxAmount": taxAmount,
        "CurrencyID": currencyID,
        "RowIndex": rowIndex,
        "OrderIndex": orderIndex,
      };
}
