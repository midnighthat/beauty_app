import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/skin_profile_provider.dart';
import '../../widgets/home/home_widgets.dart';
import '../../widgets/home/budget_wellness_widgets.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Watch only the hasProfile boolean to avoid unnecessary rebuilds
    final hasProfile = ref.watch(hasCompletedQuizProvider.select((completed) => completed));
    
    // If no profile, show quiz prompt
    if (!hasProfile) {
      return QuizPromptWidget(isDark: isDark);
    }

    // Main content for users with profiles
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with cart button
            _HomeHeader(isDark: isDark),
            
            const SizedBox(height: 16),
            
            // Featured skin overview section
            SkinOverviewSection(isDark: isDark),
            
            const SizedBox(height: 24),
            
            // Personalized Skin Routine Section
            SkinRoutineSection(isDark: isDark),
            
            const SizedBox(height: 20),
            
            // Recommended Treatments Section
            RecommendedTreatmentsSection(isDark: isDark),
            
            const SizedBox(height: 24),
            
            // Budget and Wellness Tracking Section
            BudgetAndWellnessSection(isDark: isDark),
            
            const SizedBox(height: 32),
            
            // Add bottom padding for the island tab bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// Simple header widget that only contains cart functionality
class _HomeHeader extends StatelessWidget {
  final bool isDark;
  
  const _HomeHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        CartIconWidget(isDark: isDark),
      ],
    );
  }
}