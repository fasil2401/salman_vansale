class SalesInvoiceApiModelNames {
  static const String tableName = "salesInvoiceHeader";
  static const String token = "token";
  static const String vANSalesPOS = "vANSalesPOS";
  static const String sysdocid = "sysdocid";
  static const String voucherid = "voucherid";
  static const String divisionID = "divisionID";
  static const String companyID = "companyID";
  static const String shiftID = "shiftID";
  static const String batchID = "batchID";
  static const String customerID = "customerID";
  static const String customerName = "customerName";
  static const String transactionDate = "transactionDate";
  static const String registerId = "registerId";
  static const String paymentType = "paymentType";
  static const String salespersonId = "salespersonId";
  static const String address = "address";
  static const String phone = "phone";
  static const String note = "note";
  static const String total = "total";
  static const String taxAmount = "taxAmount";
  static const String discount = "discount";
  static const String taxGroupId = "taxGroupId";
  static const String reference = "reference";
  static const String reference1 = "reference1";
  static const String taxOption = "taxOption";
  static const String dateCreated = "dateCreated";
  static const String accountID = "accountID";
  static const String paymentMethodID = "paymentMethodID";
  static const String headerImage = "headerImage";
  static const String footerImage = "footerImage";
  static const String isReturn = "isReturn";
  static const String isSynced = 'isSynced';
  static const String isError = 'isError';
  static const String error = 'error';
  static const String quantity = "quantity";
}

class SalesInvoiceApiModel {
  String? token;
  int? isnewRecord;
  String? vanSalesPos;
  String? sysdocid;
  String? voucherid;
  String? divisionId;
  int? companyId;
  int? shiftId;
  int? batchId;
  String? customerId;
  String? customerName;
  String? transactionDate;
  String? registerId;
  int? paymentType;
  String? salespersonId;
  String? note;
  double? total;
  double? taxAmount;
  double? discount;
  String? taxGroupId;
  String? reference;
  String? reference1;
  String? address;
  String? phone;
  int? taxOption;
  String? dateCreated;
  String? accountID;
  String? paymentMethodID;
  String? headerImage;
  String? footerImage;
  int? isReturn;
  int? isSynced;
  int? isError;
  String? error;
  double? quantity;
  double? availableAmount;

  SalesInvoiceApiModel(
      {this.token,
      this.isnewRecord,
      this.vanSalesPos,
      this.sysdocid,
      this.voucherid,
      this.divisionId,
      this.companyId,
      this.shiftId,
      this.batchId,
      this.customerId,
      this.customerName,
      this.transactionDate,
      this.registerId,
      this.paymentType,
      this.salespersonId,
      this.note,
      this.total,
      this.taxAmount,
      this.discount,
      this.taxGroupId,
      this.reference,
      this.reference1,
      this.address,
      this.phone,
      this.taxOption,
      this.dateCreated,
      this.accountID,
      this.paymentMethodID,
      this.headerImage,
      this.footerImage,
      this.isReturn,
      this.isSynced,
      this.isError,
      this.error,
      this.quantity,
      this.availableAmount});

  Map<String, dynamic> toMap() {
    return {
      SalesInvoiceApiModelNames.vANSalesPOS: vanSalesPos,
      SalesInvoiceApiModelNames.sysdocid: sysdocid,
      SalesInvoiceApiModelNames.voucherid: voucherid,
      SalesInvoiceApiModelNames.divisionID: divisionId,
      SalesInvoiceApiModelNames.companyID: companyId,
      SalesInvoiceApiModelNames.shiftID: shiftId,
      SalesInvoiceApiModelNames.batchID: batchId,
      SalesInvoiceApiModelNames.customerID: customerId,
      SalesInvoiceApiModelNames.customerName: customerName,
      SalesInvoiceApiModelNames.transactionDate: transactionDate,
      SalesInvoiceApiModelNames.registerId: registerId,
      SalesInvoiceApiModelNames.paymentType: paymentType,
      SalesInvoiceApiModelNames.salespersonId: salespersonId,
      SalesInvoiceApiModelNames.address: address,
      SalesInvoiceApiModelNames.phone: phone,
      SalesInvoiceApiModelNames.note: note,
      SalesInvoiceApiModelNames.total: total,
      SalesInvoiceApiModelNames.taxAmount: taxAmount,
      SalesInvoiceApiModelNames.discount: discount,
      SalesInvoiceApiModelNames.taxGroupId: taxGroupId,
      SalesInvoiceApiModelNames.reference: reference,
      SalesInvoiceApiModelNames.reference1: reference1,
      SalesInvoiceApiModelNames.taxOption: taxOption,
      SalesInvoiceApiModelNames.dateCreated: dateCreated,
      SalesInvoiceApiModelNames.accountID: accountID,
      SalesInvoiceApiModelNames.paymentMethodID: paymentMethodID,
      SalesInvoiceApiModelNames.headerImage: headerImage,
      SalesInvoiceApiModelNames.footerImage: footerImage,
      SalesInvoiceApiModelNames.isReturn: isReturn,
      SalesInvoiceApiModelNames.isSynced: isSynced,
      SalesInvoiceApiModelNames.isError: isError,
      SalesInvoiceApiModelNames.error: error,
      SalesInvoiceApiModelNames.quantity: quantity,
    };
  }

  SalesInvoiceApiModel.fromMap(Map<String, dynamic> map) {
    token = map[SalesInvoiceApiModelNames.token];
    vanSalesPos = map[SalesInvoiceApiModelNames.vANSalesPOS];
    sysdocid = map[SalesInvoiceApiModelNames.sysdocid];
    voucherid = map[SalesInvoiceApiModelNames.voucherid];
    divisionId = map[SalesInvoiceApiModelNames.divisionID];
    companyId = map[SalesInvoiceApiModelNames.companyID];
    shiftId = map[SalesInvoiceApiModelNames.shiftID];
    batchId = map[SalesInvoiceApiModelNames.batchID];
    customerId = map[SalesInvoiceApiModelNames.customerID];
    customerName = map[SalesInvoiceApiModelNames.customerName];
    transactionDate = map[SalesInvoiceApiModelNames.transactionDate];
    registerId = map[SalesInvoiceApiModelNames.registerId];
    paymentType = map[SalesInvoiceApiModelNames.paymentType];
    salespersonId = map[SalesInvoiceApiModelNames.salespersonId];
    address = map[SalesInvoiceApiModelNames.address];
    phone = map[SalesInvoiceApiModelNames.phone];
    note = map[SalesInvoiceApiModelNames.note];
    total = map[SalesInvoiceApiModelNames.total];
    taxAmount = map[SalesInvoiceApiModelNames.taxAmount];
    discount = map[SalesInvoiceApiModelNames.discount];
    taxGroupId = map[SalesInvoiceApiModelNames.taxGroupId];
    reference = map[SalesInvoiceApiModelNames.reference];
    reference1 = map[SalesInvoiceApiModelNames.reference1];
    taxOption = map[SalesInvoiceApiModelNames.taxOption];
    dateCreated = map[SalesInvoiceApiModelNames.dateCreated];
    accountID = map[SalesInvoiceApiModelNames.accountID];
    paymentMethodID = map[SalesInvoiceApiModelNames.paymentMethodID];
    headerImage = map[SalesInvoiceApiModelNames.headerImage];
    footerImage = map[SalesInvoiceApiModelNames.footerImage];
    isReturn = map[SalesInvoiceApiModelNames.isReturn];
    isSynced = map[SalesInvoiceApiModelNames.isSynced];
    isError = map[SalesInvoiceApiModelNames.isError];
    error = map[SalesInvoiceApiModelNames.error];
    quantity = map[SalesInvoiceApiModelNames.quantity];
    availableAmount = map['DueAmount'];
  }
}

class SalesInvoiceDetailApiModelNames {
  static const String tableName = "salesInvoiceDetail";
  static const String rowIndex = "rowIndex";
  static const String productID = "productID";
  static const String quantity = "quantity";
  static const String unitPrice = "unitPrice";
  static const String locationId = "locationId";
  static const String listedPrice = "listedPrice";
  static const String amount = "amount";
  static const String description = "description";
  static const String discount = "discount";
  static const String taxAmount = "taxAmount";
  static const String taxGroupId = "taxGroupId";
  static const String barcode = "barcode";
  static const String taxOption = "taxOption";
  static const String unitId = "unitId";
  static const String itemType = "itemType";
  static const String productCategory = "productCategory";
  static const String voucherId = "voucherId";
  static const String onHand = "onHand";
  static const String isDamaged = "isDamaged";
  static const String isMainUnit = "isMainUnit";
  static const String factor = "factor";
  static const String factorType = "factorType";
  static const String customerProductId = "customerProductId";
}

class SalesInvoiceDetailApiModel {
  int? rowIndex;
  String? productId;
  double? quantity;
  double? unitPrice;
  String? locationId;
  double? listedPrice;
  double? amount;
  String? description;
  double? discount;
  double? taxAmount;
  String? taxGroupId;
  String? barcode;
  String? taxOption;
  String? unitId;
  int? itemType;
  String? productCategory;
  String? voucherId;
  double? onHand;
  int? isDamaged;
  int? isMainUnit;
  dynamic factor;
  String? factorType;
  String? customerProductId;
  SalesInvoiceDetailApiModel(
      {this.rowIndex,
      this.productId,
      this.quantity,
      this.unitPrice,
      this.locationId,
      this.listedPrice,
      this.amount,
      this.description,
      this.discount,
      this.taxAmount,
      this.taxGroupId,
      this.barcode,
      this.taxOption,
      this.unitId,
      this.itemType,
      this.productCategory,
      this.voucherId,
      this.onHand,
      this.isDamaged,
      this.isMainUnit,
      this.factor,
      this.factorType,
      this.customerProductId});

  SalesInvoiceDetailApiModel.fromMap(Map<String, dynamic> map) {
    rowIndex = map[SalesInvoiceDetailApiModelNames.rowIndex];
    productId = map[SalesInvoiceDetailApiModelNames.productID];
    quantity = map[SalesInvoiceDetailApiModelNames.quantity];
    unitPrice = map[SalesInvoiceDetailApiModelNames.unitPrice];
    locationId = map[SalesInvoiceDetailApiModelNames.locationId];
    listedPrice = map[SalesInvoiceDetailApiModelNames.listedPrice];
    amount = map[SalesInvoiceDetailApiModelNames.amount];
    description = map[SalesInvoiceDetailApiModelNames.description];
    discount = map[SalesInvoiceDetailApiModelNames.discount];
    taxAmount = map[SalesInvoiceDetailApiModelNames.taxAmount];
    taxGroupId = map[SalesInvoiceDetailApiModelNames.taxGroupId];
    barcode = map[SalesInvoiceDetailApiModelNames.barcode];
    taxOption = map[SalesInvoiceDetailApiModelNames.taxOption];
    unitId = map[SalesInvoiceDetailApiModelNames.unitId];
    itemType = map[SalesInvoiceDetailApiModelNames.itemType];
    productCategory = map[SalesInvoiceDetailApiModelNames.productCategory];
    voucherId = map[SalesInvoiceDetailApiModelNames.voucherId];
    onHand = map[SalesInvoiceDetailApiModelNames.onHand];
    isDamaged = map[SalesInvoiceDetailApiModelNames.isDamaged];
    isMainUnit = map[SalesInvoiceDetailApiModelNames.isMainUnit];
    factor = map[SalesInvoiceDetailApiModelNames.factor];
    factorType = map[SalesInvoiceDetailApiModelNames.factorType];
    customerProductId = map[SalesInvoiceDetailApiModelNames.customerProductId];
  }

  Map<String, dynamic> toMap() {
    return {
      SalesInvoiceDetailApiModelNames.rowIndex: rowIndex,
      SalesInvoiceDetailApiModelNames.productID: productId,
      SalesInvoiceDetailApiModelNames.quantity: quantity,
      SalesInvoiceDetailApiModelNames.unitPrice: unitPrice,
      SalesInvoiceDetailApiModelNames.locationId: locationId,
      SalesInvoiceDetailApiModelNames.listedPrice: listedPrice,
      SalesInvoiceDetailApiModelNames.amount: amount,
      SalesInvoiceDetailApiModelNames.description: description,
      SalesInvoiceDetailApiModelNames.discount: discount,
      SalesInvoiceDetailApiModelNames.taxAmount: taxAmount,
      SalesInvoiceDetailApiModelNames.taxGroupId: taxGroupId,
      SalesInvoiceDetailApiModelNames.barcode: barcode,
      SalesInvoiceDetailApiModelNames.taxOption: taxOption,
      SalesInvoiceDetailApiModelNames.unitId: unitId,
      SalesInvoiceDetailApiModelNames.itemType: itemType,
      SalesInvoiceDetailApiModelNames.productCategory: productCategory,
      SalesInvoiceDetailApiModelNames.voucherId: voucherId,
      SalesInvoiceDetailApiModelNames.onHand: onHand,
      SalesInvoiceDetailApiModelNames.isDamaged: isDamaged,
      SalesInvoiceDetailApiModelNames.isMainUnit: isMainUnit,
      SalesInvoiceDetailApiModelNames.factor: factor,
      SalesInvoiceDetailApiModelNames.factorType: factorType,
      SalesInvoiceDetailApiModelNames.customerProductId: customerProductId,
    };
  }

  Map<String, dynamic> toJson() => {
        "RowIndex": rowIndex,
        "ProductID": productId,
        "Quantity": quantity,
        "UnitPrice": unitPrice,
        "LocationId": locationId,
        "ListedPrice": listedPrice,
        "Amount": amount,
        "Description": description,
        "Discount": discount,
        "TaxAmount": taxAmount,
        "TaxGroupId": taxGroupId,
        "Barcode": barcode,
        "TaxOption": taxOption,
        "UnitId": unitId,
        "ItemType": itemType,
        "ProductCategory": productCategory,
      };
}

class SalesInvoiceLotApiModelNames {
  static const String tableName = "salesInvoiceLot";
  static const String productId = "productId";
  static const String locationId = "locationId";
  static const String lotNumber = "lotNumber";
  static const String reference = "reference";
  static const String sourceLotNumber = "sourceLotNumber";
  static const String quantity = "quantity";
  static const String binID = " binID";
  static const String reference2 = "reference2";
  static const String sysDocId = "sysDocId";
  static const String voucherId = "voucherId";
  static const String unitPrice = "unitPrice";
  static const String rowIndex = "rowIndex";
  static const String unitId = "unitId";
}

class SalesInvoiceLotApiModel {
  String? productId;
  String? locationId;
  String? lotNumber;
  String? reference;
  String? sourceLotNumber;
  double? quantity;
  String? binId;
  String? reference2;
  String? sysDocId;
  String? voucherId;
  double? unitPrice;
  int? rowIndex;
  String? unitid;

  SalesInvoiceLotApiModel({
    this.productId,
    this.locationId,
    this.lotNumber,
    this.reference,
    this.sourceLotNumber,
    this.quantity,
    this.binId,
    this.reference2,
    this.sysDocId,
    this.voucherId,
    this.unitPrice,
    this.rowIndex,
    this.unitid,
  });

  SalesInvoiceLotApiModel.fromMap(Map<String, dynamic> map) {
    productId = map[SalesInvoiceLotApiModelNames.productId];
    locationId = map[SalesInvoiceLotApiModelNames.locationId];
    lotNumber = map[SalesInvoiceLotApiModelNames.lotNumber];
    reference = map[SalesInvoiceLotApiModelNames.reference];
    sourceLotNumber = map[SalesInvoiceLotApiModelNames.sourceLotNumber];
    quantity = map[SalesInvoiceLotApiModelNames.quantity];
    binId = map[SalesInvoiceLotApiModelNames.binID];
    reference2 = map[SalesInvoiceLotApiModelNames.reference2];
    sysDocId = map[SalesInvoiceLotApiModelNames.sysDocId];
    voucherId = map[SalesInvoiceLotApiModelNames.voucherId];
    unitPrice = map[SalesInvoiceLotApiModelNames.unitPrice];
    rowIndex = map[SalesInvoiceLotApiModelNames.rowIndex];
    unitid = map[SalesInvoiceLotApiModelNames.unitId];
  }

  Map<String, dynamic> toMap() {
    return {
      SalesInvoiceLotApiModelNames.productId: productId,
      SalesInvoiceLotApiModelNames.locationId: locationId,
      SalesInvoiceLotApiModelNames.lotNumber: lotNumber,
      SalesInvoiceLotApiModelNames.reference: reference,
      SalesInvoiceLotApiModelNames.sourceLotNumber: sourceLotNumber,
      SalesInvoiceLotApiModelNames.quantity: quantity,
      SalesInvoiceLotApiModelNames.binID: binId,
      SalesInvoiceLotApiModelNames.reference2: reference2,
      SalesInvoiceLotApiModelNames.sysDocId: sysDocId,
      SalesInvoiceLotApiModelNames.voucherId: voucherId,
      SalesInvoiceLotApiModelNames.unitPrice: unitPrice,
      SalesInvoiceLotApiModelNames.rowIndex: rowIndex,
      SalesInvoiceLotApiModelNames.unitId: unitid,
    };
  }

  Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "LocationId": locationId,
        "LotNumber": lotNumber,
        "Reference": reference,
        "SourceLotNumber": sourceLotNumber,
        "Quantity": quantity,
        "BinID": binId,
        "Reference2": reference2,
        "SysDocId": sysDocId,
        "VoucherId": voucherId,
        "UnitPrice": unitPrice,
        "RowIndex": rowIndex,
        "Unitid": unitid,
      };
}
