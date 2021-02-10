import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/providers/products_provider.dart';

// import '../widgets/badge.dart';
// import '../providers/cart.dart';
// import '../screens/cart_screen.dart';
// import '../widgets/products_grid.dart';
// import '../widgets/app_drawer.dart';

// enum FilterOptions {
//   Favorites,
//   All,
// }

// class ProductsOverViewScreen extends StatefulWidget {
//   static const routName = "/products-overview";
//   @override
//   _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
// }

// class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
//   var _showOnlyFav = false;
//   var _isInit = true;
//   var _isLoading = false;

//   @override
//   void initState() {
//     //Provider.of<ProductsProvider>(context).fetchAndSetProudcts();  //WON'T WORK!  CONTECT TO ERALY TO BE CREATED
//     // Future.delayed(Duration.zero).then((_) {
//     //   Provider.of<ProductsProvider>(context).fetchAndSetProudcts();
//     // });
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("MyShop"),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: (FilterOptions selectedValue) {
//               setState(() {
//                 if (selectedValue == FilterOptions.Favorites) {
//                   _showOnlyFav = true;
//                 } else {
//                   _showOnlyFav = false;
//                 }
//               });
//             },
//             icon: Icon(Icons.more_vert),
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 child: Text("Only Favorites"),
//                 value: FilterOptions.Favorites,
//               ),
//               PopupMenuItem(
//                 child: Text("Show All"),
//                 value: FilterOptions.All,
//               )
//             ],
//           ),
//           Consumer<Cart>(
//             builder: (_, cart, ch) => Badge(
//               child: ch,
//               value: cart.itemCount.toString(),
//             ),
//             child: IconButton(
//               icon: Icon(Icons.shopping_cart),
//               onPressed: () {
//                 Navigator.of(context).pushNamed(CartScreen.routeName);
//               },
//             ),
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : ProductsGrid(_showOnlyFav),
//     );
//   }
// }
