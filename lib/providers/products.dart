import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/exceptions/HttpException.dart';
import 'package:shop/providers/Product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/Constantes.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${Constantes.BASE_API_URL}/products';
  List<Product> _items = [];
  List<Product> get items => _items;
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  int get itemCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);
    final favResponse = await http.get("${Constantes.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token");
    final favMap = json.decode(favResponse.body);

    _items.clear();

    if (data != null) {
      data.forEach(
        (productId, product) {
          final isFavorite = favMap == null ? false : favMap[productId] ?? false;
          _items.add(
            Product(
              id: productId,
              title: product['title'],
              price: product['price'],
              description: product['description'],
              imageUrl: product['imageUrl'],
              isFavorite: isFavorite,
            ),
          );
        },
      );
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      "$_baseUrl.json?auth=$_token",
      body: json.encode(
        {
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
        },
      ),
    );
    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch("$_baseUrl/${product.id}.json?auth=$_token",
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    final product = _items[index];

    _items.remove(product);
    notifyListeners();

    if (index >= 0) {
      final response = await http.delete("$_baseUrl/${product.id}.json?auth=$_token");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto');
      }
    }
  }
}
