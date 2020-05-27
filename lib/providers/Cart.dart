import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/Product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return _item;
  }

  int get itemCount {
    return _item.length;
  }

  double get totalAmount {
    double total = 0.0;
    _item.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void AddItem(Product product) {
    if (_item.containsKey(product.id)) {
      _item.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: product.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _item.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(productId) {
    if (!_item.containsKey(productId)) {
      return;
    }

    if (_item[productId].quantity == 1) {
      _item.remove(productId);
    } else {
      _item.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.productId,
                productId: productId,
                title: existingItem.title,
                quantity: existingItem.quantity - 1,
                price: existingItem.price,
              ));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void clear() {
    _item = {};
    notifyListeners();
  }
}