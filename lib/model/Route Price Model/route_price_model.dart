class RoutePriceModel {
  final String? sysDocID;
  final String? voucherID;
  final String? productID;
  final String? customerProductID;
  final double? unitPrice;
  final String? description;
  final String? remarks;
  final String? unitID;
  final dynamic unitQuantity;
  final dynamic unitFactor;
  final dynamic factorType;
  final dynamic subunitPrice;
  final int? rowIndex;
  final String? routeID;
  final String? posRegisterID;

  RoutePriceModel({
    required this.sysDocID,
    required this.voucherID,
    required this.productID,
    required this.customerProductID,
    required this.unitPrice,
    required this.description,
    required this.remarks,
    required this.unitID,
    required this.unitQuantity,
    required this.unitFactor,
    required this.factorType,
    required this.subunitPrice,
    required this.rowIndex,
    required this.routeID,
    required this.posRegisterID,
  });

  factory RoutePriceModel.fromJson(Map<String, dynamic> json) {
    return RoutePriceModel(
      sysDocID: json['SysDocID'],
      voucherID: json['VoucherID'],
      productID: json['ProductID'],
      customerProductID: json['CustomerProductID'],
      unitPrice: json['UnitPrice'].toDouble(),
      description: json['Description'],
      remarks: json['Remarks'],
      unitID: json['UnitID'],
      unitQuantity: json['UnitQuantity'],
      unitFactor: json['UnitFactor'],
      factorType: json['FactorType'],
      subunitPrice: json['SubunitPrice'],
      rowIndex: json['RowIndex'],
      routeID: json['RouteID'],
      posRegisterID: json['POSRegisterID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'SysDocID': sysDocID,
        'VoucherID': voucherID,
        'ProductID': productID,
        'CustomerProductID': customerProductID,
        'UnitPrice': unitPrice,
        'Description': description,
        'Remarks': remarks,
        'UnitID': unitID,
        'UnitQuantity': unitQuantity,
        'UnitFactor': unitFactor,
        'FactorType': factorType,
        'SubunitPrice': subunitPrice,
        'RowIndex': rowIndex,
        'RouteID': routeID,
        'POSRegisterID': posRegisterID,
      };

  Map<String, dynamic> toMap() {
    return {
      'SysDocID': sysDocID,
      'VoucherID': voucherID,
      'ProductID': productID,
      'CustomerProductID': customerProductID,
      'UnitPrice': unitPrice,
      'Description': description,
      'Remarks': remarks,
      'UnitID': unitID,
      'UnitQuantity': unitQuantity,
      'UnitFactor': unitFactor,
      'FactorType': factorType,
      'SubunitPrice': subunitPrice,
      'RowIndex': rowIndex,
      'RouteID': routeID,
      'POSRegisterID': posRegisterID,
    };
  }

  factory RoutePriceModel.fromMap(Map<String, dynamic> map) {
    return RoutePriceModel(
      sysDocID: map['SysDocID'],
      voucherID: map['VoucherID'],
      productID: map['ProductID'],
      customerProductID: map['CustomerProductID'],
      unitPrice: map['UnitPrice'].toDouble(),
      description: map['Description'],
      remarks: map['Remarks'],
      unitID: map['UnitID'],
      unitQuantity: map['UnitQuantity'],
      unitFactor: map['UnitFactor'],
      factorType: map['FactorType'],
      subunitPrice: map['SubunitPrice'],
      rowIndex: map['RowIndex'],
      routeID: map['RouteID'],
      posRegisterID: map['POSRegisterID'],
    );
  }
}

class VanPriceModel {
  final String? sysDocID;
  final String? voucherID;
  final String? productID;
  final String? customerProductID;
  final double? unitPrice;
  final String? description;
  final String? remarks;
  final String? unitID;
  final dynamic unitQuantity;
  final dynamic unitFactor;
  final dynamic factorType;
  final dynamic subunitPrice;
  final int? rowIndex;
  final String? routeID;
  final String? vanID;

  VanPriceModel({
    required this.sysDocID,
    required this.voucherID,
    required this.productID,
    required this.customerProductID,
    required this.unitPrice,
    required this.description,
    required this.remarks,
    required this.unitID,
    required this.unitQuantity,
    required this.unitFactor,
    required this.factorType,
    required this.subunitPrice,
    required this.rowIndex,
    required this.routeID,
    required this.vanID,
  });

  factory VanPriceModel.fromJson(Map<String, dynamic> json) {
    return VanPriceModel(
      sysDocID: json['SysDocID'],
      voucherID: json['VoucherID'],
      productID: json['ProductID'],
      customerProductID: json['CustomerProductID'],
      unitPrice: json['UnitPrice'].toDouble(),
      description: json['Description'],
      remarks: json['Remarks'],
      unitID: json['UnitID'],
      unitQuantity: json['UnitQuantity'],
      unitFactor: json['UnitFactor'],
      factorType: json['FactorType'],
      subunitPrice: json['SubunitPrice'],
      rowIndex: json['RowIndex'],
      routeID: json['RouteID'],
      vanID: json['VanID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'SysDocID': sysDocID,
        'VoucherID': voucherID,
        'ProductID': productID,
        'CustomerProductID': customerProductID,
        'UnitPrice': unitPrice,
        'Description': description,
        'Remarks': remarks,
        'UnitID': unitID,
        'UnitQuantity': unitQuantity,
        'UnitFactor': unitFactor,
        'FactorType': factorType,
        'SubunitPrice': subunitPrice,
        'RowIndex': rowIndex,
        'RouteID': routeID,
        'VanID': vanID,
      };

  Map<String, dynamic> toMap() {
    return {
      'SysDocID': sysDocID,
      'VoucherID': voucherID,
      'ProductID': productID,
      'CustomerProductID': customerProductID,
      'UnitPrice': unitPrice,
      'Description': description,
      'Remarks': remarks,
      'UnitID': unitID,
      'UnitQuantity': unitQuantity,
      'UnitFactor': unitFactor,
      'FactorType': factorType,
      'SubunitPrice': subunitPrice,
      'RowIndex': rowIndex,
      'RouteID': routeID,
      'VanID': vanID,
    };
  }

  factory VanPriceModel.fromMap(Map<String, dynamic> map) {
    return VanPriceModel(
      sysDocID: map['SysDocID'],
      voucherID: map['VoucherID'],
      productID: map['ProductID'],
      customerProductID: map['CustomerProductID'],
      unitPrice: map['UnitPrice'].toDouble(),
      description: map['Description'],
      remarks: map['Remarks'],
      unitID: map['UnitID'],
      unitQuantity: map['UnitQuantity'],
      unitFactor: map['UnitFactor'],
      factorType: map['FactorType'],
      subunitPrice: map['SubunitPrice'],
      rowIndex: map['RowIndex'],
      routeID: map['RouteID'],
      vanID: map['VanID'],
    );
  }
}

class CustomerPriceModel {
  final String? sysDocID;
  final String? voucherID;
  final String? productID;
  final String? customerProductID;
  final double? unitPrice;
  final String? description;
  final String? remarks;
  final String? unitID;
  final dynamic unitQuantity;
  final dynamic unitFactor;
  final dynamic factorType;
  final dynamic subunitPrice;
  final int? rowIndex;
  final String? customerID;
  final String? routeID;
  final String? vanID;
  final bool? applicableToChild;

  CustomerPriceModel({
    this.sysDocID,
    this.voucherID,
    this.productID,
    this.customerProductID,
    this.unitPrice,
    this.description,
    this.remarks,
    this.unitID,
    this.unitQuantity,
    this.unitFactor,
    this.factorType,
    this.subunitPrice,
    this.rowIndex,
    this.customerID,
    this.routeID,
    this.vanID,
    this.applicableToChild,
  });

  factory CustomerPriceModel.fromJson(Map<String, dynamic> json) {
    return CustomerPriceModel(
      sysDocID: json['SysDocID'],
      voucherID: json['VoucherID'],
      productID: json['ProductID'],
      customerProductID: json['CustomerProductID'],
      unitPrice: json['UnitPrice'].toDouble(),
      description: json['Description'],
      remarks: json['Remarks'],
      unitID: json['UnitID'],
      unitQuantity: json['UnitQuantity'],
      unitFactor: json['UnitFactor'],
      factorType: json['FactorType'],
      subunitPrice: json['SubunitPrice'],
      rowIndex: json['RowIndex'],
      customerID: json['CustomerID'],
      routeID: json['RouteID'],
      vanID: json['VanID'],
      applicableToChild: json['ApplicableToChild'],
    );
  }

  Map<String, dynamic> toJson() => {
        'SysDocID': sysDocID,
        'VoucherID': voucherID,
        'ProductID': productID,
        'CustomerProductID': customerProductID,
        'UnitPrice': unitPrice,
        'Description': description,
        'Remarks': remarks,
        'UnitID': unitID,
        'UnitQuantity': unitQuantity,
        'UnitFactor': unitFactor,
        'FactorType': factorType,
        'SubunitPrice': subunitPrice,
        'RowIndex': rowIndex,
        'CustomerID': customerID,
        'RouteID': routeID,
        'VanID': vanID,
        'ApplicableToChild': applicableToChild,
      };

  Map<String, dynamic> toMap() {
    return {
      'SysDocID': sysDocID,
      'VoucherID': voucherID,
      'ProductID': productID,
      'CustomerProductID': customerProductID,
      'UnitPrice': unitPrice,
      'Description': description,
      'Remarks': remarks,
      'UnitID': unitID,
      'UnitQuantity': unitQuantity,
      'UnitFactor': unitFactor,
      'FactorType': factorType,
      'SubunitPrice': subunitPrice,
      'RowIndex': rowIndex,
      'CustomerID': customerID,
      'RouteID': routeID,
      'VanID': vanID,
      'ApplicableToChild': applicableToChild,
    };
  }

  factory CustomerPriceModel.fromMap(Map<String, dynamic> map) {
    return CustomerPriceModel(
      sysDocID: map['SysDocID'],
      voucherID: map['VoucherID'],
      productID: map['ProductID'],
      customerProductID: map['CustomerProductID'],
      unitPrice: map['UnitPrice'].toDouble(),
      description: map['Description'],
      remarks: map['Remarks'],
      unitID: map['UnitID'],
      unitQuantity: map['UnitQuantity'],
      unitFactor: map['UnitFactor'],
      factorType: map['FactorType'],
      subunitPrice: map['SubunitPrice'],
      rowIndex: map['RowIndex'],
      customerID: map['CustomerID'],
      routeID: map['RouteID'],
      vanID: map['VanID'],
      applicableToChild: map['ApplicableToChild'] == 1 ? true : false,
    );
  }
}

class CustomerClassPriceModel {
  final String? sysDocID;
  final String? voucherID;
  final String? productID;
  final String? customerProductID;
  final double? unitPrice;
  final String? description;
  final String? remarks;
  final String? unitID;
  final dynamic unitQuantity;
  final dynamic unitFactor;
  final dynamic factorType;
  final dynamic subunitPrice;
  final int? rowIndex;
  final String? customerClassID;

  CustomerClassPriceModel({
    required this.sysDocID,
    required this.voucherID,
    required this.productID,
    required this.customerProductID,
    required this.unitPrice,
    required this.description,
    required this.remarks,
    required this.unitID,
    required this.unitQuantity,
    required this.unitFactor,
    required this.factorType,
    required this.subunitPrice,
    required this.rowIndex,
    required this.customerClassID,
  });

  factory CustomerClassPriceModel.fromJson(Map<String, dynamic> json) {
    return CustomerClassPriceModel(
      sysDocID: json['SysDocID'],
      voucherID: json['VoucherID'],
      productID: json['ProductID'],
      customerProductID: json['CustomerProductID'],
      unitPrice: json['UnitPrice'].toDouble(),
      description: json['Description'],
      remarks: json['Remarks'],
      unitID: json['UnitID'],
      unitQuantity: json['UnitQuantity'],
      unitFactor: json['UnitFactor'],
      factorType: json['FactorType'],
      subunitPrice: json['SubunitPrice'],
      rowIndex: json['RowIndex'],
      customerClassID: json['CustomerClassID'],
    );
  }
  Map<String, dynamic> toJson() => {
        'SysDocID': sysDocID,
        'VoucherID': voucherID,
        'ProductID': productID,
        'CustomerProductID': customerProductID,
        'UnitPrice': unitPrice,
        'Description': description,
        'Remarks': remarks,
        'UnitID': unitID,
        'UnitQuantity': unitQuantity,
        'UnitFactor': unitFactor,
        'FactorType': factorType,
        'SubunitPrice': subunitPrice,
        'RowIndex': rowIndex,
        'CustomerClassID': customerClassID,
      };

  Map<String, dynamic> toMap() {
    return {
      'SysDocID': sysDocID,
      'VoucherID': voucherID,
      'ProductID': productID,
      'CustomerProductID': customerProductID,
      'UnitPrice': unitPrice,
      'Description': description,
      'Remarks': remarks,
      'UnitID': unitID,
      'UnitQuantity': unitQuantity,
      'UnitFactor': unitFactor,
      'FactorType': factorType,
      'SubunitPrice': subunitPrice,
      'RowIndex': rowIndex,
      'CustomerClassID': customerClassID,
    };
  }

  factory CustomerClassPriceModel.fromMap(Map<String, dynamic> map) {
    return CustomerClassPriceModel(
      sysDocID: map['SysDocID'],
      voucherID: map['VoucherID'],
      productID: map['ProductID'],
      customerProductID: map['CustomerProductID'],
      unitPrice: map['UnitPrice'].toDouble(),
      description: map['Description'],
      remarks: map['Remarks'],
      unitID: map['UnitID'],
      unitQuantity: map['UnitQuantity'],
      unitFactor: map['UnitFactor'],
      factorType: map['FactorType'],
      subunitPrice: map['SubunitPrice'],
      rowIndex: map['RowIndex'],
      customerClassID: map['CustomerClassID'],
    );
  }
}

class LocationPriceModel {
  final String? sysDocID;
  final String? voucherID;
  final String? productID;
  final String? customerProductID;
  final double? unitPrice;
  final String? description;
  final String? remarks;
  final String? unitID;
  final dynamic unitQuantity;
  final dynamic unitFactor;
  final dynamic factorType;
  final dynamic subunitPrice;
  final int? rowIndex;
  final String? locationID;

  LocationPriceModel({
    required this.sysDocID,
    required this.voucherID,
    required this.productID,
    required this.customerProductID,
    required this.unitPrice,
    required this.description,
    required this.remarks,
    required this.unitID,
    required this.unitQuantity,
    required this.unitFactor,
    required this.factorType,
    required this.subunitPrice,
    required this.rowIndex,
    required this.locationID,
  });

  factory LocationPriceModel.fromJson(Map<String, dynamic> json) {
    return LocationPriceModel(
      sysDocID: json['SysDocID'],
      voucherID: json['VoucherID'],
      productID: json['ProductID'],
      customerProductID: json['CustomerProductID'],
      unitPrice: json['UnitPrice'].toDouble(),
      description: json['Description'],
      remarks: json['Remarks'],
      unitID: json['UnitID'],
      unitQuantity: json['UnitQuantity'],
      unitFactor: json['UnitFactor'],
      factorType: json['FactorType'],
      subunitPrice: json['SubunitPrice'],
      rowIndex: json['RowIndex'],
      locationID: json['LocationID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'SysDocID': sysDocID,
        'VoucherID': voucherID,
        'ProductID': productID,
        'CustomerProductID': customerProductID,
        'UnitPrice': unitPrice,
        'Description': description,
        'Remarks': remarks,
        'UnitID': unitID,
        'UnitQuantity': unitQuantity,
        'UnitFactor': unitFactor,
        'FactorType': factorType,
        'SubunitPrice': subunitPrice,
        'RowIndex': rowIndex,
        'LocationID': locationID,
      };

  Map<String, dynamic> toMap() {
    return {
      'SysDocID': sysDocID,
      'VoucherID': voucherID,
      'ProductID': productID,
      'CustomerProductID': customerProductID,
      'UnitPrice': unitPrice,
      'Description': description,
      'Remarks': remarks,
      'UnitID': unitID,
      'UnitQuantity': unitQuantity,
      'UnitFactor': unitFactor,
      'FactorType': factorType,
      'SubunitPrice': subunitPrice,
      'RowIndex': rowIndex,
      'LocationID': locationID,
    };
  }

  factory LocationPriceModel.fromMap(Map<String, dynamic> map) {
    return LocationPriceModel(
      sysDocID: map['SysDocID'],
      voucherID: map['VoucherID'],
      productID: map['ProductID'],
      customerProductID: map['CustomerProductID'],
      unitPrice: map['UnitPrice'].toDouble(),
      description: map['Description'],
      remarks: map['Remarks'],
      unitID: map['UnitID'],
      unitQuantity: map['UnitQuantity'],
      unitFactor: map['UnitFactor'],
      factorType: map['FactorType'],
      subunitPrice: map['SubunitPrice'],
      rowIndex: map['RowIndex'],
      locationID: map['LocationID'],
    );
  }
}

class PriceListModel {
  final int? result;
  final List<RoutePriceModel>? routePriceList;
  final List<VanPriceModel>? vanPriceList;
  final List<CustomerPriceModel>? customerPriceList;
  final List<CustomerClassPriceModel>? customerClassPriceList;
  final List<LocationPriceModel>? locationPriceList;

  PriceListModel({
    required this.result,
    required this.routePriceList,
    required this.vanPriceList,
    required this.customerPriceList,
    required this.customerClassPriceList,
    required this.locationPriceList,
  });

  factory PriceListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> routeList = json['RoutePriceList'];
    List<dynamic> vanList = json['VanPriceList'];
    List<dynamic> customerList = json['CustomerPriceList'];
    List<dynamic> customerClassList = json['CustomerClassPriceList'];
    List<dynamic> locationList = json['LocationPriceList'];

    List<RoutePriceModel> routePriceList =
        routeList.map((item) => RoutePriceModel.fromJson(item)).toList();
    List<VanPriceModel> vanPriceList =
        vanList.map((item) => VanPriceModel.fromJson(item)).toList();
    List<CustomerPriceModel> customerPriceList =
        customerList.map((item) => CustomerPriceModel.fromJson(item)).toList();
    List<CustomerClassPriceModel> customerClassPriceList = customerClassList
        .map((item) => CustomerClassPriceModel.fromJson(item))
        .toList();
    List<LocationPriceModel> locationPriceList =
        locationList.map((item) => LocationPriceModel.fromJson(item)).toList();

    return PriceListModel(
      result: json['result'],
      routePriceList: routePriceList,
      vanPriceList: vanPriceList,
      customerPriceList: customerPriceList,
      customerClassPriceList: customerClassPriceList,
      locationPriceList: locationPriceList,
    );
  }
}

class RoutePriceListLocalImportantNames {
  static const String tableName = 'RoutePrice';
  static const String sysDocID = 'SysDocID';
  static const String voucherID = 'VoucherID';
  static const String productID = 'ProductID';
  static const String customerProductID = 'CustomerProductID';
  static const String unitPrice = 'UnitPrice';
  static const String description = 'Description';
  static const String remarks = 'Remarks';
  static const String unitID = 'UnitID';
  static const String unitQuantity = 'UnitQuantity';
  static const String unitFactor = 'UnitFactor';
  static const String factorType = 'FactorType';
  static const String subunitPrice = 'SubunitPrice';
  static const String rowIndex = 'RowIndex';
  static const String routeID = 'RouteID';
  static const String posRegisterID = 'POSRegisterID';
}

class VanPriceListLocalImportantNames {
  static const String tableName = 'VanPrice';
  static const String sysDocID = 'SysDocID';
  static const String voucherID = 'VoucherID';
  static const String productID = 'ProductID';
  static const String customerProductID = 'CustomerProductID';
  static const String unitPrice = 'UnitPrice';
  static const String description = 'Description';
  static const String remarks = 'Remarks';
  static const String unitID = 'UnitID';
  static const String unitQuantity = 'UnitQuantity';
  static const String unitFactor = 'UnitFactor';
  static const String factorType = 'FactorType';
  static const String subunitPrice = 'SubunitPrice';
  static const String rowIndex = 'RowIndex';
  static const String routeID = 'RouteID';
  static const String vanID = 'VanID';
}

class CustomerPriceListLocalImportantNames {
  static const String tableName = 'CustomerPrice';
  static const String sysDocID = 'SysDocID';
  static const String voucherID = 'VoucherID';
  static const String productID = 'ProductID';
  static const String customerProductID = 'CustomerProductID';
  static const String unitPrice = 'UnitPrice';
  static const String description = 'Description';
  static const String remarks = 'Remarks';
  static const String unitID = 'UnitID';
  static const String unitQuantity = 'UnitQuantity';
  static const String unitFactor = 'UnitFactor';
  static const String factorType = 'FactorType';
  static const String subunitPrice = 'SubunitPrice';
  static const String rowIndex = 'RowIndex';
  static const String customerID = 'CustomerID';
  static const String routeID = 'RouteID';
  static const String vanID = 'VanID';
  static const String applicableToChild = 'ApplicableToChild';
}

class CustomerClassPriceListLocalImportantNames {
  static const String tableName = 'CustomerClassPrice';
  static const String sysDocID = 'SysDocID';
  static const String voucherID = 'VoucherID';
  static const String productID = 'ProductID';
  static const String customerProductID = 'CustomerProductID';
  static const String unitPrice = 'UnitPrice';
  static const String description = 'Description';
  static const String remarks = 'Remarks';
  static const String unitID = 'UnitID';
  static const String unitQuantity = 'UnitQuantity';
  static const String unitFactor = 'UnitFactor';
  static const String factorType = 'FactorType';
  static const String subunitPrice = 'SubunitPrice';
  static const String rowIndex = 'RowIndex';
  static const String customerClassID = 'CustomerClassID';
}

class LocationPriceListLocalImportantNames {
  static const String tableName = 'LocationPrice';
  static const String sysDocID = 'SysDocID';
  static const String voucherID = 'VoucherID';
  static const String productID = 'ProductID';
  static const String customerProductID = 'CustomerProductID';
  static const String unitPrice = 'UnitPrice';
  static const String description = 'Description';
  static const String remarks = 'Remarks';
  static const String unitID = 'UnitID';
  static const String unitQuantity = 'UnitQuantity';
  static const String unitFactor = 'UnitFactor';
  static const String factorType = 'FactorType';
  static const String subunitPrice = 'SubunitPrice';
  static const String rowIndex = 'RowIndex';
  static const String locationID = 'LocationID';
}
