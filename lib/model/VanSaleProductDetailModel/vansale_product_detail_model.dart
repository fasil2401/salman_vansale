import 'dart:convert';

import 'package:axoproject/model/Product%20Model/product_model.dart';

VanSaleDetailModel vanSaleDetailModelFromJson(String str) =>
    VanSaleDetailModel.fromJson(json.decode(str));

String vanSaleDetailModelToJson(VanSaleDetailModel data) =>
    json.encode(data.toJson());

class VanSaleDetailModel {
  List<VanSaleDetail>? vanSaleDetails;
  List<TaxGroupDetail>? taxGroupDetail;
  List<VanSaleProductLotDetail>? vanSaleProductLotDetails;
  dynamic unitTax;
  dynamic price;
  dynamic quantity;
  double initialQuantity;
  dynamic amount;
  UnitModel? updatedUnit;
  List<UnitModel>? unitList;
  int? isTrackLot;
  int? isDamaged;
  bool? isEdited;
  String? customerProductId;

  VanSaleDetailModel({
    this.vanSaleDetails,
    this.taxGroupDetail,
    this.vanSaleProductLotDetails,
    this.unitTax,
    this.price,
    this.quantity,
    this.initialQuantity = 0.0,
    this.amount,
    this.updatedUnit,
    this.unitList,
    this.isDamaged,
    this.isTrackLot,
    this.isEdited,
    this.customerProductId,
  });

  factory VanSaleDetailModel.fromJson(Map<String, dynamic> json) =>
      VanSaleDetailModel(
        vanSaleDetails: json["VANSaleDetails"] == null
            ? []
            : List<VanSaleDetail>.from(
                json["VANSaleDetails"]!.map((x) => VanSaleDetail.fromJson(x))),
        taxGroupDetail: json["TaxGroupDetail"] == null
            ? []
            : List<TaxGroupDetail>.from(
                json["TaxGroupDetail"]!.map((x) => TaxGroupDetail.fromJson(x))),
        vanSaleProductLotDetails: json["VANSaleProductLotDetails"] == null
            ? []
            : List<VanSaleProductLotDetail>.from(
                json["VANSaleProductLotDetails"]!
                    .map((x) => VanSaleProductLotDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "VANSaleDetails": vanSaleDetails == null
            ? []
            : List<dynamic>.from(vanSaleDetails!.map((x) => x.toJson())),
        "TaxGroupDetail": taxGroupDetail == null
            ? []
            : List<dynamic>.from(taxGroupDetail!.map((x) => x.toJson())),
        "VANSaleProductLotDetails": vanSaleProductLotDetails == null
            ? []
            : List<dynamic>.from(
                vanSaleProductLotDetails!.map((x) => x.toJson())),
      };
}

class TaxGroupDetailNames {
  static const String tableName = "taxGroupDetail";
  static const String sysDocId = "sysDocId";
  static const String voucherId = "voucherId";
  static const String taxGroupId = "taxGroupId";
  static const String taxCode = "taxCode";
  static const String items = "items";
  static const String taxRate = "taxRate";
  static const String calculationMethod = "calculationMethod";
  static const String taxAmount = "taxAmount";
  static const String taxExcludeDiscount = "taxExcludeDiscount";
  static const String currencyId = "currencyId";
  static const String rowIndex = "rowIndex";
  static const String orderIndex = "orderIndex";
}

class TaxGroupDetail {
  String? sysDocId;
  String? voucherId;
  String? taxGroupId;
  String? taxCode;
  String? items;
  dynamic taxRate;
  String? calculationMethod;
  dynamic taxAmount;
  dynamic taxExcludeDiscount;
  String? currencyId;
  int? rowIndex;
  int? orderIndex;

  TaxGroupDetail({
    this.sysDocId,
    this.voucherId,
    this.taxGroupId,
    this.taxCode,
    this.items,
    this.taxRate,
    this.calculationMethod,
    this.taxAmount,
    this.taxExcludeDiscount,
    this.currencyId,
    this.rowIndex,
    this.orderIndex,
  });

  factory TaxGroupDetail.fromJson(Map<String, dynamic> json) => TaxGroupDetail(
        sysDocId: json["SysDocId"],
        voucherId: json["VoucherId"],
        taxGroupId: json["TaxGroupId"],
        taxCode: json["TaxCode"],
        items: json["Items"],
        taxRate: json["TaxRate"],
        calculationMethod: json["CalculationMethod"],
        taxAmount: json["TaxAmount"],
        currencyId: json["CurrencyID"],
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
        "CurrencyID": currencyId,
        "RowIndex": rowIndex,
        "OrderIndex": orderIndex,
      };
  TaxGroupDetail.fromMap(Map<String, dynamic> map) {
    sysDocId = map[TaxGroupDetailNames.sysDocId];
    voucherId = map[TaxGroupDetailNames.voucherId];
    taxGroupId = map[TaxGroupDetailNames.taxGroupId];
    taxCode = map[TaxGroupDetailNames.taxCode];
    items = map[TaxGroupDetailNames.items];
    taxRate = map[TaxGroupDetailNames.taxRate];
    calculationMethod = map[TaxGroupDetailNames.calculationMethod];
    taxAmount = map[TaxGroupDetailNames.taxAmount];
    taxExcludeDiscount = map[TaxGroupDetailNames.taxExcludeDiscount];
    currencyId = map[TaxGroupDetailNames.currencyId];
    rowIndex = map[TaxGroupDetailNames.rowIndex];
    orderIndex = map[TaxGroupDetailNames.orderIndex];
  }

  Map<String, dynamic> toMap() {
    return {
      TaxGroupDetailNames.sysDocId: sysDocId,
      TaxGroupDetailNames.voucherId: voucherId,
      TaxGroupDetailNames.taxGroupId: taxGroupId,
      TaxGroupDetailNames.taxCode: taxCode,
      TaxGroupDetailNames.items: items,
      TaxGroupDetailNames.taxRate: taxRate,
      TaxGroupDetailNames.calculationMethod: calculationMethod,
      TaxGroupDetailNames.taxAmount: taxAmount,
      TaxGroupDetailNames.taxExcludeDiscount: taxExcludeDiscount,
      TaxGroupDetailNames.currencyId: currencyId,
      TaxGroupDetailNames.rowIndex: rowIndex,
      TaxGroupDetailNames.orderIndex: orderIndex,
    };
  }
}

class VanSaleDetail {
  int? rowIndex;
  String? productId;
  dynamic quantity;
  dynamic unitPrice;
  String? locationId;
  dynamic listedPrice;
  dynamic amount;
  String? description;
  dynamic discount;
  dynamic taxAmount;
  String? taxGroupId;
  String? barcode;
  String? taxOption;
  String? unitId;
  int? itemType;
  String? productCategory;
  double? saleQuantity;
  double? returnQuantity;
  double? basePrice;
  double? availableQty;
  String? customeritemcode;

  VanSaleDetail({
    this.rowIndex,
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
    this.saleQuantity,
    this.returnQuantity,
    this.basePrice,
    this.availableQty,
    this.customeritemcode
  });

  factory VanSaleDetail.fromJson(Map<String, dynamic> json) => VanSaleDetail(
        rowIndex: json["RowIndex"],
        productId: json["ProductID"],
        quantity: json["Quantity"],
        unitPrice: json["UnitPrice"],
        locationId: json["LocationId"],
        listedPrice: json["ListedPrice"],
        amount: json["Amount"],
        description: json["Description"],
        discount: json["Discount"],
        taxAmount: json["TaxAmount"],
        taxGroupId: json["TaxGroupId"],
        barcode: json["Barcode"],
        taxOption: json["TaxOption"],
        unitId: json["UnitId"],
        itemType: json["ItemType"],
        productCategory: json["ProductCategory"],
        customeritemcode: json["CustomerItemCode"],
      );

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
        "CustomerItemCode": customeritemcode,
      };
}

class VanSaleProductLotDetail {
  String? productId;
  String? locationId;
  String? lotNumber;
  String? reference;
  String? sourceLotNumber;
  dynamic quantity;
  String? binId;
  String? reference2;
  String? sysDocId;
  String? voucherId;
  double? unitPrice;
  int? rowIndex;
  String? unitid;

  VanSaleProductLotDetail({
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

  factory VanSaleProductLotDetail.fromJson(Map<String, dynamic> json) =>
      VanSaleProductLotDetail(
        productId: json["ProductID"],
        locationId: json["LocationId"],
        lotNumber: json["LotNumber"],
        reference: json["Reference"],
        sourceLotNumber: json["SourceLotNumber"],
        quantity: json["Quantity"],
        binId: json["BinID"],
        reference2: json["Reference2"],
        sysDocId: json["SysDocId"],
        voucherId: json["VoucherId"],
        unitPrice: json["UnitPrice"],
        rowIndex: json["RowIndex"],
        unitid: json["Unitid"],
      );

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
