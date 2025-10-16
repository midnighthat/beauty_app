import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../widgets/common/budget_dialogs.dart';
import '../../providers/cart_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/currency_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartItems = ref.watch(cartProvider);
    final usdCartTotal = ref.watch(cartTotalProvider);
    final currency = ref.watch(currencyProvider);
    final convertedCartTotal = CurrencyUtils.convertPrice(usdCartTotal, currency);
    final formattedCartTotal = CurrencyUtils.formatPrice(convertedCartTotal, currency);
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBrown,
                    AppColors.primaryBrown.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleText(
                        'Total',
                        color: AppColors.white,
                        fontSize: 24,
                      ),
                      TitleText(
                        formattedCartTotal,
                        color: AppColors.white,
                        fontSize: 24,
                      ),
                    ],
                  ),
                  
                  // Budget Progress Section
                  _buildBudgetProgress(ref, convertedCartTotal),
                ],
              ),
            ),
            
            // Product list or empty state
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 64,
                            color: AppColors.primaryBrown.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            'Your cart is empty',
                            type: TextType.bodyLarge,
                            color: isDark ? AppColors.creamBackground : AppColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            'Add some products to get started',
                            type: TextType.bodySmall,
                            color: AppColors.lightText,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Continue Shopping'),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Product items
                          Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildCartItem(item),
                                );
                              },
                            ),
                          ),
                    
                    const SizedBox(height: 20),
                    
                    // Continue button
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.image.isNotEmpty
                  ? Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: AppColors.primaryBrown,
                            size: 30,
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: AppColors.primaryBrown,
                        size: 30,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.name,
                  type: TextType.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                CustomText(
                  item.brand,
                  type: TextType.caption,
                  color: AppColors.lightText,
                ),
                const SizedBox(height: 12),
                // Quantity controls
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              item.id,
                              item.quantity - 1,
                            );
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: AppColors.primaryBrown,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomText(
                      item.quantity.toString(),
                      type: TextType.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              item.id,
                              item.quantity + 1,
                            );
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.primaryBrown,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final currency = ref.watch(currencyProvider);
                  if (item.salePrice != null) {
                    final convertedSalePrice = CurrencyUtils.convertPrice(item.salePrice!, currency);
                    final convertedPrice = CurrencyUtils.convertPrice(item.price, currency);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          CurrencyUtils.formatPrice(convertedSalePrice, currency),
                          type: TextType.bodyLarge,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBrown,
                        ),
                        CustomText(
                          CurrencyUtils.formatPrice(convertedPrice, currency),
                          type: TextType.caption,
                          color: AppColors.lightText,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ],
                    );
                  } else {
                    final convertedPrice = CurrencyUtils.convertPrice(item.price, currency);
                    return CustomText(
                      CurrencyUtils.formatPrice(convertedPrice, currency),
                      type: TextType.bodyLarge,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBrown,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Consumer(
      builder: (context, ref, child) {
        final hasBudget = ref.watch(hasBudgetSetupProvider);
        final budgetProfile = ref.watch(budgetProfileProvider);
        final usdCartTotal = ref.watch(cartTotalProvider);
        final currency = ref.watch(currencyProvider);
        final convertedCartTotal = CurrencyUtils.convertPrice(usdCartTotal, currency);
        
        // Check if budget is required
        if (!hasBudget || budgetProfile == null) {
          return Column(
            children: [
              // Budget warning
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget Required',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You need to set a budget before you can continue shopping.',
                            style: TextStyle(
                              color: Colors.orange.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Disabled continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _showBudgetRequiredDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Set Budget First',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Check if over budget
        final convertedMonthlyBudget = CurrencyUtils.convertPrice(budgetProfile.monthlyBudget, currency);
        final convertedCurrentSpent = CurrencyUtils.convertPrice(budgetProfile.currentMonthSpent, currency);
        final potentialNewSpent = convertedCurrentSpent + convertedCartTotal;
        final isOverBudget = potentialNewSpent > convertedMonthlyBudget;
        
        if (isOverBudget) {
          final overAmount = potentialNewSpent - convertedMonthlyBudget;
          return Column(
            children: [
              // Over budget warning
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Over Budget!',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'This purchase will exceed your budget by ${CurrencyUtils.formatPrice(overAmount, currency)}.',
                            style: TextStyle(
                              color: Colors.red.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Disabled continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _showOverBudgetDialog(overAmount, currency);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Over Budget - Cannot Continue',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Normal continue button
        return PrimaryButton(
          text: 'Continue',
          onPressed: () {
            _showPaymentDrawer(context);
          },
          width: double.infinity,
          size: ButtonSize.large,
        );
      },
    );
  }

  Widget _buildBudgetProgress(WidgetRef ref, double cartTotal) {
    final budgetProfile = ref.watch(budgetProfileProvider);
    final hasBudget = ref.watch(hasBudgetSetupProvider);
    final currency = ref.watch(currencyProvider);
    
    if (!hasBudget || budgetProfile == null) {
      return const SizedBox(); // Don't show if no budget set
    }
    
    // Convert budget amounts to selected currency for display
    final convertedMonthlyBudget = CurrencyUtils.convertPrice(budgetProfile.monthlyBudget, currency);
    final convertedCurrentSpent = CurrencyUtils.convertPrice(budgetProfile.currentMonthSpent, currency);
    
    final potentialNewSpent = convertedCurrentSpent + cartTotal;
    final remainingBudget = convertedMonthlyBudget - potentialNewSpent;
    final progressPercentage = (potentialNewSpent / convertedMonthlyBudget * 100).clamp(0, 100);
    final isOverBudget = potentialNewSpent > convertedMonthlyBudget;
    
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Budget',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isOverBudget 
                  ? 'Over by ${CurrencyUtils.formatPrice((potentialNewSpent - convertedMonthlyBudget), currency)}'
                  : '${CurrencyUtils.formatPrice(remainingBudget, currency)} left',
                style: TextStyle(
                  color: isOverBudget ? Colors.red.shade300 : AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress Bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: AppColors.white.withOpacity(0.3),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: (progressPercentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isOverBudget 
                        ? Colors.red.shade300
                        : progressPercentage >= 80 
                          ? Colors.orange.shade300
                          : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 4),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${CurrencyUtils.formatPrice(potentialNewSpent, currency)} spent',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              Text(
                '${CurrencyUtils.formatPrice(convertedMonthlyBudget, currency)} budget',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaymentDrawer(),
    );
  }

  void _showBudgetRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkSurface 
            : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            const TitleText(
              'Set Your Budget',
              color: Colors.orange,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BodyText(
              'You need to set a monthly budget before you can proceed with checkout. This helps you manage your spending.',
              textAlign: TextAlign.center,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.creamBackground.withOpacity(0.8)
                  : AppColors.lightText,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Later',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      BudgetDialogs.showBudgetSetupDialog(context, ref);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Set Budget',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOverBudgetDialog(double overAmount, String currency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkSurface 
            : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const TitleText(
              'Budget Exceeded!',
              color: Colors.red,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BodyText(
              'This purchase would exceed your monthly budget by ${CurrencyUtils.formatPrice(overAmount, currency)}. Please remove some items or increase your budget.',
              textAlign: TextAlign.center,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.creamBackground.withOpacity(0.8)
                  : AppColors.lightText,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Edit Cart',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      BudgetDialogs.showBudgetSetupDialog(context, ref);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Increase Budget',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentDrawer extends ConsumerStatefulWidget {
  const PaymentDrawer({super.key});

  @override
  ConsumerState<PaymentDrawer> createState() => _PaymentDrawerState();
}

class _PaymentDrawerState extends ConsumerState<PaymentDrawer> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Mock card details for demo
    _cardNumberController.text = '4532 1234 5678 9012';
    _expiryController.text = '12/26';
    _cvvController.text = '123';
    _nameController.text = 'John Doe';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightText.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Header
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: TitleText(
                    'Payment Details',
                    textAlign: TextAlign.center,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
                const SizedBox(width: 48), // Balance close button
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Payment form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card preview
                      _buildCardPreview(),
                      
                      const SizedBox(height: 32),
                      
                      // Card Number
                      CustomText(
                        'Card Number',
                        type: TextType.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _CardNumberFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: '1234 5678 9012 3456',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.lightText.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.lightText.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBrown,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter card number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Cardholder Name
                      CustomText(
                        'Cardholder Name',
                        type: TextType.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'John Doe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.lightText.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.lightText.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBrown,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cardholder name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Expiry and CVV
                      Row(
                        children: [
                          // Expiry
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  'Expiry Date',
                                  type: TextType.bodyMedium,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _expiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    _ExpiryDateFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'MM/YY',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.lightText.withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.lightText.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryBrown,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // CVV
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  'CVV',
                                  type: TextType.bodyMedium,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 3,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '123',
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.lightText.withOpacity(0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.lightText.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryBrown,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Order Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              'Total Amount',
                              type: TextType.bodyLarge,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.creamBackground : AppColors.darkText,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final usdCartTotal = ref.watch(cartTotalProvider);
                                final currency = ref.watch(currencyProvider);
                                final convertedCartTotal = CurrencyUtils.convertPrice(usdCartTotal, currency);
                                final formattedCartTotal = CurrencyUtils.formatPrice(convertedCartTotal, currency);
                                return CustomText(
                                  formattedCartTotal,
                                  type: TextType.bodyLarge,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBrown,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            
            // Pay Now Button
            PrimaryButton(
              text: _isProcessing ? 'Processing...' : 'Pay Now',
              onPressed: _isProcessing ? null : _processPayment,
              width: double.infinity,
              size: ButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBrown,
            Color(0xFFE91E63),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Card type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  'BEAUTY CARD',
                  type: TextType.caption,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const CustomText(
                    'VISA',
                    type: TextType.caption,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            
            // Card number
            CustomText(
              _cardNumberController.text.isNotEmpty 
                  ? _cardNumberController.text 
                  : '•••• •••• •••• ••••',
              type: TextType.bodyLarge,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
            
            // Name and expiry
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'CARD HOLDER',
                      type: TextType.caption,
                      color: AppColors.white,
                    ),
                    CustomText(
                      _nameController.text.isNotEmpty 
                          ? _nameController.text.toUpperCase() 
                          : 'YOUR NAME',
                      type: TextType.bodyMedium,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CustomText(
                      'EXPIRES',
                      type: TextType.caption,
                      color: AppColors.white,
                    ),
                    CustomText(
                      _expiryController.text.isNotEmpty 
                          ? _expiryController.text 
                          : 'MM/YY',
                      type: TextType.bodyMedium,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Clear the cart after successful payment
    ref.read(cartProvider.notifier).clearCart();

    setState(() {
      _isProcessing = false;
    });

    // Close drawer
    Navigator.pop(context);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkSurface 
            : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 40,
                color: AppColors.primaryBrown,
              ),
            ),
            const SizedBox(height: 24),
            const TitleText(
              'Payment Successful!',
              color: AppColors.primaryBrown,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BodyText(
              'Your order has been placed successfully. You will receive an email confirmation shortly.',
              textAlign: TextAlign.center,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.creamBackground.withOpacity(0.8)
                  : AppColors.lightText,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Continue Shopping',
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close cart screen
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

// Card number formatter
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Expiry date formatter
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}