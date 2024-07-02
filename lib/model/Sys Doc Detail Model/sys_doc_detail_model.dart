class SysDocDetail {
  String? sysDocID;
  String? numberPrefix;
  int? nextNumber;
  String? lastNumber;
  String? headerImage;
  String? footerImage;
  String? inventoryTransferLocationID;
  String? defaultCustomerID;
  int? priceIncludeTax;

  SysDocDetail({
     this.sysDocID,
     this.numberPrefix,
     this.nextNumber,
     this.lastNumber,
     this.headerImage,
     this.footerImage,
     this.inventoryTransferLocationID,
     this.defaultCustomerID,
     this.priceIncludeTax,
  });

  factory SysDocDetail.fromJson(Map<String, dynamic> json) {
    return SysDocDetail(
      sysDocID: json['SysDocID'],
      numberPrefix: json['NumberPrefix'],
      nextNumber: json['NextNumber'],
      lastNumber: json['LastNumber'],
      headerImage: json['headerimage'],
      footerImage: json['FooterImage'],
      inventoryTransferLocationID: json['InventoryTransferLocationID'],
      defaultCustomerID: json['DefaultCustomerID'],
      priceIncludeTax: json["PriceIncludeTax"] == null
          ? null
          : json["PriceIncludeTax"]
              ? 1
              : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'SysDocID': sysDocID,
        'NumberPrefix': numberPrefix,
        'NextNumber': nextNumber,
        'LastNumber': lastNumber,
        'headerimage': headerImage,
        'FooterImage': footerImage,
        'InventoryTransferLocationID': inventoryTransferLocationID,
        'DefaultCustomerID': defaultCustomerID,
        'PriceIncludeTax': priceIncludeTax,
      };

  Map<String, dynamic> toMap() {
    return {
      'SysDocID': sysDocID,
      'NumberPrefix': numberPrefix,
      'NextNumber': nextNumber,
      'LastNumber': lastNumber,
      'headerimage': headerImage,
      'FooterImage': footerImage,
      'InventoryTransferLocationID': inventoryTransferLocationID,
      'DefaultCustomerID': defaultCustomerID,
      'PriceIncludeTax': priceIncludeTax,
    };
  }

  SysDocDetail.fromMap(Map<String, dynamic> map) {
    //  return SysDocDetail(
    sysDocID = map['SysDocID'];
    numberPrefix = map['NumberPrefix'];
    nextNumber = map['NextNumber'];
    lastNumber = map['LastNumber'];
    headerImage = map['headerimage'];
    footerImage = map['FooterImage'];
    inventoryTransferLocationID = map['InventoryTransferLocationID'];
    defaultCustomerID = map['DefaultCustomerID'];
    priceIncludeTax = map['PriceIncludeTax'];
    // );
  }
}

class SysDocDetailListModel {
  int? result;
  List<SysDocDetail>? modelObject;

  SysDocDetailListModel({
    required this.result,
    required this.modelObject,
  });

  factory SysDocDetailListModel.fromJson(Map<String, dynamic> json) {
    return SysDocDetailListModel(
      result: json['result'],
      modelObject: List<SysDocDetail>.from(
        json['Modelobject'].map((x) => SysDocDetail.fromJson(x)),
      ),
    );
  }
}

class SysDocDetailListLocalImportantNames {
  static const String tableName = 'SysDocDetail';
  static const String sysDocID = 'SysDocID';
  static const String numberPrefix = 'NumberPrefix';
  static const String nextNumber = 'NextNumber';
  static const String lastNumber = 'LastNumber';
  static const String headerImage = 'headerimage';
  static const String footerImage = 'FooterImage';
  static const String inventoryTransferLocationID =
      'InventoryTransferLocationID';
  static const String defaultCustomerID = 'DefaultCustomerID';
  static const String priceIncludeTax = 'PriceIncludeTax';
}
