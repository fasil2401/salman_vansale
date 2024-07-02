class UserByIDModel {
  final String? userID;
  final String? userName;
  final String? employeeID;
  final String? defaultSalesPersonID;
  final String? defaultInventoryLocationID;
  final String? defaultCompanyDivisionID;
  final String? defaultTransactionLocationID;
  final String? defaultTransactionRegisterID;
  final String? locationID;

  UserByIDModel({
    required this.userID,
    required this.userName,
    required this.employeeID,
    required this.defaultSalesPersonID,
    required this.defaultInventoryLocationID,
    required this.defaultCompanyDivisionID,
    required this.defaultTransactionLocationID,
    required this.defaultTransactionRegisterID,
    required this.locationID,
  });

  factory UserByIDModel.fromJson(Map<String, dynamic> json) {
    return UserByIDModel(
      userID: json['UserID'],
      userName: json['UserName'],
      employeeID: json['EmployeeID'],
      defaultSalesPersonID: json['DefaultSalesPersonID'],
      defaultInventoryLocationID: json['DefaultInventoryLocationID'],
      defaultCompanyDivisionID: json['DefaultCompanyDivisionID'],
      defaultTransactionLocationID: json['DefaultTransactionLocationID'],
      defaultTransactionRegisterID: json['DefaultTransactionRegisterID'],
      locationID: json['LocationID'],
    );
  }
}

class UserByIDListModel {
  final int? result;
  final List<UserByIDModel>? userList;

  UserByIDListModel({
    required this.result,
    required this.userList,
  });

  factory UserByIDListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['User'];
    List<UserByIDModel> users = list.map((item) => UserByIDModel.fromJson(item)).toList();

    return UserByIDListModel(
      result: json['result'],
      userList: users,
    );
  }
}

class UserByIDListLocalImportantNames {
  static const String tableName = 'User';
  static const String userID = 'UserID';
  static const String userName = 'UserName';
  static const String employeeID = 'EmployeeID';
  static const String defaultSalesPersonID = 'DefaultSalesPersonID';
  static const String defaultInventoryLocationID = 'DefaultInventoryLocationID';
  static const String defaultCompanyDivisionID = 'DefaultCompanyDivisionID';
  static const String defaultTransactionLocationID = 'DefaultTransactionLocationID';
  static const String defaultTransactionRegisterID = 'DefaultTransactionRegisterID';
  static const String locationID = 'LocationID';
}
