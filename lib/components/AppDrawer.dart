import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Auth.dart';
import 'package:shop/utils/AppRoutes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Camila Cosméticos',
            ),
            backgroundColor: Colors.black,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: Text(
              'Loja',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCT_HOME);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text(
              'Pedidos',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
            ),
            title: Text(
              'Carrinho',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.CART);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.store_mall_directory,
            ),
            title: Text(
              'Gerenciar Produtos',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.PRODUCT_CRUD);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text(
              'Sair',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Divider(),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height - 516),
            height: 60,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.copyright,
                  color: Colors.white,
                ),
                Text('Israel Rodrigues - ',style: TextStyle(color: Colors.white),),
                Text(
                  'Camila Cosméticos',
                  style: TextStyle(color: Colors.yellow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
