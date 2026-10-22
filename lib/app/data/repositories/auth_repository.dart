import 'package:get/get.dart';

import '../../core/network/api_exception.dart';
import '../../core/storage/local_storage.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class AuthRepository {
  AuthRepository({AuthProvider? provider})
      : _provider = provider ?? AuthProvider();

  final AuthProvider _provider;

  LocalStorage get _storage => Get.find<LocalStorage>();

  Future<UserModel> login(String identifier, String password) async {
    final res =
        await _provider.login(identifier: identifier, password: password);
    return _persist(AuthResult.fromJson(Map<String, dynamic>.from(res)));
  }

  Future<UserModel> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    final res = await _provider.register(
        name: name, email: email, phone: phone, password: password);
    return _persist(AuthResult.fromJson(Map<String, dynamic>.from(res)));
  }

  Future<Map<String, dynamic>> requestOtp(String phone) =>
      _provider.requestOtp(phone);

  Future<UserModel> verifyOtp(
      {required String phone, required String code, String? name}) async {
    final res = await _provider.verifyOtp(phone: phone, code: code, name: name);
    return _persist(AuthResult.fromJson(Map<String, dynamic>.from(res)));
  }

  Future<UserModel> me() async {
    final res = await _provider.me();
    return UserModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<UserModel> updateProfile(Map<String, dynamic> body) async {
    final res = await _provider.updateMe(body);
    final user = UserModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
    if (_storage.token != null) {
      await _storage.saveSession(
          _storage.token!, _storage.refreshToken ?? '', _jsonOf(user));
    }
    return user;
  }

  Future<void> changePassword(String current, String next) async {
    try {
      await _provider.changePassword(current: current, next: next);
    } on ApiException catch (e) {
      throw ApiException(e.message, statusCode: e.statusCode);
    }
  }

  Future<void> logout() => _storage.clearSession();

  Future<UserModel> _persist(AuthResult result) async {
    await _storage.saveSession(
        result.accessToken, result.refreshToken, _jsonOf(result.user));
    return result.user;
  }

  String _jsonOf(UserModel user) =>
      '{"id":"${user.id}","name":"${user.name}","email":"${user.email ?? ''}","phone":"${user.phone ?? ''}","avatar":"${user.avatar ?? ''}","role":"${user.role}"}';
}
