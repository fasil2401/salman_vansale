enum ButtonTypes {
  Primary(1, 'primary'),
  Secondary(2, 'secondary'),
  Outlined(3, 'outlined');

  const ButtonTypes(this.value, this.name);
  final int value;
  final String name;
}

enum PreviewTemplate {
  Template1(1, 'assets/print_templates/preview1.html'),
  Template2(2, 'assets/print_templates/preview2.html'),
  Template3(3, 'assets/print_templates/preview3.html'),
  Template4(4, 'assets/print_templates/preview4.html'),
  Template5(5, 'assets/print_templates/preview6.html'),
  Template6(9, 'assets/print_templates/preview5.html'),
  Template7(10, 'assets/print_templates/preview7.html'),
  Template8(11, 'assets/print_templates/preview8.html'),
  NewOrder(6, 'assets/print_templates/order_template/order.html'),
  Expenses(7, 'assets/print_templates/expenses.html'),
  CashCheque(8, 'assets/print_templates/cash_cheque.html');

  const PreviewTemplate(this.value, this.path);
  final int value;
  final String path;
}

enum ReportPreviewTemplate {
  SalesInvoice(
      1, 'assets/print_templates/report_templates/sales_invoice_report.html'),
  SalesOrder(
      2, 'assets/print_templates/report_templates/sales_order_report.html'),
  DailySales(
      3, 'assets/print_templates/report_templates/daily_sales_report.html'),
  StockReport(4, 'assets/print_templates/report_templates/stock_report.html'),
  Payments(5, 'assets/print_templates/report_templates/payments_report.html'),
  Expenses(6, 'assets/print_templates/report_templates/expenses_report.html');

  const ReportPreviewTemplate(this.value, this.path);
  final int value;
  final String path;
}

enum ConnectionOptions {
  Bluetooth(1, 'Bluetooth'),
  Wifi(2, 'Wifi');

  const ConnectionOptions(this.value, this.name);
  final int value;
  final String name;
}

enum PaperOptions {
  Basic(1, '80 mm'),
  Inch4(2, '100 mm');

  const PaperOptions(this.value, this.name);
  final int value;
  final String name;
}

enum PrintPreference {
  Thermal(1, 'Thermal Printer'),
  Pdf(2, 'Print pdf');

  const PrintPreference(this.value, this.name);
  final int value;
  final String name;
}

enum PrintLayouts {
  SalesInvoice(1, 'Sales Invoice'),
  SalesReturn(2, 'Sales Return'),
  StockReport(3, 'Stock Report'),
  DailySales(4, 'Daily Sales'),
  SalesReport(5, 'Sales Report'),
  PaymentsReport(6, 'Sales Report'),
  CashOrChequeReciept(7, 'Cash Cheque Reciept'),
  ExpenseReport(7, 'Expense Report'),
  ExpenseTransaction(8, 'Expense Transaction'),
  SalesOrder(9, 'Sales Order');

  const PrintLayouts(this.value, this.name);
  final int value;
  final String name;
}
