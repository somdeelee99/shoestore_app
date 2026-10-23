import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shoestore_app/app.dart';
import 'app/core/network/api_client.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/services/notification_service.dart';
import 'app/core/services/socket_service.dart';
import 'app/core/storage/local_storage.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 0));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Core services (dependency injection via GetX)
  await Get.putAsync(() => LocalStorage().init(), permanent: true);
  Get.put(ApiClient(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(SocketService(), permanent: true);
  Get.put(NotificationService(), permanent: true);

  runApp(const App());
}
