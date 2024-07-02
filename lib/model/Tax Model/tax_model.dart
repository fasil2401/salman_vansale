class TaxModel {
  final String? taxCode;
  final String? taxGroupID;
  final int? rowIndex;
  final String? taxItemName;
  final String? taxType;
  final int? calculationMethod;
  final dynamic taxRate;

  TaxModel({
    this.taxCode,
    this.taxGroupID,
    this.rowIndex,
    this.taxItemName,
    this.taxType,
    this.calculationMethod,
    this.taxRate,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      taxCode: json['TaxCode'],
      taxGroupID: json['TaxGroupID'],
      rowIndex: json['RowIndex'],
      taxItemName: json['TaxItemName'],
      taxType: json['TaxType'],
      calculationMethod: json['CalculationMethod'],
      taxRate: json['TaxRate'],
    );
  }

 Map<String, dynamic> toJson() => {
        'TaxCode': taxCode,
        'TaxGroupID': taxGroupID,
        'RowIndex': rowIndex,
        'TaxItemName': taxItemName,
        'TaxType': taxType,
        'CalculationMethod': calculationMethod,
        'TaxRate': taxRate,
      };

  Map<String, dynamic> toMap() {
    return {
      'TaxCode': taxCode,
      'TaxGroupID': taxGroupID,
      'RowIndex': rowIndex,
      'TaxItemName': taxItemName,
      'TaxType': taxType,
      'CalculationMethod': calculationMethod,
      'TaxRate': taxRate,
    };
  }

  factory TaxModel.fromMap(Map<String, dynamic> map) {
    return TaxModel(
      taxCode: map['TaxCode'],
      taxGroupID: map['TaxGroupID'],
      rowIndex: map['RowIndex'],
      taxItemName: map['TaxItemName'],
      taxType: map['TaxType'],
      calculationMethod: map['CalculationMethod'],
      taxRate: map['TaxRate'].toDouble(),
    );
  }

}

class TaxListModel {
  final int? result;
  final List<TaxModel>? modelObject;

  TaxListModel({
    required this.result,
    required this.modelObject,
  });

  factory TaxListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<TaxModel> items = list.map((item) => TaxModel.fromJson(item)).toList();

    return TaxListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class TaxListLocalImportantNames {
  static const String tableName = 'Tax';
  static const String taxCode = "TaxCode";
  static const String taxGroupID = "TaxGroupID";
  static const String rowIndex = "RowIndex";
  static const String taxItemName = "TaxItemName";
  static const String taxType = "TaxType";
  static const String calculationMethod = "CalculationMethod";
  static const String taxRate = "TaxRate";
}
