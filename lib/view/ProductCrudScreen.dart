import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/AppDrawer.dart';
import 'package:shop/components/ProductCrudItem.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/AppRoutes.dart';

class ProductCrudScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar de Produtos'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORMS);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: products.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: <Widget>[
              ProductCrudItem(products.items[i]),
              Divider(color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
