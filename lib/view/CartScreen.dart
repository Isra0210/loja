import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/AppDrawer.dart';
import 'package:shop/components/CartItemWidget.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/providers/orders.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.item.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Carrinho',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 4,
            color: Colors.black,
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, //espaçamento entre os elementos
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.yellow,
                  ),
                  Spacer(), //Ocupa espaço a mais
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItemWidget(cartItems[i]),
            ),
          ), //Ocupa a tela toda
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),)
          : Text(
              'COMPRAR',
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
      onPressed: widget.cart.totalAmount == 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart);
              widget.cart.clear();

              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
