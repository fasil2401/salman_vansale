class DiscountHelper {
  static double calculateDiscount(
      {required double discountAmount,
      required double totalAmount,
      required bool isPercent}) {
    double result = 0.0;
    if (isPercent) {
      result = (totalAmount * discountAmount) / 100;
    } else {
      result = (discountAmount * 100) / totalAmount;
    }
    return result;
  }

  static double subtractPercentage(double value, double percentage) {
    double result = 0.0;
    if (value != 0.0) {
      result = value - (percentage / 100) * value;
    }
    return result;
  }
}
