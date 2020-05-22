import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/providers/Product.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;
    final Cart cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            product.title, 
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              color: Colors.black,
              child: Text(
                'R\$ ${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.yellow,
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                '${product.description}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 50),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.yellow[600],
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                color: Colors.black,
                onPressed: () {
                  cart.AddItem(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
