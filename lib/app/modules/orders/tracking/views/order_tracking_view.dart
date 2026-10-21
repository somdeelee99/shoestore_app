import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/loading_list.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingView extends GetView<OrderTrackingController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ຕິດຕາມຄຳສັ່ງຊື້'),
      body: Obx(() {
        final tracking = controller.tracking.value;
        if (tracking == null) {
          return Padding(
              padding: EdgeInsets.all(16.w),
              child: const LoadingCard(height: 120));
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(9.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.local_shipping_rounded,
                            color: Colors.white, size: 20.r),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tracking.trackingNumber ?? 'ລໍຖ້າເລກພັດສະດຸ',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'ຄາດວ່າຈະຮອດ ${Formatters.date(tracking.estimatedDelivery)}',
                              style: TextStyle(
                                  fontSize: 10.5.sp, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      tracking.statusLabel,
                      style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ເສັ້ນທາງການສົ່ງ',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 14.h),
                  ...List.generate(tracking.steps.length, (i) {
                    final step = tracking.steps[i];
                    final isLast = i == tracking.steps.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 22.r,
                                width: 22.r,
                                decoration: BoxDecoration(
                                  color: step.done
                                      ? AppColors.success
                                      : AppColors.surfaceAlt,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: step.done
                                        ? AppColors.success
                                        : AppColors.divider,
                                    width: 1.4,
                                  ),
                                ),
                                child: step.done
                                    ? Icon(Icons.check_rounded,
                                        size: 13.r, color: Colors.white)
                                    : null,
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    margin: EdgeInsets.symmetric(vertical: 2.h),
                                    color: step.done
                                        ? AppColors.success
                                            .withValues(alpha: .4)
                                        : AppColors.divider,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: isLast ? 0 : 18.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step.label,
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      fontWeight: step.done
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: step.done
                                          ? AppColors.textPrimary
                                          : AppColors.textHint,
                                    ),
                                  ),
                                  if (step.at != null)
                                    Text(
                                      Formatters.dateTime(step.at),
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: AppColors.textHint),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Text('ທີ່ຢູ່ຈັດສົ່ງ',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${tracking.recipient} · ${tracking.phone}',
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    tracking.shippingAddress,
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
