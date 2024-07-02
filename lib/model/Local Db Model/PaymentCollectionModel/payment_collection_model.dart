class CreateTransferHeaderModelNames {
  static const String tableName = 'CreateTransferHeader';
  static const String sysDocId = 'sysDocId';
  static const String sysDocType = 'sysDocType';
  static const String voucherId = 'voucherId';
  static const String reference = 'reference';
  static const String description = 'description';
  static const String customerName = 'customerName';
  static const String transactionDate = 'transactionDate';
  static const String dueDate = 'dueDate';
  static const String registerId = 'registerId';
  static const String divisionId = 'divisionId';
  static const String companyId = 'companyId';
  static const String payeeId = 'payeeId';
  static const String payeeType = 'payeeType';
  static const String currencyId = 'currencyId';
  static const String currencyRate = 'currencyRate';
  static const String amount = 'amount';
  static const String headerImage = 'headerImage';
  static const String footerImage = 'footerImage';
  static const String isPos = 'isPos';
  static const String isCheque = 'isCheque';
  static const String posShiftId = 'posShiftId';
  static const String posBatchId = 'posBatchId';
  static const String isSynced = 'isSynced';
  static const String isError = 'isError';
  static const String error = 'error';
}

class CreateTransferHeaderModel {
  int? sysDocType;
  String? sysDocId;
  String? voucherId;
  String? reference;
  String? description;
  String? customerName;
  DateTime? transactionDate;
  DateTime? dueDate;
  String? registerId;
  String? divisionId;
  String? companyId;
  String? payeeId;
  String? payeeType;
  String? currencyId;
  dynamic currencyRate;
  dynamic amount;
  String? headerImage;
  String? footerImage;
  bool? isPos;
  bool? isCheque;
  int? posShiftId;
  int? posBatchId;
  int? isSynced;
  int? isError;
  String? error;

  CreateTransferHeaderModel({
    this.sysDocType,
    this.sysDocId,
    this.voucherId,
    this.reference,
    this.description,
    this.customerName,
    this.transactionDate,
    this.dueDate,
    this.registerId,
    this.divisionId,
    this.companyId,
    this.payeeId,
    this.payeeType,
    this.currencyId,
    this.currencyRate,
    this.amount,
    this.headerImage,
    this.footerImage,
    this.isPos,
    this.isCheque,
    this.posShiftId,
    this.posBatchId,
    this.isSynced,
    this.isError,
    this.error,
  });

  Map<String, dynamic> toMap() {
    return {
      CreateTransferHeaderModelNames.sysDocType: sysDocType,
      CreateTransferHeaderModelNames.sysDocId: sysDocId,
      CreateTransferHeaderModelNames.voucherId: voucherId,
      CreateTransferHeaderModelNames.reference: reference,
      CreateTransferHeaderModelNames.description: description,
      CreateTransferHeaderModelNames.customerName: customerName,
      CreateTransferHeaderModelNames.transactionDate: transactionDate,
      CreateTransferHeaderModelNames.dueDate: dueDate,
      CreateTransferHeaderModelNames.registerId: registerId,
      CreateTransferHeaderModelNames.divisionId: divisionId,
      CreateTransferHeaderModelNames.companyId: companyId,
      CreateTransferHeaderModelNames.payeeId: payeeId,
      CreateTransferHeaderModelNames.payeeType: payeeType,
      CreateTransferHeaderModelNames.currencyId: currencyId,
      CreateTransferHeaderModelNames.currencyRate: currencyRate,
      CreateTransferHeaderModelNames.amount: amount,
      CreateTransferHeaderModelNames.headerImage: headerImage,
      CreateTransferHeaderModelNames.isPos: isPos,
      CreateTransferHeaderModelNames.isCheque: isCheque,
      CreateTransferHeaderModelNames.posShiftId: posShiftId,
      CreateTransferHeaderModelNames.posBatchId: posBatchId,
      CreateTransferHeaderModelNames.isSynced: isSynced,
      CreateTransferHeaderModelNames.isError: isError,
      CreateTransferHeaderModelNames.error: error,
    };
  }

  CreateTransferHeaderModel.fromMap(Map<String, dynamic> map) {
    sysDocType = map[CreateTransferHeaderModelNames.sysDocType];
    sysDocId = map[CreateTransferHeaderModelNames.sysDocId];
    voucherId = map[CreateTransferHeaderModelNames.voucherId];
    reference = map[CreateTransferHeaderModelNames.reference];
    description = map[CreateTransferHeaderModelNames.description];
    customerName = map[CreateTransferHeaderModelNames.customerName];
    transactionDate =
        DateTime.parse(map[CreateTransferHeaderModelNames.transactionDate]);
    dueDate = DateTime.parse(map[CreateTransferHeaderModelNames.dueDate]);
    registerId = map[CreateTransferHeaderModelNames.registerId];
    divisionId = map[CreateTransferHeaderModelNames.divisionId];
    companyId = map[CreateTransferHeaderModelNames.companyId];
    payeeId = map[CreateTransferHeaderModelNames.payeeId];
    payeeType = map[CreateTransferHeaderModelNames.payeeType];
    currencyId = map[CreateTransferHeaderModelNames.currencyId];
    currencyRate = map[CreateTransferHeaderModelNames.currencyRate];
    amount = map[CreateTransferHeaderModelNames.amount];
    headerImage = map[CreateTransferHeaderModelNames.headerImage];
    footerImage = map[CreateTransferHeaderModelNames.footerImage];
    isPos = map[CreateTransferHeaderModelNames.isPos] == 1 ? true : false;
    isCheque = map[CreateTransferHeaderModelNames.isCheque] == 1 ? true : false;
    posShiftId = map[CreateTransferHeaderModelNames.posShiftId];
    posBatchId = map[CreateTransferHeaderModelNames.posBatchId];
    isSynced = map[CreateTransferHeaderModelNames.isSynced];
    isError = map[CreateTransferHeaderModelNames.isError];
    error = map[CreateTransferHeaderModelNames.error];
  }

  factory CreateTransferHeaderModel.fromJson(Map<String, dynamic> json) =>
      CreateTransferHeaderModel(
        sysDocType: json["SysDocType"],
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        reference: json["Reference"],
        description: json["Description"],
        transactionDate: json["TransactionDate"] == null
            ? null
            : DateTime.parse(json["TransactionDate"]),
        dueDate:
            json["DueDate"] == null ? null : DateTime.parse(json["DueDate"]),
        registerId: json["RegisterID"],
        divisionId: json["DivisionID"],
        companyId: json["CompanyID"],
        payeeId: json["PayeeID"],
        payeeType: json["PayeeType"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
        amount: json["Amount"],
        isPos: json["IsPOS"],
        isCheque: json["IsCheque"],
        posShiftId: json["POSShiftID"],
        posBatchId: json["POSBatchID"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocType": sysDocType,
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "Reference": reference,
        "Description": description,
        "TransactionDate": transactionDate?.toIso8601String(),
        "DueDate": dueDate?.toIso8601String(),
        "RegisterID": registerId,
        "DivisionID": divisionId,
        "CompanyID": companyId,
        "PayeeID": payeeId,
        "PayeeType": payeeType,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
        "Amount": amount,
        "IsPOS": isPos,
        "IsCheque": isCheque,
        "POSShiftID": posShiftId,
        "POSBatchID": posBatchId,
      };
}

class TransactionAllocationDetailModelNames {
  static const String tableName = 'TransactionAllocationDetail';
  static const String invoiceSysDocId = 'invoiceSysDocId';
  static const String invoiceVoucherId = 'invoiceVoucherId';
  static const String paymentSysDocId = 'paymentSysDocId';
  static const String paymentVoucherId = 'paymentVoucherId';
  static const String customerId = 'customerId';
  static const String arJournalId = 'arJournalId';
  static const String paymentArid = 'paymentArid';
  static const String allocationDate = 'allocationDate';
  static const String paymentAmount = 'paymentAmount';
  static const String dueAmount = "dueAmount";
  static const String isSynced = 'isSynced';
  static const String isChecked = 'isChecked';
}

class TransactionAllocationDetailModel {
  String? invoiceSysDocId;
  String? invoiceVoucherId;
  String? paymentSysDocId;
  String? paymentVoucherId;
  String? customerId;
  int? arJournalId;
  int? paymentArid;
  DateTime? allocationDate;
  dynamic paymentAmount;
  dynamic dueAmount;
  bool? isSynced;
  int? isChecked;
  double? availableAmount;

  TransactionAllocationDetailModel({
    this.invoiceSysDocId,
    this.invoiceVoucherId,
    this.paymentSysDocId,
    this.paymentVoucherId,
    this.customerId,
    this.arJournalId,
    this.paymentArid,
    this.allocationDate,
    this.paymentAmount,
    this.dueAmount,
    this.isSynced,
    this.isChecked,
    this.availableAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      TransactionAllocationDetailModelNames.invoiceSysDocId: invoiceSysDocId,
      TransactionAllocationDetailModelNames.invoiceVoucherId: invoiceVoucherId,
      TransactionAllocationDetailModelNames.paymentSysDocId: paymentSysDocId,
      TransactionAllocationDetailModelNames.customerId: customerId,
      TransactionAllocationDetailModelNames.paymentVoucherId: paymentVoucherId,
      TransactionAllocationDetailModelNames.arJournalId: arJournalId,
      TransactionAllocationDetailModelNames.paymentArid: paymentArid,
      TransactionAllocationDetailModelNames.allocationDate: allocationDate,
      TransactionAllocationDetailModelNames.paymentAmount: paymentAmount,
      TransactionAllocationDetailModelNames.dueAmount: dueAmount,
      TransactionAllocationDetailModelNames.isSynced: isSynced,
      TransactionAllocationDetailModelNames.isChecked: isChecked,
    };
  }

  TransactionAllocationDetailModel.fromMap(Map<String, dynamic> map) {
    invoiceSysDocId =
        map[TransactionAllocationDetailModelNames.invoiceSysDocId];
    invoiceVoucherId =
        map[TransactionAllocationDetailModelNames.invoiceVoucherId];
    paymentSysDocId =
        map[TransactionAllocationDetailModelNames.paymentSysDocId];
    paymentVoucherId =
        map[TransactionAllocationDetailModelNames.paymentVoucherId];
    customerId = map[TransactionAllocationDetailModelNames.customerId];
    arJournalId = map[TransactionAllocationDetailModelNames.arJournalId];
    paymentArid = map[TransactionAllocationDetailModelNames.paymentArid];
    allocationDate = DateTime.parse(
        map[TransactionAllocationDetailModelNames.allocationDate]);
    paymentAmount = map[TransactionAllocationDetailModelNames.paymentAmount];
    dueAmount = map[TransactionAllocationDetailModelNames.dueAmount];
    isSynced =
        map[TransactionAllocationDetailModelNames.isSynced] == 1 ? true : false;
    isChecked = map[TransactionAllocationDetailModelNames.isChecked];
    availableAmount = map['DueAmount'];
  }

  factory TransactionAllocationDetailModel.fromJson(
          Map<String, dynamic> json) =>
      TransactionAllocationDetailModel(
        invoiceSysDocId: json["InvoiceSysDocID"],
        invoiceVoucherId: json["InvoiceVoucherID"],
        paymentSysDocId: json["PaymentSysDocID"],
        paymentVoucherId: json["PaymentVoucherID"],
        customerId: json["CustomerID"],
        arJournalId: json["ARJournalID"],
        paymentArid: json["PaymentARID"],
        allocationDate: json["AllocationDate"] == null
            ? null
            : DateTime.parse(json["AllocationDate"]),
        paymentAmount: json["PaymentAmount"],
      );

  Map<String, dynamic> toJson() => {
        "InvoiceSysDocID": invoiceSysDocId,
        "InvoiceVoucherID": invoiceVoucherId,
        "PaymentSysDocID": paymentSysDocId,
        "PaymentVoucherID": paymentVoucherId,
        "CustomerID": customerId,
        "ARJournalID": arJournalId,
        "PaymentARID": paymentArid,
        "AllocationDate": allocationDate?.toIso8601String(),
        "PaymentAmount": paymentAmount,
      };
}

class TransactionDetailModelNames {
  static const String tableName = 'TransactionDetail';
  static const String voucherId = 'voucherId';
  static const String paymentMethodId = 'paymentMethodId';
  static const String paymentMethodType = 'paymentMethodType';
  static const String bankId = 'bankId';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String amountFc = 'amountFc';
  static const String chequeDate = 'chequeDate';
  static const String chequeNumber = 'chequeNumber';
  static const String isSynced = 'isSynced';
}

class TransactionDetailModel {
  String? voucherId;
  String? paymentMethodId;
  int? paymentMethodtype;
  String? bankId;
  String? description;
  dynamic amount;
  dynamic amountFc;
  DateTime? chequeDate;
  String? chequeNumber;
  bool? isSynced;

  TransactionDetailModel({
    this.voucherId,
    this.paymentMethodId,
    this.paymentMethodtype,
    this.bankId,
    this.description,
    this.amount,
    this.amountFc,
    this.chequeDate,
    this.chequeNumber,
    this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      TransactionDetailModelNames.voucherId: voucherId,
      TransactionDetailModelNames.paymentMethodId: paymentMethodId,
      TransactionDetailModelNames.paymentMethodType: paymentMethodtype,
      TransactionDetailModelNames.bankId: bankId,
      TransactionDetailModelNames.description: description,
      TransactionDetailModelNames.amount: amount,
      TransactionDetailModelNames.amountFc: amountFc,
      TransactionDetailModelNames.chequeDate: chequeDate,
      TransactionDetailModelNames.chequeNumber: chequeNumber,
      TransactionDetailModelNames.isSynced: isSynced,
    };
  }

  TransactionDetailModel.fromMap(Map<String, dynamic> map) {
    voucherId = map[TransactionDetailModelNames.voucherId];
    paymentMethodId = map[TransactionDetailModelNames.paymentMethodId];
    paymentMethodtype = map[TransactionDetailModelNames.paymentMethodType];
    bankId = map[TransactionDetailModelNames.bankId];
    description = map[TransactionDetailModelNames.description];
    amount = map[TransactionDetailModelNames.amount];
    amountFc = map[TransactionDetailModelNames.amountFc];
    chequeDate = DateTime.parse(map[TransactionDetailModelNames.chequeDate]);
    chequeNumber = map[TransactionDetailModelNames.chequeNumber];
    isSynced = map[TransactionDetailModelNames.isSynced] == 1 ? true : false;
  }

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailModel(
        paymentMethodId: json["PaymentMethodID"],
        paymentMethodtype: json["PaymentMethodtype"],
        bankId: json["BankID"],
        description: json["Description"],
        amount: json["Amount"],
        amountFc: json["AmountFC"],
        chequeDate: json["ChequeDate"] == null
            ? null
            : DateTime.parse(json["ChequeDate"]),
        chequeNumber: json["ChequeNumber"],
      );

  Map<String, dynamic> toJson() => {
        "PaymentMethodID": paymentMethodId,
        "PaymentMethodtype": paymentMethodtype,
        "BankID": bankId,
        "Description": description,
        "Amount": amount,
        "AmountFC": amountFc,
        "ChequeDate": chequeDate?.toIso8601String(),
        "ChequeNumber": chequeNumber,
      };
}
