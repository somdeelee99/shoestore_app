import 'package:get/get.dart';

/// Holds the selected bottom-navigation tab for [MainView].
/// Kept permanent so auth guards can reopen the account tab from anywhere.
class MainController extends GetxController {
  static const int homeTab = 0;
  static const int accountTab = 4;

  final RxInt index = homeTab.obs;

  void change(int value) => index.value = value;
  void openAccount() => index.value = accountTab;
}
