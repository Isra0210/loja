import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/Cart.dart';
import 'package:shop/utils/Constantes.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = '${Constantes.BASE_API_URL}/orders';

  List<Order> _items = [];

  List<Order> get items {
    return _items;
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);

    loadedItems.clear();

    if (data != null) {
      data.forEach(
        (orderId, orderData) {
          loadedItems.add(
            Order(
              id: orderId,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map(
                (item) {
                  return CartItem(
                    id: item['id'],
                    price: item['price'],
                    productId: item['productId'],
                    quantity: item['quantity'],
                    title: item['title'],
                  );
                },
              ).toList(),
            ),
          );
        },
      );
      notifyListeners();
    }

    _items =
        loadedItems.reversed.toList(); //deixando os pedidos mais novos em cima
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      "$_baseUrl.json",
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.item.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.item.values.toList(),
      ),
    );
    notifyListeners();
  }
}
