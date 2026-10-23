import 'package:get/get.dart';

import '../network/api_exception.dart';

/// Shared MVVM controller base:
/// every ViewModel exposes the same loading / error surface,
/// so the views stay dumb and declarative.
abstract class BaseController extends GetxController {
  final RxBool loading = false.obs;
  final RxnString error = RxnString();
  final RxnString message = RxnString();

  Future<T?> guard<T>(Future<T> Function() task,
      {bool showLoading = true}) async {
    if (showLoading) loading.value = true;
    error.value = null;
    try {
      return await task();
    } on ApiException catch (e) {
      error.value = e.message;
      rethrow;
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      if (showLoading) loading.value = false;
    }
  }
}
