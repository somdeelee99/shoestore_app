import 'package:get/get.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';

/// Base class for every remote data source.
/// Providers only speak HTTP + JSON, the repositories turn maps into models.
abstract class ApiProvider {
  ApiProvider() : _client = Get.find<ApiClient>();

  final ApiClient _client;

  ApiClient get client => _client;

  List<T> listOf<T>(dynamic raw, T Function(Map<String, dynamic>) mapper) {
    if (raw is! List) return <T>[];
    return raw
        .whereType<Map>()
        .map((e) => mapper(Map<String, dynamic>.from(e)))
        .toList();
  }

  Never fail(Exception e) =>
      throw (e is ApiException ? e : ApiException(e.toString()));
}

class AuthProvider extends ApiProvider {
  Future<Map<String, dynamic>> login(
          {required String identifier, required String password}) =>
      client.post(ApiEndpoints.login,
          body: {'identifier': identifier, 'password': password});

  Future<Map<String, dynamic>> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) =>
      client.post(ApiEndpoints.register, body: {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        'password': password,
      });

  Future<Map<String, dynamic>> requestOtp(String phone) =>
      client.post(ApiEndpoints.requestOtp, body: {'phone': phone});

  Future<Map<String, dynamic>> verifyOtp(
          {required String phone, required String code, String? name}) =>
      client.post(ApiEndpoints.verifyOtp,
          body: {'phone': phone, 'code': code, if (name != null) 'name': name});

  Future<Map<String, dynamic>> me() => client.get(ApiEndpoints.me);

  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> body) =>
      client.patch(ApiEndpoints.me, body: body);

  Future<Map<String, dynamic>> changePassword(
          {required String current, required String next}) =>
      client.post(ApiEndpoints.changePassword,
          body: {'currentPassword': current, 'newPassword': next});
}

class CatalogProvider extends ApiProvider {
  Future<Map<String, dynamic>> home() => client.get(ApiEndpoints.home);

  Future<Map<String, dynamic>> categories() =>
      client.get(ApiEndpoints.categories);

  Future<Map<String, dynamic>> products(Map<String, dynamic> query) =>
      client.get(ApiEndpoints.products, query: query);

  Future<Map<String, dynamic>> brands() => client.get(ApiEndpoints.brands);

  Future<Map<String, dynamic>> product(String key) =>
      client.get(ApiEndpoints.product(key));

  Future<Map<String, dynamic>> related(String key) =>
      client.get(ApiEndpoints.related(key));

  Future<Map<String, dynamic>> addReview(
          String productId, int rating, String? comment) =>
      client.post(ApiEndpoints.reviews(productId),
          body: {'rating': rating, 'comment': comment});

  Future<Map<String, dynamic>> bestSellers() =>
      client.get(ApiEndpoints.bestSellers);
}

class CartProvider extends ApiProvider {
  Future<Map<String, dynamic>> cart() => client.get(ApiEndpoints.cart);

  Future<Map<String, dynamic>> add(
          {required String productId, String? variantId, int quantity = 1}) =>
      client.post(ApiEndpoints.cart, body: {
        'productId': productId,
        if (variantId != null) 'variantId': variantId,
        'quantity': quantity,
      });

  Future<Map<String, dynamic>> update(String itemId, int quantity) =>
      client.patch(ApiEndpoints.cartItem(itemId), body: {'quantity': quantity});

  Future<Map<String, dynamic>> remove(String itemId) =>
      client.delete(ApiEndpoints.cartItem(itemId));

  Future<Map<String, dynamic>> clear() => client.delete(ApiEndpoints.cart);

  Future<Map<String, dynamic>> wishlist() => client.get(ApiEndpoints.wishlist);

  Future<Map<String, dynamic>> toggleWishlist(String productId) =>
      client.post(ApiEndpoints.wishlistToggle, body: {'productId': productId});
}

class OrderProvider extends ApiProvider {
  Future<Map<String, dynamic>> create(Map<String, dynamic> body) =>
      client.post(ApiEndpoints.orders, body: body);

  Future<Map<String, dynamic>> myOrders({String? status, int page = 1}) =>
      client.get(
        ApiEndpoints.orders,
        query: {'status': status, 'page': page, 'limit': 20},
      );

  Future<Map<String, dynamic>> detail(String id) =>
      client.get(ApiEndpoints.order(id));

  Future<Map<String, dynamic>> tracking(String id) =>
      client.get(ApiEndpoints.orderTracking(id));

  Future<Map<String, dynamic>> cancel(String id) =>
      client.post(ApiEndpoints.cancelOrder(id));

  Future<Map<String, dynamic>> confirmReceived(String id) =>
      client.post(ApiEndpoints.confirmReceived(id));

  Future<Map<String, dynamic>> checkoutOptions() =>
      client.get(ApiEndpoints.checkoutOptions);

  Future<Map<String, dynamic>> validateCoupon(String code, double subtotal) =>
      client.post(ApiEndpoints.validateCoupon,
          body: {'code': code, 'subtotal': subtotal});

  Future<Map<String, dynamic>> coupons() => client.get(ApiEndpoints.coupons);
}

class ProfileProvider extends ApiProvider {
  Future<Map<String, dynamic>> addresses() =>
      client.get(ApiEndpoints.addresses);

  Future<Map<String, dynamic>> createAddress(Map<String, dynamic> body) =>
      client.post(ApiEndpoints.addresses, body: body);

  Future<Map<String, dynamic>> updateAddress(
          String id, Map<String, dynamic> body) =>
      client.patch(ApiEndpoints.address(id), body: body);

  Future<Map<String, dynamic>> deleteAddress(String id) =>
      client.delete(ApiEndpoints.address(id));
}

class ChatProvider extends ApiProvider {
  Future<Map<String, dynamic>> conversation() =>
      client.get(ApiEndpoints.chatConversation);

  Future<Map<String, dynamic>> messages() =>
      client.get(ApiEndpoints.chatMessages);

  Future<Map<String, dynamic>> send(String body) =>
      client.post(ApiEndpoints.chatMessages, body: {'body': body});

  Future<Map<String, dynamic>> notifications() =>
      client.get(ApiEndpoints.notifications);

  Future<Map<String, dynamic>> unreadCount() =>
      client.get(ApiEndpoints.unreadCount);

  Future<Map<String, dynamic>> markRead(String id) =>
      client.patch(ApiEndpoints.readNotification(id));

  Future<Map<String, dynamic>> markAllRead() =>
      client.post(ApiEndpoints.readAllNotifications);
}
