import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shoestore_app/app/core/brinding/app_binding.dart';

import 'app/core/network/api_client.dart';
import 'app/core/routes/app_pages.dart';
import 'app/core/routes/app_routes.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/services/notification_service.dart';
import 'app/core/services/socket_service.dart';
import 'app/core/storage/local_storage.dart';
import 'app/core/theme/app_theme.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 0));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Core services (dependency injection via GetX)
  await Get.putAsync(() => LocalStorage().init(), permanent: true);
  Get.put(ApiClient(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(SocketService(), permanent: true);
  Get.put(NotificationService(), permanent: true);

  runApp(const ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  const ShoeStoreApp({super.key});

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
        builder: (context, child) {
          // lock text scaling so the design stays stable
          final mq = MediaQuery.of(context);
          return MediaQuery(
              data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!);
        },
      ),
    );
  }
}
