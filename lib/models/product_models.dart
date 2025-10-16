import 'package:json_annotation/json_annotation.dart';

part 'product_models.g.dart';

@JsonSerializable()
class KBeautyProduct {
  final int id;
  final String name;
  final String images;
  final String description;
  final double price;
  final double rating;
  final String categories;
  final List<String> ingredient;
  final List<String> skinType;
  final String bestFor;
  final String routine;

  const KBeautyProduct({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.price,
    required this.rating,
    required this.categories,
    required this.ingredient,
    required this.skinType,
    required this.bestFor,
    required this.routine,
  });

  factory KBeautyProduct.fromJson(Map<String, dynamic> json) {
    try {
      return _$KBeautyProductFromJson(json);
    } catch (e) {
      print('Error parsing KBeautyProduct: $e');
      print('JSON data: $json');
      // Fallback with safe parsing
      return KBeautyProduct(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        images: json['images'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        categories: json['categories'] as String? ?? '',
        ingredient: (json['ingredient'] as List<dynamic>?)?.cast<String>() ?? [],
        skinType: (json['skinType'] as List<dynamic>?)?.cast<String>() ?? [],
        bestFor: json['bestFor'] as String? ?? '',
        routine: json['routine'] as String? ?? '',
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$KBeautyProductToJson(this);
}

@JsonSerializable()
class KBeautyTreatment {
  final int id;
  final String name;
  final int price;
  final String duration;
  final String whatItIs;
  final String whyItWorks;
  final String bestFor;
  final String results;
  final String skinConcern;
  final List<String> skinTypes;
  final List<int> recommendedProducts;

  const KBeautyTreatment({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.whatItIs,
    required this.whyItWorks,
    required this.bestFor,
    required this.results,
    required this.skinConcern,
    required this.skinTypes,
    required this.recommendedProducts,
  });

  factory KBeautyTreatment.fromJson(Map<String, dynamic> json) {
    try {
      return _$KBeautyTreatmentFromJson(json);
    } catch (e) {
      print('Error parsing KBeautyTreatment: $e');
      print('JSON data: $json');
      // Fallback with safe parsing
      return KBeautyTreatment(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        price: json['price'] as int? ?? 0,
        duration: json['duration'] as String? ?? '',
        whatItIs: json['whatItIs'] as String? ?? '',
        whyItWorks: json['whyItWorks'] as String? ?? '',
        bestFor: json['bestFor'] as String? ?? '',
        results: json['results'] as String? ?? '',
        skinConcern: json['skinConcern'] as String? ?? '',
        skinTypes: (json['skinTypes'] as List<dynamic>?)?.cast<String>() ?? [],
        recommendedProducts: (json['recommendedProducts'] as List<dynamic>?)?.cast<int>() ?? [],
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$KBeautyTreatmentToJson(this);
}

@JsonSerializable()
class KBeautyData {
  final List<String> skinTypes;
  final List<String> categories;
  final List<KBeautyProduct> products;
  final List<KBeautyTreatment> treatments;

  const KBeautyData({
    required this.skinTypes,
    required this.categories,
    required this.products,
    required this.treatments,
  });

  factory KBeautyData.fromJson(Map<String, dynamic> json) {
    try {
      return _$KBeautyDataFromJson(json);
    } catch (e) {
      print('Error parsing KBeautyData: $e');
      print('JSON keys: ${json.keys.toList()}');
      // Fallback with safe parsing
      return KBeautyData(
        skinTypes: (json['skinTypes'] as List<dynamic>?)?.cast<String>() ?? [],
        categories: (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
        products: (json['products'] as List<dynamic>?)?.map((e) => KBeautyProduct.fromJson(e)).toList() ?? [],
        treatments: (json['treatments'] as List<dynamic>?)?.map((e) => KBeautyTreatment.fromJson(e)).toList() ?? [],
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$KBeautyDataToJson(this);
}