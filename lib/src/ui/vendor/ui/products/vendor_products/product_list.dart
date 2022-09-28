import 'package:app/src/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import 'add_product.dart';
import 'product_detail.dart';

class VendorProductList extends StatefulWidget {
  final vendorBloc = VendorBloc();
  final String vendorId;
  VendorProductList({Key? key, required this.vendorId}) : super(key: key);
  @override
  _VendorProductListState createState() => _VendorProductListState();
}

class _VendorProductListState extends State<VendorProductList> {
  ScrollController _scrollController = new ScrollController();
  bool hasMoreProducts = true;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    widget.vendorBloc.productFilter['vendor'] = widget.vendorId;
    widget.vendorBloc.fetchAllProducts();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMoreProducts) {
        hasMoreProducts = await widget.vendorBloc.loadMoreProducts();

        if (!hasMoreProducts) {
          setState(() {
            hasMoreProducts;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
      appBar: AppBar(title: Text(appStateModel.blocks.localeText.products), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            semanticLabel: 'add',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddVendorProduct(vendorBloc: widget.vendorBloc)),
            );
          },
        ),
      ]),
      body: StreamBuilder(
          stream: widget.vendorBloc.allVendorProducts,
          builder: (context, AsyncSnapshot<List<VendorProduct>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                controller: _scrollController,
                children: buildListOfProducts(snapshot),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  buildListOfProducts(AsyncSnapshot<List<VendorProduct>> snapshot) {
    List<Widget> list = [];

    NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, name: AppStateModel().selectedCurrency);

    snapshot.data!.forEach((element) {
      list.add(
          Card(
            margin: EdgeInsets.all(0.5),
            elevation: 0,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: ListTile(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return VendorProductDetail(
                      product: element,
                      vendorBloc: widget.vendorBloc
                  );
                }));
                setState(() {});
              },
              contentPadding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              leading: Container(
                width: 60,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: element.images.length > 0 ? element.images[0].src : '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 80,
                    color: Theme.of(context).canvasColor,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 80,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
              title: Text(parseHtmlString(element.name), maxLines: 2),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parseHtmlString(element.description), maxLines: 2),
                  Price(formatter: formatter, product: element),
                  element.totalSales != 0 ?
                  Row(
                    children: [
                      SizedBox(width: 12),
                      Text(element.totalSales.toString() + ' Orders'),
                    ],
                  ) : Container(),
                ],
              ),
            ),
          )
      );
    });

    list.add(Container(
        height: 60,
        child: hasMoreProducts ?  Center(child: CircularProgressIndicator()) : Container()));

    return list;
  }

}

class Price extends StatelessWidget {
  const Price({
    Key? key,
    required this.formatter,
    required this.product,
  }) : super(key: key);

  final NumberFormat formatter;
  final VendorProduct product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          double.parse(product.salePrice) != 0 ? Text(formatter.format(double.parse(product.salePrice)), style: Theme.of(context).textTheme.subtitle1) : double.parse(product.price) != 0 ? Text(formatter.format(double.parse(product.price)), style: Theme.of(context).textTheme.subtitle1) : Container(),
          SizedBox(width: 4),
          double.parse(product.salePrice) != 0 && double.parse(product.regularPrice) != 0 ? Text(formatter.format(double.parse(product.regularPrice)), style: TextStyle(
            decoration: TextDecoration.lineThrough,
            fontSize: 12,
          ),) : Container(),
        ],
      ),
    );
  }
}
