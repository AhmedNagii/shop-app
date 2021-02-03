import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class TheOrderItem {
  final String id;
  final double amount;
  final List<CartItem> proudcts;
  final DateTime dateTime;

  TheOrderItem({
    @required this.id,
    @required this.amount,
    @required this.proudcts,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<TheOrderItem> _orders = [];

  List<TheOrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        "https://shop-app-1e38a-default-rtdb.firebaseio.com/orders.json";
    final response = await http.get(url);
    final List<TheOrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        TheOrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(orderData["dateTime"]),
          proudcts: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item["id"],
                  price: item["price"],
                  quantity: item["quantity"],
                  title: item["title"],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        "https://shop-app-1e38a-default-rtdb.firebaseio.com/orders.json";
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "proudcts": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
        }),
      );

      final newOrder = TheOrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        proudcts: cartProducts,
        dateTime: timestamp,
      );

      _orders.add(newOrder);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
