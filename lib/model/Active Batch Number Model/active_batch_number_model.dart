class AccountListModel {
  final int? result;
  final int? modelObject;

  AccountListModel({
    required this.result,
    required this.modelObject,
  });

  factory AccountListModel.fromJson(Map<String, dynamic> json) {

    return AccountListModel(
      result: json['result'],
      modelObject: json['Modelobject'],
    );
  }
}