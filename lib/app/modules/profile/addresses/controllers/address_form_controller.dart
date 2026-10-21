import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class AddressFormController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final formKey = GlobalKey<FormState>();
  final recipientController = TextEditingController();
  final phoneController = TextEditingController();
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final villageController = TextEditingController();
  final detailController = TextEditingController();

  final RxString label = 'ເຮືອນ'.obs;
  final RxBool isDefault = false.obs;

  AddressModel? editing;

  static const labels = ['ເຮືອນ', 'ຫ້ອງການ', 'ອື່ນໆ'];

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is AddressModel) {
      editing = arg;
      recipientController.text = arg.recipient;
      phoneController.text = arg.phone;
      provinceController.text = arg.province;
      districtController.text = arg.district;
      villageController.text = arg.village ?? '';
      detailController.text = arg.detail;
      label.value = arg.label;
      isDefault.value = arg.isDefault;
    }
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final body = {
      'label': label.value,
      'recipient': recipientController.text.trim(),
      'phone': phoneController.text.trim(),
      'province': provinceController.text.trim(),
      'district': districtController.text.trim(),
      'village': villageController.text.trim(),
      'detail': detailController.text.trim(),
      'isDefault': isDefault.value,
    };
    try {
      await guard(() async {
        if (editing == null) {
          await _repository.createAddress(body);
        } else {
          await _repository.updateAddress(editing!.id, body);
        }
      });
      AppSnackbar.success(editing == null ? 'ເພີ່ມທີ່ຢູ່ສຳເລັດ' : 'ອັບເດດທີ່ຢູ່ສຳເລັດ');
      Get.back(result: true);
    } catch (_) {}
  }

  String? validateRequired(String? v) => Validators.required(v);

  @override
  void onClose() {
    recipientController.dispose();
    phoneController.dispose();
    provinceController.dispose();
    districtController.dispose();
    villageController.dispose();
    detailController.dispose();
    super.onClose();
  }
}
