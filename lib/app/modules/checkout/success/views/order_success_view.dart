import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/order_success_controller.dart';

class OrderSuccessView extends GetView<OrderSuccessController> {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 120.r,
                width: 120.r,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    height: 84.r,
                    width: 84.r,
                    decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    child: Icon(Icons.check_rounded, size: 46.r, color: Colors.white),
                  ),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              SizedBox(height: 26.h),
              Text(
                'ສັ່ງຊື້ສຳເລັດ!',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ).animate().fadeIn(delay: 200.ms),
              SizedBox(height: 8.h),
              Text(
                'ຂອບໃຈສຳລັບການສັ່ງຊື້ ພວກເຮົາຈະຕິດຕໍ່ກັບທ່ານໂດຍໄວ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary, height: 1.6),
              ).animate().fadeIn(delay: 300.ms),
              if (order != null) ...[
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Column(
                    children: [
                      _row('ເລກທີຄຳສັ່ງຊື້', order.code),
                      SizedBox(height: 8.h),
                      _row('ວັນທີ', Formatters.dateTime(order.createdAt)),
                      SizedBox(height: 8.h),
                      _row('ການຊຳລະ', order.paymentStatus == 'PAID' ? 'ຊຳລະແລ້ວ' : 'ຍັງບໍ່ຊຳລະ'),
                      Divider(height: 18.h),
                      _row('ຍອດລວມ', Formatters.money(order.total), bold: true),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: .15),
              ],
              const Spacer(),
              AppButton(label: 'ຕິດຕາມຄຳສັ່ງຊື້', icon: Icons.local_shipping_outlined, onPressed: controller.trackOrder),
              SizedBox(height: 10.h),
              AppButton(label: 'ກັບໜ້າຫຼັກ', outlined: true, onPressed: controller.backHome),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) => Row(
        children: [
          Text(label, style: TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: bold ? 14.sp : 12.sp,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
                color: bold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      );
}
