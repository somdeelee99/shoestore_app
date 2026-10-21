import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';

import '../constants/api_endpoints.dart';
import '../storage/local_storage.dart';
import 'api_exception.dart';

/// Thin Dio wrapper.
/// - injects the Bearer token
/// - unwraps the `{ success, data, meta }` envelope of the NestJS API
/// - converts errors into readable Lao messages
class ApiClient extends GetxService {
  late final Dio _dio;
  final Logger _log = Get.isRegistered<Logger>() ? Get.find<Logger>() : Get.put(Logger());

  LocalStorage get _storage => Get.find<LocalStorage>();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          _log.w('API error ${error.requestOptions.path}: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      _request(() => _dio.get(path, queryParameters: _clean(query)));

  Future<Map<String, dynamic>> post(String path, {Object? body}) =>
      _request(() => _dio.post(path, data: body));

  Future<Map<String, dynamic>> patch(String path, {Object? body}) =>
      _request(() => _dio.patch(path, data: body));

  Future<Map<String, dynamic>> delete(String path, {Object? body}) =>
      _request(() => _dio.delete(path, data: body));

  Future<Map<String, dynamic>> _request(Future<Response> Function() call) async {
    try {
      final res = await call();
      final json = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{'data': res.data};

      final status = res.statusCode ?? 200;
      if (status >= 400) {
        throw ApiException(_extractMessage(json) ?? 'ເກີດຂໍ້ຜິດພາດ (${status})', statusCode: status);
      }

      if (json['data'] is Map<String, dynamic>) {
        final data = Map<String, dynamic>.from(json['data'] as Map);
        if (json['meta'] != null) data['meta'] = json['meta'];
        return data;
      }
      return <String, dynamic>{
        'data': json['data'],
        if (json['meta'] != null) 'meta': json['meta'],
      };
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw ApiException('ບໍ່ສາມາດເຊື່ອມຕໍ່ເຊີບເວີໄດ້ ກະລຸນາກວດສອບອິນເຕີເນັດ');
      }
      final data = e.response?.data;
      final msg = data is Map ? _extractMessage(Map<String, dynamic>.from(data)) : null;
      throw ApiException(msg ?? e.message ?? 'ເກີດຂໍ້ຜິດພາດ', statusCode: e.response?.statusCode);
    }
  }

  String? _extractMessage(Map<String, dynamic> json) {
    final message = json['message'];
    if (message is List) return message.join(', ');
    if (message is String) return message;
    return null;
  }

  Map<String, dynamic>? _clean(Map<String, dynamic>? query) {
    if (query == null) return null;
    final out = <String, dynamic>{};
    query.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      out[key] = value;
    });
    return out;
  }
}
