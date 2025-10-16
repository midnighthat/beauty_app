// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBeautyProduct _$KBeautyProductFromJson(Map<String, dynamic> json) =>
    KBeautyProduct(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      images: json['images'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      categories: json['categories'] as String,
      ingredient: (json['ingredient'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      skinType:
          (json['skinType'] as List<dynamic>).map((e) => e as String).toList(),
      bestFor: json['bestFor'] as String,
      routine: json['routine'] as String,
    );

Map<String, dynamic> _$KBeautyProductToJson(KBeautyProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'images': instance.images,
      'description': instance.description,
      'price': instance.price,
      'rating': instance.rating,
      'categories': instance.categories,
      'ingredient': instance.ingredient,
      'skinType': instance.skinType,
      'bestFor': instance.bestFor,
      'routine': instance.routine,
    };

KBeautyTreatment _$KBeautyTreatmentFromJson(Map<String, dynamic> json) =>
    KBeautyTreatment(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      duration: json['duration'] as String,
      whatItIs: json['whatItIs'] as String,
      whyItWorks: json['whyItWorks'] as String,
      bestFor: json['bestFor'] as String,
      results: json['results'] as String,
      skinConcern: json['skinConcern'] as String,
      skinTypes:
          (json['skinTypes'] as List<dynamic>).map((e) => e as String).toList(),
      recommendedProducts: (json['recommendedProducts'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$KBeautyTreatmentToJson(KBeautyTreatment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'duration': instance.duration,
      'whatItIs': instance.whatItIs,
      'whyItWorks': instance.whyItWorks,
      'bestFor': instance.bestFor,
      'results': instance.results,
      'skinConcern': instance.skinConcern,
      'skinTypes': instance.skinTypes,
      'recommendedProducts': instance.recommendedProducts,
    };

KBeautyData _$KBeautyDataFromJson(Map<String, dynamic> json) => KBeautyData(
      skinTypes:
          (json['skinTypes'] as List<dynamic>).map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      products: (json['products'] as List<dynamic>)
          .map((e) => KBeautyProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      treatments: (json['treatments'] as List<dynamic>)
          .map((e) => KBeautyTreatment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KBeautyDataToJson(KBeautyData instance) =>
    <String, dynamic>{
      'skinTypes': instance.skinTypes,
      'categories': instance.categories,
      'products': instance.products,
      'treatments': instance.treatments,
    };
