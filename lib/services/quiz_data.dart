import '../models/quiz_models.dart';

class QuizData {
  static const List<QuizQuestion> questions = [
    // Question 1
    QuizQuestion(
      id: 1,
      question: "By midday, my face feels...",
      options: [
        QuizOption(
          text: "Very shiny / slick",
          scoring: SkinScoring(
            type: SkinTypeScores(oily: 2),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Slightly shiny in T-zone",
          scoring: SkinScoring(
            type: SkinTypeScores(combo: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Comfortable",
          scoring: SkinScoring(
            type: SkinTypeScores(normal: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Tight or flaky",
          scoring: SkinScoring(
            type: SkinTypeScores(dry: 2),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 2
    QuizQuestion(
      id: 2,
      question: "Visible pores on cheeks?",
      options: [
        QuizOption(
          text: "Very visible",
          scoring: SkinScoring(
            type: SkinTypeScores(oily: 2),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Only around nose",
          scoring: SkinScoring(
            type: SkinTypeScores(combo: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Barely visible",
          scoring: SkinScoring(
            type: SkinTypeScores(normal: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Not visible + flaky skin",
          scoring: SkinScoring(
            type: SkinTypeScores(dry: 1),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 3
    QuizQuestion(
      id: 3,
      question: "After gel cleansing (no cream) my skin feels...",
      options: [
        QuizOption(
          text: "Very tight",
          scoring: SkinScoring(
            type: SkinTypeScores(dry: 2),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "A bit tight",
          scoring: SkinScoring(
            type: SkinTypeScores(dry: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Fine/normal",
          scoring: SkinScoring(
            type: SkinTypeScores(normal: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Still oily",
          scoring: SkinScoring(
            type: SkinTypeScores(oily: 1),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 4
    QuizQuestion(
      id: 4,
      question: "Breakouts happen...",
      options: [
        QuizOption(
          text: "Weekly, several",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(acne: 2),
          ),
        ),
        QuizOption(
          text: "Monthly, a few",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(acne: 1),
          ),
        ),
        QuizOption(
          text: "Rarely",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Bumps after new products",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(sensitive: 1),
          ),
        ),
      ],
    ),

    // Question 5
    QuizQuestion(
      id: 5,
      question: "Redness/burning after sunscreen/new product?",
      options: [
        QuizOption(
          text: "Often",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(sensitive: 2),
          ),
        ),
        QuizOption(
          text: "Sometimes",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(sensitive: 1),
          ),
        ),
        QuizOption(
          text: "Rarely",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Never",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 6
    QuizQuestion(
      id: 6,
      question: "Brown spots/freckles that don't fade:",
      options: [
        QuizOption(
          text: "Many",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(pigmentation: 2),
          ),
        ),
        QuizOption(
          text: "A few",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(pigmentation: 1),
          ),
        ),
        QuizOption(
          text: "None",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Not sure",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 7
    QuizQuestion(
      id: 7,
      question: "Fine lines are most noticeable...",
      options: [
        QuizOption(
          text: "Daily (eyes/forehead)",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(aging: 2),
          ),
        ),
        QuizOption(
          text: "Only when dehydrated",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(dehydration: 1),
          ),
        ),
        QuizOption(
          text: "Not noticeable",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Not sure",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 8
    QuizQuestion(
      id: 8,
      question: "Sleep most nights:",
      options: [
        QuizOption(
          text: "<5h",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(dehydration: 2),
          ),
        ),
        QuizOption(
          text: "5–6h",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(dehydration: 1),
          ),
        ),
        QuizOption(
          text: "7–8h",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "8h+",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 9
    QuizQuestion(
      id: 9,
      question: "Climate most of the year:",
      options: [
        QuizOption(
          text: "Hot & humid",
          scoring: SkinScoring(
            type: SkinTypeScores(oily: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Hot & dry",
          scoring: SkinScoring(
            type: SkinTypeScores(dry: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Mixed seasons",
          scoring: SkinScoring(
            type: SkinTypeScores(combo: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Mild",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(),
          ),
        ),
      ],
    ),

    // Question 10
    QuizQuestion(
      id: 10,
      question: "Current routine:",
      options: [
        QuizOption(
          text: "Harsh scrubs/strong actives daily",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(sensitive: 1),
          ),
        ),
        QuizOption(
          text: "Only foaming cleanser",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(dehydration: 1),
          ),
        ),
        QuizOption(
          text: "Cleanse + moisturize + SPF",
          scoring: SkinScoring(
            type: SkinTypeScores(normal: 1),
            concerns: SkinConcernScores(),
          ),
        ),
        QuizOption(
          text: "Try many new products monthly",
          scoring: SkinScoring(
            type: SkinTypeScores(),
            concerns: SkinConcernScores(overuse: 1),
          ),
        ),
      ],
    ),
  ];

  // Scoring Algorithm
  static SkinProfile calculateProfile(List<int> answers) {
    // Initialize scores
    var typeScores = const SkinTypeScores();
    var concernScores = const SkinConcernScores();

    // Apply scoring for each answer
    for (int i = 0; i < answers.length && i < questions.length; i++) {
      if (answers[i] < questions[i].options.length) {
        final scoring = questions[i].options[answers[i]].scoring;
        typeScores = typeScores + scoring.type;
        concernScores = concernScores + scoring.concerns;
      }
    }

    // Determine final skin type
    final String finalSkinType = _determineSkinType(typeScores);
    
    // Determine top concerns
    final List<String> finalConcerns = _determineConcerns(concernScores);

    // Generate routines and recommendations
    final routines = _generateRoutines(finalSkinType, finalConcerns);
    final treatments = _generateTreatments(finalSkinType, finalConcerns);
    final doAndDont = _generateDoAndDont(finalSkinType, finalConcerns);

    return SkinProfile(
      skinType: finalSkinType,
      concerns: finalConcerns,
      morningRoutine: routines['morning']!,
      nightRoutine: routines['night']!,
      activesSchedule: _generateActivesSchedule(finalSkinType, finalConcerns),
      doAndDont: doAndDont,
      facialTreatments: treatments,
    );
  }

  static String _determineSkinType(SkinTypeScores scores) {
    // Special combination rule
    if (scores.oily >= 2 && scores.dry >= 2) {
      return 'Combination';
    }

    // Find highest score
    final Map<String, int> typeMap = {
      'Oily': scores.oily,
      'Dry': scores.dry,
      'Combination': scores.combo,
      'Normal': scores.normal,
    };

    final maxScore = typeMap.values.reduce((a, b) => a > b ? a : b);
    
    // If all scores are low, default to normal
    if (maxScore <= 1) {
      return 'Normal';
    }

    return typeMap.entries.firstWhere((entry) => entry.value == maxScore).key;
  }

  static List<String> _determineConcerns(SkinConcernScores scores) {
    final Map<String, int> concernMap = {
      'Acne': scores.acne,
      'Sensitive': scores.sensitive,
      'Pigmentation': scores.pigmentation,
      'Aging': scores.aging,
      'Dehydration': scores.dehydration,
      'Product Overuse': scores.overuse,
    };

    // Get concerns with score >= 2 or top 2 concerns
    List<MapEntry<String, int>> sortedConcerns = concernMap.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

    List<String> finalConcerns = [];
    
    // Add concerns with score >= 2
    finalConcerns.addAll(
      sortedConcerns
          .where((entry) => entry.value >= 2)
          .map((entry) => entry.key)
          .toList(),
    );

    // If no concerns with score >= 2, take top 2
    if (finalConcerns.isEmpty && sortedConcerns.isNotEmpty) {
      finalConcerns.addAll(
        sortedConcerns
            .take(2)
            .where((entry) => entry.value > 0)
            .map((entry) => entry.key)
            .toList(),
      );
    }

    return finalConcerns;
  }

  static Map<String, List<RoutineStep>> _generateRoutines(String skinType, List<String> concerns) {
    // This is a simplified version - you would expand this with full K-Beauty routines
    Map<String, List<RoutineStep>> routines = {};

    switch (skinType.toLowerCase()) {
      case 'oily':
        routines['morning'] = [
          const RoutineStep(step: 1, name: "Gentle Gel Cleanser", description: "Remove overnight buildup", productExample: "COSRX Low pH Good Morning Gel Cleanser"),
          const RoutineStep(step: 2, name: "Hydrating Toner", description: "Light humectants", productExample: "Some By Mi Bye Bye Blackhead Toner"),
          const RoutineStep(step: 3, name: "Essence", description: "Green tea or centella", productExample: "COSRX Centella Blemish Ampoule"),
          const RoutineStep(step: 4, name: "Light Gel Moisturizer", description: "Lightweight hydration", productExample: "Belif Aqua Bomb"),
          const RoutineStep(step: 5, name: "SPF 50 PA++++", description: "Matte or gel base", productExample: "Biore UV Aqua Rich Watery Essence"),
        ];
        routines['night'] = [
          const RoutineStep(step: 1, name: "Oil Cleanser", description: "Remove SPF/makeup", productExample: "Banila Co Clean It Zero"),
          const RoutineStep(step: 2, name: "Gel Cleanser", description: "Deep cleanse", productExample: "COSRX Low pH Good Morning Gel Cleanser"),
          const RoutineStep(step: 3, name: "Exfoliant", description: "AHA/BHA 2-3x/week", productExample: "Paula's Choice 2% BHA", note: "2-3 times per week"),
          const RoutineStep(step: 4, name: "Soothing Serum", description: "Niacinamide + zinc", productExample: "The Ordinary Niacinamide 10% + Zinc 1%"),
          const RoutineStep(step: 5, name: "Lightweight Moisturizer", description: "Night hydration", productExample: "Belif Aqua Bomb"),
        ];
        break;
      case 'dry':
        routines['morning'] = [
          const RoutineStep(step: 1, name: "Milky/Creamy Cleanser", description: "Gentle cleansing", productExample: "CeraVe Hydrating Cleanser"),
          const RoutineStep(step: 2, name: "Hydrating Toner", description: "Multi-step toning", productExample: "Hada Labo Gokujyun Premium Lotion"),
          const RoutineStep(step: 3, name: "Essence", description: "Extra hydration layer", productExample: "SK-II Facial Treatment Essence"),
          const RoutineStep(step: 4, name: "Ceramide-Rich Cream", description: "Heavy moisturization", productExample: "Dr. Jart+ Ceramidin Cream"),
          const RoutineStep(step: 5, name: "SPF 50 PA++++", description: "Sun protection", productExample: "La Roche-Posay Anthelios Ultra Cover"),
        ];
        routines['night'] = [
          const RoutineStep(step: 1, name: "Balm/Cleansing Oil", description: "Gentle makeup removal", productExample: "Heimish All Clean Balm"),
          const RoutineStep(step: 2, name: "Creamy Cleanser", description: "Second cleanse", productExample: "CeraVe Hydrating Cleanser"),
          const RoutineStep(step: 3, name: "Peptide/Ceramide Serum", description: "Repair and hydrate", productExample: "The Ordinary Matrixyl 10% + HA"),
          const RoutineStep(step: 4, name: "Rich Cream", description: "Deep moisturization", productExample: "Laneige Water Sleeping Mask"),
          const RoutineStep(step: 5, name: "Sleeping Mask", description: "Optional overnight treatment", productExample: "COSRX Ultimate Nourishing Rice Overnight Spa Mask", note: "Optional"),
        ];
        break;
      case 'combination':
        routines['morning'] = [
          const RoutineStep(step: 1, name: "Gel Cleanser", description: "Balanced cleansing", productExample: "Neutrogena Ultra Gentle Daily Cleanser"),
          const RoutineStep(step: 2, name: "Balancing Toner", description: "Adjust pH", productExample: "Klairs Supple Preparation Toner"),
          const RoutineStep(step: 3, name: "Essence", description: "Light hydration", productExample: "Missha Time Revolution First Treatment Essence"),
          const RoutineStep(step: 4, name: "Zone-Targeted Moisturizer", description: "Light on T-zone, rich on cheeks", productExample: "The Ordinary Natural Moisturizing Factors"),
          const RoutineStep(step: 5, name: "SPF 50 PA++++", description: "Broad spectrum protection", productExample: "EltaMD UV Clear Broad-Spectrum SPF 46"),
        ];
        routines['night'] = [
          const RoutineStep(step: 1, name: "Double Cleanse", description: "Oil then gel cleanser", productExample: "Banila Co Clean It Zero + Gel Cleanser"),
          const RoutineStep(step: 2, name: "Zone-Targeted Actives", description: "BHA on T-zone", productExample: "Paula's Choice 2% BHA", note: "T-zone only"),
          const RoutineStep(step: 3, name: "Hydrating Serum", description: "For dry areas", productExample: "The Ordinary Hyaluronic Acid 2% + B5"),
          const RoutineStep(step: 4, name: "Moisturizer", description: "Adjust by zone", productExample: "Combination of light and rich moisturizers"),
        ];
        break;
      default: // Normal
        routines['morning'] = [
          const RoutineStep(step: 1, name: "Gentle Cleanser", description: "Maintain balance", productExample: "CeraVe Foaming Facial Cleanser"),
          const RoutineStep(step: 2, name: "Toner", description: "Prep skin", productExample: "Thayers Rose Petal Toner"),
          const RoutineStep(step: 3, name: "Serum", description: "Antioxidant protection", productExample: "Skinceuticals CE Ferulic"),
          const RoutineStep(step: 4, name: "Moisturizer", description: "Daily hydration", productExample: "Neutrogena Hydro Boost"),
          const RoutineStep(step: 5, name: "SPF", description: "Sun protection", productExample: "Supergoop! Unseen Sunscreen SPF 40"),
        ];
        routines['night'] = [
          const RoutineStep(step: 1, name: "Double Cleanse", description: "Thorough cleansing", productExample: "Oil cleanser + gentle cleanser"),
          const RoutineStep(step: 2, name: "Retinoid", description: "Anti-aging treatment", productExample: "The Ordinary Retinol 0.5%", note: "1-2x per week"),
          const RoutineStep(step: 3, name: "Moisturizer", description: "Night repair", productExample: "Olay Regenerist Night Recovery Cream"),
        ];
        break;
    }

    return routines;
  }

  static List<FacialTreatment> _generateTreatments(String skinType, List<String> concerns) {
    List<FacialTreatment> treatments = [];

    switch (skinType.toLowerCase()) {
      case 'oily':
        treatments.addAll([
          const FacialTreatment(
            name: "Oil-Control Clay Mask",
            description: "Deep pore cleansing with kaolin and bentonite clay",
            frequency: "1x per week",
            estimatedPrice: 45.0,
            benefits: ["Reduces excess oil", "Minimizes pores", "Prevents breakouts"],
          ),
          const FacialTreatment(
            name: "Deep-Pore Vacuum Extraction",
            description: "Professional comedone extraction with gentle suction",
            frequency: "Monthly",
            estimatedPrice: 85.0,
            benefits: ["Clears blackheads", "Reduces pore congestion", "Improves skin texture"],
          ),
          const FacialTreatment(
            name: "Charcoal Green Tea Peel",
            description: "Sebum-regulating peel with charcoal and green tea",
            frequency: "Bi-weekly",
            estimatedPrice: 65.0,
            benefits: ["Controls oil production", "Soothes inflammation", "Brightens skin"],
          ),
        ]);
        break;
      case 'dry':
        treatments.addAll([
          const FacialTreatment(
            name: "Hydration Moisture Mask",
            description: "Intensive hydrating treatment with hyaluronic acid",
            frequency: "Weekly",
            estimatedPrice: 55.0,
            benefits: ["Deep hydration", "Plumps fine lines", "Restores barrier"],
          ),
          const FacialTreatment(
            name: "Honey Aloe Facial",
            description: "Nourishing treatment with manuka honey and aloe vera",
            frequency: "Bi-weekly",
            estimatedPrice: 70.0,
            benefits: ["Intense moisturizing", "Heals dry patches", "Anti-inflammatory"],
          ),
          const FacialTreatment(
            name: "Ultrasonic Hydration Infusion",
            description: "Technology-assisted water and serum infusion",
            frequency: "Monthly",
            estimatedPrice: 120.0,
            benefits: ["Maximum hydration", "Improved absorption", "Instant plumping"],
          ),
        ]);
        break;
      case 'combination':
        treatments.addAll([
          const FacialTreatment(
            name: "Dual-Zone Facial Treatment",
            description: "Customized treatment for different facial zones",
            frequency: "Bi-weekly",
            estimatedPrice: 75.0,
            benefits: ["Balances skin", "Addresses multiple concerns", "Personalized care"],
          ),
          const FacialTreatment(
            name: "Water-Gel Hydrating Mask",
            description: "Lightweight hydration without heaviness",
            frequency: "Weekly",
            estimatedPrice: 50.0,
            benefits: ["Balanced hydration", "Non-comedogenic", "Suitable for mixed skin"],
          ),
        ]);
        break;
      default: // Normal
        treatments.addAll([
          const FacialTreatment(
            name: "Glowing Skin Booster Facial",
            description: "Vitamin C and brightening treatment",
            frequency: "Bi-weekly",
            estimatedPrice: 80.0,
            benefits: ["Radiant glow", "Even skin tone", "Antioxidant protection"],
          ),
          const FacialTreatment(
            name: "Brightening Sheet Mask",
            description: "Korean-style essence-soaked sheet mask",
            frequency: "2x per week",
            estimatedPrice: 25.0,
            benefits: ["Instant brightness", "Hydration boost", "Even complexion"],
          ),
        ]);
        break;
    }

    return treatments;
  }

  static DoAndDont _generateDoAndDont(String skinType, List<String> concerns) {
    List<String> dos = [];
    List<String> donts = [];

    // General dos and don'ts based on skin type
    switch (skinType.toLowerCase()) {
      case 'oily':
        dos.addAll([
          "Use oil-free, non-comedogenic products",
          "Cleanse twice daily with gel cleanser",
          "Use clay masks weekly",
          "Apply lightweight, gel-based moisturizers",
          "Use salicylic acid 2-3 times per week",
        ]);
        donts.addAll([
          "Over-cleanse or scrub harshly",
          "Use heavy, oil-based products",
          "Skip moisturizer",
          "Use alcohol-based toners daily",
        ]);
        break;
      case 'dry':
        dos.addAll([
          "Use cream-based cleansers",
          "Layer hydrating products",
          "Apply moisturizer while skin is damp",
          "Use a humidifier",
          "Gentle exfoliation 1x per week",
        ]);
        donts.addAll([
          "Use foaming cleansers daily",
          "Apply actives without moisturizer",
          "Take hot showers",
          "Use alcohol-based products",
        ]);
        break;
      case 'combination':
        dos.addAll([
          "Treat different zones appropriately",
          "Use balanced, gentle products",
          "Multi-mask (different masks for different areas)",
          "Use lightweight hydration",
        ]);
        donts.addAll([
          "Use the same product everywhere",
          "Over-treat the T-zone",
          "Neglect dry areas",
        ]);
        break;
      default: // Normal
        dos.addAll([
          "Maintain consistent routine",
          "Use antioxidant serums",
          "Regular gentle exfoliation",
          "Don't change products too frequently",
        ]);
        donts.addAll([
          "Over-complicate your routine",
          "Skip SPF",
          "Introduce too many actives at once",
        ]);
        break;
    }

    return DoAndDont(dos: dos, donts: donts);
  }

  static Map<String, String> _generateActivesSchedule(String skinType, List<String> concerns) {
    Map<String, String> schedule = {};

    if (concerns.contains('Acne')) {
      schedule['Monday'] = 'BHA (Salicylic Acid)';
      schedule['Wednesday'] = 'BHA (Salicylic Acid)';
      schedule['Friday'] = 'Niacinamide';
    }

    if (concerns.contains('Aging')) {
      schedule['Tuesday'] = 'Retinol';
      schedule['Thursday'] = 'Vitamin C (morning)';
      schedule['Saturday'] = 'AHA (Glycolic Acid)';
    }

    if (concerns.contains('Pigmentation')) {
      schedule['Daily (AM)'] = 'Vitamin C';
      schedule['Tuesday'] = 'Arbutin';
      schedule['Thursday'] = 'Kojic Acid';
    }

    if (concerns.contains('Sensitive')) {
      schedule['As needed'] = 'Centella Asiatica';
      schedule['Daily'] = 'Ceramides';
    }

    return schedule;
  }
}