import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';

class SkinDiscoveryScreen extends ConsumerStatefulWidget {
  const SkinDiscoveryScreen({super.key});

  @override
  ConsumerState<SkinDiscoveryScreen> createState() => _SkinDiscoveryScreenState();
}

class _SkinDiscoveryScreenState extends ConsumerState<SkinDiscoveryScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _sphereController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _sphereAnimation;

  @override
  void initState() {
    super.initState();
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _sphereController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _sphereAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _sphereController,
      curve: Curves.easeInOut,
    ));

    _floatingController.repeat(reverse: true);
    _sphereController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _sphereController.dispose();
    super.dispose();
  }

  void _startSkinAssessment() {
    Navigator.pushNamed(context, '/quiz');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Background animated spheres
            ...List.generate(6, (index) => _buildAnimatedSphere(size, index)),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Header text
                  Column(
                    children: [
                      const DisplayText(
                        'Begin Your',
                        textAlign: TextAlign.center,
                        isLarge: true,
                      ),
                      
                      CustomText(
                        'Skincare Journey',
                        type: TextType.displayLarge,
                        color: AppColors.primaryPink,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      const BodyText(
                        'Discover your skin type easily',
                        textAlign: TextAlign.center,
                        color: AppColors.lightText,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Floating product container
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: _buildProductDisplay(size),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // CTA Button
                  PrimaryButton(
                    text: 'Find Your Skin\'s Perfect Fit',
                    onPressed: _startSkinAssessment,
                    width: double.infinity,
                    size: ButtonSize.large,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDisplay(Size size) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Product bottle
            Container(
              width: 120,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Pump/dispenser
                  Container(
                    width: 40,
                    height: 50,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.lightText.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 25,
                          height: 20,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.lightText.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Product content (gradient representing the liquid)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryPink.withOpacity(0.8),
                            AppColors.primaryPink.withOpacity(0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  // Label area
                  Container(
                    height: 80,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.lightText.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          'BODY OIL',
                          type: TextType.caption,
                          fontSize: 8,
                        ),
                        const SizedBox(height: 4),
                        const CustomText(
                          'Skin Care',
                          type: TextType.labelMedium,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        const CustomText(
                          'Beauty',
                          type: TextType.labelMedium,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSphere(Size size, int index) {
    final positions = [
      {'top': 120.0, 'left': 50.0, 'size': 60.0},
      {'top': 200.0, 'right': 40.0, 'size': 40.0},
      {'top': 300.0, 'left': 30.0, 'size': 35.0},
      {'top': 450.0, 'right': 60.0, 'size': 50.0},
      {'top': 520.0, 'left': 80.0, 'size': 25.0},
      {'top': 600.0, 'right': 30.0, 'size': 30.0},
    ];

    if (index >= positions.length) return const SizedBox.shrink();

    final position = positions[index];
    final sphereSize = position['size'] as double;

    return AnimatedBuilder(
      animation: _sphereAnimation,
      builder: (context, child) {
        final animationOffset = (index % 2 == 0 ? 1 : -1) * 
            _sphereAnimation.value * 20;
        
        return Positioned(
          top: (position['top'] as double) + animationOffset,
          left: position['left'] as double?,
          right: position['right'] as double?,
          child: Container(
            width: sphereSize,
            height: sphereSize,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryPink.withOpacity(0.6),
                  AppColors.primaryPink.withOpacity(0.2),
                  AppColors.primaryPink.withOpacity(0.1),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPink.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}