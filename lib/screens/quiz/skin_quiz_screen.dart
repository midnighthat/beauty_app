import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../services/quiz_data.dart';
import '../../providers/skin_profile_provider.dart';

class SkinQuizScreen extends ConsumerStatefulWidget {
  const SkinQuizScreen({super.key});

  @override
  ConsumerState<SkinQuizScreen> createState() => _SkinQuizScreenState();
}

class _SkinQuizScreenState extends ConsumerState<SkinQuizScreen>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  List<int> _answers = [];
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  int? _selectedOption;

  @override
  void initState() {
    super.initState();
    _answers = List.filled(QuizData.questions.length, -1);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _selectedOption = optionIndex;
      _answers[_currentQuestionIndex] = optionIndex;
    });
  }

  void _nextQuestion() async {
    if (_selectedOption == null) return;

    if (_currentQuestionIndex < QuizData.questions.length - 1) {
      // Slide out current question
      await _slideController.reverse();
      
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = _answers[_currentQuestionIndex] != -1 
            ? _answers[_currentQuestionIndex] 
            : null;
      });
      
      // Slide in next question
      await _slideController.forward();
    } else {
      // Quiz completed, calculate results
      _completeQuiz();
    }
  }

  void _previousQuestion() async {
    if (_currentQuestionIndex > 0) {
      // Slide out current question
      await _slideController.reverse();
      
      setState(() {
        _currentQuestionIndex--;
        _selectedOption = _answers[_currentQuestionIndex] != -1 
            ? _answers[_currentQuestionIndex] 
            : null;
      });
      
      // Slide in previous question
      await _slideController.forward();
    }
  }

  void _completeQuiz() {
    final skinProfile = QuizData.calculateProfile(_answers);
    
    // Save the skin profile to provider
    ref.read(skinProfileProvider.notifier).state = skinProfile;
    
    // Navigate directly to main screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
    );
  }

  double get _progress {
    return (_currentQuestionIndex + 1) / QuizData.questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = QuizData.questions[_currentQuestionIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
        elevation: 0,
        leading: _currentQuestionIndex > 0 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryPink),
                onPressed: _previousQuestion,
              )
            : null,
        title: TitleText(
          'Skin Assessment',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CaptionText('Question ${_currentQuestionIndex + 1} of ${QuizData.questions.length}'),
                      CaptionText('${(_progress * 100).round()}%'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: AppColors.primaryPink.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
                    minHeight: 6,
                  ),
                ],
              ),
            ),

            // Question content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Question card
                      Expanded(
                        child: CustomCard(
                          type: CardType.elevated,
                          size: CardSize.large,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              
                              // Question number badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPink.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomText(
                                  'Q${_currentQuestionIndex + 1}',
                                  type: TextType.labelMedium,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Question text
                              HeadingText(
                                currentQuestion.question,
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Options
                              Expanded(
                                child: ListView.builder(
                                  itemCount: currentQuestion.options.length,
                                  itemBuilder: (context, index) {
                                    final option = currentQuestion.options[index];
                                    final isSelected = _selectedOption == index;
                                    
                                    return GestureDetector(
                                      onTap: () => _selectOption(index),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryPink.withOpacity(0.1)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primaryPink
                                                : (isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText.withOpacity(0.3)),
                                            width: isSelected ? 2 : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? AppColors.primaryPink
                                                      : (isDark ? AppColors.creamBackground.withOpacity(0.5) : AppColors.lightText.withOpacity(0.5)),
                                                  width: 2,
                                                ),
                                                color: isSelected
                                                    ? AppColors.primaryPink
                                                    : Colors.transparent,
                                              ),
                                              child: isSelected
                                                  ? const Icon(
                                                      Icons.check,
                                                      size: 12,
                                                      color: AppColors.white,
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: BodyText(
                                                option.text,
                                                color: isSelected
                                                    ? AppColors.primaryPink
                                                    : (isDark ? AppColors.creamBackground : AppColors.darkText),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: _currentQuestionIndex == QuizData.questions.length - 1
                    ? 'Get My Results'
                    : 'Next Question',
                onPressed: _selectedOption != null ? _nextQuestion : null,
                width: double.infinity,
                size: ButtonSize.large,
                icon: Icon(
                  _currentQuestionIndex == QuizData.questions.length - 1
                      ? Icons.psychology
                      : Icons.arrow_forward,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}