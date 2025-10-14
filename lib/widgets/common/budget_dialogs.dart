import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/budget_provider.dart';
import '../../providers/currency_provider.dart';
import '../../models/budget_models.dart';
import 'index.dart';

class BudgetSetupDialog extends ConsumerStatefulWidget {
  const BudgetSetupDialog({super.key});

  @override
  ConsumerState<BudgetSetupDialog> createState() => _BudgetSetupDialogState();
}

class _BudgetSetupDialogState extends ConsumerState<BudgetSetupDialog> {
  final _budgetController = TextEditingController();
  bool _isLoading = false;
  String _selectedCurrency = 'USD';
  String _lastCurrency = '';

  @override
  void initState() {
    super.initState();
    // Initialize with global currency preference
    _selectedCurrency = ref.read(currencyProvider);
    _lastCurrency = _selectedCurrency;
    
    // If editing existing budget, populate current values converted to selected currency
    final currentBudget = ref.read(budgetProfileProvider);
    if (currentBudget != null) {
      final convertedBudget = CurrencyUtils.convertPrice(currentBudget.monthlyBudget, _selectedCurrency);
      _budgetController.text = convertedBudget.toStringAsFixed(0);
    }
  }

  void _updateBudgetForCurrency(String newCurrency) {
    if (_lastCurrency == newCurrency || _budgetController.text.isEmpty) return;
    
    final currentValue = double.tryParse(_budgetController.text);
    if (currentValue == null) return;
    
    // Convert current value back to USD first
    final usdValue = _lastCurrency == 'AED' 
      ? currentValue / CurrencyUtils.usdToAedRate 
      : currentValue;
    
    // Convert USD to new currency
    final newValue = CurrencyUtils.convertPrice(usdValue, newCurrency);
    _budgetController.text = newValue.toStringAsFixed(0);
    
    _lastCurrency = newCurrency;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.creamBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primaryBrown,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TitleText(
                    'Set Monthly Budget',
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Currency Selection
            BodyText(
              'Currency',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildCurrencyOption('USD', 'US Dollar', '\$', isDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCurrencyOption('AED', 'UAE Dirham', 'AED', isDark),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Budget Amount Input
            BodyText(
              'Monthly Budget Amount',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 8),
            
            // Amount Input with USD prefix
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: _selectedCurrency == 'AED' ? '370' : '100',
                prefixText: '${CurrencyUtils.getCurrencyPrefix(_selectedCurrency)} ',
                prefixStyle: TextStyle(
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryBrown),
                ),
              ),
              style: TextStyle(
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Info Text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CaptionText(
                      'This budget will help you track your monthly skincare spending and get insights on your habits.',
                      color: AppColors.primaryBrown,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBrown.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.primaryBrown),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveBudget,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                            ),
                          )
                        : const Text('Save Budget'),
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

  Future<void> _saveBudget() async {
    final budgetText = _budgetController.text.trim();
    if (budgetText.isEmpty) {
      _showError('Please enter a budget amount');
      return;
    }

    final displayBudgetAmount = double.tryParse(budgetText);
    if (displayBudgetAmount == null || displayBudgetAmount <= 0) {
      _showError('Please enter a valid budget amount');
      return;
    }

    // Convert input back to USD for storage
    final usdBudgetAmount = _selectedCurrency == 'AED' 
      ? displayBudgetAmount / CurrencyUtils.usdToAedRate 
      : displayBudgetAmount;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(budgetProfileProvider.notifier).setBudget(usdBudgetAmount, 'USD');
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Budget set to ${CurrencyUtils.formatPrice(displayBudgetAmount, _selectedCurrency)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to save budget. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCurrencyOption(String code, String name, String symbol, bool isDark) {
    final isSelected = _selectedCurrency == code;
    
    return GestureDetector(
      onTap: () {
        if (_selectedCurrency != code) {
          _updateBudgetForCurrency(code);
          setState(() {
            _selectedCurrency = code;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primaryBrown.withOpacity(0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
              ? AppColors.primaryBrown
              : (isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3)),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBrown,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              code,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected 
                  ? AppColors.primaryBrown
                  : (isDark ? AppColors.creamBackground : AppColors.darkText),
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _productNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.cleanser;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.creamBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.add_shopping_cart,
                    color: AppColors.primaryBrown,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TitleText(
                      'Add Expense',
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Product Name
              _buildInputField(
                label: 'Product Name',
                controller: _productNameController,
                hint: 'e.g., CeraVe Foaming Cleanser',
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Amount
              _buildInputField(
                label: 'Amount',
                controller: _amountController,
                hint: '0.00',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                isDark: isDark,
                prefix: Text(
                  '\$ ',
                  style: TextStyle(
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Category
              BodyText(
                'Category',
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<ExpenseCategory>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ExpenseCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.displayName,
                        style: TextStyle(
                          color: isDark ? AppColors.creamBackground : AppColors.darkText,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Notes (Optional)
              _buildInputField(
                label: 'Notes (Optional)',
                controller: _notesController,
                hint: 'Add any notes about this purchase...',
                maxLines: 3,
                isDark: isDark,
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBrown.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.primaryBrown),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _addExpense,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                              ),
                            )
                          : const Text('Add Expense'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          label,
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: prefix,
            ) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryBrown),
            ),
          ),
          style: TextStyle(
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
        ),
      ],
    );
  }

  Future<void> _addExpense() async {
    final productName = _productNameController.text.trim();
    final amountText = _amountController.text.trim();

    if (productName.isEmpty) {
      _showError('Please enter a product name');
      return;
    }

    if (amountText.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final transaction = ExpenseTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productName: productName,
        amount: amount,
        date: DateTime.now(),
        category: _selectedCategory,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await ref.read(budgetProfileProvider.notifier).addExpense(transaction);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added \$${amount.toStringAsFixed(2)} expense for $productName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to add expense. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class WellnessInputDialog extends StatefulWidget {
  final String title;
  final double currentValue;
  final String unit;
  final double maxValue;
  final Function(double) onSave;

  const WellnessInputDialog({
    super.key,
    required this.title,
    required this.currentValue,
    required this.unit,
    required this.maxValue,
    required this.onSave,
  });

  @override
  State<WellnessInputDialog> createState() => _WellnessInputDialogState();
}

class _WellnessInputDialogState extends State<WellnessInputDialog> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.creamBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: TitleText(
                    widget.title,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Current Value Display
            DisplayText(
              '${_currentValue.toStringAsFixed(1)} ${widget.unit}',
              color: AppColors.primaryBrown,
              isLarge: true,
            ),
            
            const SizedBox(height: 24),
            
            // Slider
            Slider(
              value: _currentValue,
              min: 0.0,
              max: widget.maxValue,
              divisions: (widget.maxValue * 10).toInt(),
              activeColor: AppColors.primaryBrown,
              inactiveColor: AppColors.primaryBrown.withOpacity(0.3),
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
            ),
            
            // Range Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CaptionText(
                    '0 ${widget.unit}',
                    color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                  ),
                  CaptionText(
                    '${widget.maxValue.toStringAsFixed(1)} ${widget.unit}',
                    color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryBrown.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.primaryBrown),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSave(_currentValue);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save'),
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