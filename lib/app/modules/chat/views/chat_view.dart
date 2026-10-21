import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'ສະໜັບສະໜູນ',
        actions: [
          Obx(
            () => Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Row(
                children: [
                  Container(
                    height: 7.r,
                    width: 7.r,
                    decoration: BoxDecoration(
                      color: controller.connected.value
                          ? AppColors.success
                          : AppColors.textHint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    controller.connected.value ? 'ອອນລາຍ' : 'ອອບລາຍ',
                    style:
                        TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isLoggedIn) {
          return const EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'ເຂົ້າສູ່ລະບົບເພື່ອສົນທະນາ',
            description: 'ທີມງານຂອງພວກເຮົາພ້ອມຊ່ວຍເຫຼືອທ່ານ',
          );
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    height: 38.r,
                    width: 38.r,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryLight, shape: BoxShape.circle),
                    child: Icon(Icons.support_agent_rounded,
                        size: 20.r, color: AppColors.primary),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ທີມງານ ShoeStore',
                          style: TextStyle(
                              fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'ຕອບໄວພາຍໃນ 5 ນາທີ · 08:00 - 20:00',
                          style: TextStyle(
                              fontSize: 10.sp, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.messages.isEmpty
                  ? const EmptyState(
                      icon: Icons.waving_hand_outlined,
                      title: 'ເລີ່ມການສົນທະນາ',
                      description:
                          'ສົ່ງຂໍ້ຄວາມຫາທີມງານ ເພື່ອສອບຖາມກ່ຽວກັບສິນຄ້າ ຫຼື ຄຳສັ່ງຊື້',
                    )
                  : ListView.builder(
                      controller: controller.scroll,
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                      itemCount: controller.messages.length,
                      itemBuilder: (_, i) {
                        final message = controller.messages[i];
                        return _bubble(message);
                      },
                    ),
            ),
            if (controller.partnerTyping.value)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'ກຳລັງພິມ...',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textHint,
                      fontStyle: FontStyle.italic),
                ),
              ),
            _quickReplies(),
            _composer(),
          ],
        );
      }),
    );
  }

  Widget _bubble(dynamic message) {
    final mine = message.senderRole == 'CUSTOMER';
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            Container(
              height: 28.r,
              width: 28.r,
              decoration: const BoxDecoration(
                  color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Icon(Icons.support_agent_rounded,
                  size: 15.r, color: AppColors.primary),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: mine ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                  bottomLeft: Radius.circular(mine ? 14.r : 4.r),
                  bottomRight: Radius.circular(mine ? 4.r : 14.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.45,
                      color: mine ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    Formatters.time(message.createdAt),
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: mine
                          ? Colors.white.withValues(alpha: .75)
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickReplies() => Obx(
        () => controller.messages.length > 3
            ? const SizedBox.shrink()
            : SizedBox(
                height: 34.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: ChatController.quickReplies
                      .map(
                        (reply) => Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: GestureDetector(
                            onTap: () => controller.send(reply),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Text(
                                reply,
                                style: TextStyle(
                                    fontSize: 10.5.sp,
                                    color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
      );

  Widget _composer() => Container(
        padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 12,
                offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: TextField(
                    controller: controller.input,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (v) {
                      controller.onInputChanged(v);
                      if (v.isNotEmpty) controller.startTyping();
                    },
                    style: TextStyle(fontSize: 12.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ພິມຂໍ້ຄວາມ...',
                      hintStyle:
                          TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: controller.send,
                child: Container(
                  height: 42.r,
                  width: 42.r,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child:
                      Icon(Icons.send_rounded, size: 18.r, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
}
