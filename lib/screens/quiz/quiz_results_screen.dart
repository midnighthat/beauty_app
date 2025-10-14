import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../models/quiz_models.dart';
import '../../providers/skin_profile_provider.dart';
import '../../services/preferences_service.dart';

class QuizResultsScreen extends ConsumerStatefulWidget {
  final SkinProfile skinProfile;

  const QuizResultsScreen({
    super.key,
    required this.skinProfile,
  });

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _profileAnimationController;
  late Animation<double> _profileAnimation;

  @override
  void initState() {
    super.initState();
    
    // Save the skin profile to provider and persistent storage
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(skinProfileProvider.notifier).state = widget.skinProfile;
      await PreferencesService.setSkinProfile(widget.skinProfile);
    });
    
    _tabController = TabController(length: 4, vsync: this);
    
    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _profileAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.easeOutBack,
    ));

    _profileAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _profileAnimationController.dispose();
    super.dispose();
  }

  void _bookConsultation() {
    Navigator.pushNamed(context, '/book-appointment');
  }

  void _shopProducts() {
    Navigator.pushNamed(context, '/marketplace');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: const TitleText('Your Skin Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.primaryBrown),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, 
              '/main', 
              (route) => false,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          AnimatedBuilder(
            animation: _profileAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _profileAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: CustomCard(
                    type: CardType.elevated,
                    size: CardSize.large,
                    backgroundColor: AppColors.primaryBrown.withOpacity(0.05),
                    child: Column(
                      children: [
                        // Skin type badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBrown,
                                AppColors.primaryBrown.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: CustomText(
                            widget.skinProfile.skinType.toUpperCase(),
                            type: TextType.titleLarge,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        const CustomText(
                          'Your Skin Type',
                          type: TextType.bodyMedium,
                          color: AppColors.lightText,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Main concerns
                        if (widget.skinProfile.concerns.isNotEmpty) ...[
                          const CustomText(
                            'Primary Concerns:',
                            type: TextType.labelMedium,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.skinProfile.concerns.map((concern) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrown.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryBrown.withOpacity(0.3),
                                  ),
                                ),
                                child: CustomText(
                                  concern,
                                  type: TextType.bodySmall,
                                  color: AppColors.primaryBrown,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Book Consultation',
                    onPressed: _bookConsultation,
                    icon: const Icon(Icons.calendar_today, color: AppColors.primaryBrown),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Shop Products',
                    onPressed: _shopProducts,
                    icon: const Icon(Icons.shopping_bag, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBrown.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryBrown,
              labelColor: AppColors.primaryBrown,
              unselectedLabelColor: AppColors.lightText,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Morning'),
                Tab(text: 'Night'),
                Tab(text: 'Treatments'),
                Tab(text: 'Tips'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRoutineTab(widget.skinProfile.morningRoutine, 'Morning'),
                  _buildRoutineTab(widget.skinProfile.nightRoutine, 'Night'),
                  _buildTreatmentsTab(),
                  _buildTipsTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineTab(List<RoutineStep> routine, String timeOfDay) {
    return CustomCard(
      type: CardType.basic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubheadingText('$timeOfDay Routine'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: routine.length,
              itemBuilder: (context, index) {
                final step = routine[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step number
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: CustomText(
                            '${step.step}',
                            type: TextType.labelMedium,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Step content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(step.name),
                            const SizedBox(height: 4),
                            BodyText(
                              step.description,
                              color: AppColors.lightText,
                            ),
                            if (step.productExample != null) ...[
                              const SizedBox(height: 4),
                              CustomText(
                                'Example: ${step.productExample}',
                                type: TextType.bodySmall,
                                color: AppColors.primaryBrown,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                            if (step.note != null) ...[
                              const SizedBox(height: 4),
                              CustomText(
                                'Note: ${step.note}',
                                type: TextType.caption,
                                color: AppColors.lightText,
                              ),
                            ],
                          ],
                        ),
                      ),
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

  Widget _buildTreatmentsTab() {
    return CustomCard(
      type: CardType.basic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubheadingText('Recommended Treatments'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.skinProfile.facialTreatments.length,
              itemBuilder: (context, index) {
                final treatment = widget.skinProfile.facialTreatments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryBrown.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TitleText(treatment.name),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBrown,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomText(
                              '\$${treatment.estimatedPrice.toInt()}',
                              type: TextType.bodySmall,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BodyText(treatment.description),
                      const SizedBox(height: 8),
                      CustomText(
                        'Frequency: ${treatment.frequency}',
                        type: TextType.bodySmall,
                        color: AppColors.primaryBrown,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: treatment.benefits.map((benefit) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primaryBrown.withOpacity(0.3),
                              ),
                            ),
                            child: CustomText(
                              benefit,
                              type: TextType.caption,
                              color: AppColors.darkText,
                            ),
                          );
                        }).toList(),
                      ),
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

  Widget _buildTipsTab() {
    return CustomCard(
      type: CardType.basic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubheadingText('Do\'s and Don\'ts'),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Do's section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.check, color: Colors.green),
                      ),
                      const SizedBox(width: 12),
                      const TitleText('DO\'S'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.skinProfile.doAndDont.dos.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: BodyText(tip)),
                        ],
                      ),
                    );
                  }).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // Don'ts section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                      const SizedBox(width: 12),
                      const TitleText('DON\'TS'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.skinProfile.doAndDont.donts.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.cancel_outlined,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: BodyText(tip)),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}