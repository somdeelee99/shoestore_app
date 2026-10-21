import 'dart:convert';

import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../storage/local_storage.dart';

/// Single source of truth for the signed-in user.
/// Controllers observe [user] / [isLoggedIn] reactively through GetX.
class AuthService extends GetxService {
  final AuthRepository _repository = AuthRepository();

  final Rxn<UserModel> _user = Rxn<UserModel>();
  final RxBool _loading = false.obs;

  UserModel? get user => _user.value;
  bool get isLoggedIn =>
      _user.value != null || Get.find<LocalStorage>().isLoggedIn;
  RxBool get loading => _loading;
  Rxn<UserModel> get userRx => _user;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final cached = Get.find<LocalStorage>().cachedUser;
    if (cached != null && cached.isNotEmpty) {
      try {
        _user.value =
            UserModel.fromJson(jsonDecode(cached) as Map<String, dynamic>);
      } catch (_) {
        // ignore corrupted cache
      }
    }
    if (Get.find<LocalStorage>().isLoggedIn) refreshProfile();
  }

  Future<void> refreshProfile() async {
    try {
      final me = await _repository.me();
      _user.value = me;
    } catch (_) {
      // token expired – stay silent, guards will redirect
    }
  }

  Future<void> login(String identifier, String password) async {
    _loading.value = true;
    try {
      _user.value = await _repository.login(identifier, password);
    } finally {
      _loading.value = false;
    }
  }

  Future<void> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    _loading.value = true;
    try {
      _user.value = await _repository.register(
          name: name, email: email, phone: phone, password: password);
    } finally {
      _loading.value = false;
    }
  }

  Future<String> requestOtp(String phone) async {
    final res = await _repository.requestOtp(phone);
    final data = res['data'];
    if (data is Map && data['devCode'] != null)
      return data['devCode'].toString();
    return '';
  }

  Future<bool> verifyOtp({required String phone, required String code}) async {
    _loading.value = true;
    try {
      _user.value = await _repository.verifyOtp(phone: phone, code: code);
      return true;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> updateProfile(
      {String? name, String? email, String? avatar}) async {
    _user.value = await _repository.updateProfile({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatar != null) 'avatar': avatar,
    });
  }

  Future<void> changePassword(String current, String next) =>
      _repository.changePassword(current, next);

  Future<void> logout() async {
    await _repository.logout();
    _user.value = null;
  }
}
