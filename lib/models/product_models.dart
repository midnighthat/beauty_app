import 'package:json_annotation/json_annotation.dart';

part 'product_models.g.dart';

@JsonSerializable()
class Product {
  final String productId;
  final String brandName;
  final String displayName;
  final String heroImage;
  final String? altImage;
  final String rating;
  final String reviews;
  final String targetUrl;
  final CurrentSku currentSku;
  final bool sponsored;

  const Product({
    required this.productId,
    required this.brandName,
    required this.displayName,
    required this.heroImage,
    this.altImage,
    required this.rating,
    required this.reviews,
    required this.targetUrl,
    required this.currentSku,
    required this.sponsored,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as String? ?? '',
      brandName: json['brandName'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      heroImage: json['heroImage'] as String? ?? '',
      altImage: json['altImage'] as String?,
      rating: json['rating'] as String? ?? '0',
      reviews: json['reviews'] as String? ?? '0',
      targetUrl: json['targetUrl'] as String? ?? '',
      currentSku: CurrentSku.fromJson(json['currentSku'] as Map<String, dynamic>? ?? {}),
      sponsored: json['sponsored'] as bool? ?? false,
    );
  }
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class CurrentSku {
  final String skuId;
  final String listPrice;
  final String? salePrice;
  final String? valuePrice;
  final String imageAltText;
  final bool isNew;
  final bool isOnlineOnly;
  final bool isSephoraExclusive;
  final bool isLimitedEdition;

  const CurrentSku({
    required this.skuId,
    required this.listPrice,
    this.salePrice,
    this.valuePrice,
    required this.imageAltText,
    required this.isNew,
    required this.isOnlineOnly,
    required this.isSephoraExclusive,
    required this.isLimitedEdition,
  });

  factory CurrentSku.fromJson(Map<String, dynamic> json) {
    return CurrentSku(
      skuId: json['skuId'] as String? ?? '',
      listPrice: json['listPrice'] as String? ?? '0',
      salePrice: json['salePrice'] as String?,
      valuePrice: json['valuePrice'] as String?,
      imageAltText: json['imageAltText'] as String? ?? '',
      isNew: json['isNew'] as bool? ?? false,
      isOnlineOnly: json['isOnlineOnly'] as bool? ?? false,
      isSephoraExclusive: json['isSephoraExclusive'] as bool? ?? false,
      isLimitedEdition: json['isLimitedEdition'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() => _$CurrentSkuToJson(this);
}

@JsonSerializable()
class Category {
  final String categoryId;
  final String displayName;
  final bool hasChildCategories;
  final bool hasDropdownMenu;
  final String? selectedThumbImage;
  final bool showInAppJaBsDropdown;
  final String targetUrl;
  final String? thumbImage;

  const Category({
    required this.categoryId,
    required this.displayName,
    required this.hasChildCategories,
    required this.hasDropdownMenu,
    this.selectedThumbImage,
    required this.showInAppJaBsDropdown,
    required this.targetUrl,
    this.thumbImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      hasChildCategories: json['hasChildCategories'] as bool? ?? false,
      hasDropdownMenu: json['hasDropdownMenu'] as bool? ?? false,
      selectedThumbImage: json['selectedThumbImage'] as String?,
      showInAppJaBsDropdown: json['showInAppJaBsDropdown'] as bool? ?? false,
      targetUrl: json['targetUrl'] as String? ?? '',
      thumbImage: json['thumbImage'] as String?,
    );
  }
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoriesResponse {
  final List<Category> rootCategories;

  const CategoriesResponse({
    required this.rootCategories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}

@JsonSerializable()
class SephoraResponse {
  final String categoryId;
  final String displayName;
  final int currentPage;
  final int pageSize;
  final int totalProducts;
  final List<Product> products;
  final List<Category> categories;

  const SephoraResponse({
    required this.categoryId,
    required this.displayName,
    required this.currentPage,
    required this.pageSize,
    required this.totalProducts,
    required this.products,
    required this.categories,
  });

  factory SephoraResponse.fromJson(Map<String, dynamic> json) =>
      _$SephoraResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SephoraResponseToJson(this);
}