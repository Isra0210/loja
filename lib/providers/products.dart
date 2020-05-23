import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/DummyData.dart';
import 'package:shop/providers/Product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCT;

  List<Product> get items => _items;

  int get itemCount{
    return _items.length;
  }

  List<Product> get favoriteItems{
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product newProduct) {
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }
}
