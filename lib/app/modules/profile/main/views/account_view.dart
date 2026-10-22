import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../auth/login/views/login_view.dart';
import 'profile_view.dart';

/// Single location shared by login and profile.
///
/// - signed out -> [LoginView]
/// - signed in  -> [ProfileView]
///
/// Because both views live at this same position, registering or logging in
/// swaps the login view for the profile view, and logging out swaps it back.
class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    return Obx(
      () => auth.isLoggedIn ? const ProfileView() : const LoginView(),
    );
  }
}
