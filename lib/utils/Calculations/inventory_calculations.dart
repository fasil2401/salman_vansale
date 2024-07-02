import 'package:intl/intl.dart';
import 'dart:math';

class InventoryCalculations {
  static getStockPerFactor(
      {required String factorType,
      required double factor,
      required double stock}) {
    double stockPerFactor = stock;
    if (factorType == 'D') {
      stockPerFactor = stock / factor;
    } else if (factorType == 'M') {
      stockPerFactor = stock * factor;
    }
    return stockPerFactor;
  }

  static getPricePerFactor(
      {required String factorType,
      required double factor,
      required double price}) {
    double pricePerFactor = price;
    if (factorType == 'D') {
      pricePerFactor = price * factor;
    } else if (factorType == 'M') {
      pricePerFactor = price / factor;
    }
    return pricePerFactor;
  }

  static roundOffQuantity({required double quantity}) {
    String roundedQuantity = quantity.toStringAsFixed(2);
    return roundedQuantity;
  }

  static String formatPrice(double price) {
    String formattedPrice =
        NumberFormat.currency(name: '', decimalDigits: 2).format(price);
    return formattedPrice;
  }

  static String formatPriceDgt3(double price) {
    String formattedPrice =
        NumberFormat.currency(name: '', decimalDigits: 3).format(price);
    return formattedPrice;
  }

  static double roundHalfAwayFromZeroToDecimal(double value) {
    final multiplier = pow(10, 2).toDouble();
    final roundedValue =
        (value * multiplier + (value < 0 ? 0 : 0.5)).floor() / multiplier;
    return roundedValue;
  }
  static double roundHalfAwayFromZeroToDecimalFour(double value) {
    final multiplier = pow(10, 4).toDouble();
    final roundedValue =
        (value * multiplier + (value < 0 ? 0 : 0.5)).floor() / multiplier;
    return roundedValue;
  }
}
