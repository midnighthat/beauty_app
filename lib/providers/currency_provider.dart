import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

// Currency state notifier
class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('USD') {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final currency = await PreferencesService.getCurrency();
    state = currency;
  }

  Future<void> setCurrency(String currency) async {
    await PreferencesService.setCurrency(currency);
    state = currency;
  }
}

// Currency provider
final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

// Currency utility class
class CurrencyUtils {
  static const double usdToAedRate = 3.7;
  
  static double convertPrice(double usdPrice, String targetCurrency) {
    switch (targetCurrency) {
      case 'AED':
        return usdPrice * usdToAedRate;
      case 'USD':
      default:
        return usdPrice;
    }
  }
  
  static String formatPrice(double price, String currency) {
    switch (currency) {
      case 'AED':
        return 'AED ${price.toStringAsFixed(2)}';
      case 'USD':
      default:
        return '\$${price.toStringAsFixed(2)}';
    }
  }
  
  static String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'AED':
        return 'AED';
      case 'USD':
      default:
        return '\$';
    }
  }
  
  static String getCurrencyPrefix(String currency) {
    switch (currency) {
      case 'AED':
        return 'AED';
      case 'USD':
      default:
        return '\$';
    }
  }
}