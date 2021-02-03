import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class OrderButton extends StatefulWidget {
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var _isLoading = false;
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
      onPressed: cart.totalAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false).addOrder(
                cart.items.values.toList(),
                cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
