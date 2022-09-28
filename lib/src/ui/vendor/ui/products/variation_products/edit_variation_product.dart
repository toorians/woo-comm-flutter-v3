
// ignore_for_file: unused_import

import 'package:app/src/blocs/vendor/variation_product_bloc.dart';
import 'package:app/src/ui/vendor/ui/products/vendor_products/text_editor.dart';
import 'package:app/src/ui/widgets/buttons/button_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../functions.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/product_attribute_model.dart';
import '../../../../../models/vendor/product_variation_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';

class EditVariationProduct extends StatefulWidget {
  final VariationProductBloc variationProductBloc;
  final VendorProduct product;
  final ProductVariation variationProduct;

  EditVariationProduct({Key? key, required this.variationProductBloc, required this.product, required this.variationProduct}) : super(key: key);
  @override
  _EditVariationProductState createState() => _EditVariationProductState();
}

class _EditVariationProductState extends State<EditVariationProduct> {

  AppStateModel _appStateModel = AppStateModel();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  ProductAttribute attribute = ProductAttribute.fromJson({});

  @override
  void initState() {
    super.initState();
    if (widget.variationProduct.attributes == null) widget.variationProduct.attributes = [];

  }

  void handleStockStatusValueChanged(String? value) {
    if(value != null)
    setState(() {
      widget.variationProduct.stockStatus = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(_appStateModel.blocks.localeText.variations),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  widget.variationProductBloc.deleteVariationProduct(widget.product.id, widget.variationProduct.id);
                  Navigator.of(context).pop();
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(slivers: _buildList()),
        ));
  }

  _buildList() {
    List<Widget> list = [];

    bool hasAttributes = false;
    widget.product.attributes.forEach((attribute) {
      if(attribute.options.length > 0 && attribute.variation) {
        hasAttributes = true;
      };
    });

    if(hasAttributes) {
      widget.product.attributes.forEach((attribute) {
        if (attribute.variation) {
          String selected = attribute.options.first;
          if (widget.variationProduct.attributes
              .any((item) => item.name == attribute.name)) {
            selected = widget.variationProduct.attributes
                .singleWhere((item) => item.name == attribute.name)
                .option;
          }
          list.add(SliverToBoxAdapter(
            child: Container(
              child: Text(attribute.name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1),
            ),
          ));
          list.add(
            SliverToBoxAdapter(
              child: DropdownButton<String>(
                value: selected,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 25,
                elevation: 16,
                underline: Container(
                  height: 1,
                ),
                onChanged: (String? newValue) {
                  if(newValue != null) {
                    VariationAttribute variationAttribute = new VariationAttribute(id: attribute.id, name: attribute.name, option: newValue);
                    if (widget.variationProduct.attributes
                        .any((item) => item.id == attribute.id)) {
                      setState(() {
                        widget.variationProduct.attributes
                            .removeWhere((item) => item.id == attribute.id);
                      });
                      setState(() {
                        widget.variationProduct.attributes.add(
                            variationAttribute);
                      });
                    } else {
                      setState(() {
                        widget.variationProduct.attributes.add(
                            variationAttribute);
                      });
                    }
                  }
                },
                items: attribute.options
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        }
      });
      list.add(SliverToBoxAdapter(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: widget.variationProduct.sku,
                decoration: InputDecoration(
                  labelText: _appStateModel.blocks.localeText.sku,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _appStateModel.blocks.localeText.pleaseEnter + ' ' +
                        _appStateModel.blocks.localeText.sku;
                  } else
                    return null;
                },
                onSaved: (val) {
                  if(val != null)
                  setState(() => widget.variationProduct.sku = val);
                },
              ),
              const SizedBox(height: 16.0),
              ListTile(
                trailing: Icon(Icons.arrow_right_rounded),
                contentPadding: EdgeInsets.zero,
                title: Text(AppStateModel().blocks.localeText.description),
                subtitle: Text(parseHtmlString(widget.variationProduct.description), maxLines: 2),
                onTap: () async {
                  String? text = await Navigator.push(context, MaterialPageRoute( builder: (context) => TextEditorPage(text: widget.product.shortDescription)));
                  if(text != null) {
                    setState(() => widget.variationProduct.description = text);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: widget.variationProduct.regularPrice,
                decoration: InputDecoration(
                    labelText: _appStateModel.blocks.localeText.regularPrice),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _appStateModel.blocks.localeText.pleaseEnter + ' ' +
                        _appStateModel.blocks.localeText.regularPrice;
                  } else
                    return null;
                },
                onSaved: (val) {
                  if(val != null)
                  setState(() => widget.variationProduct.regularPrice = val);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: widget.variationProduct.salePrice,
                decoration: InputDecoration(
                    labelText: _appStateModel.blocks.localeText.salesPrice),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _appStateModel.blocks.localeText.pleaseEnter + ' ' +
                        _appStateModel.blocks.localeText.salesPrice;
                  } else
                    return null;
                },
                onSaved: (val) {
                  if(val != null)
                  setState(() => widget.variationProduct.salePrice = val);
                },
              ),
              const SizedBox(height: 16.0),
              Text(_appStateModel.blocks.localeText.stockStatus, style: Theme
                  .of(context)
                  .textTheme
                  .subtitle2),
              Row(
                children: <Widget>[
                  Radio<String>(
                    value: 'instock',
                    groupValue: widget.variationProduct.stockStatus,
                    onChanged: handleStockStatusValueChanged,
                  ),
                  new Text(
                    _appStateModel.blocks.localeText.inStock,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio<String>(
                    value: 'outofstock',
                    groupValue: widget.variationProduct.stockStatus,
                    onChanged: handleStockStatusValueChanged,
                  ),
                  new Text(
                    _appStateModel.blocks.localeText.outOfStock,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio<String>(
                    value: 'onbackorder',
                    groupValue: widget.variationProduct.stockStatus,
                    onChanged: handleStockStatusValueChanged,
                  ),
                  new Text(
                    _appStateModel.blocks.localeText.backOrder,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() { isLoading = true; });
                    bool status = await widget.variationProductBloc.editVariationProduct(widget.product.id, widget.variationProduct);
                    setState(() { isLoading = false; });
                    if(status) Navigator.of(context).pop();
                  }
                },
                child: ButtonText(text: _appStateModel.blocks.localeText.save, isLoading: isLoading), //Text(_appStateModel.blocks.localeText.save),
              ),
            ],
          ),
        ),
      ));
    }
    return list;
  }
}

