import '../constants/api_endpoints.dart';

/// Resolves relative API paths (`/uploads/...`) into absolute URLs.
class AssetService {
  AssetService._();

  static String url(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${ApiEndpoints.origin}$path';
  }
}
