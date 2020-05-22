import 'package:flutter/material.dart';
import 'package:shop/data/DummyData.dart';
import 'package:shop/providers/Product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCT;

  List<Product> get items => _items;

 
  List<Product> get favoriteItems{
    return _items.where((prod) => prod.isFavorite).toList();
  }
}
