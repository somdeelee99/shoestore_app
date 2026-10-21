import 'package:get/get.dart';

import '../../data/models/chat_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'auth_service.dart';

/// In-app notification centre (bell + badge).
/// Firebase Messaging can be enabled later inside `initPush()`.
class NotificationService extends GetxService {
  final ChatRepository _repository = ChatRepository();

  final RxList<NotificationModel> items = <NotificationModel>[].obs;
  final RxInt unread = 0.obs;

  Future<void> load() async {
    if (!Get.find<AuthService>().isLoggedIn) return;
    try {
      items.value = await _repository.notifications();
      unread.value = await _repository.unreadCount();
    } catch (_) {
      // silent – the user might not be signed in yet
    }
  }

  Future<void> markRead(String id) async {
    await _repository.markRead(id);
    final index = items.indexWhere((e) => e.id == id);
    if (index >= 0 && items[index].readAt == null) {
      unread.value = (unread.value - 1).clamp(0, 999);
    }
    await load();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    await load();
  }

  /*
  /// Enable when `google-services.json` / `GoogleService-Info.plist` are added.
  Future<void> initPush() async {
    await Firebase.initializeApp();
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await FirebaseMessaging.instance.getToken();
      // send `token` to your backend to store it per user
    }
    FirebaseMessaging.onMessage.listen((message) {
      Get.snackbar(message.notification?.title ?? 'ແຈ້ງເຕືອນ', message.notification?.body ?? '');
    });
  }
  */
}
