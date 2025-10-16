import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../models/product_models.dart';
import '../../providers/booking_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/skin_profile_provider.dart';
import '../../providers/home_providers.dart';

// Treatment selection drawer
class TreatmentSelectionDrawer extends ConsumerStatefulWidget {
  final VoidCallback onTreatmentSelected;

  const TreatmentSelectionDrawer({
    super.key,
    required this.onTreatmentSelected,
  });

  @override
  ConsumerState<TreatmentSelectionDrawer> createState() => _TreatmentSelectionDrawerState();
}

class _TreatmentSelectionDrawerState extends ConsumerState<TreatmentSelectionDrawer> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final treatmentsAsync = ref.watch(availableTreatmentsProvider);
    final bookingState = ref.watch(bookingProvider);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Drawer handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightText.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Expanded(
                  child: DisplayText(
                    'Select Treatment',
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.lightText),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: treatmentsAsync.when(
              data: (treatments) {
                print('Treatments loaded: ${treatments.length}');
                if (treatments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.lightText, size: 48),
                        const SizedBox(height: 16),
                        const BodyText('No treatments available'),
                        const SizedBox(height: 8),
                        const BodyText('Please check your data source'),
                      ],
                    ),
                  );
                }
                return _buildTreatmentsListWithRecommendations(treatments, isDark);
              },
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBrown),
                    SizedBox(height: 16),
                    BodyText('Loading treatments...'),
                  ],
                ),
              ),
              error: (error, stack) {
                print('Treatments loading error: $error');
                print('Stack trace: $stack');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.lightText, size: 48),
                      const SizedBox(height: 16),
                      BodyText('Failed to load treatments'),
                      const SizedBox(height: 8),
                      BodyText('Error: $error', maxLines: 3),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsListWithRecommendations(List<KBeautyTreatment> allTreatments, bool isDark) {
    final skinProfile = ref.watch(skinProfileProvider);
    final recommendedTreatmentsAsync = ref.watch(recommendedTreatmentsProvider(skinProfile));
    
    return recommendedTreatmentsAsync.when(
      data: (recommendedTreatmentsData) {
        try {
          // Convert Map data to KBeautyTreatment objects for recommended treatments
          final recommendedTreatments = recommendedTreatmentsData
              .map((data) => allTreatments.firstWhere(
                  (treatment) => treatment.id.toString() == data['id'].toString(),
                  orElse: () => allTreatments.first,
                ))
              .toList();
          
          // Get other treatments (not recommended) - limit for performance
          final recommendedIds = recommendedTreatments.map((t) => t.id).toSet();
          final otherTreatments = allTreatments
              .where((treatment) => !recommendedIds.contains(treatment.id))
              .take(10) // Limit to 10 other treatments for better performance
              .toList();
        
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recommended treatments section
                if (recommendedTreatments.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const HeadingText(
                        'Recommended for You',
                        color: AppColors.primaryBrown,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const BodyText(
                    'Based on your skin type and concerns',
                    color: AppColors.lightText,
                  ),
                  const SizedBox(height: 16),
                  ...recommendedTreatments.map((treatment) => TreatmentCard(
                    treatment: treatment,
                    onTap: () => _selectTreatment(treatment),
                    isSelected: false,
                    isRecommended: true,
                  )),
                  const SizedBox(height: 24),
                ],
                
                // All treatments section
                Row(
                  children: [
                    const HeadingText(
                      'All Treatments',
                      color: AppColors.lightText,
                    ),
                    const Spacer(),
                    CaptionText(
                      '${otherTreatments.length} treatments',
                      color: AppColors.lightText,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...otherTreatments.map((treatment) => TreatmentCard(
                  treatment: treatment,
                  onTap: () => _selectTreatment(treatment),
                  isSelected: false,
                  isRecommended: false,
                )),
              ],
            ),
          );
        } catch (e) {
          print('Error building treatments list: $e');
          return _buildTreatmentsList(allTreatments, isDark);
        }
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primaryBrown),
            SizedBox(height: 16),
            BodyText('Finding your perfect treatments...'),
          ],
        ),
      ),
      error: (error, stack) {
        print('Error loading recommended treatments: $error');
        return _buildTreatmentsList(allTreatments, isDark);
      },
    );
  }

  Widget _buildTreatmentsList(List<KBeautyTreatment> treatments, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: treatments.length,
      itemBuilder: (context, index) {
        final treatment = treatments[index];
        return TreatmentCard(
          treatment: treatment,
          onTap: () => _selectTreatment(treatment),
          isSelected: false,
          isRecommended: false,
        );
      },
    );
  }

  void _selectTreatment(KBeautyTreatment treatment) async {
    await ref.read(bookingProvider.notifier).selectTreatment(treatment);
    Navigator.pop(context);
    widget.onTreatmentSelected();
  }
}

// Treatment card widget
class TreatmentCard extends ConsumerWidget {
  final KBeautyTreatment treatment;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isRecommended;

  const TreatmentCard({
    super.key,
    required this.treatment,
    required this.onTap,
    required this.isSelected,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = ref.watch(currencyProvider);
    final convertedPrice = CurrencyUtils.convertPrice(treatment.price.toDouble(), currency);
    final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primaryBrown.withOpacity(0.1)
                : isRecommended
                    ? AppColors.primaryBrown.withOpacity(0.05)
                    : (isDark ? AppColors.darkBackground : AppColors.creamBackground.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primaryBrown
                  : isRecommended
                      ? AppColors.primaryBrown.withOpacity(0.3)
                      : AppColors.lightText.withOpacity(0.2),
              width: isSelected ? 2 : (isRecommended ? 1.5 : 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with price and duration
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recommended badge
                        if (isRecommended) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'RECOMMENDED',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        TitleText(
                          treatment.name,
                          color: isDark ? AppColors.creamBackground : AppColors.darkText,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CaptionText(
                      formattedPrice,
                      color: AppColors.primaryBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Duration and skin concern
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.lightText,
                  ),
                  const SizedBox(width: 4),
                  CaptionText(
                    treatment.duration,
                    color: AppColors.lightText,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.healing,
                    size: 16,
                    color: AppColors.lightText,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: CaptionText(
                      treatment.skinConcern,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // What it is
              BodyText(
                treatment.whatItIs,
                color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
                maxLines: 2,
              ),
              
              const SizedBox(height: 8),
              
              // Why it works
              BodyText(
                'Why it works: ${treatment.whyItWorks}',
                color: AppColors.lightText,
                maxLines: 2,
              ),
              
              const SizedBox(height: 12),
              
              // Skin types
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CaptionText(
                    'Recommended for:',
                    color: AppColors.lightText,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 6,
                      children: treatment.skinTypes.map((skinType) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primaryBrown.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: CaptionText(
                            skinType,
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList(),
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
}

// Booking confirmation drawer
class BookingConfirmationDrawer extends ConsumerStatefulWidget {
  const BookingConfirmationDrawer({super.key});

  @override
  ConsumerState<BookingConfirmationDrawer> createState() => _BookingConfirmationDrawerState();
}

class _BookingConfirmationDrawerState extends ConsumerState<BookingConfirmationDrawer> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookingState = ref.watch(bookingProvider);
    final currency = ref.watch(currencyProvider);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Drawer handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightText.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppColors.lightText),
                ),
                const Expanded(
                  child: DisplayText(
                    'Booking Details',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Treatment details
                  if (bookingState.selectedTreatment != null)
                    _buildTreatmentDetails(bookingState.selectedTreatment!, isDark, currency),
                  
                  const SizedBox(height: 24),
                  
                  // Booking details
                  _buildBookingDetails(bookingState, isDark),
                  
                  const SizedBox(height: 24),
                  
                  // Recommended products
                  if (bookingState.recommendedProducts.isNotEmpty)
                    _buildRecommendedProducts(bookingState.recommendedProducts, isDark, currency),
                  
                  const SizedBox(height: 32),
                  
                  // Total and book button
                  _buildBookingFooter(bookingState, currency),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentDetails(KBeautyTreatment treatment, bool isDark, String currency) {
    final convertedPrice = CurrencyUtils.convertPrice(treatment.price.toDouble(), currency);
    final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBrown.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TitleText(
                  treatment.name,
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),
              ),
              HeadingText(
                formattedPrice,
                color: AppColors.primaryBrown,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          BodyText(
            treatment.whatItIs,
            color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.lightText),
              const SizedBox(width: 4),
              CaptionText(treatment.duration, color: AppColors.lightText),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              CaptionText(treatment.bestFor, color: AppColors.lightText),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(BookingState bookingState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.creamBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingText(
            'Appointment Details',
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
          
          const SizedBox(height: 16),
          
          _buildDetailRow('Date', bookingState.formattedDate, isDark),
          _buildDetailRow('Time', bookingState.selectedTime ?? '', isDark),
          _buildDetailRow('Consultant', bookingState.selectedConsultant ?? '', isDark),
          _buildDetailRow('For', bookingState.appointmentFor, isDark),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: BodyText(
              label,
              color: AppColors.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: BodyText(
              value,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts(List<KBeautyProduct> products, bool isDark, String currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText(
          'Recommended Products',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        
        const SizedBox(height: 8),
        
        BodyText(
          'Products that complement your treatment',
          color: AppColors.lightText,
        ),
        
        const SizedBox(height: 16),
        
        ...products.take(3).map((product) {
          final convertedPrice = CurrencyUtils.convertPrice(product.price, currency);
          final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightText.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryBrown.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(
                        product.name,
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      CaptionText(
                        formattedPrice,
                        color: AppColors.primaryBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBookingFooter(BookingState bookingState, String currency) {
    final convertedPrice = CurrencyUtils.convertPrice(bookingState.totalPrice, currency);
    final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryBrown.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: HeadingText(
                  'Total',
                  color: AppColors.primaryBrown,
                ),
              ),
              DisplayText(
                formattedPrice,
                color: AppColors.primaryBrown,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        PrimaryButton(
          text: 'Confirm Booking',
          onPressed: bookingState.isReadyForBooking ? _confirmBooking : null,
          width: double.infinity,
          size: ButtonSize.large,
        ),
        
      ],
    );
  }

  void _confirmBooking() {
    final bookingState = ref.read(bookingProvider);
    
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookingSuccessDialog(bookingState: bookingState),
    );
  }
}

// Booking success dialog
class BookingSuccessDialog extends ConsumerWidget {
  final BookingState bookingState;

  const BookingSuccessDialog({
    super.key,
    required this.bookingState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 24),
          
          TitleText(
            'Booking Confirmed!',
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          BodyText(
            'Your appointment has been successfully booked. You will receive a confirmation email shortly.',
            color: AppColors.lightText,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppColors.primaryBrown),
                    const SizedBox(width: 8),
                    CaptionText(
                      '${bookingState.formattedDate} at ${bookingState.selectedTime}',
                      color: AppColors.primaryBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: AppColors.primaryBrown),
                    const SizedBox(width: 8),
                    CaptionText(
                      'with ${bookingState.selectedConsultant}',
                      color: AppColors.primaryBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Done',
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close drawer
                // Clear the booking state for next booking
                ref.read(bookingProvider.notifier).reset();
              },
              size: ButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }
}