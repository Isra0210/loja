import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/HttpException.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/AppRoutes.dart';

class ProductCrudItem extends StatelessWidget {
  final Product product;

  ProductCrudItem(this.product);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
        backgroundColor: Colors.grey[300],
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCT_FORMS, arguments: product);
                }),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('tem certeza?'),
                    content:
                        Text('Deseja realmente remover o item do carrinho?'),
                    actions: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        child: Text(
                          'Não',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        child: Text(
                          'Sim',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  try {
                    if (value) {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                    }
                  } on HttpException catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      ),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
