import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../providers/budget_provider.dart';
import '../../themes/app_theme.dart';
import '../common/budget_dialogs.dart';

class CartUtils {
  static void addProductToCart(
    WidgetRef ref,
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    // Check if budget is set up before allowing shopping
    final hasBudget = ref.read(hasBudgetSetupProvider);
    
    if (!hasBudget) {
      _showBudgetRequiredDialog(context, ref);
      return;
    }

    // Proceed with adding to cart
    ref.read(cartProvider.notifier).addItem({
      'id': product['id'].toString(),
      'name': product['name'],
      'brand': 'K-Beauty Pro',
      'image': product['images'] ?? '',
      'price': product['price'],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: AppColors.primaryBrown,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static void _showBudgetRequiredDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Set Your Budget First'),
        content: const Text(
          'You need to set up your monthly budget before you can start shopping. This helps you track spending and make informed decisions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              BudgetDialogs.showBudgetSetupDialog(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
            ),
            child: const Text(
              'Set Budget',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}