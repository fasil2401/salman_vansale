// To parse this JSON data, do
//
//     final createVanSalesOrderModel = createVanSalesOrderModelFromJson(jsonString);

import 'dart:convert';

import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';

CreateVanSalesOrderModel createVanSalesOrderModelFromJson(String str) =>
    CreateVanSalesOrderModel.fromJson(json.decode(str));

String createVanSalesOrderModelToJson(CreateVanSalesOrderModel data) =>
    json.encode(data.toJson());

class CreateVanSalesOrderModel {
  String? token;
  String? sysdocid;
  String? voucherid;
  String? companyid;
  String? divisionid;
  String? customerid;
  DateTime? transactiondate;
  String? salespersonid;
  int? salesflow;
  bool? isexport;
  DateTime? requireddate;
  DateTime? duedate;
  DateTime? etd;
  String? shippingaddress;
  String? shiptoaddress;
  String? billingaddress;
  String? customeraddress;
  bool? priceincludetax;
  int? status;
  String? currencyid;
  double? currencyrate;
  String? currencyname;
  String? termid;
  String? shippingmethodid;
  String? reference;
  String? reference2;
  String? note;
  String? pOnumber;
  bool? isvoid;
  double? discount;
  double? total;
  double? taxamount;
  int? sourcedoctype;
  String? jobid;
  String? costcategoryid;
  String? payeetaxgroupid;
  int? taxoption;
  int? roundoff;
  int? ordertype;
  bool? isnewrecord;
  List<SalesOrderDetail>? salesOrderDetails;
  List<TaxDetail>? taxDetails;
  List<VanSaleProductLotDetail>? vanSaleProductLotDetails;

  CreateVanSalesOrderModel({
    this.token,
    this.sysdocid,
    this.voucherid,
    this.companyid,
    this.divisionid,
    this.customerid,
    this.transactiondate,
    this.salespersonid,
    this.salesflow,
    this.isexport,
    this.requireddate,
    this.duedate,
    this.etd,
    this.shippingaddress,
    this.shiptoaddress,
    this.billingaddress,
    this.customeraddress,
    this.priceincludetax,
    this.status,
    this.currencyid,
    this.currencyrate,
    this.currencyname,
    this.termid,
    this.shippingmethodid,
    this.reference,
    this.reference2,
    this.note,
    this.pOnumber,
    this.isvoid,
    this.discount,
    this.total,
    this.taxamount,
    this.sourcedoctype,
    this.jobid,
    this.costcategoryid,
    this.payeetaxgroupid,
    this.taxoption,
    this.roundoff,
    this.ordertype,
    this.isnewrecord,
    this.salesOrderDetails,
    this.taxDetails,
    this.vanSaleProductLotDetails,
  });

  factory CreateVanSalesOrderModel.fromJson(Map<String, dynamic> json) =>
      CreateVanSalesOrderModel(
        token: json["token"],
        sysdocid: json["Sysdocid"],
        voucherid: json["Voucherid"],
        companyid: json["Companyid"],
        divisionid: json["Divisionid"],
        customerid: json["Customerid"],
        transactiondate: DateTime.parse(json["Transactiondate"]),
        salespersonid: json["Salespersonid"],
        salesflow: json["Salesflow"],
        isexport: json["Isexport"],
        requireddate: DateTime.parse(json["Requireddate"]),
        duedate: DateTime.parse(json["Duedate"]),
        etd: DateTime.parse(json["ETD"]),
        shippingaddress: json["Shippingaddress"],
        shiptoaddress: json["Shiptoaddress"],
        billingaddress: json["Billingaddress"],
        customeraddress: json["Customeraddress"],
        priceincludetax: json["Priceincludetax"],
        status: json["Status"],
        currencyid: json["Currencyid"],
        currencyrate: json["Currencyrate"],
        currencyname: json["Currencyname"],
        termid: json["Termid"],
        shippingmethodid: json["Shippingmethodid"],
        reference: json["Reference"],
        reference2: json["Reference2"],
        note: json["Note"],
        pOnumber: json["POnumber"],
        isvoid: json["Isvoid"],
        discount: json["Discount"],
        total: json["Total"],
        taxamount: json["Taxamount"],
        sourcedoctype: json["Sourcedoctype"],
        jobid: json["Jobid"],
        costcategoryid: json["Costcategoryid"],
        payeetaxgroupid: json["Payeetaxgroupid"],
        taxoption: json["Taxoption"],
        roundoff: json["Roundoff"],
        ordertype: json["Ordertype"],
        isnewrecord: json["Isnewrecord"],
        salesOrderDetails: List<SalesOrderDetail>.from(
            json["SalesOrderDetails"].map((x) => SalesOrderDetail.fromJson(x))),
        taxDetails: List<TaxDetail>.from(
            json["TaxDetails"].map((x) => TaxDetail.fromJson(x))),
        vanSaleProductLotDetails: List<VanSaleProductLotDetail>.from(
            json["VANSaleProductLotDetails"]
                .map((x) => VanSaleProductLotDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "Sysdocid": sysdocid,
        "Voucherid": voucherid,
        "Companyid": companyid,
        "Divisionid": divisionid,
        "Customerid": customerid,
        "Transactiondate": transactiondate!.toIso8601String(),
        "Salespersonid": salespersonid,
        "Salesflow": salesflow,
        "Isexport": isexport,
        "Requireddate": requireddate!.toIso8601String(),
        "Duedate": duedate!.toIso8601String(),
        "ETD": etd!.toIso8601String(),
        "Shippingaddress": shippingaddress,
        "Shiptoaddress": shiptoaddress,
        "Billingaddress": billingaddress,
        "Customeraddress": customeraddress,
        "Priceincludetax": priceincludetax,
        "Status": status,
        "Currencyid": currencyid,
        "Currencyrate": currencyrate,
        "Currencyname": currencyname,
        "Termid": termid,
        "Shippingmethodid": shippingmethodid,
        "Reference": reference,
        "Reference2": reference2,
        "Note": note,
        "POnumber": pOnumber,
        "Isvoid": isvoid,
        "Discount": discount,
        "Total": total,
        "Taxamount": taxamount,
        "Sourcedoctype": sourcedoctype,
        "Jobid": jobid,
        "Costcategoryid": costcategoryid,
        "Payeetaxgroupid": payeetaxgroupid,
        "Taxoption": taxoption,
        "Roundoff": roundoff,
        "Ordertype": ordertype,
        "Isnewrecord": isnewrecord,
        "SalesOrderDetails":
            List<dynamic>.from(salesOrderDetails?.map((x) => x.toJson()) ?? []),
        "TaxDetails":
            List<dynamic>.from(taxDetails?.map((x) => x.toJson()) ?? []),
        "VANSaleProductLotDetails": List<dynamic>.from(
            vanSaleProductLotDetails?.map((x) => x.toJson()) ?? []),
      };
}

class SalesOrderDetail {
  String? itemcode;
  String? description;
  double? quantity;
  String? remarks;
  int? rowindex;
  String? unitid;
  String? specificationid;
  String? styleid;
  String? equipmentid;
  int? itemtype;
  String? locationid;
  String? jobid;
  String? costcategoryid;
  String? sourcesysdocid;
  String? sourcevoucherid;
  String? sourcerowindex;
  double? unitprice;
  double? cost;
  double? amount;
  int? taxoption;
  double? taxamount;
  String? taxgroupid;

  SalesOrderDetail({
    this.itemcode,
    this.description,
    this.quantity,
    this.remarks,
    this.rowindex,
    this.unitid,
    this.specificationid,
    this.styleid,
    this.equipmentid,
    this.itemtype,
    this.locationid,
    this.jobid,
    this.costcategoryid,
    this.sourcesysdocid,
    this.sourcevoucherid,
    this.sourcerowindex,
    this.unitprice,
    this.cost,
    this.amount,
    this.taxoption,
    this.taxamount,
    this.taxgroupid,
  });

  factory SalesOrderDetail.fromJson(Map<String, dynamic> json) =>
      SalesOrderDetail(
        itemcode: json["Itemcode"],
        description: json["Description"],
        quantity: json["Quantity"],
        remarks: json["Remarks"],
        rowindex: json["Rowindex"],
        unitid: json["Unitid"],
        specificationid: json["Specificationid"],
        styleid: json["Styleid"],
        equipmentid: json["Equipmentid"],
        itemtype: json["Itemtype"],
        locationid: json["Locationid"],
        jobid: json["Jobid"],
        costcategoryid: json["Costcategoryid"],
        sourcesysdocid: json["Sourcesysdocid"],
        sourcevoucherid: json["Sourcevoucherid"],
        sourcerowindex: json["Sourcerowindex"],
        unitprice: json["Unitprice"],
        cost: json["Cost"],
        amount: json["Amount"],
        taxoption: json["Taxoption"],
        taxamount: json["Taxamount"],
        taxgroupid: json["Taxgroupid"],
      );

  Map<String, dynamic> toJson() => {
        "Itemcode": itemcode,
        "Description": description,
        "Quantity": quantity,
        "Remarks": remarks,
        "Rowindex": rowindex,
        "Unitid": unitid,
        "Specificationid": specificationid,
        "Styleid": styleid,
        "Equipmentid": equipmentid,
        "Itemtype": itemtype,
        "Locationid": locationid,
        "Jobid": jobid,
        "Costcategoryid": costcategoryid,
        "Sourcesysdocid": sourcesysdocid,
        "Sourcevoucherid": sourcevoucherid,
        "Sourcerowindex": sourcerowindex,
        "Unitprice": unitprice,
        "Cost": cost,
        "Amount": amount,
        "Taxoption": taxoption,
        "Taxamount": taxamount,
        "Taxgroupid": taxgroupid,
      };
}


