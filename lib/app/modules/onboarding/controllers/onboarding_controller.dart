import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';

class OnboardingPage {
  OnboardingPage(
      {required this.title,
      required this.subtitle,
      required this.image,
      required this.accent});

  final String title;
  final String subtitle;
  final String image;
  final Color accent;
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt index = 0.obs;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'ຊອກຫາເກີບທີ່ໃສ່ແລ້ວມີໄສຕະ',
      subtitle:
          'ຄັດສະເພາະເກີບຄຸນນະພາບຈາກແບຣນຊັ້ນນຳ ທັງ Nike, Adidas, Puma ແລະ ອື່ນໆ',
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=900&q=80',
      accent: Color(0xFFE11D2A),
    ),
    OnboardingPage(
      title: 'Premium Quality',
      subtitle: 'ຄັດເລືອກວັດຖຸດິບຊັ້ນດີ ຕອບສະໜອງຄວາມສະບາຍໃນທຸກກ້າວ',
      image:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=900&q=80',
      accent: Color(0xFF3B82F6),
    ),
    OnboardingPage(
      title: 'Step Into Comfort',
      subtitle: 'ຄົ້ນພົບຄວາມສະບາຍທີ່ແທ້ຈິງ ກັບເກີບທີ່ເໝາະກັບທ່ານ',
      image:
          'https://images.unsplash.com/photo-1600269452121-4f2416e55c28?w=900&q=80',
      accent: Color(0xFF10B981),
    ),
  ];

  void onPageChanged(int value) => index.value = value;

  void next() {
    if (index.value == pages.length - 1) {
      finish();
    } else {
      pageController.nextPage(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic);
    }
  }

  Future<void> finish() async {
    await Get.find<LocalStorage>().setFirstRunDone();
    Get.offAllNamed(AppRoutes.main);
  }
}
