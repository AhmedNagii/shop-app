import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> proudcts;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.proudcts,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-app-1e38a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(orderData["dateTime"]),
          proudcts: (orderData["proudcts"] as List<dynamic>)
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
    final url =
        "https://shop-app-1e38a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
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
                    "price": cp.price,
                    "quantity": cp.quantity,
                    "title": cp.title,
                  })
              .toList(),
        }),
      );

      final newOrder = OrderItem(
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

// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// import './cart.dart';

// class OrderItem {
//   final String id;
//   final double amount;
//   final List<CartItem> products;
//   final DateTime dateTime;

//   OrderItem({
//     @required this.id,
//     @required this.amount,
//     @required this.products,
//     @required this.dateTime,
//   });
// }

// class Orders with ChangeNotifier {
//   List<OrderItem> _orders = [];
//   final String authToken;

//   Orders(this.authToken, this._orders);

//   List<OrderItem> get orders {
//     return [..._orders];
//   }

//   Future<void> fetchAndSetOrders() async {
//     final url =
//         "https://shop-app-1e38a-default-rtdb.firebaseio.com/orders.json?auth=$authToken";
//     final response = await http.get(url);
//     final List<OrderItem> loadedOrders = [];
//     final extractedData = json.decode(response.body) as Map<String, dynamic>;
//     if (extractedData == null) {
//       return;
//     }
//     extractedData.forEach((orderId, orderData) {
//       loadedOrders.add(
//         OrderItem(
//           id: orderId,
//           amount: orderData['amount'],
//           dateTime: DateTime.parse(orderData['dateTime']),
//           products: (orderData['products'] as List<dynamic>)
//               .map(
//                 (item) => CartItem(
//                   id: item['id'],
//                   price: item['price'],
//                   quantity: item['quantity'],
//                   title: item['title'],
//                 ),
//               )
//               .toList(),
//         ),
//       );
//     });
//     _orders = loadedOrders.reversed.toList();
//     notifyListeners();
//   }

//   Future<void> addOrder(List<CartItem> cartProducts, double total) async {
//     final url =
//         "https://shop-app-1e38a-default-rtdb.firebaseio.com/orders.json?auth=$authToken";
//     final timestamp = DateTime.now();
//     final response = await http.post(
//       url,
//       body: json.encode({
//         'amount': total,
//         'dateTime': timestamp.toIso8601String(),
//         'products': cartProducts
//             .map((cp) => {
//                   'id': cp.id,
//                   'title': cp.title,
//                   'quantity': cp.quantity,
//                   'price': cp.price,
//                 })
//             .toList(),
//       }),
//     );
//     _orders.insert(
//       0,
//       OrderItem(
//         id: json.decode(response.body)['name'],
//         amount: total,
//         dateTime: timestamp,
//         products: cartProducts,
//       ),
//     );
//     notifyListeners();
//   }
// }
