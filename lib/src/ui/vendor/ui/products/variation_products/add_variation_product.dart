// ignore_for_file: unused_import

import 'package:app/src/blocs/vendor/variation_product_bloc.dart';
import 'package:app/src/ui/widgets/buttons/button_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../models/vendor/product_attribute_model.dart';
import '../../../../../models/vendor/product_variation_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';

class AddVariations extends StatefulWidget {
  final VariationProductBloc variationProductBloc;
  final VendorProduct product;

  AddVariations({Key? key, required this.variationProductBloc, required this.product}) : super(key: key);
  @override
  _AddVariationsState createState() => _AddVariationsState();
}

class _AddVariationsState extends State<AddVariations> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  ProductVariation variationProduct = ProductVariation.fromJson({
    'stockStatus': 'instock',
    'status': 'pending',
    'manageStock': false,
    'stockQuantity': 1,
    'onSale': false,
  });
  ProductAttribute attribute = ProductAttribute.fromJson({});

  @override
  void initState() {
    super.initState();
    if (variationProduct.attributes == null) variationProduct.attributes = [];
  }

  void handlestockStatusValueChanged(String? value) {
    if(value != null)
    setState(() {
      variationProduct.stockStatus = value;
    });
  }

  void handleStatusTypeValueChanged(String value) {
    setState(() {
      variationProduct.status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Variation"),
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
        if (attribute.variation != null && attribute.variation) {
          String selected = attribute.options.first;
          if (variationProduct.attributes
              .any((item) => item.name == attribute.name)) {
            selected = variationProduct.attributes
                .singleWhere((item) => item.name == attribute.name)
                .option;
          } else {
            VariationAttribute variationAttribute =
            new VariationAttribute(id: attribute.id, name: attribute.name, option: selected);
            variationProduct.attributes.add(variationAttribute);
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
                    VariationAttribute variationAttribute =
                    new VariationAttribute(id: attribute.id, name: attribute.name, option: newValue);
                    if (variationProduct.attributes
                        .any((item) => item.id == attribute.id)) {
                      setState(() {
                        variationProduct.attributes
                            .removeWhere((item) => item.id == attribute.id);
                      });
                      setState(() {
                        variationProduct.attributes.add(variationAttribute);
                      });
                    } else {
                      setState(() {
                        variationProduct.attributes.add(variationAttribute);
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Sku",
                ),
                onSaved: (val) {
                  if(val != null)
                  setState(() => variationProduct.sku = val);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) {
                  if(val != null)
                  setState(() => variationProduct.description = val);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: "Regular Price"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter regular price";
                  }
                },
                onSaved: (val) {
                  if(val != null)
                  setState(() => variationProduct.regularPrice = val);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: "Sale Price"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter sale price";
                  }
                },
                onSaved: (val) {
                  if(val != null)
                  setState(() => variationProduct.salePrice = val);
                },
              ),
              const SizedBox(height: 16.0),
              Text("Stock Status", style: Theme
                  .of(context)
                  .textTheme
                  .subtitle1),
              Row(
                children: <Widget>[
                  Radio<String>(
                    value: 'instock',
                    groupValue: variationProduct.stockStatus,
                    onChanged: handlestockStatusValueChanged,
                  ),
                  new Text(
                    "Instock",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio<String>(
                    value: 'outofstock',
                    groupValue: variationProduct.stockStatus,
                    onChanged: handlestockStatusValueChanged,
                  ),
                  new Text(
                    "Outof Stock",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio<String>(
                    value: 'onbackorder',
                    groupValue: variationProduct.stockStatus,
                    onChanged: handlestockStatusValueChanged,
                  ),
                  new Text(
                    "onbackorder",
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
                    await widget.variationProductBloc.addVariationProduct(widget.product.id, variationProduct);
                    setState(() { isLoading = false; });
                    Navigator.of(context).pop();
                  }
                },
                child: ButtonText(text: "Submit", isLoading: isLoading),
              ),
            ],
          ),
        ),
      ));
    }
    return list;
  }
}
