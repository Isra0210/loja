import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/AppDrawer.dart';
import 'package:shop/components/OrderWidget.dart';
import 'package:shop/providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _refreshOrder(BuildContext context) {
      return Provider.of<Orders>(context, listen: false).loadOrders();
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Meus Pedidos',
            style: TextStyle(color: Colors.yellow),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Ocorreu um erro inesperado!'),
            );
          } else {
            return Consumer<Orders>(builder: (ctx, orders, child) {
              return RefreshIndicator(
                color: Colors.yellow,
                onRefresh: () => _refreshOrder(context),
                child: ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
                ),
              );
            });
          }
        },
      ),
      // _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //         onRefresh: () => _refreshOrder(context),
      //         child: ListView.builder(
      //           itemCount: orders.itemsCount,
      //           itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
      //         ),
      //       ),
    );
  }
}
