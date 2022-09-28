import 'package:app/src/ui/products/product_grid/products_widgets/grouped_add_to_cart_button.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupedProduct extends StatefulWidget {

  GroupedProduct({
    Key? key,
    required this.id,
    required this.product,
    required this.context,
  }) : super(key: key);

  final int id;
  final Product product;
  final BuildContext context;
  final model = AppStateModel();

  @override
  _GroupedProductState createState() => _GroupedProductState();
}

class _GroupedProductState extends State<GroupedProduct> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.name),
          SizedBox(height: 4),
          _variationPrice()
        ],
      ),
      trailing: SizedBox(width: 120, child: GroupedAddToCartButton(id: widget.id, product: widget.product)),
    );
  }

  Container leadingIcon() {
    return Container(
      width: 30,
      height: 30,
      child: CachedNetworkImage(
        imageUrl: widget.product.images[0].src,
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          margin: EdgeInsets.all(0.0),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                //onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          //shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          elevation: 0.0,
          color: Colors.white,
          //shape: StadiumBorder(),
        ),
      ),
    );
  }

  _variationPrice() {
    if(widget.product.formattedPrice != null && widget.product.formattedSalesPrice == null) {
      return Text(parseHtmlString(widget.product.formattedPrice!), style: TextStyle(
        fontWeight: FontWeight.bold,
      ));
    } else if(widget.product.formattedPrice != null && widget.product.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(widget.product.formattedSalesPrice!), style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
          SizedBox(width: 4),
          Text(parseHtmlString(widget.product.formattedPrice!), style: TextStyle(
              fontSize: 10,
              decoration: TextDecoration.lineThrough
          )),
        ],
      );
    }
  }
}