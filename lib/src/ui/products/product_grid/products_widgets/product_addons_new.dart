// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import './../../../../models/addons_model.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/product_addons_model.dart';
import 'package:intl/intl.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';

class ProductAddons extends StatefulWidget {

  final Product product;
  final GlobalKey<FormState> addonFormKey;
  final Map<String, dynamic> addOnsFormData;

  const ProductAddons({Key? key, required this.product, required this.addOnsFormData, required this.addonFormKey}) : super(key: key);

  @override
  _ProductAddonsState createState() => _ProductAddonsState();
}

class _ProductAddonsState extends State<ProductAddons> {

  final appStateModel = AppStateModel();
  late NumberFormat formatter;

  //List<AddonsModel> addons = addonsModelFromJson(test);

  @override
  void initState() {
    super.initState();
    formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, name: AppStateModel().selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return SliverToBoxAdapter(
            child: Form(
              key: widget.addonFormKey,
              child: ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                children: buildList(model),
              ),
            )
        );
      }
    );
  }

  buildList(AppStateModel model) {
    List<Widget> list = [];

    widget.product.addons.forEach((addon) {

      list.add(
          ListTile(
            title: Text(addon.name, style: Theme.of(context).textTheme.headline6),
            subtitle: addon.description.isNotEmpty ? Text(addon.description) : null,
          )
      );

      if(addon.type == 'multiple_choice' && (addon.display == 'radiobutton' || addon.display == 'select')) {
          for( var i = 0; i < addon.options.length; i++ ) {
            list.add(
              CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: widget.addOnsFormData.containsKey('addon-' + addon.fieldName + '['+ i.toString() +']'),
                  onChanged: (value) {
                    if(value != null)
                    setState(() {
                      widget.addOnsFormData['addon-' + addon.fieldName + '['+ i.toString() +']'] = addon.options[i].key;
                    });
                    else {
                      setState(() {
                        widget.addOnsFormData.remove('addon-' + addon.fieldName + '['+ i.toString() +']');
                      });
                    }
                  },
                title: Text(addon.options[i].label + ' ' + _getPrice(addon.options[i].price)),
              )
            );
          }
      }

      else if(addon.type == 'checkbox' && addon.display == 'radiobutton') {
        for( var i = 0; i < addon.options.length; i++ ) {
          list.add(
              RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                value: addon.options[i].key,
                groupValue: widget.addOnsFormData['addon-' + addon.fieldName],
                onChanged: (value) {
                  setState(() {
                    widget.addOnsFormData['addon-' + addon.fieldName] = value;
                  });
                },
                title: Text(addon.options[i].label + ' ' + _getPrice(addon.options[i].price)),
              )
          );
        }
      }

      else if(addon.type == 'checkbox' && (addon.display == 'select' || addon.display == '')) {
        for( var i = 0; i < addon.options.length; i++ ) {
          list.add(
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                value: widget.addOnsFormData.containsKey('addon-' + addon.fieldName + '['+ i.toString() +']'),
                onChanged: (value) {
                  for( var j = 0; j < addon.options.length; j++ ) {
                    widget.addOnsFormData.remove('addon-' + addon.fieldName + '['+ j.toString() +']');
                  }
                  if(value != null) {
                    setState(() {
                      widget.addOnsFormData['addon-' + addon.fieldName + '['+ i.toString() +']'] = addon.options[i].key;
                    });
                  }
                },
                title: Text(addon.options[i].label + ' ' + _getPrice(addon.options[i].price)),
              )
          );
        }
      }

      else if(addon.type == 'checkbox' && addon.display == 'images') {

      }

      else if(addon.type == 'multiple_choice' && addon.display == 'images') {

      }

      else if(addon.type == 'custom_text' || addon.type == 'custom_textarea') {
        list.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                maxLength: 60,
                maxLines: 4,
                onSaved: (value) {
                  setState(() {
                     widget.addOnsFormData['addon-' + addon.fieldName] = value;
                  });
                },
                validator: (value) {
                  if (addon.required == 1 && (value == null || value.isEmpty)) {
                    return appStateModel.blocks.localeText.pleaseEnter + ' ' + addon.name;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  suffix: Text(_getPrice(addon.price)),
                ),
              ),
            )
        );
      }

      else if(addon.type == 'custom_email') {
        list.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  setState(() {
                    widget.addOnsFormData['addon-' + addon.fieldName] = value;
                  });
                },
                validator: (value) {
                  if (addon.required == 1 && (value == null || value.isEmpty)) {
                    return appStateModel.blocks.localeText.pleaseEnter + ' ' + addon.name;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  suffix: Text(_getPrice(addon.price)),
                ),
              ),
            )
        );
      }

      else if(addon.type == 'custom_digits_only') {
        list.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  setState(() {
                    widget.addOnsFormData['addon-' + addon.fieldName] = value;
                  });
                },
                validator: (value) {
                  if (addon.required == 1 && (value == null || value.isEmpty)) {
                    return appStateModel.blocks.localeText.pleaseEnter + ' ' + addon.name;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  suffix: Text(_getPrice(addon.price)),
                ),
              ),
            )
        );
      }

      else if(addon.type == 'input_multiplier') {
        list.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  setState(() {
                    widget.addOnsFormData['addon-' + addon.fieldName] = value;
                  });
                },
                validator: (value) {
                  if (addon.required == 1 && (value == null || value.isEmpty)) {
                    return appStateModel.blocks.localeText.pleaseEnter + ' ' + addon.name;
                  }
                  return null;
                },
              ),
            )
        );
      }

    });

    return list;

  }

  String _getPrice(String price) {
    if(price.isNotEmpty) {
      return formatter.format(double.parse(price)).toString();
    } else {
      return '';
    }
  }

}
