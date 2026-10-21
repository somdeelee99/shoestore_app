class AppRoutes {
  AppRoutes._();

  // 1-4 onboarding & auth
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';

  // 5-9 home & catalog
  static const main = '/main';
  static const home = '/main';
  static const categories = '/categories';
  static const productList = '/products';
  static const productDetail = '/product';
  static const search = '/search';

  // 10-15 cart & checkout
  static const cart = '/cart';
  static const checkoutAddress = '/checkout/address';
  static const checkoutShipping = '/checkout/shipping';
  static const checkoutPayment = '/checkout/payment';
  static const orderReview = '/checkout/review';
  static const orderSuccess = '/checkout/success';
  static const addressForm = '/address/form';

  // 16-20 orders
  static const orders = '/orders';
  static const orderDetail = '/order';
  static const orderTracking = '/order/tracking';

  // 21-27 account
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const addresses = '/addresses';
  static const wishlist = '/wishlist';
  static const coupons = '/coupons';
  static const settings = '/settings';
  static const notifications = '/notifications';

  // 28-30 chat
  static const chat = '/chat';
}
