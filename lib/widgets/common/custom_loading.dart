import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import 'custom_text.dart';

enum LoadingType { circular, linear, dots, pulse, shimmer }
enum LoadingSize { small, medium, large }

class CustomLoading extends StatefulWidget {
  final LoadingType type;
  final LoadingSize size;
  final Color? color;
  final String? message;
  final bool showMessage;

  const CustomLoading({
    super.key,
    this.type = LoadingType.circular,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.showMessage = false,
  });

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loadingColor = widget.color ?? AppColors.primaryBrown;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoadingWidget(loadingColor, isDark),
        if (widget.showMessage && widget.message != null) ...[
          const SizedBox(height: 16),
          CustomText(
            widget.message!,
            type: TextType.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingWidget(Color color, bool isDark) {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularLoading(color);
      case LoadingType.linear:
        return _buildLinearLoading(color);
      case LoadingType.dots:
        return _buildDotsLoading(color);
      case LoadingType.pulse:
        return _buildPulseLoading(color);
      case LoadingType.shimmer:
        return _buildShimmerLoading(isDark);
    }
  }

  Widget _buildCircularLoading(Color color) {
    final size = _getSize();
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: _getStrokeWidth(),
      ),
    );
  }

  Widget _buildLinearLoading(Color color) {
    return SizedBox(
      width: _getSize() * 2,
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withOpacity(0.2),
      ),
    );
  }

  Widget _buildDotsLoading(Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * (1 - (animationValue - 0.5).abs() * 2));
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: _getDotSize(),
                  height: _getDotSize(),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPulseLoading(Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: _getSize(),
            height: _getSize(),
            decoration: BoxDecoration(
              color: color.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading(bool isDark) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _getSize() * 2,
          height: _getSize(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _animation.value, 0.0),
              end: Alignment(1.0 - _animation.value, 0.0),
              colors: isDark
                  ? [
                      AppColors.darkSurface,
                      AppColors.creamBackground.withOpacity(0.1),
                      AppColors.darkSurface,
                    ]
                  : [
                      AppColors.creamBackground,
                      AppColors.white,
                      AppColors.creamBackground,
                    ],
            ),
          ),
        );
      },
    );
  }

  double _getSize() {
    switch (widget.size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 32;
      case LoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (widget.size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  double _getDotSize() {
    switch (widget.size) {
      case LoadingSize.small:
        return 6;
      case LoadingSize.medium:
        return 8;
      case LoadingSize.large:
        return 12;
    }
  }
}

// Specific loading components for common use cases
class LoadingScreen extends StatelessWidget {
  final String? message;
  final LoadingType type;

  const LoadingScreen({
    super.key,
    this.message,
    this.type = LoadingType.circular,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: CustomLoading(
          type: type,
          size: LoadingSize.large,
          message: message ?? 'Loading...',
          showMessage: true,
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final LoadingSize size;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.size = LoadingSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? CustomLoading(
              type: LoadingType.circular,
              size: LoadingSize.small,
              color: AppColors.white,
            )
          : CustomText(
              text,
              type: TextType.labelLarge,
              color: AppColors.white,
            ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  final LoadingType loadingType;

  const LoadingOverlay({
    super.key,
    required this.child,
    this.isLoading = false,
    this.loadingMessage,
    this.loadingType = LoadingType.circular,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomLoading(
                  type: loadingType,
                  size: LoadingSize.medium,
                  message: loadingMessage,
                  showMessage: loadingMessage != null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 100,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: CustomLoading(
        type: LoadingType.shimmer,
        size: LoadingSize.medium,
      ),
    );
  }
}