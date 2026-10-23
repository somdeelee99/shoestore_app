import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shoestore_app/app/core/brinding/app_binding.dart';
import 'package:shoestore_app/app/core/routes/app_pages.dart';
import 'package:shoestore_app/app/core/routes/app_routes.dart';
import 'package:shoestore_app/app/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        title: 'ShoeStore',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 280),
        initialBinding: AppBinding(),
        locale: const Locale('lo', 'LA'),
        fallbackLocale: const Locale('en', 'US'),
      ),
    );
  }
}
