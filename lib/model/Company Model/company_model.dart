class CompanyListModel {
  final int? result;
  final List<CompanyModel>? modelObject;

  CompanyListModel({required this.result, required this.modelObject});

  factory CompanyListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<CompanyModel> items =
        list.map((i) => CompanyModel.fromJson(i)).toList();

    return CompanyListModel(result: json['result'], modelObject: items);
  }
}

class CompanyModel {
  final String? companyName;
  final String? notes;
  final String? baseCurrencyID;

  CompanyModel(
      { this.companyName,
       this.notes,
       this.baseCurrencyID});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyName: json['CompanyName'],
      notes: json['Notes'],
      baseCurrencyID: json['BaseCurrencyID']
    );
  }

  Map<String, dynamic> toJson() => {
        'CompanyName': companyName,
        'Notes': notes,
        'BaseCurrencyID': baseCurrencyID,
      };

  Map<String, dynamic> toMap() {
    return {
      'CompanyName': companyName,
      'Notes': notes,
      'BaseCurrencyID': baseCurrencyID,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      companyName: map['CompanyName'],
      notes: map['Notes'],
      baseCurrencyID: map['BaseCurrencyID'],
    );
  }
}

class CompanyListLocalImportantNames {
  static const String tableName = 'Company';
  static const String companyName = 'CompanyName';
  static const String notes = 'Notes';
  static const String baseCurrencyID = 'BaseCurrencyID';
}
