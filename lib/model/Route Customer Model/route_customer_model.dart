class RouteCustomerModel {
  final String? routeCustomerID;
  final String? routeID;
  final String? customerID;
  final String? customerName;
  final String? shortName;
  final String? dateCreated;
  final String? dateUpdated;
  final String? latitude;
  final String? longitude;
  final String? address1;
  final String? status;
  int? inActive;
  int? creditLimitType;
  int? noCredit;
  double? creditAvailable;
  int? isHold;

  RouteCustomerModel({
    this.routeCustomerID,
    this.routeID,
    this.customerID,
    this.customerName,
    this.shortName,
    this.dateCreated,
    this.dateUpdated,
    this.latitude,
    this.longitude,
    this.address1,
    this.status,
    this.inActive,
    this.creditLimitType,
    this.noCredit,
    this.creditAvailable,
    this.isHold,
  });

  factory RouteCustomerModel.fromJson(Map<String, dynamic> json) {
    return RouteCustomerModel(
        routeCustomerID: json['RouteID'] + json['CustomerID'],
        routeID: json['RouteID'],
        customerID: json['CustomerID'],
        customerName: json['CustomerName'],
        shortName: json['ShortName'],
        dateCreated: json['DateCreated'],
        dateUpdated: json['DateUpdated'],
        latitude: json['Latitude'],
        longitude: json['Longitude'],
        address1: json['Address1'],
        status: "Pending",
        inActive: 0,
        creditLimitType: 0,
        noCredit: 0,
        creditAvailable: 0,
        isHold: 0);
  }

  Map<String, dynamic> toJson() => {
        'RouteCustomerID': routeCustomerID,
        'RouteID': routeID,
        'CustomerID': customerID,
        'CustomerName': customerName,
        'ShortName': shortName,
        'DateCreated': dateCreated,
        'DateUpdated': dateUpdated,
        'Latitude': latitude,
        'Longitude': longitude,
        'Address1': address1,
        'Status': status,
        'InActive': inActive,
        'CreditLimitType': creditLimitType,
        'NoCredit': noCredit,
        'CreditAvailable': creditAvailable,
        'IsHold': isHold
      };

  Map<String, dynamic> toMap() {
    return {
      'RouteCustomerID': routeCustomerID,
      'RouteID': routeID,
      'CustomerID': customerID,
      'CustomerName': customerName,
      'ShortName': shortName,
      'DateCreated': dateCreated,
      'DateUpdated': dateUpdated,
      'Latitude': latitude,
      'Longitude': longitude,
      'Address1': address1,
    };
  }

  factory RouteCustomerModel.fromMap(Map<String, dynamic> map) {
    return RouteCustomerModel(
      routeCustomerID: map['RouteCustomerID'],
      routeID: map['RouteID'],
      customerID: map['CustomerID'],
      customerName: map['CustomerName'],
      shortName: map['ShortName'],
      dateCreated: map['DateCreated'],
      dateUpdated: map['DateUpdated'],
      latitude: map['Latitude'],
      longitude: map['Longitude'],
      address1: map['Address1'],
      status: "Pending",
      inActive: map[RouteCustomerListLocalImportantNames.inActive],
      creditLimitType:
          map[RouteCustomerListLocalImportantNames.creditLimitType],
      noCredit: map[RouteCustomerListLocalImportantNames.noCredit],
      creditAvailable:
          map[RouteCustomerListLocalImportantNames.creditAvailable],
      isHold: map[RouteCustomerListLocalImportantNames.isHold],
    );
  }
}

class RouteCustomerListModel {
  final int? result;
  final List<RouteCustomerModel>? modelObject;

  RouteCustomerListModel({
    required this.result,
    required this.modelObject,
  });

  factory RouteCustomerListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<RouteCustomerModel> items =
        list.map((item) => RouteCustomerModel.fromJson(item)).toList();

    return RouteCustomerListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class RouteCustomerListLocalImportantNames {
  static const String tableName = 'RouteCustomer';
  static const String routeCustomerID = "RouteCustomerID";
  static const String routeID = "RouteID";
  static const String customerID = "CustomerID";
  static const String customerName = "CustomerName";
  static const String shortName = "ShortName";
  static const String dateCreated = "DateCreated";
  static const String dateUpdated = "DateUpdated";
  static const String latitude = "Latitude";
  static const String longitude = "Longitude";
  static const String address1 = "Address1";
  static const String status = "Status";
  static const String inActive = "InActive";
  static const String creditLimitType = "CreditLimitType";
  static const String noCredit = "NoCredit";
  static const String creditAvailable = "CreditAvailable";
  static const String isHold = "IsHold";
}
