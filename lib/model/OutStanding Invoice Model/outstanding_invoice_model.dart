import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:flutter/material.dart';

class OutstandingInvoiceListModel {
  final int? result;
  final List<OutstandingInvoiceModel>? modelObject;

  OutstandingInvoiceListModel(
      {required this.result, required this.modelObject});

  factory OutstandingInvoiceListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['Modelobject'];
    List<OutstandingInvoiceModel> items =
        list.map((i) => OutstandingInvoiceModel.fromJson(i)).toList();

    return OutstandingInvoiceListModel(
        result: json['result'], modelObject: items);
  }
}

class OutstandingInvoiceModel {
  final int? journalID;
  final String? sysDocID;
  final String? voucherID;
  final String? customerID;
  final String? description;
  final String? reference;
  final String? arDate;
  final String? dueDate;
  final double? originalAmount;
  final dynamic job;
  final String? currencyID;
  final double? currencyRate;
  final double? amountDue;
  final int? overdueDays;
  bool isChecked;
  TextEditingController? controller;
  bool isError;
  double? availableAmount;

  OutstandingInvoiceModel({
    this.journalID,
    this.sysDocID,
    this.voucherID,
    this.customerID,
    this.description,
    this.reference,
    this.arDate,
    this.dueDate,
    this.originalAmount,
    this.job,
    this.currencyID,
    this.currencyRate,
    this.amountDue,
    this.overdueDays,
    this.isChecked = false,
    this.controller,
    this.isError = false,
    this.availableAmount,
  });

  factory OutstandingInvoiceModel.fromJson(Map<String, dynamic> json) {
    return OutstandingInvoiceModel(
      journalID: json['JournalID'],
      sysDocID: json['SysDocID'],
      voucherID: json['VoucherID'],
      customerID: json['CustomerID'],
      description: json['Description'],
      reference: json['Reference'],
      arDate: json['ARDate'],
      dueDate: json['Due Date'],
      originalAmount: json['OriginalAmount']?.toDouble() ?? 0.0,
      job: json['JOB'],
      currencyID: json['CurrencyID'],
      currencyRate: json['CurrencyRate']?.toDouble() ?? 0.0,
      amountDue: json['AmountDue']?.toDouble() ?? 0.0,
      overdueDays: json['OverdueDays'],
    );
  }

  Map<String, dynamic> toJson() => {
        'JournalID': journalID,
        'SysDocID': sysDocID,
        'VoucherID': voucherID,
        'CustomerID': customerID,
        'Description': description,
        'Reference': reference,
        'ARDate': arDate,
        'Due Date': dueDate,
        'OriginalAmount': originalAmount,
        'JOB': job,
        'CurrencyID': currencyID,
        'CurrencyRate': currencyRate,
        'AmountDue': amountDue,
        'OverdueDays': overdueDays,
      };

  Map<String, dynamic> toMap() {
    return {
      'JournalID': journalID,
      'SysDocID': sysDocID,
      'VoucherID': voucherID,
      'CustomerID': customerID,
      'Description': description,
      'Reference': reference,
      'ARDate': arDate,
      'Due Date': dueDate,
      'OriginalAmount': originalAmount,
      'JOB': job,
      'CurrencyID': currencyID,
      'CurrencyRate': currencyRate,
      'AmountDue': amountDue,
      'OverdueDays': overdueDays,
    };
  }

  factory OutstandingInvoiceModel.fromMap(Map<String, dynamic> map) {
    return OutstandingInvoiceModel(
      journalID: int.tryParse(map['JournalID']),
      sysDocID: map['SysDocID'],
      voucherID: map['VoucherID'],
      customerID: map['CustomerID'],
      description: map['Description'],
      reference: map['Reference'],
      arDate: map['ARDate'],
      dueDate: map['Due Date'],
      originalAmount: map['OriginalAmount']?.toDouble() ?? 0.0,
      job: map['JOB'],
      currencyID: map['CurrencyID'],
      currencyRate: map['CurrencyRate']?.toDouble() ?? 0.0,
      amountDue: map['AmountDue']?.toDouble() ?? 0.0,
      overdueDays: map['OverdueDays'],
      availableAmount: map['DueAmount'],
      controller:
          TextEditingController(text: InventoryCalculations.formatPrice(0.0)),
    );
  }
}

class OutstandingInvoiceListLocalImportantNames {
  static const String tableName = 'OutStandingInvoice';
  static const String journalID = 'JournalID';
  static const String sysDocID = 'SysDocID';
  static const String voucherID = 'VoucherID';
  static const String customerID = 'CustomerID';
  static const String description = 'Description';
  static const String reference = 'Reference';
  static const String arDate = 'ARDate';
  static const String dueDate = 'DueDate';
  static const String originalAmount = 'OriginalAmount';
  static const String job = 'JOB';
  static const String currencyID = 'CurrencyID';
  static const String currencyRate = 'CurrencyRate';
  static const String amountDue = 'AmountDue';
  static const String overdueDays = 'OverdueDays';
}
