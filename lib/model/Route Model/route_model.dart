class RouteModel {
  String? routeID;
  String? routeName;
  String? locationID;
  int? isEnableAllocation;
  String? damageLocationID;

  RouteModel({
    this.routeID,
    this.routeName,
    this.locationID,
    this.isEnableAllocation,
    this.damageLocationID,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      routeID: json['RouteID'],
      routeName: json['RouteName'],
      locationID: json['LocationID'],
      isEnableAllocation: json["IsEnableAllocation"] == null
          ? null
          : json["IsEnableAllocation"]
              ? 1
              : 0,
      damageLocationID: json['DamageLocationID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'RouteID': routeID,
        'RouteName': routeName,
        'LocationID': locationID,
        'IsEnableAllocation': isEnableAllocation,
        'DamageLocationID': damageLocationID
      };

  Map<String, dynamic> toMap() {
    return {
      'RouteID': routeID,
      'RouteName': routeName,
      'LocationID': locationID,
      'IsEnableAllocation': isEnableAllocation,
      'DamageLocationID': damageLocationID,
    };
  }

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      routeID: map['RouteID'],
      routeName: map['RouteName'],
      locationID: map['LocationID'],
      isEnableAllocation: map['IsEnableAllocation'],
      damageLocationID: map['DamageLocationID'],
    );
  }
}

class RouteListModel {
  final int? result;
  final List<RouteModel>? modelObject;

  RouteListModel({
    required this.result,
    required this.modelObject,
  });

  factory RouteListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<RouteModel> items =
        list.map((item) => RouteModel.fromJson(item)).toList();

    return RouteListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class RouteListLocalImportantNames {
  static const String tableName = 'Route';
  static const String routeID = "RouteID";
  static const String routeName = "RouteName";
  static const String locationID = "LocationID";
  static const String isEnableAllocation = "IsEnableAllocation";
  static const String damageLocationID = 'DamageLocationID';
}
