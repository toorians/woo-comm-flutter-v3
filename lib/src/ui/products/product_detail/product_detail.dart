
import 'package:app/src/ui/products/product_detail/product_detail5.dart';
import 'package:app/src/ui/products/product_detail/product_detail4.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/product_model.dart';
import './../../../models/app_state_model.dart';
import 'product_detail2.dart';
import 'product_detail3.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          print(model.blocks.settings.pageLayout.product);
          // return ProductDetail2(product: widget.product);
          //return ProductDetail2(product: widget.product);
          // return ProductDetailBooking(product: widget.product);
          //return ProductDetail4(product: widget.product,);
          /*if (widget.product.type == 'booking') {
        return ProductDetailBooking(product: widget.product);
      } else */if (model.blocks.settings.pageLayout.product == 'layout1') {
            return ProductDetail2(product: widget.product);
          } else if (model.blocks.settings.pageLayout.product == 'layout2') {
            return ProductDetail3(product: widget.product);
          } else if (model.blocks.settings.pageLayout.product == 'layout3') {
            return ProductDetail3(product: widget.product);
          } else if (model.blocks.settings.pageLayout.product == 'layout4') {
            return ProductDetail4(product: widget.product);
          } else {
            return ProductDetail3(product: widget.product);
          }
        });
  }
}
