import '../../core/utils/formatters.dart';

class CartItemModel {
  CartItemModel({
    required this.id,
    required this.productId,
    this.variantId,
    required this.name,
    this.image,
    this.size,
    this.color,
    required this.price,
    required this.quantity,
    this.stock = 0,
  });

  final String id;
  final String productId;
  final String? variantId;
  final String name;
  final String? image;
  final String? size;
  final String? color;
  final double price;
  final int quantity;
  final int stock;

  double get lineTotal => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id']?.toString() ?? '',
        productId: json['productId']?.toString() ?? '',
        variantId: json['variantId']?.toString(),
        name: json['name']?.toString() ?? '',
        image: json['image']?.toString(),
        size: json['size']?.toString(),
        color: json['color']?.toString(),
        price: Formatters.toDouble(json['price']),
        quantity: Formatters.toInt(json['quantity']),
        stock: Formatters.toInt(json['stock']),
      );

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        id: id,
        productId: productId,
        variantId: variantId,
        name: name,
        image: image,
        size: size,
        color: color,
        price: price,
        quantity: quantity ?? this.quantity,
        stock: stock,
      );
}

class CartModel {
  CartModel({this.items = const [], this.subtotal = 0, this.shippingFee = 0, this.total = 0, this.itemCount = 0});

  final List<CartItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double total;
  final int itemCount;

  bool get isEmpty => items.isEmpty;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] is Map ? Map<String, dynamic>.from(json['summary'] as Map) : <String, dynamic>{};
    return CartModel(
      items: (json['items'] as List? ?? [])
          .whereType<Map>()
          .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      subtotal: Formatters.toDouble(summary['subtotal']),
      shippingFee: Formatters.toDouble(summary['shippingFee']),
      total: Formatters.toDouble(summary['total']),
      itemCount: Formatters.toInt(summary['itemCount']),
    );
  }
}

class WishlistItemModel {
  WishlistItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.comparePrice,
    this.rating = 0,
    this.thumbnail,
  });

  final String id;
  final String productId;
  final String name;
  final double price;
  final double? comparePrice;
  final double rating;
  final String? thumbnail;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) => WishlistItemModel(
        id: json['id']?.toString() ?? '',
        productId: json['productId']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        price: Formatters.toDouble(json['price']),
        comparePrice: json['comparePrice'] == null ? null : Formatters.toDouble(json['comparePrice']),
        rating: Formatters.toDouble(json['rating']),
        thumbnail: json['thumbnail']?.toString(),
      );
}

class CouponModel {
  CouponModel({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.value,
    this.minSpend = 0,
    this.maxDiscount,
    this.endAt,
  });

  final String id;
  final String code;
  final String name;
  final String type; // PERCENT | FIXED
  final double value;
  final double minSpend;
  final double? maxDiscount;
  final DateTime? endAt;

  String get label => type == 'PERCENT' ? 'ຫຼຸດ ${value.round()}%' : 'ຫຼຸດ ${Formatters.money(value)}';

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        type: json['type']?.toString() ?? 'PERCENT',
        value: Formatters.toDouble(json['value']),
        minSpend: Formatters.toDouble(json['minSpend']),
        maxDiscount: json['maxDiscount'] == null ? null : Formatters.toDouble(json['maxDiscount']),
        endAt: Formatters.parse(json['endAt']),
      );
}
