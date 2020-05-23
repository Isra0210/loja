import 'package:flutter/material.dart';
import 'package:shop/providers/Product.dart';

class ProductCrudItem extends StatelessWidget {
  final Product product;

  ProductCrudItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
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
                }),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
