import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/socket_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatController extends BaseController {
  final ChatRepository _repository = Get.find<ChatRepository>();
  final SocketService _socket = Get.find<SocketService>();
  final AuthService _auth = Get.find<AuthService>();

  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxString conversationId = ''.obs;
  final RxBool typing = false.obs;
  final RxBool partnerTyping = false.obs;
  final RxBool connected = false.obs;

  final TextEditingController input = TextEditingController();
  final ScrollController scroll = ScrollController();

  Timer? _poll;
  Timer? _typingTimer;

  static const quickReplies = [
    'ສະບາຍດີ ຕ້ອງການສອບຖາມສິນຄ້າ',
    'ສິນຄ້າຍັງມີສາງບໍ?',
    'ສົ່ງໃນວຽງຈັນຈັກວັນ?',
    'ຕ້ອງການແຈ້ງເລກພັດສະດຸ',
  ];

  bool get isLoggedIn => _auth.isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) _start();
  }

  Future<void> _start() async {
    await fetch();
    _connectSocket();
    _poll =
        Timer.periodic(const Duration(seconds: 12), (_) => fetch(silent: true));
  }

  void _connectSocket() {
    try {
      _socket.connect(
        conversationId:
            conversationId.value.isEmpty ? null : conversationId.value,
        onMessage: (data) {
          final message = ChatMessageModel.fromJson(data['message'] is Map
              ? Map<String, dynamic>.from(data['message'] as Map)
              : data);
          if (message.id.isEmpty) return;
          if (messages.any((m) => m.id == message.id)) return;
          messages.add(message);
          _scrollToEnd();
        },
      );
      connected.value = true;
    } catch (_) {
      connected.value = false;
    }
  }

  Future<void> fetch({bool silent = false}) async {
    try {
      final conversation = await _repository.conversation();
      conversationId.value = conversation.id;
      final list = await _repository.messages();
      if (list.length != messages.length) {
        messages.assignAll(list);
        _scrollToEnd();
      }
    } catch (_) {
      if (!silent) _loadFailed();
    }
  }

  void _loadFailed() {
    if (!(error.value ?? '').isEmpty) return;
    AppSnackbar.error('ໂຫຼດຂໍ້ຄວາມບໍ່ສຳເລັດ');
  }

  void onInputChanged(String value) {
    if (value.trim().isEmpty && typing.value) {
      typing.value = false;
      _socket.typing(conversationId: conversationId.value, isTyping: false);
    }
  }

  Future<void> send([String? preset]) async {
    final text = (preset ?? input.text).trim();
    if (text.isEmpty) return;
    input.clear();
    typing.value = false;

    final optimistic = ChatMessageModel(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      body: text,
      senderRole: 'CUSTOMER',
      createdAt: DateTime.now(),
    );
    messages.add(optimistic);
    _scrollToEnd();

    try {
      final sent = await _repository.send(text);
      final index = messages.indexWhere((m) => m.id == optimistic.id);
      if (index >= 0) messages[index] = sent;
    } catch (_) {
      messages.removeWhere((m) => m.id == optimistic.id);
      AppSnackbar.error('ສົ່ງຂໍ້ຄວາມບໍ່ສຳເລັດ');
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      scroll.animateTo(
        scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  void startTyping() {
    if (conversationId.value.isEmpty) return;
    if (!typing.value) {
      typing.value = true;
      _socket.typing(conversationId: conversationId.value, isTyping: true);
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      typing.value = false;
      _socket.typing(conversationId: conversationId.value, isTyping: false);
    });
  }

  @override
  void onClose() {
    _poll?.cancel();
    _typingTimer?.cancel();
    _socket.disconnect();
    input.dispose();
    scroll.dispose();
    super.onClose();
  }
}
