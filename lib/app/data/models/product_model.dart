import '../../core/utils/formatters.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.image,
    this.productCount = 0,
  });

  final String id;
  final String name;
  final String? slug;
  final String? image;
  final int productCount;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        slug: json['slug']?.toString(),
        image: json['image']?.toString(),
        productCount: Formatters.toInt(json['productCount'] ?? (json['_count'] is Map ? json['_count']['products'] : 0)),
      );
}

class ProductVariantModel {
  ProductVariantModel({
    required this.id,
    required this.size,
    required this.color,
    this.colorHex,
    required this.price,
    required this.stock,
    this.sku,
  });

  final String id;
  final String size;
  final String color;
  final String? colorHex;
  final double price;
  final int stock;
  final String? sku;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) => ProductVariantModel(
        id: json['id']?.toString() ?? '',
        size: json['size']?.toString() ?? '',
        color: json['color']?.toString() ?? '',
        colorHex: json['colorHex']?.toString(),
        price: Formatters.toDouble(json['price']),
        stock: Formatters.toInt(json['stock']),
        sku: json['sku']?.toString(),
      );
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    this.slug,
    this.sku,
    this.brand,
    this.description,
    required this.price,
    this.comparePrice,
    this.rating = 0,
    this.reviewCount = 0,
    this.soldCount = 0,
    this.thumbnail,
    this.images = const [],
    this.variants = const [],
    this.sizes = const [],
    this.colors = const [],
    this.inStock = true,
    this.category,
    this.reviews = const [],
  });

  final String id;
  final String name;
  final String? slug;
  final String? sku;
  final String? brand;
  final String? description;
  final double price;
  final double? comparePrice;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final String? thumbnail;
  final List<String> images;
  final List<ProductVariantModel> variants;
  final List<String> sizes;
  final List<ColorOption> colors;
  final bool inStock;
  final CategoryModel? category;
  final List<ReviewModel> reviews;

  bool get hasDiscount => (comparePrice ?? 0) > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((comparePrice! - price) / comparePrice!) * 100).round();
  }

  int get totalStock => variants.fold(0, (sum, v) => sum + v.stock);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final imageUrls = <String>[];
    if (json['imageUrls'] is List) {
      imageUrls.addAll((json['imageUrls'] as List).map((e) => e.toString()));
    }
    if (rawImages is List) {
      for (final img in rawImages) {
        if (img is Map) {
          imageUrls.add(img['url'].toString());
        } else if (img is String) {
          imageUrls.add(img);
        }
      }
    }
    final thumb = json['thumbnail']?.toString();

    final variants = (json['variants'] as List? ?? [])
        .whereType<Map>()
        .map((e) => ProductVariantModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final sizes = (json['sizes'] as List? ?? []).map((e) => e.toString()).toList();

    final colors = <ColorOption>[];
    final rawColors = json['colors'];
    if (rawColors is List) {
      for (final c in rawColors) {
        if (c is Map) {
          colors.add(ColorOption(name: c['name']?.toString() ?? '', hex: c['hex']?.toString()));
        }
      }
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      sku: json['sku']?.toString(),
      brand: json['brand']?.toString(),
      description: json['description']?.toString(),
      price: Formatters.toDouble(json['price']),
      comparePrice: json['comparePrice'] == null ? null : Formatters.toDouble(json['comparePrice']),
      rating: Formatters.toDouble(json['rating']),
      reviewCount: Formatters.toInt(json['reviewCount']),
      soldCount: Formatters.toInt(json['soldCount']),
      thumbnail: thumb ?? (imageUrls.isNotEmpty ? imageUrls.first : null),
      images: imageUrls,
      variants: variants,
      sizes: sizes.isNotEmpty ? sizes : variants.map((v) => v.size).toSet().toList(),
      colors: colors,
      inStock: json['inStock'] != false,
      category: json['category'] is Map
          ? CategoryModel.fromJson(Map<String, dynamic>.from(json['category'] as Map))
          : null,
      reviews: (json['reviews'] as List? ?? [])
          .whereType<Map>()
          .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class ColorOption {
  ColorOption({required this.name, this.hex});

  final String name;
  final String? hex;
}

class ReviewModel {
  ReviewModel({required this.id, required this.rating, this.comment, this.userName, this.createdAt});

  final String id;
  final int rating;
  final String? comment;
  final String? userName;
  final DateTime? createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id']?.toString() ?? '',
        rating: Formatters.toInt(json['rating']),
        comment: json['comment']?.toString(),
        userName: json['user'] is Map ? json['user']['name']?.toString() : null,
        createdAt: Formatters.parse(json['createdAt']),
      );
}

class BannerModel {
  BannerModel({required this.title, required this.image});

  final String title;
  final String image;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        title: json['title']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
      );
}

class HomeModel {
  HomeModel({
    this.banners = const [],
    this.categories = const [],
    this.featured = const [],
    this.newArrivals = const [],
    this.bestSellers = const [],
    this.storeName = 'ShoeStore',
  });

  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> featured;
  final List<ProductModel> newArrivals;
  final List<ProductModel> bestSellers;
  final String storeName;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        banners: (json['banners'] as List? ?? [])
            .whereType<Map>()
            .map((e) => BannerModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        categories: (json['categories'] as List? ?? [])
            .whereType<Map>()
            .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        featured: _products(json['featured']),
        newArrivals: _products(json['newArrivals']),
        bestSellers: _products(json['bestSellers']),
        storeName: json['storeName']?.toString() ?? 'ShoeStore',
      );

  static List<ProductModel> _products(dynamic raw) => (raw as List? ?? [])
      .whereType<Map>()
      .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}
