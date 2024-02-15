import 'dart:convert';

import 'package:http/http.dart';

import '../Model/product_model/product_model.dart';

class ProductRepository {
  Future<ProductModel> fetchProductData() async {
    Response response = await get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return ProductModel.fromJson(data);
    }
    throw ("Data Fetch Error");
  }
}
