

import 'dart:convert';

UserRoute userRouteFromJson(String str) => UserRoute.fromJson(json.decode(str));

String userRouteToJson(UserRoute data) => json.encode(data.toJson());

class UserRoute {
    UserRoute({
       required this.res,
       required this.model,
    });

    int res;
    List<UserRouteModel> model;

    factory UserRoute.fromJson(Map<String, dynamic> json) => UserRoute(
        res: json["res"],
        model: List<UserRouteModel>.from(json["model"].map((x) => UserRouteModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
    };
}

class UserRouteModel {
    UserRouteModel({
        this.code,
        this.name,
        this.isConsignOutRoute,
        this.isConsignInRoute,
        this.isposRoute,
        this.isWarehouse,
    });

    String? code;
    String? name;
    dynamic isConsignOutRoute;
    dynamic isConsignInRoute;
    int? isposRoute;
    int? isWarehouse;

    factory UserRouteModel.fromJson(Map<String, dynamic> json) => UserRouteModel(
        code: json["Code"],
        name: json["Name"],
        isConsignOutRoute: json["IsConsignOutRoute"],
        isConsignInRoute: json["IsConsignInRoute"],
        isposRoute: json["ISPOSRoute"] == true ? 1 : 0,
        isWarehouse: json["IsWarehouse"] == true ? 1 : 0,
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "IsConsignOutRoute": isConsignOutRoute,
        "IsConsignInRoute": isConsignInRoute,
        "ISPOSRoute": isposRoute,
        "IsWarehouse": isWarehouse,
    };
}
