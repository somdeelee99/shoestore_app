import '../../core/utils/formatters.dart';

class OrderItemModel {
  OrderItemModel({
    required this.id,
    required this.name,
    this.image,
    this.size,
    this.color,
    required this.price,
    required this.quantity,
  });

  final String id;
  final String name;
  final String? image;
  final String? size;
  final String? color;
  final double price;
  final int quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        image: json['image']?.toString(),
        size: json['size']?.toString(),
        color: json['color']?.toString(),
        price: Formatters.toDouble(json['price']),
        quantity: Formatters.toInt(json['quantity']),
      );
}

class OrderStatusHistoryModel {
  OrderStatusHistoryModel({required this.status, this.note, this.createdAt});

  final String status;
  final String? note;
  final DateTime? createdAt;

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) => OrderStatusHistoryModel(
        status: json['status']?.toString() ?? '',
        note: json['note']?.toString(),
        createdAt: Formatters.parse(json['createdAt']),
      );
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.code,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.subtotal,
    this.shippingFee = 0,
    this.discount = 0,
    required this.total,
    this.recipient = '',
    this.phone = '',
    this.shippingAddress = '',
    this.trackingNumber,
    this.note,
    this.items = const [],
    this.history = const [],
    this.customerName,
    this.customerAvatar,
    this.createdAt,
    this.itemCount,
  });

  final String id;
  final String code;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String shippingMethod;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final String recipient;
  final String phone;
  final String shippingAddress;
  final String? trackingNumber;
  final String? note;
  final List<OrderItemModel> items;
  final List<OrderStatusHistoryModel> history;
  final String? customerName;
  final String? customerAvatar;
  final DateTime? createdAt;
  final int? itemCount;

  int get totalQuantity => itemCount ?? items.fold(0, (sum, i) => sum + i.quantity);

  bool get canCancel => status == 'PENDING' || status == 'CONFIRMED';
  bool get canConfirmReceived => status == 'SHIPPING';

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        status: json['status']?.toString() ?? 'PENDING',
        paymentStatus: json['paymentStatus']?.toString() ?? 'UNPAID',
        paymentMethod: json['paymentMethod']?.toString() ?? 'COD',
        shippingMethod: json['shippingMethod']?.toString() ?? 'STANDARD',
        subtotal: Formatters.toDouble(json['subtotal']),
        shippingFee: Formatters.toDouble(json['shippingFee']),
        discount: Formatters.toDouble(json['discount']),
        total: Formatters.toDouble(json['total']),
        recipient: json['recipient']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        shippingAddress: json['shippingAddress']?.toString() ?? '',
        trackingNumber: json['trackingNumber']?.toString(),
        note: json['note']?.toString(),
        items: (json['items'] as List? ?? [])
            .whereType<Map>()
            .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        history: (json['history'] as List? ?? [])
            .whereType<Map>()
            .map((e) => OrderStatusHistoryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        customerName: json['customer'] is Map ? json['customer']['name']?.toString() : null,
        customerAvatar: json['customer'] is Map ? json['customer']['avatar']?.toString() : null,
        createdAt: Formatters.parse(json['createdAt']),
        itemCount: json['itemCount'] == null ? null : Formatters.toInt(json['itemCount']),
      );
}

class TrackingStepModel {
  TrackingStepModel({required this.status, required this.label, required this.done, this.at});

  final String status;
  final String label;
  final bool done;
  final DateTime? at;

  factory TrackingStepModel.fromJson(Map<String, dynamic> json) => TrackingStepModel(
        status: json['status']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
        done: json['done'] == true,
        at: Formatters.parse(json['at']),
      );
}

class TrackingModel {
  TrackingModel({
    required this.code,
    required this.status,
    required this.statusLabel,
    this.trackingNumber,
    required this.recipient,
    required this.phone,
    required this.shippingAddress,
    this.estimatedDelivery,
    this.steps = const [],
  });

  final String code;
  final String status;
  final String statusLabel;
  final String? trackingNumber;
  final String recipient;
  final String phone;
  final String shippingAddress;
  final DateTime? estimatedDelivery;
  final List<TrackingStepModel> steps;

  factory TrackingModel.fromJson(Map<String, dynamic> json) => TrackingModel(
        code: json['code']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        statusLabel: json['statusLabel']?.toString() ?? '',
        trackingNumber: json['trackingNumber']?.toString(),
        recipient: json['recipient']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        shippingAddress: json['shippingAddress']?.toString() ?? '',
        estimatedDelivery: Formatters.parse(json['estimatedDelivery']),
        steps: (json['steps'] as List? ?? [])
            .whereType<Map>()
            .map((e) => TrackingStepModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class ShippingOptionModel {
  ShippingOptionModel({required this.id, required this.name, required this.eta, required this.fee});

  final String id;
  final String name;
  final String eta;
  final double fee;

  factory ShippingOptionModel.fromJson(Map<String, dynamic> json) => ShippingOptionModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        eta: json['eta']?.toString() ?? '',
        fee: Formatters.toDouble(json['fee']),
      );
}

class PaymentOptionModel {
  PaymentOptionModel({required this.id, required this.name, this.icon});

  final String id;
  final String name;
  final String? icon;

  factory PaymentOptionModel.fromJson(Map<String, dynamic> json) => PaymentOptionModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        icon: json['icon']?.toString(),
      );
}

class CheckoutOptionsModel {
  CheckoutOptionsModel({this.shipping = const [], this.payments = const []});

  final List<ShippingOptionModel> shipping;
  final List<PaymentOptionModel> payments;

  factory CheckoutOptionsModel.fromJson(Map<String, dynamic> json) => CheckoutOptionsModel(
        shipping: (json['shipping'] as List? ?? [])
            .whereType<Map>()
            .map((e) => ShippingOptionModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        payments: (json['payments'] as List? ?? [])
            .whereType<Map>()
            .map((e) => PaymentOptionModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}
