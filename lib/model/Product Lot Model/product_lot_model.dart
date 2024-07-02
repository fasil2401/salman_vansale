import 'dart:developer';

import 'package:flutter/material.dart';

class ProductLotModel {
  final String? productID;
  final String? locationID;
  final String? lotNumber;
  final dynamic reference;
  final dynamic reference2;
  final int? itemType;
  final String? sourceLotNumber;
  dynamic lotQty;
  final dynamic cost;
  final String? consignNumber;
  final dynamic availableQty;
  final TextEditingController? controller;
  bool? isError;

  ProductLotModel(
      {this.productID,
      this.locationID,
      this.lotNumber,
      this.reference,
      this.reference2,
      this.itemType,
      this.sourceLotNumber,
      this.lotQty,
      this.cost,
      this.consignNumber,
      this.availableQty,
      this.controller,
      this.isError});

  factory ProductLotModel.fromJson(Map<String, dynamic> json) {
    return ProductLotModel(
        productID: json['ProductID'],
        locationID: json['LocationID'],
        lotNumber: json['LotNumber'].toString(),
        reference: json['Reference'],
        reference2: json['Reference2'],
        itemType: json['ItemType'],
        sourceLotNumber: json['SourceLotNumber'].toString(),
        lotQty: json['LotQty'].toDouble(),
        cost: json['Cost'].toDouble(),
        consignNumber: json['Consign#'],
        availableQty: json['AvailableQty'].toDouble(),
        controller: TextEditingController(text: '0'));
  }

  Map<String, dynamic> toJson() => {
        "productID": productID,
        "locationID": locationID,
        "lotNumber": lotNumber,
        "reference": reference,
        "reference2": reference2,
        "itemType": itemType,
        "sourceLotNumber": sourceLotNumber,
        "lotQty": lotQty,
        "cost": cost,
        "consignNumber": consignNumber,
        "availableQty": availableQty,
      };

  Map<String, dynamic> toMap() {
    return {
      "productID": productID,
      "locationID": locationID,
      "lotNumber": lotNumber,
      "reference": reference,
      "reference2": reference2,
      "itemType": itemType,
      "sourceLotNumber": sourceLotNumber,
      "lotQty": lotQty,
      "cost": cost,
      "consignNumber": consignNumber,
      "availableQty": availableQty,
    };
  }

  factory ProductLotModel.fromMap(Map<String, dynamic> map) {
    return ProductLotModel(
      productID: map["ProductID"],
      locationID: map["LocationID"],
      lotNumber: map["LotNumber"].toString(),
      reference: map["Reference"],
      reference2: map["Reference2"],
      itemType: map["ItemType"],
      sourceLotNumber: map["SourceLotNumber"].toString(),
      lotQty: map["LotQty"],
      cost: map["Cost"],
      consignNumber: map["Consign"],
      availableQty: map["LotAvailable"] < 0 ? 0.0 : map["LotAvailable"],
      controller: TextEditingController(text: '0'),
    );
  }
}

class ProductLotListModel {
  final int? result;
  final List<ProductLotModel>? modelObject;

  ProductLotListModel({
    required this.result,
    required this.modelObject,
  });

  factory ProductLotListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<ProductLotModel> items =
        list.map((item) => ProductLotModel.fromJson(item)).toList();

    return ProductLotListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class ProductLotListLocalImportantNames {
  static const String tableName = 'ProductLot';
  static const String productID = "ProductID";
  static const String locationID = "LocationID";
  static const String lotNumber = "LotNumber";
  static const String reference = "Reference";
  static const String reference2 = "Reference2";
  static const String itemType = "ItemType";
  static const String sourceLotNumber = "SourceLotNumber";
  static const String lotQty = "LotQty";
  static const String cost = "Cost";
  static const String consignNumber = "Consign";
  static const String availableQty = "AvailableQty";
}
