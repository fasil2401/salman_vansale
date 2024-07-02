class SecurityModel {
  final int? securityRoleID;
  final String? securityRoleName;
  final bool? isAllowed;
  final String? userID;
  final String? groupID;
  final int? intValue;

  SecurityModel({
    required this.securityRoleID,
    required this.securityRoleName,
    required this.isAllowed,
    required this.userID,
    required this.groupID,
    required this.intValue,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    return SecurityModel(
      securityRoleID: json['SecurityRoleID'],
      securityRoleName: json['SecurityRoleName'],
      isAllowed: json['IsAllowed'],
      userID: json['UserID'],
      groupID: json['GroupID'],
      intValue: json['intval'],
    );
  }

Map<String, dynamic> toJson() => {
  'SecurityRoleID': securityRoleID,
  'SecurityRoleName': securityRoleName,
  'IsAllowed': isAllowed,
  'UserID': userID,
  'GroupID': groupID,
  'intval': intValue,
};

Map<String, dynamic> toMap() {
  return {
    'SecurityRoleID': securityRoleID,
    'SecurityRoleName': securityRoleName,
    'IsAllowed': isAllowed,
    'UserID': userID,
    'GroupID': groupID,
    'intval': intValue,
  };
}

factory SecurityModel.fromMap(Map<String, dynamic> map) {
  return SecurityModel(
    securityRoleID: map['SecurityRoleID'],
    securityRoleName: map['SecurityRoleName'],
    isAllowed: map['IsAllowed'],
    userID: map['UserID'],
    groupID: map['GroupID'],
    intValue: map['intval'],
  );
}

}

class SecurityListModel {
  final int? result;
  final List<SecurityModel>? modelObject;

  SecurityListModel({
    required this.result,
    required this.modelObject,
  });

  factory SecurityListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<SecurityModel> items = list.map((item) => SecurityModel.fromJson(item)).toList();

    return SecurityListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class SecurityListLocalImportantNames {
  static const String tableName = 'Security';
  static const String securityRoleID = "SecurityRoleID";
  static const String securityRoleName = "SecurityRoleName";
  static const String isAllowed = "IsAllowed";
  static const String userID = "UserID";
  static const String groupID = "GroupID";
  static const String intValue = "intval";
}
