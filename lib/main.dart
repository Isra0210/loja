import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Auth.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/AppRoutes.dart';
import 'package:shop/view/AuthOrHomeScreen.dart';
import 'package:shop/view/CartScreen.dart';
import 'package:shop/view/OrdersScreen.dart';
import 'package:shop/view/ProductCrudScreen.dart';
import 'package:shop/view/ProductDetailScreen.dart';
import 'package:shop/view/ProductFormsScreen.dart';
import 'package:shop/view/ProductOverviewScreen.dart';
import 'package:shop/view/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(null, []),
          update: (ctx, auth, previousProducts) => new Products(auth.token, previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Camila Cosméticos',
        theme: ThemeData(
          accentColor: Colors.red,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.HOME: (ctx) => SplashScreen(),
          AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_HOME: (ctx) => ProductOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCT_CRUD: (ctx) => ProductCrudScreen(),
          AppRoutes.PRODUCT_FORMS: (ctx) => ProductFormsScreen(),
        },
      ),
    );
  }
}
