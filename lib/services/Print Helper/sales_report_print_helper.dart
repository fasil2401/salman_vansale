class SalesReportPrintHelper {
  String? printDate;
  String? fromDate;
  String? toDate;
  String? salesPerson;
  String? vanName;
  String? total;
  String? headerImage;
  String? footerImage;
  List<SalesReportDetailModel>? items;

  SalesReportPrintHelper({
    this.printDate,
    this.fromDate,
    this.toDate,
    this.salesPerson,
    this.vanName,
    this.total,
    this.headerImage,
    this.footerImage,
    this.items,
  });
}

class SalesReportDetailModel {
  String? customerCode;
  String? voucherNo;
  double? total;
  double? tax;
  double? netAmount;
  double? discount;
  String? date;
  String? paymentMode;

  SalesReportDetailModel({
    this.customerCode,
    this.voucherNo,
    this.total,
    this.tax,
    this.netAmount,
    this.discount,
    this.date,
    this.paymentMode,
  });
}
