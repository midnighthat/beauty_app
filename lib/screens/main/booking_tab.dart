import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';

class BookingTab extends ConsumerStatefulWidget {
  const BookingTab({super.key});

  @override
  ConsumerState<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends ConsumerState<BookingTab> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  String selectedStylist = '';
  String appointmentFor = 'Myself';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: Column(
        children: [
          // Custom header with rounded bottom corners
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: AppColors.primaryPink,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TitleText(
                    'Set Appointment',
                    color: AppColors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar Section
                  _buildCalendarSection(),
                  
                  const SizedBox(height: 30),
                  
                  // Service Selection
                  _buildServiceSection(),
                  
                  const SizedBox(height: 30),
                  
                  // Available Times
                  _buildTimeSection(),
                  
                  const SizedBox(height: 30),
                  
                  // Appointment For
                  _buildAppointmentForSection(isDark),
                  
                  const SizedBox(height: 40),
                  
                  // Book Now Button
                  _buildBookButton(),
                  
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

  Widget _buildCalendarSection() {
    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.primaryPink),
              onPressed: () {
                setState(() {
                  selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
                });
              },
            ),
            TitleText(
              _getMonthName(selectedDate.month),
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.creamBackground 
                  : AppColors.darkText,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.primaryPink),
              onPressed: () {
                setState(() {
                  selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
                });
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
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
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
            setState(() {
              selectedDate = date;
            });
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
                      color: AppColors.primaryPink,
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

  Widget _buildServiceSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(
              'Hair Stylish',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            GestureDetector(
              onTap: () {},
              child: const CustomText(
                'See All',
                type: TextType.bodyMedium,
                color: AppColors.primaryPink,
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
            children: [
              SizedBox(
                width: 140,
                child: _buildStylistCard('Elly', '4.5', 'assets/images/profile-image-1.jpg', selectedStylist == 'Elly'),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildStylistCard('Clara', '4.2', 'assets/images/profile-image-2.jpg', selectedStylist == 'Clara'),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: _buildStylistCard('Sofia', '4.8', 'assets/images/profile-image-3.jpg', selectedStylist == 'Sofia'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStylistCard(String name, String rating, String imagePath, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStylist = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryPink.withOpacity(0.1) 
              : Colors.transparent,
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryPink 
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
                  color: isSelected ? AppColors.primaryPink : Colors.transparent,
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
                        color: AppColors.primaryPink.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primaryPink,
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

  Widget _buildTimeSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeSlots = [
      '11:00 AM', '11:30 AM', '01:00 PM', '01:30 PM',
      '02:00 PM', '03:00 PM', '04:00 PM', 
      '05:00 PM', '06:00 PM', '07:00 PM',
      '08:00 PM'
    ];
    
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
            final isSelected = selectedTime == time;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTime = time;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primaryPink 
                      : AppColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  time,
                  type: TextType.bodySmall,
                  color: isSelected ? AppColors.white : AppColors.primaryPink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppointmentForSection(bool isDark) {
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
            color: AppColors.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: appointmentFor,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryPink),
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
                  setState(() {
                    appointmentFor = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return PrimaryButton(
      text: 'Book Now',
      onPressed: () {
        // TODO: Handle booking
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: AppColors.primaryPink,
          ),
        );
      },
      width: double.infinity,
      size: ButtonSize.large,
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