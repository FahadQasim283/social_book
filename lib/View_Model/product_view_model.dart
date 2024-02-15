import 'package:news_app/Model/product_model/product.dart';
import 'package:news_app/repository/product_repository.dart';
import '../Model/product_model/product_model.dart';

class ProductViewModel {
  static List<Product> favoriteProducts = [];
  final _repository = ProductRepository();

  Future<ProductModel> fetchProductData() async {
    return await _repository.fetchProductData();
  }
}
