class ProductModel {
  String? productID;
  String? description;
  int? isTrackLot;
  String? upc;
  double? quantity;
  double? openingStock;
  double? saleQuantity;
  double? returnQuantity;
  double? damageQuantity;
  String? unitID;
  String? taxGroupID;
  int? taxOption;
  double? price;
  double? standardPrice;
  double? wholeSalePrice;
  double? specialPrice;
  double? minPrice;
  String? description2;
  int? itemType;

  ProductModel({
    this.productID,
    this.description,
    this.isTrackLot,
    this.upc,
    this.quantity,
    this.unitID,
    this.taxGroupID,
    this.taxOption,
    this.price,
    this.standardPrice,
    this.wholeSalePrice,
    this.specialPrice,
    this.minPrice,
    this.description2,
    this.itemType,
    this.openingStock,
    this.returnQuantity,
    this.saleQuantity,
    this.damageQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productID: json['ProductID'],
      description: json['Description'],
      isTrackLot: json['IsTrackLot'] == null
          ? null
          : json["IsTrackLot"]
              ? 1
              : 0,
      upc: json['UPC'],
      quantity: json['Quantity'].toDouble(),
      unitID: json['UnitID'],
      taxGroupID: json['TaxGroupID'],
      taxOption: json['TaxOption'],
      price: json['Price'].toDouble(),
      standardPrice: json['StandardPrice'].toDouble(),
      wholeSalePrice: json['WholeSalePrice'].toDouble(),
      specialPrice: json['SpecialPrice'].toDouble(),
      minPrice: json['MinPrice'].toDouble(),
      description2: json['Description2'],
      itemType: json['ItemType'],
      openingStock: json[ProductListLocalImportantNames.openingStock],
      saleQuantity: json[ProductListLocalImportantNames.saleQuantity],
      returnQuantity: json[ProductListLocalImportantNames.returnQuantity],
    );
  }

  Map<String, dynamic> toJson() => {
        "ProductID": productID,
        "Description": description,
        "IsTrackLot": isTrackLot,
        "UPC": upc,
        "Quantity": quantity,
        "UnitID": unitID,
        "TaxGroupID": taxGroupID,
        "TaxOption": taxOption,
        "Price": price,
        "StandardPrice": standardPrice,
        "WholeSalePrice": wholeSalePrice,
        "SpecialPrice": specialPrice,
        "MinPrice": minPrice,
        "Description2": description2,
        "ItemType": itemType,
        ProductListLocalImportantNames.openingStock: openingStock,
        ProductListLocalImportantNames.saleQuantity: saleQuantity,
        ProductListLocalImportantNames.returnQuantity: returnQuantity,
      };

  Map<String, dynamic> toMap() {
    return {
      "ProductID": productID,
      "Description": description,
      "IsTrackLot": isTrackLot,
      "UPC": upc,
      "Quantity": quantity,
      "UnitID": unitID,
      "TaxGroupID": taxGroupID,
      "TaxOption": taxOption,
      "Price": price,
      "StandardPrice": standardPrice,
      "WholeSalePrice": wholeSalePrice,
      "SpecialPrice": specialPrice,
      "MinPrice": minPrice,
      "Description2": description2,
      "ItemType": itemType,
      ProductListLocalImportantNames.openingStock: openingStock,
      ProductListLocalImportantNames.saleQuantity: saleQuantity,
      ProductListLocalImportantNames.returnQuantity: returnQuantity,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productID: map["ProductID"],
      description: map["Description"],
      isTrackLot: map["IsTrackLot"],
      upc: map["UPC"],
      quantity: map["Stock"],
      unitID: map["UnitID"],
      taxGroupID: map["TaxGroupID"],
      taxOption: map["TaxOption"],
      price: map["Price"],
      standardPrice: map["StandardPrice"],
      wholeSalePrice: map["WholeSalePrice"],
      specialPrice: map["SpecialPrice"],
      minPrice: map["MinPrice"],
      description2: map["Description2"],
      itemType: map["ItemType"],
      openingStock:
          map[ProductListLocalImportantNames.openingStock]?.toDouble() ?? 0.0,
      saleQuantity:
          map[ProductListLocalImportantNames.saleQuantity]?.toDouble() ?? 0.0,
      returnQuantity:
          map[ProductListLocalImportantNames.returnQuantity]?.toDouble() ?? 0.0,
      damageQuantity: map['DamageQuantity']?.toDouble() ?? 0.0,
    );
  }
}

class UnitModel {
  final String? code;
  final String? name;
  final String? productID;
  final String? factorType;
  final dynamic factor;
  final int? isMainUnit;

  UnitModel({
    this.code,
    this.name,
    this.productID,
    this.factorType,
    this.factor,
    this.isMainUnit,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      code: json['Code'],
      name: json['Name'],
      productID: json['ProductID'],
      factorType: json['FactorType'],
      factor: json['Factor'],
      isMainUnit: json['IsMainUnit'] == null
          ? null
          : json["IsMainUnit"]
              ? 1
              : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Name': name,
        'ProductID': productID,
        'FactorType': factorType,
        'Factor': factor,
        'IsMainUnit': isMainUnit,
      };

  Map<String, dynamic> toMap() {
    return {
      'Code': code,
      'Name': name,
      'ProductID': productID,
      'FactorType': factorType,
      'Factor': factor,
      'IsMainUnit': isMainUnit,
    };
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      code: map['Code'],
      name: map['Name'],
      productID: map['ProductID'],
      factorType: map['FactorType'],
      factor: map['Factor'],
      isMainUnit: map['IsMainUnit'],
    );
  }
}

class ProductListModel {
  final int? result;
  final List<ProductModel>? products;
  final List<UnitModel>? units;

  ProductListModel(
      {required this.result, required this.products, required this.units});

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Products'];
    List<ProductModel> items =
        list.map((item) => ProductModel.fromJson(item)).toList();

    List<dynamic> listUnits = json['Units'];
    List<UnitModel> units =
        listUnits.map((item) => UnitModel.fromJson(item)).toList();

    return ProductListModel(
        result: json['result'], products: items, units: units);
  }
}

class ProductListLocalImportantNames {
  static const String tableName = 'Product';
  static const String productID = "ProductID";
  static const String description = "Description";
  static const String isTrackLot = "IsTrackLot";
  static const String upc = "UPC";
  static const String quantity = "Quantity";
  static const String unitID = "UnitID";
  static const String taxGroupID = "TaxGroupID";
  static const String taxOption = "TaxOption";
  static const String price = "Price";
  static const String standardPrice = "StandardPrice";
  static const String wholeSalePrice = "WholeSalePrice";
  static const String specialPrice = "SpecialPrice";
  static const String minPrice = "MinPrice";
  static const String description2 = "Description2";
  static const String itemType = "ItemType";
  static const String openingStock = "OpeningStock";
  static const String saleQuantity = "SaleQuantity";
  static const String returnQuantity = "ReturnQuantity";
}

class UnitListLocalImportantNames {
  static const String tableName = 'Units';
  static const String code = 'Code';
  static const String name = 'Name';
  static const String productID = 'ProductID';
  static const String factorType = 'FactorType';
  static const String factor = 'Factor';
  static const String isMainUnit = 'IsMainUnit';
}
