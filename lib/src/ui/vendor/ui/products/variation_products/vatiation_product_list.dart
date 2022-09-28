import 'package:app/src/blocs/vendor/variation_product_bloc.dart';
import 'package:app/src/ui/accounts/account/account1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/product_variation_model.dart'
    hide VariationImage;
import '../../../../../models/vendor/vendor_product_model.dart';
import 'add_variation_product.dart';
import 'edit_variation_product.dart';

class VariationProductList extends StatefulWidget {
  final VariationProductBloc variationProductBloc = VariationProductBloc();
  final VendorProduct product;
  VariationProductList({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _VariationProductListState createState() => _VariationProductListState();
}

class _VariationProductListState extends State<VariationProductList> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel _appStateModel = AppStateModel();
  @override
  void initState() {
    super.initState();
    widget.variationProductBloc.getVariationProducts(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_appStateModel.blocks.localeText.variations),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                semanticLabel: 'add',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddVariations(
                            variationProductBloc: widget.variationProductBloc,
                            product: widget.product,
                          )),
                );
              },
            ),
          ]),
      body: StreamBuilder(
          stream: widget.variationProductBloc.allVendorVariationProducts,
          builder: (context, AsyncSnapshot<List<ProductVariation>> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                  controller: _scrollController, slivers: buildList(snapshot));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildListTile(
      BuildContext context, ProductVariation variationProduct) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: _appStateModel.blocks.siteSettings.priceDecimal,
        name: _appStateModel.selectedCurrency);
    var name = '';

    variationProduct.attributes.forEach((value) {
      name = name + ' ' + value.option;
    });

    return MergeSemantics(
      child: CustomCard(
        child: ListTile(
            isThreeLine: true,
            leading: variationProduct.image.src.isNotEmpty ? Image.network(
              variationProduct.image.src,
              fit: BoxFit.fill,
            ) : Icon(Icons.image, size: 48, color: Theme.of(context).focusColor),
            title: Text(name),
            subtitle: Text(formatter
                .format((double.parse('${variationProduct.regularPrice}')))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditVariationProduct(
                      variationProduct: variationProduct,
                      variationProductBloc: widget.variationProductBloc,
                      product: widget.product,
                    )),
              );
            }),
      ),
    );
  }

  Widget buildItemList(AsyncSnapshot<List<ProductVariation>> snapshot) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            buildListTile(context, snapshot.data![index]),
            Divider(height: 0.0),
          ],
        );
      },
      childCount: snapshot.data!.length,
    ));
  }

  buildList(AsyncSnapshot<List<ProductVariation>> snapshot) {
    List<Widget> list = [];
    list.add(buildItemList(snapshot));
    if (snapshot.data != null) {
      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: StreamBuilder(
                    // stream: widget.vendorBloc.hasMoreProducts,
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                  return snapshot.hasData && snapshot.data == false
                      ? Center(
                          child: Text(
                              _appStateModel.blocks.localeText.noMoreProducts))
                      : Center(child: Container());
                }))
          ]))));
    }
    return list;
  }
}
