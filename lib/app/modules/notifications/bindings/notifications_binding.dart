import 'package:get/get.dart';

import '../../../data/repositories/chat_repository.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChatRepository>()) Get.lazyPut(() => ChatRepository(), fenix: true);
    Get.lazyPut(() => NotificationsController());
  }
}
