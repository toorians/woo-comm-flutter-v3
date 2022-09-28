import 'package:app/src/models/product_model.dart';
import 'package:app/src/ui/products/products/product.dart';
import 'package:app/src/ui/products/products/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  const ProductListPage({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Return List of Booking Products
    //return BookingProductList(products: products);

    //return FoodProductList(products: products);

    //return GroceryProductGrid(products: products);

    return SliverPadding(
      padding: const EdgeInsets.all(4.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return GroceryProductItem(product: products[index]);
          },
          // 40 list items
          childCount: products.length,
        ),
      ),
    );

  }
}

class ProductGridPage extends StatelessWidget {
  final List<Product> products;
  const ProductGridPage({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Return List of Booking Products
    //return GroceryProductGrid(products: products);

    //return FoodProductList(products: products);

    //Return List of Booking Products
    //return BookingProductList(products: products);

    //Add More Product List Pages as necessary
    return SliverStaggeredGrid.count(
      crossAxisCount: 4,
      children: products.map<Widget>((item) {
        return ProductItemCard(product: item);
      }).toList(),
      staggeredTiles: products.map<StaggeredTile>((_) => StaggeredTile.fit(2))
          .toList(),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }
}
