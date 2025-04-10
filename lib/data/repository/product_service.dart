import 'dart:convert';
import 'package:echokart/data/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load products: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load product: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
