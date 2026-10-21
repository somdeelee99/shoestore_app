import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/api_endpoints.dart';

/// Socket.IO client for the customer chat (namespace `/chat`).
/// Mirrors the gateway used by the admin panel.
class SocketService extends GetxService {
  io.Socket? _socket;
  final Logger _log = Logger();

  final RxBool connected = false.obs;
  final RxnString conversationId = RxnString();

  io.Socket connect(
      {String? conversationId,
      required void Function(Map<String, dynamic>) onMessage}) {
    this.conversationId.value = conversationId;
    _socket?.dispose();

    _socket = io.io(
      '${ApiEndpoints.socketUrl}/chat',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionAttempts(5)
          .build(),
    );

    _socket!.onConnect((_) {
      connected.value = true;
      _log.i('chat socket connected');
      if (conversationId != null) {
        _socket!.emit('chat:join',
            {'conversationId': conversationId, 'role': 'CUSTOMER'});
      }
    });

    _socket!.onDisconnect((_) {
      connected.value = false;
    });

    _socket!.on('chat:message', (data) {
      if (data is Map) onMessage(Map<String, dynamic>.from(data));
    });

    _socket!.onConnectError((err) => _log.w('socket error: $err'));

    _socket!.connect();
    return _socket!;
  }

  void send(
      {required String conversationId,
      required String body,
      String? senderId}) {
    _socket?.emit('chat:send', {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderRole': 'CUSTOMER',
      'body': body,
    });
  }

  void typing({required String conversationId, required bool isTyping}) {
    _socket?.emit('chat:typing', {
      'conversationId': conversationId,
      'role': 'CUSTOMER',
      'isTyping': isTyping,
    });
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
    connected.value = false;
  }

  @override
  void onClose() {
    _socket?.dispose();
    super.onClose();
  }
}
