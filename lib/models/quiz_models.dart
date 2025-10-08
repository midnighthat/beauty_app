import 'package:json_annotation/json_annotation.dart';

part 'quiz_models.g.dart';

// Quiz Question Model
@JsonSerializable()
class QuizQuestion {
  final int id;
  final String question;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}

// Quiz Option Model
@JsonSerializable()
class QuizOption {
  final String text;
  final SkinScoring scoring;

  const QuizOption({
    required this.text,
    required this.scoring,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) => _$QuizOptionFromJson(json);
  Map<String, dynamic> toJson() => _$QuizOptionToJson(this);
}

// Skin Scoring Model
@JsonSerializable()
class SkinScoring {
  final SkinTypeScores type;
  final SkinConcernScores concerns;

  const SkinScoring({
    required this.type,
    required this.concerns,
  });

  factory SkinScoring.fromJson(Map<String, dynamic> json) => _$SkinScoringFromJson(json);
  Map<String, dynamic> toJson() => _$SkinScoringToJson(this);
}

// Skin Type Scores
@JsonSerializable()
class SkinTypeScores {
  final int oily;
  final int dry;
  final int combo;
  final int normal;

  const SkinTypeScores({
    this.oily = 0,
    this.dry = 0,
    this.combo = 0,
    this.normal = 0,
  });

  factory SkinTypeScores.fromJson(Map<String, dynamic> json) => _$SkinTypeScoresFromJson(json);
  Map<String, dynamic> toJson() => _$SkinTypeScoresToJson(this);

  SkinTypeScores operator +(SkinTypeScores other) {
    return SkinTypeScores(
      oily: oily + other.oily,
      dry: dry + other.dry,
      combo: combo + other.combo,
      normal: normal + other.normal,
    );
  }
}

// Skin Concern Scores
@JsonSerializable()
class SkinConcernScores {
  final int acne;
  final int sensitive;
  final int pigmentation;
  final int aging;
  final int dehydration;
  final int overuse;

  const SkinConcernScores({
    this.acne = 0,
    this.sensitive = 0,
    this.pigmentation = 0,
    this.aging = 0,
    this.dehydration = 0,
    this.overuse = 0,
  });

  factory SkinConcernScores.fromJson(Map<String, dynamic> json) => _$SkinConcernScoresFromJson(json);
  Map<String, dynamic> toJson() => _$SkinConcernScoresToJson(this);

  SkinConcernScores operator +(SkinConcernScores other) {
    return SkinConcernScores(
      acne: acne + other.acne,
      sensitive: sensitive + other.sensitive,
      pigmentation: pigmentation + other.pigmentation,
      aging: aging + other.aging,
      dehydration: dehydration + other.dehydration,
      overuse: overuse + other.overuse,
    );
  }
}

// Skin Profile Result
@JsonSerializable()
class SkinProfile {
  final String skinType;
  final List<String> concerns;
  final List<RoutineStep> morningRoutine;
  final List<RoutineStep> nightRoutine;
  final Map<String, String> activesSchedule;
  final DoAndDont doAndDont;
  final List<FacialTreatment> facialTreatments;

  const SkinProfile({
    required this.skinType,
    required this.concerns,
    required this.morningRoutine,
    required this.nightRoutine,
    required this.activesSchedule,
    required this.doAndDont,
    required this.facialTreatments,
  });

  factory SkinProfile.fromJson(Map<String, dynamic> json) => _$SkinProfileFromJson(json);
  Map<String, dynamic> toJson() => _$SkinProfileToJson(this);
}

// Routine Step
@JsonSerializable()
class RoutineStep {
  final int step;
  final String name;
  final String description;
  final String? productExample;
  final String? note;

  const RoutineStep({
    required this.step,
    required this.name,
    required this.description,
    this.productExample,
    this.note,
  });

  factory RoutineStep.fromJson(Map<String, dynamic> json) => _$RoutineStepFromJson(json);
  Map<String, dynamic> toJson() => _$RoutineStepToJson(this);
}

// Do and Don't
@JsonSerializable()
class DoAndDont {
  final List<String> dos;
  final List<String> donts;

  const DoAndDont({
    required this.dos,
    required this.donts,
  });

  factory DoAndDont.fromJson(Map<String, dynamic> json) => _$DoAndDontFromJson(json);
  Map<String, dynamic> toJson() => _$DoAndDontToJson(this);
}

// Facial Treatment
@JsonSerializable()
class FacialTreatment {
  final String name;
  final String description;
  final String frequency;
  final double estimatedPrice;
  final List<String> benefits;

  const FacialTreatment({
    required this.name,
    required this.description,
    required this.frequency,
    required this.estimatedPrice,
    required this.benefits,
  });

  factory FacialTreatment.fromJson(Map<String, dynamic> json) => _$FacialTreatmentFromJson(json);
  Map<String, dynamic> toJson() => _$FacialTreatmentToJson(this);
}

// Quiz State
enum SkinType { oily, dry, combination, normal }
enum SkinConcern { acne, sensitive, pigmentation, aging, dehydration, overuse }

extension SkinTypeExtension on SkinType {
  String get displayName {
    switch (this) {
      case SkinType.oily:
        return 'Oily';
      case SkinType.dry:
        return 'Dry';
      case SkinType.combination:
        return 'Combination';
      case SkinType.normal:
        return 'Normal';
    }
  }
}

extension SkinConcernExtension on SkinConcern {
  String get displayName {
    switch (this) {
      case SkinConcern.acne:
        return 'Acne';
      case SkinConcern.sensitive:
        return 'Sensitive';
      case SkinConcern.pigmentation:
        return 'Pigmentation';
      case SkinConcern.aging:
        return 'Aging';
      case SkinConcern.dehydration:
        return 'Dehydration';
      case SkinConcern.overuse:
        return 'Product Overuse';
    }
  }
}