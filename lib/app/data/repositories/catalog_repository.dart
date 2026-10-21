import '../models/product_model.dart';
import '../providers/api_provider.dart';

class CatalogRepository {
  CatalogRepository({CatalogProvider? provider}) : _provider = provider ?? CatalogProvider();

  final CatalogProvider _provider;

  Future<HomeModel> home() async {
    final res = await _provider.home();
    return HomeModel.fromJson(Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<List<CategoryModel>> categories() async {
    final res = await _provider.categories();
    return _provider.listOf(res['data'], CategoryModel.fromJson);
  }

  Future<List<ProductModel>> products(Map<String, dynamic> query) async {
    final res = await _provider.products(query);
    return _provider.listOf(res['data'], ProductModel.fromJson);
  }

  Future<List<ProductModel>> bestSellers() async {
    final res = await _provider.bestSellers();
    return _provider.listOf(res['data'], ProductModel.fromJson);
  }

  Future<List<String>> brands() async {
    final raw = await _provider.brands();
    final data = raw['data'];
    if (data is List) return data.map((e) => e.toString()).toList();
    return <String>[];
  }

  Future<ProductModel> product(String key) async {
    final res = await _provider.product(key);
    return ProductModel.fromJson(Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<List<ProductModel>> related(String key) async {
    final res = await _provider.related(key);
    return _provider.listOf(res['data'], ProductModel.fromJson);
  }

  Future<void> addReview(String productId, int rating, String? comment) =>
      _provider.addReview(productId, rating, comment);
}
