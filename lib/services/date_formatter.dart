import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat('dd MMM yyyy');
DateFormat dateFormatTime = DateFormat('jm');
DateFormat dateFormatter = DateFormat('yyyy-mm-dd h:mm a');

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
