import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/booking_provider.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/booking/booking_widgets.dart';

class BookingTab extends ConsumerStatefulWidget {
  const BookingTab({super.key});

  @override
  ConsumerState<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends ConsumerState<BookingTab> {
  @override
  void initState() {
    super.initState();
    // Initialize booking state with current date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).setDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookingState = ref.watch(bookingProvider);
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: Column(
        children: [
          // Custom header with rounded bottom corners
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: AppColors.primaryBrown,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const TitleText(
              'Book Treatment',
              color: AppColors.white,
              textAlign: TextAlign.center,
            ),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected Treatment Display (if any)
                  if (bookingState.selectedTreatment != null)
                    _buildSelectedTreatmentSection(bookingState, isDark),
                  
                  if (bookingState.selectedTreatment != null)
                    const SizedBox(height: 30),
                  
                  // Calendar Section
                  _buildCalendarSection(bookingState),
                  
                  const SizedBox(height: 30),
                  
                  // Service Selection
                  _buildServiceSection(bookingState),
                  
                  const SizedBox(height: 30),
                  
                  // Available Times
                  _buildTimeSection(bookingState),
                  
                  const SizedBox(height: 30),
                  
                  // Appointment For
                  _buildAppointmentForSection(bookingState, isDark),
                  
                  const SizedBox(height: 40),
                  
                  // Book Now Button
                  _buildBookButton(bookingState),
                  
                  // Add bottom padding for the island tab bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTreatmentSection(BookingState bookingState, bool isDark) {
    final treatment = bookingState.selectedTreatment!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBrown.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBrown.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryBrown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.spa,
              color: AppColors.primaryBrown,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  treatment.name,
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.lightText),
                    const SizedBox(width: 4),
                    CaptionText(
                      treatment.duration,
                      color: AppColors.lightText,
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.attach_money, size: 14, color: AppColors.primaryBrown),
                    const SizedBox(width: 4),
                    Consumer(
                      builder: (context, ref, child) {
                        final currency = ref.watch(currencyProvider);
                        final price = treatment.price.toDouble();
                        final convertedPrice = CurrencyUtils.convertPrice(price, currency);
                        return CaptionText(
                          CurrencyUtils.formatPrice(convertedPrice, currency),
                          color: AppColors.primaryBrown,
                          fontWeight: FontWeight.w600,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          IconButton(
            onPressed: () {
              ref.read(bookingProvider.notifier).clearTreatment();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.lightText,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(BookingState bookingState) {
    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.primaryBrown),
              onPressed: () {
                final newDate = DateTime(bookingState.selectedDate?.year ?? DateTime.now().year, 
                                        (bookingState.selectedDate?.month ?? DateTime.now().month) - 1);
                ref.read(bookingProvider.notifier).setDate(newDate);
              },
            ),
            TitleText(
              _getMonthName((bookingState.selectedDate ?? DateTime.now()).month),
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.creamBackground 
                  : AppColors.darkText,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.primaryBrown),
              onPressed: () {
                final newDate = DateTime(bookingState.selectedDate?.year ?? DateTime.now().year, 
                                        (bookingState.selectedDate?.month ?? DateTime.now().month) + 1);
                ref.read(bookingProvider.notifier).setDate(newDate);
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Calendar grid
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookingState = ref.watch(bookingProvider);
    final today = DateTime.now();
    final selectedDate = bookingState.selectedDate ?? today;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 42, // 6 weeks
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == selectedDate.month;
        final isSelected = date.day == selectedDate.day && 
                          date.month == selectedDate.month && 
                          date.year == selectedDate.year;
        final isToday = date.day == today.day && 
                       date.month == today.month && 
                       date.year == today.year;
        
        return GestureDetector(
          onTap: isCurrentMonth ? () {
            ref.read(bookingProvider.notifier).setDate(date);
          } : null,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  '${date.day}',
                  type: TextType.bodyMedium,
                  color: isCurrentMonth 
                      ? (isDark ? AppColors.creamBackground : AppColors.darkText)
                      : AppColors.lightText.withOpacity(0.3),
                  fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
                ),
                const SizedBox(height: 2),
                // Selected date indicator
                if (isSelected)
                  Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceSection(BookingState bookingState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(
              'Skincare Consultants',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            GestureDetector(
              onTap: () {},
              child: const CustomText(
                'See All',
                type: TextType.bodyMedium,
                color: AppColors.primaryBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Stylists
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ref.watch(availableConsultantsProvider).map((consultant) {
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                child: _buildStylistCard(
                  consultant.name, 
                  consultant.rating.toString(), 
                  consultant.imagePath, 
                  bookingState.selectedConsultant == consultant.name,
                  consultant,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStylistCard(String name, String rating, String imagePath, bool isSelected, Consultant consultant) {
    return GestureDetector(
      onTap: () {
        ref.read(bookingProvider.notifier).setConsultant(name);
        _showConsultantDetails(consultant);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryBrown.withOpacity(0.1) 
              : Colors.transparent,
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryBrown 
                : AppColors.lightText.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Profile photo
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryBrown : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBrown.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primaryBrown,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Name
            TitleText(
              name,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.creamBackground 
                  : AppColors.darkText,
            ),
            
            const SizedBox(height: 4),
            
            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  rating,
                  type: TextType.bodySmall,
                  color: AppColors.lightText,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(BookingState bookingState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeSlots = ref.watch(availableTimeSlotsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          'Available Time',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: timeSlots.map((time) {
            final isSelected = bookingState.selectedTime == time;
            return GestureDetector(
              onTap: () {
                ref.read(bookingProvider.notifier).setTime(time);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primaryBrown 
                      : AppColors.primaryBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  time,
                  type: TextType.bodySmall,
                  color: isSelected ? AppColors.white : AppColors.primaryBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppointmentForSection(BookingState bookingState, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          'Appointment For',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        
        const SizedBox(height: 16),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryBrown.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: bookingState.appointmentFor,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBrown),
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.white,
              items: ['Myself', 'Family Member', 'Friend'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: CustomText(
                    value,
                    type: TextType.bodyMedium,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(bookingProvider.notifier).setAppointmentFor(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton(BookingState bookingState) {
    return Column(
      children: [
        // Select Treatment button if no treatment selected
        if (bookingState.selectedTreatment == null)
          PrimaryButton(
            text: 'Select Treatment',
            onPressed: _showTreatmentSelection,
            width: double.infinity,
            size: ButtonSize.large,
            icon: const Icon(Icons.spa, color: AppColors.white, size: 18),
          ),
        
        // Continue to booking button if treatment selected
        if (bookingState.selectedTreatment != null)
          PrimaryButton(
            text: bookingState.selectedDate != null && 
                  bookingState.selectedTime != null && 
                  bookingState.selectedConsultant != null
                ? 'Review Booking'
                : 'Complete Booking Details',
            onPressed: bookingState.selectedDate != null && 
                      bookingState.selectedTime != null && 
                      bookingState.selectedConsultant != null
                ? _showBookingConfirmation
                : null,
            width: double.infinity,
            size: ButtonSize.large,
          ),
      ],
    );
  }

  void _showTreatmentSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TreatmentSelectionDrawer(
        onTreatmentSelected: () {
          // Treatment has been selected, no additional action needed
        },
      ),
    );
  }

  void _showBookingConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const BookingConfirmationDrawer(),
    );
  }

  void _showConsultantDetails(Consultant consultant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Modal handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Consultant profile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryBrown.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryBrown,
                        width: 3,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        consultant.imagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBrown.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primaryBrown,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(
                          consultant.name,
                          color: isDark ? AppColors.creamBackground : AppColors.darkText,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 6),
                            CaptionText(
                              consultant.rating.toString(),
                              color: AppColors.primaryBrown,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CaptionText(
                                '${consultant.experienceYears} years experience',
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Bio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(
                  'About',
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),
                const SizedBox(height: 8),
                BodyText(
                  consultant.bio,
                  color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Specializations
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(
                  'Specializations',
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: consultant.specializations.map((spec) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryBrown.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: CaptionText(
                          spec,
                          color: AppColors.primaryBrown,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Select button
            PrimaryButton(
              text: 'Select ${consultant.name}',
              onPressed: () {
                ref.read(bookingProvider.notifier).setConsultant(consultant.name);
                Navigator.pop(context);
              },
              width: double.infinity,
              size: ButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}