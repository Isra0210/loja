import 'package:flutter/material.dart';
import 'package:shop/components/AppDrawer.dart';

import 'package:shop/components/Badge.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/AppRoutes.dart';
import '../components/ProductGrid.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    //carregar os produtos
    super.initState();
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Camila Cosméticos',
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (ctx, cart, _) => Badge(
              color: Colors.redAccent[400],
              value: cart.itemCount.toString(),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Colors.yellowAccent,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART);
                },
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            color: Colors.white,
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOption.All,
              ),
            ],
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            )
          : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
