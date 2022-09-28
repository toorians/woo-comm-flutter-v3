import 'package:flutter/material.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: <Widget>[
        if(product.formattedSalesPrice != null && product.formattedSalesPrice!.isNotEmpty)
        Text(parseHtmlString(product.formattedSalesPrice!),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        //product.onSale && product.formattedSalesPrice != null ? SizedBox(width: 4.0) : SizedBox(width: 0.0),
        Text(parseHtmlString(product.formattedPrice!),
            style: product.onSale && product.formattedSalesPrice != null ? Theme.of(context).textTheme.bodyText1!.copyWith(
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Theme.of(context).textTheme.caption!.color,
                decorationColor: Theme.of(context).textTheme.caption!.color
            ) : Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )
        ),
      ],
    );
  }
}

class VariationPriceWidget extends StatelessWidget {
  const VariationPriceWidget({
    Key? key,
    required this.selectedVariation,
  }) : super(key: key);

  final AvailableVariation selectedVariation;

  @override
  Widget build(BuildContext context) {
    bool onSale = (selectedVariation.formattedSalesPrice != null &&
        selectedVariation.formattedSalesPrice!.isNotEmpty);
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: <Widget>[
        Text(onSale ? parseHtmlString(selectedVariation.formattedSalesPrice!) : '',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        onSale ? SizedBox(width: 6.0) : SizedBox(width: 0.0),
        Text(
            (selectedVariation.formattedPrice != null &&
                selectedVariation.formattedPrice!.isNotEmpty)
                ? parseHtmlString(selectedVariation.formattedPrice!)
                : '',
            style: onSale && (selectedVariation.formattedSalesPrice != null &&
                selectedVariation.formattedSalesPrice!.isNotEmpty) ? Theme.of(context).textTheme.caption!.copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: Theme.of(context).textTheme.caption!.color!.withOpacity(0.3)
            ) : Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )
        ),
        SizedBox(width: 4.0),
        onSale ? Text((((selectedVariation.displayRegularPrice! - selectedVariation.displayPrice!) / selectedVariation.displayRegularPrice! ) * 100 ).round().toStringAsFixed(0) + '% OFF', style: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Colors.green
        )) : Container()
      ],
    );
  }
}
