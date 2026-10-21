import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Two-tier storage: the JWT lives in the secure keystore,
/// everything else (locale, onboarding flag, recent searches) in SharedPreferences.
class LocalStorage extends GetxService {
  static const _tokenKey = 'shoestore_token';
  static const _refreshKey = 'shoestore_refresh';
  static const _userKey = 'shoestore_user';

  final FlutterSecureStorage _secure = const FlutterSecureStorage();
  late final SharedPreferences _prefs;

  String? _token;
  String? _refreshToken;

  String? get token => _token;
  String? get refreshToken => _refreshToken;

  Future<LocalStorage> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = await _secure.read(key: _tokenKey);
    _refreshToken = await _secure.read(key: _refreshKey);
    return this;
  }

  Future<void> saveSession(
      String token, String refreshToken, String userJson) async {
    _token = token;
    _refreshToken = refreshToken;
    await _secure.write(key: _tokenKey, value: token);
    await _secure.write(key: _refreshKey, value: refreshToken);
    await _prefs.setString(_userKey, userJson);
  }

  Future<void> clearSession() async {
    _token = null;
    _refreshToken = null;
    await _secure.delete(key: _tokenKey);
    await _secure.delete(key: _refreshKey);
    await _prefs.remove(_userKey);
  }

  String? get cachedUser => _prefs.getString(_userKey);

  bool get isFirstRun => _prefs.getBool('first_run') ?? true;
  Future<void> setFirstRunDone() => _prefs.setBool('first_run', false);

  bool get isLoggedIn => (_token ?? '').isNotEmpty;

  // ---- app preferences -------------------------------------------------
  bool get pushEnabled => _prefs.getBool('push_enabled') ?? true;
  Future<void> setPushEnabled(bool value) =>
      _prefs.setBool('push_enabled', value);

  bool get promoEnabled => _prefs.getBool('promo_enabled') ?? true;
  Future<void> setPromoEnabled(bool value) =>
      _prefs.setBool('promo_enabled', value);

  String get language => _prefs.getString('language') ?? 'lo';
  Future<void> setLanguage(String value) => _prefs.setString('language', value);

  bool get darkMode => _prefs.getBool('dark_mode') ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool('dark_mode', value);

  List<String> get recentSearches =>
      _prefs.getStringList('recent_searches') ?? const [];
  Future<void> addRecentSearch(String keyword) async {
    final list = [
      ..._prefs.getStringList('recent_searches') ?? const <String>[]
    ];
    list.removeWhere((e) => e.toLowerCase() == keyword.toLowerCase());
    list.insert(0, keyword);
    await _prefs.setStringList('recent_searches', list.take(10).toList());
  }

  Future<void> clearRecentSearches() => _prefs.remove('recent_searches');
}
