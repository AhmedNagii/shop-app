import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  @override
  Widget build(BuildContext context) {
    //  final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapShot.error != null) {
                //error handling
                return Center(
                  child: Text("An error occurred"),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (ctx, index) =>
                        OrderItem(ordersData.orders[index]),
                  ),
                );
              }
            }
          },
        ));
  }
}

// it could be an insted of future widget
// var _isLoading = false;
//   @override
//   void initState() {
//    // Future.delayed(Duration.zero).then((_) async {
//         _isLoading = true;
//        Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_){
//  setState(() {
//         _isLoading = false;
//       });
//       });
//     super.initState();
//   }
