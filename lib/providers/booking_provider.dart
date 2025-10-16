import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_models.dart';
import '../services/product_service.dart';

// Booking state class
class BookingState {
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? selectedConsultant;
  final String appointmentFor;
  final KBeautyTreatment? selectedTreatment;
  final List<KBeautyProduct> recommendedProducts;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.selectedDate,
    this.selectedTime,
    this.selectedConsultant,
    this.appointmentFor = 'Myself',
    this.selectedTreatment,
    this.recommendedProducts = const [],
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    String? selectedConsultant,
    String? appointmentFor,
    KBeautyTreatment? selectedTreatment,
    List<KBeautyProduct>? recommendedProducts,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedConsultant: selectedConsultant ?? this.selectedConsultant,
      appointmentFor: appointmentFor ?? this.appointmentFor,
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isReadyForBooking =>
      selectedDate != null &&
      selectedTime != null &&
      selectedConsultant != null &&
      selectedTreatment != null;

  double get totalPrice {
    final treatmentPrice = selectedTreatment?.price ?? 0;
    return treatmentPrice.toDouble();
  }

  String get formattedDate {
    if (selectedDate == null) return '';
    final date = selectedDate!;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

// Booking state notifier
class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState());

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTime(String time) {
    state = state.copyWith(selectedTime: time);
  }

  void setConsultant(String consultant) {
    state = state.copyWith(selectedConsultant: consultant);
  }

  void setAppointmentFor(String appointmentFor) {
    state = state.copyWith(appointmentFor: appointmentFor);
  }

  Future<void> selectTreatment(KBeautyTreatment treatment) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Load recommended products for this treatment
      final products = await ProductService.getProductsForTreatment(treatment.id);
      final kbeautyProducts = products.map((p) => KBeautyProduct.fromJson(p)).toList();
      
      state = state.copyWith(
        selectedTreatment: treatment,
        recommendedProducts: kbeautyProducts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearTreatment() {
    state = state.copyWith(
      selectedTreatment: null,
      recommendedProducts: [],
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const BookingState();
  }
}

// Consultant data class
class Consultant {
  final String id;
  final String name;
  final double rating;
  final String imagePath;
  final List<String> specializations;
  final String bio;
  final int experienceYears;

  const Consultant({
    required this.id,
    required this.name,
    required this.rating,
    required this.imagePath,
    required this.specializations,
    required this.bio,
    required this.experienceYears,
  });
}

// Providers
final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

// Available treatments provider
final availableTreatmentsProvider = FutureProvider<List<KBeautyTreatment>>((ref) async {
  print('=== Loading treatments from JSON ===');
  
  try {
    final treatmentsStream = ProductService.getTreatments();
    final treatmentMaps = await treatmentsStream.first;
    print('Got ${treatmentMaps.length} treatment maps from ProductService');
    
    final treatments = treatmentMaps
        .map((map) => KBeautyTreatment.fromJson(map))
        .toList();
    
    print('Successfully parsed ${treatments.length} treatments');
    return treatments;
  } catch (e) {
    print('Error loading treatments: $e');
    rethrow; // Let the UI handle the error
  }
});


// Available consultants provider
final availableConsultantsProvider = Provider<List<Consultant>>((ref) {
  return [
    const Consultant(
      id: 'elly',
      name: 'Elly',
      rating: 4.5,
      imagePath: 'assets/images/profile-image-1.jpg',
      specializations: ['Acne Treatment', 'Anti-Aging', 'Sensitive Skin'],
      bio: 'Licensed esthetician with 5+ years of experience in K-beauty treatments.',
      experienceYears: 5,
    ),
    const Consultant(
      id: 'clara',
      name: 'Clara',
      rating: 4.2,
      imagePath: 'assets/images/profile-image-2.jpg',
      specializations: ['Hydrating Facials', 'Brightening', 'Dry Skin'],
      bio: 'Specializes in hydrating treatments and glass skin techniques.',
      experienceYears: 3,
    ),
    const Consultant(
      id: 'sofia',
      name: 'Sofia',
      rating: 4.8,
      imagePath: 'assets/images/profile-image-3.jpg',
      specializations: ['Advanced Peels', 'Hyperpigmentation', 'Combination Skin'],
      bio: 'Master esthetician with expertise in advanced Korean skincare treatments.',
      experienceYears: 8,
    ),
  ];
});

// Available time slots provider
final availableTimeSlotsProvider = Provider<List<String>>((ref) {
  return [
    '11:00 AM', '11:30 AM', '01:00 PM', '01:30 PM',
    '02:00 PM', '03:00 PM', '04:00 PM', 
    '05:00 PM', '06:00 PM', '07:00 PM',
    '08:00 PM'
  ];
});

// Recommended treatment provider based on user's skin profile
final recommendedTreatmentProvider = FutureProvider<KBeautyTreatment?>((ref) async {
  try {
    // Get user's skin profile to recommend appropriate treatment
    // For now, return a default recommendation
    final treatmentsStream = ProductService.getTreatments();
    final treatments = await treatmentsStream.first;
    
    if (treatments.isNotEmpty) {
      // Return first treatment as default recommendation
      return KBeautyTreatment.fromJson(treatments.first);
    }
    return null;
  } catch (e) {
    return null;
  }
});