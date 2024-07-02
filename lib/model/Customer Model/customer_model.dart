class CustomerModel {
  String? routeID;
  int? rowIndex;
  String? customerID;
  String? customerName;
  String? shortName;
  String? companyName;
  String? addressPrintFormat;
  String? city;
  String? contactName;
  String? phone1;
  String? email;
  String? phone2;
  String? address1;
  String? address2;
  String? address3;
  String? taxGroupID;
  int? taxOption;
  String? dateCreated;
  String? taxIDNumber;
  String? latitude;
  String? longitude;
  String? customerClassID;
  String? parentCustomerID;

  CustomerModel({
    this.routeID,
    this.rowIndex,
    this.customerID,
    this.customerName,
    this.shortName,
    this.companyName,
    this.addressPrintFormat,
    this.city,
    this.contactName,
    this.phone1,
    this.email,
    this.phone2,
    this.address1,
    this.address2,
    this.address3,
    this.taxGroupID,
    this.taxOption,
    this.dateCreated,
    this.taxIDNumber,
    this.latitude,
    this.longitude,
    this.customerClassID,
    this.parentCustomerID,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      routeID: json['RouteID'],
      rowIndex: json['RowIndex'],
      customerID: json['CustomerID'],
      customerName: json['CustomerName'],
      shortName: json['ShortName'],
      companyName: json['Companyname'],
      addressPrintFormat: json['AddressPrintFormat'],
      city: json['City'],
      contactName: json['ContactName'],
      phone1: json['Phone1'],
      email: json['Email'],
      phone2: json['Phone2'],
      address1: json['Address1'],
      address2: json['Address2'],
      address3: json['Address3'],
      taxGroupID: json['TaxGroupID'],
      taxOption: json['TaxOption'],
      dateCreated: json['DateCreated'],
      taxIDNumber: json['TaxIDNumber'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      customerClassID: json['CustomerClassID'],
      parentCustomerID: json['ParentCustomerID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'routeID': routeID,
        'rowIndex': rowIndex,
        'customerID': customerID,
        'customerName': customerName,
        'shortName': shortName,
        'companyName': companyName,
        'addressPrintFormat': addressPrintFormat,
        'city': city,
        'contactName': contactName,
        'phone1': phone1,
        'email': email,
        'phone2': phone2,
        'address1': address1,
        'address2': address2,
        'address3': address3,
        'taxGroupID': taxGroupID,
        'taxOption': taxOption,
        'dateCreated': dateCreated,
        'taxIDNumber': taxIDNumber,
        'latitude': latitude,
        'longitude': longitude,
        'customerClassID': customerClassID,
        'ParentCustomerID': parentCustomerID,
      };

  Map<String, dynamic> toMap() {
    return {
      'routeID': routeID,
      'rowIndex': rowIndex,
      'customerID': customerID,
      'customerName': customerName,
      'shortName': shortName,
      'companyName': companyName,
      'addressPrintFormat': addressPrintFormat,
      'city': city,
      'contactName': contactName,
      'phone1': phone1,
      'email': email,
      'phone2': phone2,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'taxGroupID': taxGroupID,
      'taxOption': taxOption,
      'dateCreated': dateCreated,
      'taxIDNumber': taxIDNumber,
      'latitude': latitude,
      'longitude': longitude,
      'customerClassID': customerClassID,
      'ParentCustomerID': parentCustomerID,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
        routeID: map['RouteID'],
        rowIndex: map['RowIndex'],
        customerID: map['CustomerID'],
        customerName: map['CustomerName'],
        shortName: map['ShortName'],
        companyName: map['Companyname'],
        addressPrintFormat: map['AddressPrintFormat'],
        city: map['City'],
        contactName: map['ContactName'],
        phone1: map['Phone1'],
        email: map['Email'],
        phone2: map['Phone2'],
        address1: map['Address1'],
        address2: map['Address2'],
        address3: map['Address3'],
        taxGroupID: map['TaxGroupID'],
        taxOption: map['TaxOption'],
        dateCreated: map['DateCreated'],
        taxIDNumber: map['TaxIDNumber'],
        latitude: map['Latitude'],
        longitude: map['Longitude'],
        customerClassID: map['CustomerClassID'],
        parentCustomerID: map['ParentCustomerID']);
  }
}

class CustomerListModel {
  final int? result;
  final List<CustomerModel>? modelObject;

  CustomerListModel({
    required this.result,
    required this.modelObject,
  });

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<CustomerModel> items =
        list.map((item) => CustomerModel.fromJson(item)).toList();

    return CustomerListModel(
      result: json['result'],
      modelObject: items,
    );
  }
}

class CustomerListLocalImportantNames {
  static const String tableName = 'Customer';
  static const String routeID = "RouteID";
  static const String rowIndex = "RowIndex";
  static const String customerID = "CustomerID";
  static const String customerName = "CustomerName";
  static const String shortName = "ShortName";
  static const String companyName = "Companyname";
  static const String addressPrintFormat = "AddressPrintFormat";
  static const String city = "City";
  static const String contactName = "ContactName";
  static const String phone1 = 'Phone1';
  static const String email = 'Email';
  static const String phone2 = 'Phone2';
  static const String address1 = 'Address1';
  static const String address2 = 'Address2';
  static const String address3 = 'Address3';
  static const String taxGroupID = 'TaxGroupID';
  static const String taxOption = 'TaxOption';
  static const String dateCreated = 'DateCreated';
  static const String taxIDNumber = 'TaxIDNumber';
  static const String latitude = 'Latitude';
  static const String longitude = 'Longitude';
  static const String customerClassID = 'CustomerClassID';
  static const String parentCustomerID = 'ParentCustomerID';
}
