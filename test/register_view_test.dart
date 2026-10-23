import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shoestore_app/app/core/services/auth_service.dart';
import 'package:shoestore_app/app/core/theme/app_theme.dart';
import 'package:shoestore_app/app/modules/auth/register/controllers/register_controller.dart';
import 'package:shoestore_app/app/modules/auth/register/views/register_view.dart';

class _AuthStub extends AuthService {
  @override
  void onInit() {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<AuthService>(_AuthStub());
    Get.put(RegisterController());
  });

  tearDown(Get.reset);

  Future<void> pumpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => GetMaterialApp(
          theme: AppTheme.light,
          home: const RegisterView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('phone step renders', (tester) async {
    await pumpView(tester);
    expect(find.text('ສ້າງບັນຊີໃໝ່'), findsOneWidget);
    expect(find.text('ສົ່ງລະຫັດ OTP'), findsOneWidget);
  });

  testWidgets('otp step renders', (tester) async {
    await pumpView(tester);
    final controller = Get.find<RegisterController>();
    controller.phoneDisplay.value = '+856 20 5555 1234';
    controller.secondsLeft.value = 45;
    controller.step.value = 1;
    await tester.pumpAndSettle();
    expect(find.text('ປ້ອນລະຫັດ OTP'), findsOneWidget);
  });

  testWidgets('password step renders', (tester) async {
    await pumpView(tester);
    final controller = Get.find<RegisterController>();
    controller.phoneDisplay.value = '+856 20 5555 1234';
    controller.step.value = 2;
    await tester.pumpAndSettle();
    expect(find.text('ສ້າງບັນຊີ'), findsOneWidget);
  });

  testWidgets('success step renders', (tester) async {
    await pumpView(tester);
    final controller = Get.find<RegisterController>();
    controller.phoneDisplay.value = '+856 20 5555 1234';
    controller.nameController.text = 'ສົມໃຈ';
    controller.step.value = 3;
    await tester.pumpAndSettle();
    expect(find.text('ສ້າງບັນຊີສຳເລັດ'), findsOneWidget);
  });
}
