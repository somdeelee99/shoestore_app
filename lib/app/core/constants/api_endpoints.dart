/// All routes of the NestJS API used by the Flutter app.
/// Note: the website uses a completely separate `/admin/*` namespace.
class ApiEndpoints {
  ApiEndpoints._();

  /// Use your machine IP (10.0.2.2 for the Android emulator, localhost for iOS sim).
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/api',
  );

  /// Origin used to resolve relative upload paths (`/uploads/...`).
  static const String origin = String.fromEnvironment(
    'API_ORIGIN',
    defaultValue: 'http://10.0.2.2:4000',
  );

  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://10.0.2.2:4000',
  );

  // auth
  static const String login = '/app/auth/login';
  static const String register = '/app/auth/register';
  static const String requestOtp = '/app/auth/otp/request';
  static const String verifyOtp = '/app/auth/otp/verify';
  static const String me = '/app/auth/me';
  static const String changePassword = '/app/auth/change-password';

  // catalog
  static const String home = '/app/home';
  static const String config = '/app/config';
  static const String categories = '/app/categories';
  static const String products = '/app/products';
  static const String brands = '/app/products/brands';
  static const String bestSellers = '/app/products/best-sellers';
  static String product(String key) => '/app/products/$key';
  static String related(String key) => '/app/products/$key/related';
  static String reviews(String id) => '/app/products/$id/reviews';

  // cart / wishlist / addresses
  static const String cart = '/app/cart';
  static String cartItem(String id) => '/app/cart/$id';
  static const String wishlist = '/app/wishlist';
  static const String wishlistToggle = '/app/wishlist/toggle';
  static const String addresses = '/app/addresses';
  static String address(String id) => '/app/addresses/$id';

  // orders & checkout
  static const String orders = '/app/orders';
  static String order(String id) => '/app/orders/$id';
  static String orderTracking(String id) => '/app/orders/$id/tracking';
  static String cancelOrder(String id) => '/app/orders/$id/cancel';
  static String confirmReceived(String id) => '/app/orders/$id/confirm-received';
  static const String checkoutOptions = '/app/checkout/options';

  // coupons
  static const String coupons = '/app/coupons';
  static const String validateCoupon = '/app/coupons/validate';

  // chat & notifications
  static const String chatConversation = '/app/chat/conversation';
  static const String chatMessages = '/app/chat/messages';
  static const String notifications = '/app/notifications';
  static const String unreadCount = '/app/notifications/unread-count';
  static String readNotification(String id) => '/app/notifications/$id/read';
  static const String readAllNotifications = '/app/notifications/read-all';
}
