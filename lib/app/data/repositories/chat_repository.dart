import '../models/chat_model.dart';
import '../providers/api_provider.dart';

class ChatRepository {
  ChatRepository({ChatProvider? provider}) : _provider = provider ?? ChatProvider();

  final ChatProvider _provider;

  Future<ChatConversationModel> conversation() async {
    final res = await _provider.conversation();
    return ChatConversationModel.fromJson(Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<List<ChatMessageModel>> messages() async {
    final res = await _provider.messages();
    return _provider.listOf(res['data'], ChatMessageModel.fromJson);
  }

  Future<ChatMessageModel> send(String body) async {
    final res = await _provider.send(body);
    return ChatMessageModel.fromJson(Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<List<NotificationModel>> notifications() async {
    final res = await _provider.notifications();
    return _provider.listOf(res['data'], NotificationModel.fromJson);
  }

  Future<int> unreadCount() async {
    final res = await _provider.unreadCount();
    final data = res['data'];
    if (data is Map) {
      final count = data['count'];
      return int.tryParse(count?.toString() ?? '0') ?? 0;
    }
    return 0;
  }

  Future<void> markRead(String id) => _provider.markRead(id);

  Future<void> markAllRead() => _provider.markAllRead();
}
