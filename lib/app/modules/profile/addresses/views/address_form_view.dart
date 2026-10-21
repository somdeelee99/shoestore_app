import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/address_form_controller.dart';

class AddressFormView extends GetView<AddressFormController> {
  const AddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: controller.editing == null ? 'ເພີ່ມທີ່ຢູ່ໃໝ່' : 'ແກ້ໄຂທີ່ຢູ່'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('ປະເພດທີ່ຢູ່', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  children: AddressFormController.labels.map((l) {
                    final selected = controller.label.value == l;
                    return GestureDetector(
                      onTap: () => controller.label.value = l,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 18.h),
              AppTextField(
                controller: controller.recipientController,
                label: 'ຊື່ຜູ້ຮັບ',
                hint: 'ຊື່ ແລະ ນາມສະກຸນ',
                icon: Icons.person_outline_rounded,
                validator: controller.validateRequired,
              ),
              SizedBox(height: 14.h),
              AppTextField(
                controller: controller.phoneController,
                label: 'ເບີໂທ',
                hint: '020 xxxx xxxx',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: controller.validateRequired,
              ),
              SizedBox(height: 14.h),
              AppTextField(
                controller: controller.provinceController,
                label: 'ແຂວງ / ນະຄອນຫຼວງ',
                hint: 'ຕົວຢ່າງ: ນະຄອນຫຼວງວຽງຈັນ',
                icon: Icons.map_outlined,
                validator: controller.validateRequired,
              ),
              SizedBox(height: 14.h),
              AppTextField(
                controller: controller.districtController,
                label: 'ເມືອງ / ກຸ່ມ',
                hint: 'ຕົວຢ່າງ: ເມືອງສີສັດຕະນາກ',
                icon: Icons.location_city_outlined,
                validator: controller.validateRequired,
              ),
              SizedBox(height: 14.h),
              AppTextField(
                controller: controller.villageController,
                label: 'ບ້ານ',
                hint: 'ຊື່ບ້ານ',
                icon: Icons.holiday_village_outlined,
              ),
              SizedBox(height: 14.h),
              AppTextField(
                controller: controller.detailController,
                label: 'ລາຍລະອຽດທີ່ຢູ່',
                hint: 'ເຮືອນເລກ, ຖະໜົນ, ຈຸດສັງເກດ',
                icon: Icons.home_outlined,
                maxLines: 2,
                validator: controller.validateRequired,
              ),
              SizedBox(height: 16.h),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ຕັ້ງເປັນທີ່ຢູ່ຄ່າຕັ້ງຕົ້ນ',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Switch(
                      value: controller.isDefault.value,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) => controller.isDefault.value = v,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Obx(
                () => AppButton(
                  label: 'ບັນທຶກທີ່ຢູ່',
                  loading: controller.loading.value,
                  onPressed: controller.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
