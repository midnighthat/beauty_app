// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['productId'] as String,
      brandName: json['brandName'] as String,
      displayName: json['displayName'] as String,
      heroImage: json['heroImage'] as String,
      altImage: json['altImage'] as String?,
      rating: json['rating'] as String,
      reviews: json['reviews'] as String,
      targetUrl: json['targetUrl'] as String,
      currentSku:
          CurrentSku.fromJson(json['currentSku'] as Map<String, dynamic>),
      sponsored: json['sponsored'] as bool,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productId': instance.productId,
      'brandName': instance.brandName,
      'displayName': instance.displayName,
      'heroImage': instance.heroImage,
      'altImage': instance.altImage,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'targetUrl': instance.targetUrl,
      'currentSku': instance.currentSku,
      'sponsored': instance.sponsored,
    };

CurrentSku _$CurrentSkuFromJson(Map<String, dynamic> json) => CurrentSku(
      skuId: json['skuId'] as String,
      listPrice: json['listPrice'] as String,
      salePrice: json['salePrice'] as String?,
      valuePrice: json['valuePrice'] as String?,
      imageAltText: json['imageAltText'] as String,
      isNew: json['isNew'] as bool,
      isOnlineOnly: json['isOnlineOnly'] as bool,
      isSephoraExclusive: json['isSephoraExclusive'] as bool,
      isLimitedEdition: json['isLimitedEdition'] as bool,
    );

Map<String, dynamic> _$CurrentSkuToJson(CurrentSku instance) =>
    <String, dynamic>{
      'skuId': instance.skuId,
      'listPrice': instance.listPrice,
      'salePrice': instance.salePrice,
      'valuePrice': instance.valuePrice,
      'imageAltText': instance.imageAltText,
      'isNew': instance.isNew,
      'isOnlineOnly': instance.isOnlineOnly,
      'isSephoraExclusive': instance.isSephoraExclusive,
      'isLimitedEdition': instance.isLimitedEdition,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: json['categoryId'] as String,
      displayName: json['displayName'] as String,
      hasChildCategories: json['hasChildCategories'] as bool,
      hasDropdownMenu: json['hasDropdownMenu'] as bool,
      selectedThumbImage: json['selectedThumbImage'] as String?,
      showInAppJaBsDropdown: json['showInAppJaBsDropdown'] as bool,
      targetUrl: json['targetUrl'] as String,
      thumbImage: json['thumbImage'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryId': instance.categoryId,
      'displayName': instance.displayName,
      'hasChildCategories': instance.hasChildCategories,
      'hasDropdownMenu': instance.hasDropdownMenu,
      'selectedThumbImage': instance.selectedThumbImage,
      'showInAppJaBsDropdown': instance.showInAppJaBsDropdown,
      'targetUrl': instance.targetUrl,
      'thumbImage': instance.thumbImage,
    };

CategoriesResponse _$CategoriesResponseFromJson(Map<String, dynamic> json) =>
    CategoriesResponse(
      rootCategories: (json['rootCategories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesResponseToJson(CategoriesResponse instance) =>
    <String, dynamic>{
      'rootCategories': instance.rootCategories,
    };

SephoraResponse _$SephoraResponseFromJson(Map<String, dynamic> json) =>
    SephoraResponse(
      categoryId: json['categoryId'] as String,
      displayName: json['displayName'] as String,
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalProducts: (json['totalProducts'] as num).toInt(),
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SephoraResponseToJson(SephoraResponse instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'displayName': instance.displayName,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalProducts': instance.totalProducts,
      'products': instance.products,
      'categories': instance.categories,
    };
