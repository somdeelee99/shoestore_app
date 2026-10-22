import 'package:get/get.dart';
import 'package:shoestore_app/app/data/repositories/chat_repository.dart';
import 'package:shoestore_app/app/data/repositories/shop_repository.dart';
import 'package:shoestore_app/app/modules/auth/login/controllers/login_controller.dart';
import 'package:shoestore_app/app/modules/categories/controllers/categories_controller.dart';

import 'package:shoestore_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:shoestore_app/app/modules/orders/list/controllers/orders_controller.dart';
import 'package:shoestore_app/app/modules/profile/main/controllers/profile_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopRepository>(
      () => ShopRepository(),
      fenix: true,
    );

    Get.lazyPut<ChatController>(
      () => ChatController(),
      fenix: true,
    );

    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
    Get.lazyPut<CategoriesController>(
      () => CategoriesController(),
      fenix: true,
    );
    Get.lazyPut(
      () => OrdersController(),
      fenix: true,
    );
    Get.lazyPut(
      () => ChatRepository(),
      fenix: true,
    );
  }
}
