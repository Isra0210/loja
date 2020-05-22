import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/ProductItem.dart';
import 'package:shop/providers/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    final products = showFavoriteOnly
        ? productProvider.favoriteItems
        : productProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2, //altura pela largura
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
