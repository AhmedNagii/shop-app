import 'package:flutter/material.dart';
import '../screens/User_Profucts_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget _buildListTile(
    String title,
    IconData icon,
    Function onTap,
  ) {
    return ListTile(
        leading: Icon(
          icon,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            color: Colors.grey,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              "My Profile",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildListTile("Shop", Icons.shop, () {
            Navigator.of(context).pushReplacementNamed("/");
          }),
          Divider(),
          _buildListTile("My Orders", Icons.shopping_basket, () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          }),
          Divider(),
          _buildListTile("Manage Products", Icons.shopping_basket, () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          }),
        ],
      ),
    );
  }
}
