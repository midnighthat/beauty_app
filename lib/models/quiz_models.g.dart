// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
      id: (json['id'] as num).toInt(),
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
    };

QuizOption _$QuizOptionFromJson(Map<String, dynamic> json) => QuizOption(
      text: json['text'] as String,
      scoring: SkinScoring.fromJson(json['scoring'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizOptionToJson(QuizOption instance) =>
    <String, dynamic>{
      'text': instance.text,
      'scoring': instance.scoring,
    };

SkinScoring _$SkinScoringFromJson(Map<String, dynamic> json) => SkinScoring(
      type: SkinTypeScores.fromJson(json['type'] as Map<String, dynamic>),
      concerns:
          SkinConcernScores.fromJson(json['concerns'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SkinScoringToJson(SkinScoring instance) =>
    <String, dynamic>{
      'type': instance.type,
      'concerns': instance.concerns,
    };

SkinTypeScores _$SkinTypeScoresFromJson(Map<String, dynamic> json) =>
    SkinTypeScores(
      oily: (json['oily'] as num?)?.toInt() ?? 0,
      dry: (json['dry'] as num?)?.toInt() ?? 0,
      combo: (json['combo'] as num?)?.toInt() ?? 0,
      normal: (json['normal'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SkinTypeScoresToJson(SkinTypeScores instance) =>
    <String, dynamic>{
      'oily': instance.oily,
      'dry': instance.dry,
      'combo': instance.combo,
      'normal': instance.normal,
    };

SkinConcernScores _$SkinConcernScoresFromJson(Map<String, dynamic> json) =>
    SkinConcernScores(
      acne: (json['acne'] as num?)?.toInt() ?? 0,
      sensitive: (json['sensitive'] as num?)?.toInt() ?? 0,
      pigmentation: (json['pigmentation'] as num?)?.toInt() ?? 0,
      aging: (json['aging'] as num?)?.toInt() ?? 0,
      dehydration: (json['dehydration'] as num?)?.toInt() ?? 0,
      overuse: (json['overuse'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SkinConcernScoresToJson(SkinConcernScores instance) =>
    <String, dynamic>{
      'acne': instance.acne,
      'sensitive': instance.sensitive,
      'pigmentation': instance.pigmentation,
      'aging': instance.aging,
      'dehydration': instance.dehydration,
      'overuse': instance.overuse,
    };

SkinProfile _$SkinProfileFromJson(Map<String, dynamic> json) => SkinProfile(
      skinType: json['skinType'] as String,
      concerns:
          (json['concerns'] as List<dynamic>).map((e) => e as String).toList(),
      morningRoutine: (json['morningRoutine'] as List<dynamic>)
          .map((e) => RoutineStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      nightRoutine: (json['nightRoutine'] as List<dynamic>)
          .map((e) => RoutineStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      activesSchedule: Map<String, String>.from(json['activesSchedule'] as Map),
      doAndDont: DoAndDont.fromJson(json['doAndDont'] as Map<String, dynamic>),
      facialTreatments: (json['facialTreatments'] as List<dynamic>)
          .map((e) => FacialTreatment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SkinProfileToJson(SkinProfile instance) =>
    <String, dynamic>{
      'skinType': instance.skinType,
      'concerns': instance.concerns,
      'morningRoutine': instance.morningRoutine,
      'nightRoutine': instance.nightRoutine,
      'activesSchedule': instance.activesSchedule,
      'doAndDont': instance.doAndDont,
      'facialTreatments': instance.facialTreatments,
    };

RoutineStep _$RoutineStepFromJson(Map<String, dynamic> json) => RoutineStep(
      step: (json['step'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      productExample: json['productExample'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$RoutineStepToJson(RoutineStep instance) =>
    <String, dynamic>{
      'step': instance.step,
      'name': instance.name,
      'description': instance.description,
      'productExample': instance.productExample,
      'note': instance.note,
    };

DoAndDont _$DoAndDontFromJson(Map<String, dynamic> json) => DoAndDont(
      dos: (json['dos'] as List<dynamic>).map((e) => e as String).toList(),
      donts: (json['donts'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DoAndDontToJson(DoAndDont instance) => <String, dynamic>{
      'dos': instance.dos,
      'donts': instance.donts,
    };

FacialTreatment _$FacialTreatmentFromJson(Map<String, dynamic> json) =>
    FacialTreatment(
      name: json['name'] as String,
      description: json['description'] as String,
      frequency: json['frequency'] as String,
      estimatedPrice: (json['estimatedPrice'] as num).toDouble(),
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FacialTreatmentToJson(FacialTreatment instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'frequency': instance.frequency,
      'estimatedPrice': instance.estimatedPrice,
      'benefits': instance.benefits,
    };
