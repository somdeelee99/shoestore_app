import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class CouponsController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final RxList<CouponModel> coupons = <CouponModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        coupons.assignAll(await _repository.coupons());
      }, showLoading: coupons.isEmpty);
    } catch (_) {}
  }

  Future<void> copyCode(CouponModel coupon) async {
    await Clipboard.setData(ClipboardData(text: coupon.code));
    AppSnackbar.success('ຄັດລອກລະຫັດ ${coupon.code} ແລ້ວ');
  }

  void useCoupon(CouponModel coupon) {
    Clipboard.setData(ClipboardData(text: coupon.code));
    AppSnackbar.info('ລະຫັດ ${coupon.code} ຖືກຄັດລອກແລ້ວ ໃຊ້ໄດ້ທີ່ໜ້າກະຕ່າ');
    Get.toNamed(AppRoutes.cart);
  }
}
