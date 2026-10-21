import 'package:get/get.dart';

import '../../../data/repositories/chat_repository.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChatRepository>())
      Get.lazyPut(() => ChatRepository(), fenix: true);
    Get.lazyPut(() => ChatController());
  }
}
