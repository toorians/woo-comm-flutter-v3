import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import '../variation_products/vatiation_product_list.dart';
import 'edit_product.dart';

double expandedAppBarHeight = 350;

class VendorProductDetail extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;

  VendorProductDetail({
    Key? key,
    required this.product, required this.vendorBloc,
  }) : super(key: key);
  @override
  _VendorProductDetailState createState() =>
      _VendorProductDetailState();
}

class _VendorProductDetailState extends State<VendorProductDetail> {
  AppStateModel appStateModel = AppStateModel();


  @override
  void initState() {
    super.initState();
    widget.vendorBloc.resetVariationProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.product),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDeleteDialogue(context);
              }),
        ],
        //  title: Text(widget.products.name),
      ),
      body: buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditVendorProduct(
                  vendorBloc: widget.vendorBloc,
                  product: widget.product,
                )),
          );
          setState(() {});
        },
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget buildList() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            //title: Text(appStateModel.blocks.localeText.images),
              subtitle: GridView.builder(
                  shrinkWrap: true,
                  itemCount: widget.product.images.length + 1,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if (widget.product.images.length != index) {
                      return Card(
                          clipBehavior: Clip.antiAlias,

                          margin: EdgeInsets.all(4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Image.network(widget.product.images[index].src,
                              fit: BoxFit.cover));
                    } else {
                      return Container();
                    }
                  })),
          ListTile(
            title: Text("id"),
            subtitle: Text(widget.product.id.toString()),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.name),
            subtitle: Text(widget.product.name),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.regularPrice),
            subtitle: Text(widget.product.regularPrice),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.salesPrice),
            subtitle: Text(widget.product.salePrice),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.status),
            subtitle: Text(widget.product.status),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.sku),
            subtitle: Text(widget.product.sku),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.type),
            subtitle: Text(widget.product.type),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.description),
            subtitle: Html(data: widget.product.shortDescription),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.description + ' ' + appStateModel.blocks.localeText.description),
            subtitle: Html(data: widget.product.description),
          ),
          widget.product.type == "variable"
              ? ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(appStateModel.blocks.localeText.variations),
              trailing: Icon(Icons.arrow_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VariationProductList(
                      product: widget.product,
                    ),
                  ),
                );
              })
              : Container(),
        ],
      ).toList(),
    );
  }

  showDeleteDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text("Delete"),
            content: new Row(
              children: <Widget>[Text('Are you sure you want delete product?')],
            ),
            actions: <Widget>[
              new TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    widget.vendorBloc.deleteProduct(widget.product);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  })
            ],
          );
        }
    );
  }
}
