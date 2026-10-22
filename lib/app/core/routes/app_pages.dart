import 'package:get/get.dart';

import '../../modules/auth/login/bindings/login_binding.dart';
import '../../modules/auth/otp/bindings/otp_binding.dart';
import '../../modules/auth/otp/views/otp_view.dart';
import '../../modules/auth/register/bindings/register_binding.dart';
import '../../modules/auth/register/views/register_view.dart';
import '../../modules/cart/bindings/cart_binding.dart';
import '../../modules/cart/views/cart_view.dart';
import '../../modules/categories/bindings/categories_binding.dart';
import '../../modules/categories/views/categories_view.dart';
import '../../modules/chat/bindings/chat_binding.dart';
import '../../modules/chat/views/chat_view.dart';
import '../../modules/checkout/address/bindings/checkout_address_binding.dart';
import '../../modules/checkout/address/views/checkout_address_view.dart';
import '../../modules/checkout/payment/bindings/checkout_payment_binding.dart';
import '../../modules/checkout/payment/views/checkout_payment_view.dart';
import '../../modules/checkout/review/bindings/order_review_binding.dart';
import '../../modules/checkout/review/views/order_review_view.dart';
import '../../modules/checkout/shipping/bindings/checkout_shipping_binding.dart';
import '../../modules/checkout/shipping/views/checkout_shipping_view.dart';
import '../../modules/checkout/success/bindings/order_success_binding.dart';
import '../../modules/checkout/success/views/order_success_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/main_view.dart';
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/onboarding/bindings/onboarding_binding.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/orders/detail/bindings/order_detail_binding.dart';
import '../../modules/orders/detail/views/order_detail_view.dart';
import '../../modules/orders/list/bindings/orders_binding.dart';
import '../../modules/orders/list/views/orders_view.dart';
import '../../modules/orders/tracking/bindings/order_tracking_binding.dart';
import '../../modules/orders/tracking/views/order_tracking_view.dart';
import '../../modules/product/detail/bindings/product_detail_binding.dart';
import '../../modules/product/detail/views/product_detail_view.dart';
import '../../modules/product/list/bindings/product_list_binding.dart';
import '../../modules/product/list/views/product_list_view.dart';
import '../../modules/profile/addresses/bindings/addresses_binding.dart';
import '../../modules/profile/addresses/views/addresses_view.dart';
import '../../modules/profile/addresses/views/address_form_view.dart';
import '../../modules/profile/coupons/bindings/coupons_binding.dart';
import '../../modules/profile/coupons/views/coupons_view.dart';
import '../../modules/profile/edit/bindings/edit_profile_binding.dart';
import '../../modules/profile/edit/views/edit_profile_view.dart';
import '../../modules/profile/main/bindings/profile_binding.dart';
import '../../modules/profile/main/views/account_view.dart';
import '../../modules/profile/settings/bindings/settings_binding.dart';
import '../../modules/profile/settings/views/settings_view.dart';
import '../../modules/profile/wishlist/bindings/wishlist_binding.dart';
import '../../modules/profile/wishlist/views/wishlist_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(
        name: AppRoutes.splash,
        page: () => const SplashView(),
        binding: SplashBinding()),
    GetPage(
        name: AppRoutes.onboarding,
        page: () => const OnboardingView(),
        binding: OnboardingBinding()),

    // auth
    // Login and profile intentionally share one location.
    GetPage(
        name: AppRoutes.login,
        page: () => const AccountView(),
        binding: LoginBinding()),
    GetPage(
        name: AppRoutes.register,
        page: () => const RegisterView(),
        binding: RegisterBinding()),
    GetPage(
        name: AppRoutes.otp,
        page: () => const OtpView(),
        binding: OtpBinding()),

    // home & catalog
    GetPage(
        name: AppRoutes.main,
        page: () => const MainView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.categories,
        page: () => const CategoriesView(),
        binding: CategoriesBinding()),
    GetPage(
        name: AppRoutes.productList,
        page: () => const ProductListView(),
        binding: ProductListBinding()),
    GetPage(
        name: AppRoutes.productDetail,
        page: () => const ProductDetailView(),
        binding: ProductDetailBinding()),

    // cart & checkout
    GetPage(
        name: AppRoutes.cart,
        page: () => const CartView(),
        binding: CartBinding()),
    GetPage(
        name: AppRoutes.checkoutAddress,
        page: () => const CheckoutAddressView(),
        binding: CheckoutAddressBinding()),
    GetPage(
        name: AppRoutes.checkoutShipping,
        page: () => const CheckoutShippingView(),
        binding: CheckoutShippingBinding()),
    GetPage(
        name: AppRoutes.checkoutPayment,
        page: () => const CheckoutPaymentView(),
        binding: CheckoutPaymentBinding()),
    GetPage(
        name: AppRoutes.orderReview,
        page: () => const OrderReviewView(),
        binding: OrderReviewBinding()),
    GetPage(
        name: AppRoutes.orderSuccess,
        page: () => const OrderSuccessView(),
        binding: OrderSuccessBinding()),

    // orders
    GetPage(
        name: AppRoutes.orders,
        page: () => const OrdersView(),
        binding: OrdersBinding()),
    GetPage(
        name: AppRoutes.orderDetail,
        page: () => const OrderDetailView(),
        binding: OrderDetailBinding()),
    GetPage(
        name: AppRoutes.orderTracking,
        page: () => const OrderTrackingView(),
        binding: OrderTrackingBinding()),

    // account
    GetPage(
        name: AppRoutes.profile,
        page: () => const AccountView(),
        binding: ProfileBinding()),
    GetPage(
        name: AppRoutes.editProfile,
        page: () => const EditProfileView(),
        binding: EditProfileBinding()),
    GetPage(
        name: AppRoutes.addresses,
        page: () => const AddressesView(),
        binding: AddressesBinding()),
    GetPage(
        name: AppRoutes.addressForm,
        page: () => const AddressFormView(),
        binding: AddressesBinding()),
    GetPage(
        name: AppRoutes.wishlist,
        page: () => const WishlistView(),
        binding: WishlistBinding()),
    GetPage(
        name: AppRoutes.coupons,
        page: () => const CouponsView(),
        binding: CouponsBinding()),
    GetPage(
        name: AppRoutes.settings,
        page: () => const SettingsView(),
        binding: SettingsBinding()),
    GetPage(
        name: AppRoutes.notifications,
        page: () => const NotificationsView(),
        binding: NotificationsBinding()),

    // chat
    GetPage(
        name: AppRoutes.chat,
        page: () => const ChatView(),
        binding: ChatBinding()),
  ];
}
