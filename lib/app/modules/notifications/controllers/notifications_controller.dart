import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/repositories/chat_repository.dart';

class NotificationsController extends BaseController {
  final ChatRepository _repository = Get.find<ChatRepository>();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        notifications.assignAll(await _repository.notifications());
      }, showLoading: notifications.isEmpty);
    } catch (_) {}
  }

  Future<void> markRead(NotificationModel item) async {
    if (item.isRead) return;
    try {
      await _repository.markRead(item.id);
      final index = notifications.indexWhere((n) => n.id == item.id);
      if (index >= 0) {
        notifications[index] = NotificationModel(
          id: item.id,
          title: item.title,
          body: item.body,
          type: item.type,
          readAt: DateTime.now(),
          createdAt: item.createdAt,
        );
      }
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _repository.markAllRead();
      await fetch();
      AppSnackbar.success('ອ່ານທັງໝົດແລ້ວ');
    } catch (_) {
      AppSnackbar.error('ດຳເນີນການບໍ່ສຳເລັດ');
    }
  }

  void openOrder(NotificationModel item) {
    markRead(item);
    Get.toNamed(AppRoutes.orders);
  }

  IconData iconFor(String type) {
    switch (type) {
      case 'ORDER':
        return Icons.receipt_long_outlined;
      case 'PROMOTION':
        return Icons.local_offer_outlined;
      case 'CHAT':
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}
