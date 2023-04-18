import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favouriteItems  : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (ctx) => products[i],
        value: products[i],
        // using 'value' instead of 'create' is another way of providing a constructor
        // add '.value' after ChangeNotifierProvider to use value
        // use this approach if u r using a provider for something that's part of a list or a grid
        // use this approach in all scenarios where u have the provider package and you're providing ur data on a single list
        // use this approach whenever u r reusing objects and not creating them
        //
        // 'Consumer' widget could also be used instead of using a provider
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // amount of columns
        childAspectRatio: 3 / 2, // ratio of length to breadth
        crossAxisSpacing: 10, // spacing between columns
        mainAxisSpacing: 10, // spacing between rows
      ),
    );
  }
}
