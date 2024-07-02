import 'dart:convert';


PosCashRegisterModel posCashRegisterModelFromJson(String str) =>
    PosCashRegisterModel.fromJson(json.decode(str));

String posCashRegisterModelToJson(PosCashRegisterModel data) => json.encode(data.toJson());

class PosCashRegisterListModel {
  PosCashRegisterListModel({
    this.result,
    this.Modelobject,
  });

  int? result;
  List<PosCashRegisterModel>? Modelobject;

  factory PosCashRegisterListModel.fromJson(Map<String, dynamic> json) => PosCashRegisterListModel(
    result: json["result"],
    Modelobject: json["Modelobject"] == null ? [] : List<PosCashRegisterModel>.from(json["Modelobject"].map((x) => PosCashRegisterModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "Modelobject": Modelobject == null ? [] : List<dynamic>.from(Modelobject!.map((x) => x.toJson())),
  };
}

class PosCashRegisterModel {
  PosCashRegisterModel({
    this.cashRegisterID,
    this.cashRegisterName,
    this.locationID,
    this.registerType,
    this.computerName,
    this.receiptDocID,
    this.returnDocID,
    this.defaultCustomerID,
    this.discountAccountID,
    this.expenseDocID,
    this.pettyCashAccountID,
    this.cashReceiptDocID,
    this.chequeReceiptDocID,
    this.salesOrderDocID,
    this.inventoryTransferDocID,
    this.salesPersonID,
    this.note,
    this.isUseLastPrice,
    this.dateUpdated,
    this.dateCreated,
    this.createdBy,
    this.updatedBy,
  });

  String? cashRegisterID;
  String? cashRegisterName;
  String? locationID;
  int? registerType;
  String? computerName;
  String? receiptDocID;
  String? returnDocID;
  String? defaultCustomerID;
  String? discountAccountID;
  String? expenseDocID;
  String? pettyCashAccountID;
  String? cashReceiptDocID;
  String? chequeReceiptDocID;
  String? salesOrderDocID;
  String? inventoryTransferDocID;
  String? salesPersonID;
  String? note;
  int? isUseLastPrice;
  String? dateUpdated;
  String? dateCreated;
  String? createdBy;
  String? updatedBy;

  factory PosCashRegisterModel.fromJson(Map<String, dynamic> json) => PosCashRegisterModel(
    cashRegisterID: json["CashRegisterID"],
    cashRegisterName: json["CashRegisterName"],
    locationID: json["LocationID"],
    registerType: json["RegisterType"],
    computerName: json["ComputerName"],
    receiptDocID: json["ReceiptDocID"],
    returnDocID: json["ReturnDocID"],
    defaultCustomerID: json["DefaultCustomerID"],
    discountAccountID: json["DiscountAccountID"],
    expenseDocID: json["ExpenseDocID"],
    pettyCashAccountID: json["PettyCashAccountID"],
    cashReceiptDocID: json["CashReceiptDocID"],
    chequeReceiptDocID: json["ChequeReceiptDocID"],
    salesOrderDocID: json["SalesOrderDocID"],
    inventoryTransferDocID: json["InventoryTransferDocID"],
    salesPersonID: json["SalesPersonID"],
    note: json["Note"],
    isUseLastPrice: json["IsUseLastPrice"] == null
            ? null
            : json["IsUseLastPrice"]
                ? 1
                : 0,
    dateUpdated: json["DateUpdated"],
    dateCreated: json["DateCreated"],
    createdBy: json["CreatedBy"],
    updatedBy: json["UpdatedBy"],
  );

  Map<String, dynamic> toJson() => {
  "result": 1,
  "Modelobject": [
    {
      "CashRegisterID": cashRegisterID,
      "CashRegisterName": cashRegisterName,
      "LocationID": locationID,
      "RegisterType": registerType,
      "ComputerName": computerName,
      "ReceiptDocID": receiptDocID,
      "ReturnDocID": returnDocID,
      "DefaultCustomerID": defaultCustomerID,
      "DiscountAccountID": discountAccountID,
      "ExpenseDocID": expenseDocID,
      "PettyCashAccountID": pettyCashAccountID,
      "CashReceiptDocID": cashReceiptDocID,
      "ChequeReceiptDocID": chequeReceiptDocID,
      "SalesOrderDocID": salesOrderDocID,
      "InventoryTransferDocID": inventoryTransferDocID,
      "SalesPersonID": salesPersonID,
      "Note": note,
      "IsUseLastPrice": isUseLastPrice,
      "DateUpdated": dateUpdated,
      "DateCreated": dateCreated,
      "CreatedBy": createdBy,
      "UpdatedBy": updatedBy
    }
  ]
};

Map<String, dynamic> toMap() {
  return {
    "CashRegisterID": cashRegisterID,
    "CashRegisterName": cashRegisterName,
    "LocationID": locationID,
    "RegisterType": registerType,
    "ComputerName": computerName,
    "ReceiptDocID": receiptDocID,
    "ReturnDocID": returnDocID,
    "DefaultCustomerID": defaultCustomerID,
    "DiscountAccountID": discountAccountID,
    "ExpenseDocID": expenseDocID,
    "PettyCashAccountID": pettyCashAccountID,
    "CashReceiptDocID": cashReceiptDocID,
    "ChequeReceiptDocID": chequeReceiptDocID,
    "SalesOrderDocID": salesOrderDocID,
    "InventoryTransferDocID": inventoryTransferDocID,
    "SalesPersonID": salesPersonID,
    "Note": note,
    "IsUseLastPrice": isUseLastPrice,
    "DateUpdated": dateUpdated,
    "DateCreated": dateCreated,
    "CreatedBy": createdBy,
    "UpdatedBy": updatedBy
  };
}

PosCashRegisterModel.fromMap(Map<String, dynamic> map) {
cashRegisterID = map['CashRegisterID'];
cashRegisterName = map['CashRegisterName'];
locationID = map['LocationID'];
registerType = map['RegisterType'];
computerName = map['ComputerName'];
receiptDocID = map['ReceiptDocID'];
returnDocID = map['ReturnDocID'];
defaultCustomerID = map['DefaultCustomerID'];
discountAccountID = map['DiscountAccountID'];
expenseDocID = map['ExpenseDocID'];
pettyCashAccountID = map['PettyCashAccountID'];
cashReceiptDocID = map['CashReceiptDocID'];
chequeReceiptDocID = map['ChequeReceiptDocID'];
salesOrderDocID = map['SalesOrderDocID'];
inventoryTransferDocID = map['InventoryTransferDocID'];
salesPersonID = map['SalesPersonID'];
note = map['Note'];
isUseLastPrice = map['IsUseLastPrice'];
dateUpdated = map['DateUpdated'];
dateCreated = map['DateCreated'];
createdBy = map['CreatedBy'];
updatedBy = map['UpdatedBy'];
}

}


class PosCashRegisterListLocalImportantNames {
static const String cashRegisterID = 'CashRegisterID';
static const String cashRegisterName = 'CashRegisterName';
static const String locationID = 'LocationID';
static const String registerType = 'RegisterType';
static const String computerName = 'ComputerName';
static const String receiptDocID = 'ReceiptDocID';
static const String returnDocID = 'ReturnDocID';
static const String defaultCustomerID = 'DefaultCustomerID';
static const String discountAccountID = 'DiscountAccountID';
static const String expenseDocID = 'ExpenseDocID';
static const String pettyCashAccountID = 'PettyCashAccountID';
static const String cashReceiptDocID = 'CashReceiptDocID';
static const String chequeReceiptDocID = 'ChequeReceiptDocID';
static const String salesOrderDocID = 'SalesOrderDocID';
static const String inventoryTransferDocID = 'InventoryTransferDocID';
static const String salesPersonID = 'SalesPersonID';
static const String note = 'Note';
static const String isUseLastPrice = 'IsUseLastPrice';
static const String dateUpdated = 'DateUpdated';
static const String dateCreated = 'DateCreated';
static const String createdBy = 'CreatedBy';
static const String updatedBy = 'UpdatedBy';
static const String tableName = 'posCashRegisterTable';
}