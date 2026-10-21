import 'package:get/get.dart';

import '../../../../data/repositories/chat_repository.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    if (!Get.isRegistered<ChatRepository>()) Get.lazyPut(() => ChatRepository(), fenix: true);
    Get.lazyPut(() => ProfileController());
  }
}
