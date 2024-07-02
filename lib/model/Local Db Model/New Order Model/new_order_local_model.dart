class NewOrderApiMOdelNames {
  static const String tableName = "newOrderHeader";
  static const String token = "token";
  static const String salesOrderId = "salesOrderId";
  static const String sysdocid = "sysdocid";
  static const String voucherid = "voucherid";
  static const String customerid = "customerid";
  static const String customerName = "customerName";
  static const String address = "address";
  static const String phone = "phone";
  static const String shiftId = "shiftId";
  static const String batchId = "batchId";
  static const String companyid = "companyid";
  static const String transactiondate = "transactiondate";
  static const String isCash = "isCash";
  static const String registerId = "registerId";
  static const String salespersonid = "salespersonid";
  static const String shippingAddressId = "shippingAddressId";
  static const String customeraddress = "customeraddress";
  static const String payeetaxgroupid = "payeetaxgroupid";
  static const String taxoption = "taxoption";
  static const String priceincludetax = "priceincludetax";
  static const String discount = "discount";
  static const String discountPercentage = "discountPercentage";
  static const String taxamount = "taxamount";
  static const String total = "total";
  static const String note = "note";
  static const String paymentMethodType = "paymentMethodType";
  static const String isSynced = 'isSynced';
  static const String isError = 'isError';
  static const String error = 'error';
  static const String routeId = "routeId";
  static const String taxGroupId = "taxGroupId";
  static const String headerImage = "headerImage";
  static const String footerImage = "footerImage";
  static const String quantity = "quantity";
}

class NewOrderApiModel {
  String? token;
  String? salesOrderId;
  String? sysdocid;
  String? voucherid;
  String? customerid;
  String? customerName;
  String? headerImage;
  String? footerImage;
  String? address;
  String? phone;
  int? shiftId;
  int? batchId;
  String? companyid;
  String? transactiondate;
  int? isCash;
  String? registerId;
  String? salespersonid;
  String? shippingAddressId;
  String? customeraddress;
  String? payeetaxgroupid;
  String? taxGroupId;
  int? taxoption;
  int? priceincludetax;
  double? discount;
  double? discountPercentage;
  double? taxamount;
  double? total;
  String? note;
  int? paymentMethodType;
  int? isSynced;
  int? isError;
  String? error;
  String? routeId;
  double? quantity;

  NewOrderApiModel(
      {this.token,
      this.salesOrderId,
      this.sysdocid,
      this.voucherid,
      this.customerid,
      this.customerName,
      this.headerImage,
      this.footerImage,
      this.address,
      this.phone,
      this.shiftId,
      this.batchId,
      this.companyid,
      this.transactiondate,
      this.isCash,
      this.registerId,
      this.salespersonid,
      this.shippingAddressId,
      this.customeraddress,
      this.payeetaxgroupid,
      this.taxGroupId,
      this.taxoption,
      this.priceincludetax,
      this.discount,
      this.discountPercentage,
      this.taxamount,
      this.total,
      this.note,
      this.paymentMethodType,
      this.isSynced,
      this.isError,
      this.error,
      this.routeId,
      this.quantity});

  Map<String, dynamic> toMap() {
    return {
      NewOrderApiMOdelNames.salesOrderId: salesOrderId,
      NewOrderApiMOdelNames.sysdocid: sysdocid,
      NewOrderApiMOdelNames.voucherid: voucherid,
      NewOrderApiMOdelNames.customerid: customerid,
      NewOrderApiMOdelNames.customerName: customerName,
      NewOrderApiMOdelNames.address: address,
      NewOrderApiMOdelNames.phone: phone,
      NewOrderApiMOdelNames.shiftId: shiftId,
      NewOrderApiMOdelNames.batchId: batchId,
      NewOrderApiMOdelNames.companyid: companyid,
      NewOrderApiMOdelNames.transactiondate: transactiondate,
      NewOrderApiMOdelNames.isCash: isCash,
      NewOrderApiMOdelNames.registerId: registerId,
      NewOrderApiMOdelNames.salespersonid: salespersonid,
      NewOrderApiMOdelNames.shippingAddressId: shippingAddressId,
      NewOrderApiMOdelNames.customeraddress: customeraddress,
      NewOrderApiMOdelNames.payeetaxgroupid: payeetaxgroupid,
      NewOrderApiMOdelNames.taxoption: taxoption,
      NewOrderApiMOdelNames.priceincludetax: priceincludetax,
      NewOrderApiMOdelNames.discount: discount,
      NewOrderApiMOdelNames.discountPercentage: discountPercentage,
      NewOrderApiMOdelNames.taxamount: taxamount,
      NewOrderApiMOdelNames.total: total,
      NewOrderApiMOdelNames.note: note,
      NewOrderApiMOdelNames.paymentMethodType: paymentMethodType,
      NewOrderApiMOdelNames.isSynced: isSynced,
      NewOrderApiMOdelNames.isError: isError,
      NewOrderApiMOdelNames.error: error,
      NewOrderApiMOdelNames.routeId: routeId,
      NewOrderApiMOdelNames.taxGroupId: taxGroupId,
      NewOrderApiMOdelNames.headerImage: headerImage,
      NewOrderApiMOdelNames.footerImage: footerImage,
      NewOrderApiMOdelNames.quantity: quantity,
    };
  }

  NewOrderApiModel.fromMap(Map<String, dynamic> map) {
    salesOrderId = map[NewOrderApiMOdelNames.salesOrderId];
    sysdocid = map[NewOrderApiMOdelNames.sysdocid];
    voucherid = map[NewOrderApiMOdelNames.voucherid];
    customerid = map[NewOrderApiMOdelNames.customerid];
    customerName = map[NewOrderApiMOdelNames.customerName];
    address = map[NewOrderApiMOdelNames.address];
    phone = map[NewOrderApiMOdelNames.phone];
    shiftId = map[NewOrderApiMOdelNames.shiftId];
    batchId = map[NewOrderApiMOdelNames.batchId];
    companyid = map[NewOrderApiMOdelNames.companyid];
    transactiondate = map[NewOrderApiMOdelNames.transactiondate];
    isCash = map[NewOrderApiMOdelNames.isCash];
    registerId = map[NewOrderApiMOdelNames.registerId];
    salespersonid = map[NewOrderApiMOdelNames.salespersonid];
    shippingAddressId = map[NewOrderApiMOdelNames.shippingAddressId];
    customeraddress = map[NewOrderApiMOdelNames.customeraddress];
    payeetaxgroupid = map[NewOrderApiMOdelNames.payeetaxgroupid];
    taxoption = map[NewOrderApiMOdelNames.taxoption];
    priceincludetax = map[NewOrderApiMOdelNames.priceincludetax];
    discount = map[NewOrderApiMOdelNames.discount];
    discountPercentage = map[NewOrderApiMOdelNames.discountPercentage];
    taxamount = map[NewOrderApiMOdelNames.taxamount];
    total = map[NewOrderApiMOdelNames.total];
    note = map[NewOrderApiMOdelNames.note];
    paymentMethodType = map[NewOrderApiMOdelNames.paymentMethodType];
    isSynced = map[NewOrderApiMOdelNames.isSynced];
    isError = map[NewOrderApiMOdelNames.isError];
    error = map[NewOrderApiMOdelNames.error];
    routeId = map[NewOrderApiMOdelNames.routeId];
    taxGroupId = map[NewOrderApiMOdelNames.taxGroupId];
    headerImage = map[NewOrderApiMOdelNames.headerImage];
    footerImage = map[NewOrderApiMOdelNames.footerImage];
    quantity = map[NewOrderApiMOdelNames.quantity];
  }
}

class NewOrderDetailApiModelNames {
  static const String tableName = "newOrderDetailApiModel";
  static const String detailId = "detailId";
  static const String sysDocId = "sysDocId";
  static const String voucherId = 'voucherId';
  static const String productId = 'productId';
  static const String salesOrderId = 'salesOrderId';
  static const String quantity = "quantity";
  static const String barcode = 'barcode';
  static const String unitprice = "unitprice";
  static const String amount = "amount";
  static const String description = "description";
  static const String unitid = "unitid";
  static const String taxoption = "taxoption";
  static const String taxgroupid = "taxgroupid";
  static const String taxamount = "taxamount";
  static const String rowindex = "rowindex";
  static const String locationid = "locationid";
  static const String factor = "factor";
  static const String factorType = "factorType";
  static const String isManinUnit = "isManinUnit";
}

class NewOrderDetailApiModel {
  NewOrderDetailApiModel({
    this.detailId,
    this.sysDocId,
    this.voucherId,
    this.productId,
    this.salesOrderId,
    this.quantity,
    this.barcode,
    this.unitprice,
    this.amount,
    this.description,
    this.unitid,
    this.taxoption,
    this.taxgroupid,
    this.taxamount,
    this.rowindex,
    this.locationid,
    this.factor,
    this.factorType,
    this.isManinUnit,
    
  });
  String? detailId;
  String? sysDocId;
  String? voucherId;
  String? productId;
  String? salesOrderId;
  double? quantity;
  String? barcode;
  double? unitprice;
  double? amount;
  String? description;
  String? unitid;
  int? taxoption;
  String? taxgroupid;
  double? taxamount;
  int? rowindex;
  String? locationid;
  double? factor;
  String? factorType;
  int? isManinUnit;

  Map<String, dynamic> toMap() {
    return {
      NewOrderDetailApiModelNames.detailId: detailId,
      NewOrderDetailApiModelNames.sysDocId: sysDocId,
      NewOrderDetailApiModelNames.voucherId: voucherId,
      NewOrderDetailApiModelNames.productId: productId,
      NewOrderDetailApiModelNames.salesOrderId: salesOrderId,
      NewOrderDetailApiModelNames.quantity: quantity,
      NewOrderDetailApiModelNames.barcode: barcode,
      NewOrderDetailApiModelNames.unitprice: unitprice,
      NewOrderDetailApiModelNames.amount: amount,
      NewOrderDetailApiModelNames.description: description,
      NewOrderDetailApiModelNames.unitid: unitid,
      NewOrderDetailApiModelNames.taxoption: taxoption,
      NewOrderDetailApiModelNames.taxgroupid: taxgroupid,
      NewOrderDetailApiModelNames.taxamount: taxamount,
      NewOrderDetailApiModelNames.rowindex: rowindex,
      NewOrderDetailApiModelNames.locationid: locationid,
      NewOrderDetailApiModelNames.factor: factor,
      NewOrderDetailApiModelNames.factorType: factorType,
      NewOrderDetailApiModelNames.isManinUnit: isManinUnit,
    };
  }

  NewOrderDetailApiModel.fromMap(Map<String, dynamic> map) {
    detailId = map[NewOrderDetailApiModelNames.detailId];
    sysDocId = map[NewOrderDetailApiModelNames.sysDocId];
    voucherId = map[NewOrderDetailApiModelNames.voucherId];
    productId = map[NewOrderDetailApiModelNames.productId];
    salesOrderId = map[NewOrderDetailApiModelNames.salesOrderId];
    quantity = map[NewOrderDetailApiModelNames.quantity];
    barcode = map[NewOrderDetailApiModelNames.barcode];
    unitprice = map[NewOrderDetailApiModelNames.unitprice];
    amount = map[NewOrderDetailApiModelNames.amount];
    description = map[NewOrderDetailApiModelNames.description];
    unitid = map[NewOrderDetailApiModelNames.unitid];
    taxoption = map[NewOrderDetailApiModelNames.taxoption];
    taxgroupid = map[NewOrderDetailApiModelNames.taxgroupid];
    taxamount = map[NewOrderDetailApiModelNames.taxamount];
    rowindex = map[NewOrderDetailApiModelNames.rowindex];
    locationid = map[NewOrderDetailApiModelNames.locationid];
    factor = map[NewOrderDetailApiModelNames.factor];
    factorType = map[NewOrderDetailApiModelNames.factorType];
    isManinUnit = map[NewOrderDetailApiModelNames.isManinUnit];
  }
}

class NewOrderLotApiModelNames {
  static const String tableName = "newOrderLotApiModel";
  static const String token = "token";
  static const String salesLotId = "salesLotId";
  static const String productId = "productId";
  static const String sysDocId = "sysDocId";
  static const String voucherId = "voucherId";
  static const String locationId = "locationId";
  static const String reference2 = "reference2";
  static const String reference = "reference";
  static const String cost = "cost";
  static const String unitPrice = "unitPrice";
  static const String rowIndex = "rowIndex";
  static const String unitId = "unitId";
  static const String lotNumber = "lotNumber";
  static const String quantity = "quantity";
}

class NewOrderLotApiModel {
  NewOrderLotApiModel({
    this.token,
    this.salesLotId,
    this.productId,
    this.sysDocId,
    this.voucherId,
    this.locationId,
    this.reference2,
    this.reference,
    this.cost,
    this.unitPrice,
    this.rowIndex,
    this.unitId,
    this.lotNumber,
    this.quantity,
  });
  String? token;
  String? salesLotId;
  String? productId;
  String? sysDocId;
  String? voucherId;
  String? locationId;
  String? reference2;
  String? reference;
  double? cost;
  double? unitPrice;
  int? rowIndex;
  String? unitId;
  String? lotNumber;
  double? quantity;
  Map<String, dynamic> toMap() {
    return {
      NewOrderLotApiModelNames.salesLotId: salesLotId,
      NewOrderLotApiModelNames.productId: productId,
      NewOrderLotApiModelNames.sysDocId: sysDocId,
      NewOrderLotApiModelNames.voucherId: voucherId,
      NewOrderLotApiModelNames.locationId: locationId,
      NewOrderLotApiModelNames.reference2: reference2,
      NewOrderLotApiModelNames.reference: reference,
      NewOrderLotApiModelNames.cost: cost,
      NewOrderLotApiModelNames.unitPrice: unitPrice,
      NewOrderLotApiModelNames.rowIndex: rowIndex,
      NewOrderLotApiModelNames.unitId: unitId,
      NewOrderLotApiModelNames.lotNumber: lotNumber,
      NewOrderLotApiModelNames.quantity: quantity,
    };
  }

  NewOrderLotApiModel.fromMap(Map<String, dynamic> map) {
    salesLotId = map[NewOrderLotApiModelNames.salesLotId];
    productId = map[NewOrderLotApiModelNames.productId];
    sysDocId = map[NewOrderLotApiModelNames.sysDocId];
    voucherId = map[NewOrderLotApiModelNames.voucherId];
    locationId = map[NewOrderLotApiModelNames.locationId];
    reference2 = map[NewOrderLotApiModelNames.reference2];
    reference = map[NewOrderLotApiModelNames.reference];
    cost = map[NewOrderLotApiModelNames.cost];
    unitPrice = map[NewOrderLotApiModelNames.unitPrice];
    rowIndex = map[NewOrderLotApiModelNames.rowIndex];
    unitId = map[NewOrderLotApiModelNames.unitId];
    lotNumber = map[NewOrderLotApiModelNames.lotNumber];
    quantity = map[NewOrderLotApiModelNames.quantity];
  }
}

class TaxDetailNames {
  static const String tableName = "taxDetail";
  static const String sysDocId = "sysDocId";
  static const String voucherId = "voucherId";
  static const String taxLevel = "taxLevel";
  static const String taxGroupId = "taxGroupId";
  static const String taxItemId = "taxItemId";
  static const String taxItemName = "taxItemName";
  static const String taxRate = "taxRate";
  static const String calculationMethod = "calculationMethod";
  static const String taxAmount = "taxAmount";
  static const String orderIndex = "orderIndex";
  static const String rowIndex = "rowIndex";
  static const String accountId = "accountId";
  static const String currencyId = "currencyId";
  static const String currencyRate = "currencyRate";
}

class TaxDetail {
  String? token;
  String? sysDocId;
  String? voucherId;
  int? taxLevel;
  String? taxGroupId;
  String? taxItemId;
  String? taxItemName;
  double? taxRate;
  String? calculationMethod;
  double? taxAmount;
  int? orderIndex;
  int? rowIndex;
  String? accountId;
  String? currencyId;
  double? currencyRate;

  TaxDetail({
    this.token,
    this.sysDocId,
    this.voucherId,
    this.taxLevel,
    this.taxGroupId,
    this.taxItemId,
    this.taxItemName,
    this.taxRate,
    this.calculationMethod,
    this.taxAmount,
    this.orderIndex,
    this.rowIndex,
    this.accountId,
    this.currencyId,
    this.currencyRate,
  });

  factory TaxDetail.fromJson(Map<String, dynamic> json) => TaxDetail(
        token: json["token"],
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        taxLevel: json["TaxLevel"],
        taxGroupId: json["TaxGroupID"],
        taxItemId: json["TaxItemID"],
        taxItemName: json["TaxItemName"],
        taxRate: json["TaxRate"],
        calculationMethod: json["CalculationMethod"],
        taxAmount: json["TaxAmount"],
        orderIndex: json["OrderIndex"],
        rowIndex: json["RowIndex"],
        accountId: json["AccountID"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "TaxLevel": taxLevel,
        "TaxGroupID": taxGroupId,
        "TaxItemID": taxItemId,
        "TaxItemName": taxItemName,
        "TaxRate": taxRate,
        "CalculationMethod": calculationMethod,
        "TaxAmount": taxAmount,
        "OrderIndex": orderIndex,
        "RowIndex": rowIndex,
        "AccountID": accountId,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
      };

  Map<String, dynamic> toMap() {
    return {
      TaxDetailNames.sysDocId: sysDocId,
      TaxDetailNames.voucherId: voucherId,
      TaxDetailNames.taxLevel: taxLevel,
      TaxDetailNames.taxGroupId: taxGroupId,
      TaxDetailNames.taxItemId: taxItemId,
      TaxDetailNames.taxItemName: taxItemName,
      TaxDetailNames.taxRate: taxRate,
      TaxDetailNames.calculationMethod: calculationMethod,
      TaxDetailNames.taxAmount: taxAmount,
      TaxDetailNames.orderIndex: orderIndex,
      TaxDetailNames.rowIndex: rowIndex,
      TaxDetailNames.accountId: accountId,
      TaxDetailNames.currencyId: currencyId,
      TaxDetailNames.currencyRate: currencyRate,
    };
  }

  TaxDetail.fromMap(Map<String, dynamic> map) {
    sysDocId = map[TaxDetailNames.sysDocId];
    voucherId = map[TaxDetailNames.voucherId];
    taxLevel = map[TaxDetailNames.taxLevel];
    taxGroupId = map[TaxDetailNames.taxGroupId];
    taxItemId = map[TaxDetailNames.taxItemId];
    taxItemName = map[TaxDetailNames.taxItemName];
    taxRate = map[TaxDetailNames.taxRate];
    calculationMethod = map[TaxDetailNames.calculationMethod];
    taxAmount = map[TaxDetailNames.taxAmount];
    orderIndex = map[TaxDetailNames.orderIndex];
    rowIndex = map[TaxDetailNames.rowIndex];
    accountId = map[TaxDetailNames.accountId];
    currencyId = map[TaxDetailNames.currencyId];
    currencyRate = map[TaxDetailNames.currencyRate];
  }
}
