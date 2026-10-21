import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class AddressesController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool selectMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectMode.value = Get.arguments == 'select';
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        addresses.assignAll(await _repository.addresses());
      }, showLoading: addresses.isEmpty);
    } catch (_) {}
  }

  void create() => Get.toNamed(AppRoutes.addressForm);

  void edit(AddressModel address) => Get.toNamed(AppRoutes.addressForm, arguments: address);

  void select(AddressModel address) {
    if (!selectMode.value) return;
    Get.back(result: address);
  }

  Future<void> remove(AddressModel address) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('ລຶບທີ່ຢູ່'),
        content: Text('ຕ້ອງການລຶບ "${address.label}" ແທ້ບໍ?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('ຍົກເລີກ')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('ລຶບ')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repository.deleteAddress(address.id);
      addresses.removeWhere((a) => a.id == address.id);
      AppSnackbar.success('ລຶບທີ່ຢູ່ແລ້ວ');
    } catch (_) {
      AppSnackbar.error('ລຶບບໍ່ສຳເລັດ');
    }
  }
}
