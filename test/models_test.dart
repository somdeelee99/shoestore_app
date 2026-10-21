import 'package:flutter_test/flutter_test.dart';
import 'package:shoestore_app/app/core/utils/formatters.dart';
import 'package:shoestore_app/app/core/utils/validators.dart';
import 'package:shoestore_app/app/data/models/cart_model.dart';
import 'package:shoestore_app/app/data/models/order_model.dart';
import 'package:shoestore_app/app/data/models/product_model.dart';

void main() {
  group('Formatters', () {
    test('money uses Lao kip suffix', () {
      expect(Formatters.money(1500000), '1,500,000 ₭');
      expect(Formatters.money(null), '0 ₭');
    });

    test('toDouble / toInt tolerate strings', () {
      expect(Formatters.toDouble('249000'), 249000);
      expect(Formatters.toInt('3'), 3);
      expect(Formatters.toInt(null), 0);
    });
  });

  group('Validators', () {
    test('rejects short password', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Models', () {
    test('OrderModel parses items, totals and status flags', () {
      final order = OrderModel.fromJson({
        'id': 'o1',
        'code': 'ORD-1001',
        'status': 'PENDING',
        'paymentStatus': 'UNPAID',
        'paymentMethod': 'COD',
        'shippingMethod': 'STANDARD',
        'subtotal': 498000,
        'shippingFee': 30000,
        'discount': 0,
        'total': 528000,
        'recipient': 'ນາງ ສົມໃຈ',
        'phone': '02055551234',
        'shippingAddress': 'ບ້ານ ສີສັດຕະນາກ, ວຽງຈັນ',
        'items': [
          {'id': 'i1', 'name': 'Nike Air Max', 'price': '249000', 'quantity': 2, 'size': '42', 'color': 'ດຳ'},
        ],
        'createdAt': '2026-10-20T09:30:00.000Z',
      });

      expect(order.code, 'ORD-1001');
      expect(order.items.single.quantity, 2);
      expect(order.totalQuantity, 2);
      expect(order.canCancel, isTrue);
      expect(order.canConfirmReceived, isFalse);
      expect(order.createdAt, isNotNull);
    });

    test('CartModel computes item count and subtotal', () {
      final cart = CartModel.fromJson({
        'id': 'c1',
        'items': [
          {
            'id': 'ci1',
            'productId': 'p1',
            'name': 'Adidas Ultraboost',
            'price': 320000,
            'quantity': 2,
            'size': '41',
          },
        ],
        'summary': {'subtotal': 640000, 'shippingFee': 0, 'total': 640000, 'itemCount': 2},
      });

      expect(cart.itemCount, 2);
      expect(cart.subtotal, 640000);
    });

    test('ProductModel exposes variants and price range', () {
      final product = ProductModel.fromJson({
        'id': 'p1',
        'name': 'Nike Air Force 1',
        'price': 259000,
        'comparePrice': 320000,
        'rating': 4.7,
        'variants': [
          {'id': 'v1', 'size': '40', 'color': 'ຂາວ', 'stock': 4, 'price': 259000},
          {'id': 'v2', 'size': '41', 'color': 'ດຳ', 'stock': 0, 'price': 259000},
        ],
      });

      expect(product.variants.length, 2);
      expect(product.discountPercent, greaterThan(0));
    });

    test('CouponModel label reflects the discount type', () {
      final percent = CouponModel.fromJson({
        'id': 'cp1',
        'code': 'WELCOME10',
        'name': 'ລູກຄ້າໃໝ່',
        'type': 'PERCENT',
        'value': 10,
        'minSpend': 200000,
      });
      expect(percent.label, 'ຫຼຸດ 10%');
    });
  });
}
