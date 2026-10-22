import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../categories/views/categories_view.dart';
import '../../chat/views/chat_view.dart';
import '../../orders/list/views/orders_view.dart';
import '../../profile/main/views/account_view.dart';
import '../controllers/main_controller.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final MainController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<MainController>()
        ? Get.find<MainController>()
        : Get.put(MainController(), permanent: true);
  }

  final _pages = const [
    HomeView(),
    CategoriesView(),
    OrdersView(),
    ChatView(),
    AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(index: controller.index.value, children: _pages),
        floatingActionButton: controller.index.value == 2
            ? null
            : FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.cart),
                backgroundColor: AppColors.primary,
                elevation: 4,
                child: Icon(Icons.shopping_bag_outlined,
                    color: Colors.white, size: 24.r),
              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: .06),
                  blurRadius: 20,
                  offset: const Offset(0, -6)),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 62.h,
              child: Row(
                children: List.generate(_items.length, (i) {
                  final selected = controller.index.value == i;
                  return Expanded(
                    child: InkWell(
                      onTap: () => controller.change(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected ? _items[i].activeIcon : _items[i].icon,
                            size: 22.r,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            _items[i].label,
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<_NavItem> get _items => const [
        _NavItem(
            label: 'ໜ້າຫຼັກ',
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded),
        _NavItem(
            label: 'ໝວດໝູ່',
            icon: Icons.grid_view_outlined,
            activeIcon: Icons.grid_view_rounded),
        _NavItem(
            label: 'ຄຳສັ່ງຊື້',
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long_rounded),
        _NavItem(
            label: 'ແຊັດ',
            icon: Icons.chat_bubble_outline_rounded,
            activeIcon: Icons.chat_bubble_rounded),
        _NavItem(
            label: 'ໂປຣໄຟລ໌',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded),
      ];
}

class _NavItem {
  const _NavItem(
      {required this.label, required this.icon, required this.activeIcon});

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
