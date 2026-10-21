import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_list.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'ແຈ້ງເຕືອນ',
        actions: [
          Obx(
            () => controller.notifications.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: controller.markAllRead,
                    child: Text(
                      'ອ່ານທັງໝົດ',
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value && controller.notifications.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: const [LoadingCard(height: 70), LoadingCard(height: 70), LoadingCard(height: 70)]),
          );
        }
        if (controller.notifications.isEmpty) {
          return const EmptyState(
            icon: Icons.notifications_off_outlined,
            title: 'ຍັງບໍ່ມີແຈ້ງເຕືອນ',
            description: 'ແຈ້ງເຕືອນກ່ຽວກັບຄຳສັ່ງຊື້ ແລະ ໂປຣໂມຊັ່ນຈະສະແດງຢູ່ນີ້',
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetch,
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (_, i) {
              final item = controller.notifications[i];
              return InkWell(
                onTap: () => controller.openOrder(item),
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: item.isRead ? Colors.white : AppColors.primaryLight.withValues(alpha: .45),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: item.isRead ? AppColors.surfaceAlt : AppColors.primary.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Icon(
                          controller.iconFor(item.type),
                          size: 16.r,
                          color: item.isRead ? AppColors.textSecondary : AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                                    ),
                                  ),
                                ),
                                if (!item.isRead)
                                  Container(
                                    height: 7.r,
                                    width: 7.r,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              item.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.45),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              Formatters.timeAgo(item.createdAt),
                              style: TextStyle(fontSize: 9.5.sp, color: AppColors.textHint),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
