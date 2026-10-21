import '../../core/utils/formatters.dart';

class ChatMessageModel {
  ChatMessageModel({
    required this.id,
    required this.body,
    required this.senderRole,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.createdAt,
  });

  final String id;
  final String body;
  final String senderRole; // CUSTOMER | STAFF
  final String? senderId;
  final String? senderName;
  final String? senderAvatar;
  final DateTime? createdAt;

  bool get isMine => senderRole == 'CUSTOMER';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        id: json['id']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        senderRole: json['senderRole']?.toString() ?? 'CUSTOMER',
        senderId: json['senderId']?.toString(),
        senderName: json['sender'] is Map ? json['sender']['name']?.toString() : null,
        senderAvatar: json['sender'] is Map ? json['sender']['avatar']?.toString() : null,
        createdAt: Formatters.parse(json['createdAt']),
      );
}

class ChatConversationModel {
  ChatConversationModel({required this.id, this.messages = const [], this.unread = 0});

  final String id;
  final List<ChatMessageModel> messages;
  final int unread;

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) => ChatConversationModel(
        id: json['id']?.toString() ?? '',
        unread: Formatters.toInt(json['unreadForCustomer']),
        messages: (json['messages'] as List? ?? [])
            .whereType<Map>()
            .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'SYSTEM',
    this.readAt,
    this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime? readAt;
  final DateTime? createdAt;

  bool get isRead => readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        type: json['type']?.toString() ?? 'SYSTEM',
        readAt: Formatters.parse(json['readAt']),
        createdAt: Formatters.parse(json['createdAt']),
      );
}
