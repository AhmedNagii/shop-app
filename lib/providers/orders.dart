import 'package:flutter/foundation.dart';

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

  void addOrders(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      TheOrderItem(
        id: DateTime.now().toString(),
        amount: total,
        proudcts: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
