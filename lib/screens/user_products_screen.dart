import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: '');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              const Divider(),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                        // child: ListView.builder(
                        //   itemBuilder: (_, i) => UserProductItem(
                        //     productsData.items[i].title,
                        //     productsData.items[i].imageUrl,
                        //   ),
                        //   itemCount: productsData.items.length,
                        // ),
                      ),
                      // child: ,
                    ),
                  ),
        // child: ,
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Your Products'),
    //     actions: [
    //       IconButton(
    //         icon: const Icon(Icons.add),
    //         onPressed: () {},
    //       ),
    //     ],
    //   ),
    //   body: Padding(
    //     padding: EdgeInsets.all(8),
    //     child: ListView.builder(
    //       itemBuilder: (_, i) => UserProductItem(
    //         productsData.items[i].title,
    //         productsData.items[i].imageUrl,
    //       ),
    //       itemCount: productsData.items.length,
    //     ),
    //   ),
    // );
  }
}
