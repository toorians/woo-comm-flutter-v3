import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../../ui/color_override.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../config.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import 'attributes.dart';
import 'date_time.dart';
import 'select_categories.dart';

class AddVendorProduct extends StatefulWidget {
  final VendorBloc vendorBloc;
  AddVendorProduct({Key? key, required this.vendorBloc}) : super(key: key);
  @override
  _AddVendorProductState createState() => _AddVendorProductState();
}

class _AddVendorProductState extends State<AddVendorProduct> {
  VendorProduct product = VendorProduct.fromJson({});
  AppStateModel appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  Config config = Config();
  final ImagePicker _picker = ImagePicker();

  PickedFile? imageFile;
  bool isImageUploading = false;

  @override
  void initState() {
    super.initState();
    product.type = 'simple';
    product.status = 'pending';
    product.catalogVisibility = 'visible';
    product.taxStatus = 'taxable';
    product.stockStatus = 'instock';
    product.stockQuantity = 1;
    product.manageStock = false;
    product.onSale = false;
    product.backOrders = 'no';
    product.images = [];
    product.categories = [];
    product.attributes = [];
  }

  void handleTypeValueChanged(String? value) {
    if(value != null)
    setState(() {
      product.type = value;
    });
  }

  void handleStatusTypeValueChanged(String? value) {
    if(value != null)
    setState(() {
      product.status = value;
    });
  }

  void handleCatalogVisibilityTypeValueChanged(String? value) {
    if(value != null)
    setState(() {
      product.catalogVisibility = value;
    });
  }

  void handleStockStatusValueChanged(String? value) {
    if(value != null)
    setState(() {
      product.stockStatus = value;
    });
  }

  void handleBackOrdersValueChanged(String? value) {
    if(value != null)
    setState(() {
      product.backOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appStateModel.blocks.localeText.product),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: appStateModel.blocks.localeText.product +
                              ' ' +
                              appStateModel.blocks.localeText.name,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appStateModel.blocks.localeText.pleaseEnter +
                                ' ' +
                                appStateModel.blocks.localeText.product +
                                ' ' +
                                appStateModel.blocks.localeText.name;
                          }
                        },
                        onSaved: (val) {
                          if(val != null)
                          setState(() => product.name = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _choose(),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.all(4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        product.images.length >= 0
                            ? GridView.builder(
                            shrinkWrap: true,
                            itemCount: product.images.length + 1,
                            gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                            itemBuilder: (BuildContext context, int index) {
                              if (product.images.length != index) {
                                return Card(
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.all(4.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4.0),
                                    ),
                                    child: Image.network(
                                        product.images[index].src,
                                        fit: BoxFit.cover));
                              } else if (product.images.length == index &&
                                  isImageUploading) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Container();
                              }
                            })
                            : Container(),
                      ],
                    ),
                    _buildCategoryTile(),
                    _buildAttributesTile(),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.type,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'simple',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.simple,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'grouped',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.grouped,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(children: <Widget>[
                      Radio<String>(
                        value: 'external',
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        appStateModel.blocks.localeText.external,
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'variable',
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        appStateModel.blocks.localeText.variable,
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ]),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.status,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'draft',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.draft,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'pending',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.pending,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'private',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.private,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'publish',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.publish,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.catalogVisibility,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'visible',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.visible,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'catalog',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.catalog,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'search',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.search,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'hidden',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.hidden,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    /*Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'onbackorder',
                          groupValue: product.stockStatus,
                          onChanged: handleStockStatusValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.backOrder,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),*/
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(appStateModel.blocks.localeText.manageStock),
                      value: product.manageStock,
                      onChanged: (bool value) {
                        setState(() {
                          product.manageStock = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    product.manageStock == true
                        ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(appStateModel.blocks.localeText.stockQuantity),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .3,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: 12.0),
                            child: PrimaryColorOverride(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: appStateModel.blocks.localeText.stockQuantity),
                                onSaved: (val) {
                                  if(val != null)
                                  setState(
                                        () => product.stockQuantity = int.parse(val));
                                },
                              ),
                            ),
                          ),
                        ])
                        : (product.type != 'variable') ? SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(appStateModel.blocks.localeText.inStock),
                      value: product.stockStatus == 'instock',
                      onChanged: (bool value) {
                        setState(() {
                          product.stockStatus = value ? 'instock' : 'outofstock';
                        });
                      },
                    ) : Container(),
                    product.manageStock == true
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(appStateModel.blocks.localeText.backOrder,
                            style: Theme.of(context).textTheme.subtitle1),
                        Row(
                          children: <Widget>[
                            Radio<String>(
                              value: 'no',
                              groupValue: product.backOrders,
                              onChanged: handleBackOrdersValueChanged,
                            ),
                            new Text(
                              appStateModel.blocks.localeText.no,
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            Radio<String>(
                              value: 'notify ',
                              groupValue: product.backOrders,
                              onChanged: handleBackOrdersValueChanged,
                            ),
                            new Text(
                              appStateModel.blocks.localeText.notify,
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            Radio<String>(
                              value: 'yes',
                              groupValue: product.backOrders,
                              onChanged: handleBackOrdersValueChanged,
                            ),
                            new Text(
                              appStateModel.blocks.localeText.yes,
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ) : Container(),
                    const SizedBox(height: 16.0),
                    product.type != 'variable' ? Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(appStateModel.blocks.localeText.schedule),
                          value: product.onSale,
                          onChanged: (bool value) {
                            setState(() {
                              product.onSale = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        product.onSale == true
                            ? Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(appStateModel.blocks.localeText.from),
                                DateTimeItem(
                                  dateTime: product.dateOnSaleFromGmt == null ? DateTime.now() : product.dateOnSaleFromGmt,
                                  onChanged: (DateTime value) {
                                    setState(() {
                                      product.dateOnSaleFromGmt = value.toIso8601String();
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  appStateModel.blocks.localeText.to,
                                ),
                                DateTimeItem(
                                  dateTime: DateTime.now(),
                                  onChanged: (DateTime value) {
                                    setState(() {
                                      product.dateOnSaleToGmt = value.toIso8601String();
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ) : Container(),
                      ],
                    ) : Container(),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: appStateModel.blocks.localeText.weight),
                        onSaved: (val) => setState(() => product.weight),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: appStateModel.blocks.localeText.sku,
                        ),
                        onSaved: (val) {
                          if(val != null)
                          setState(() => product.sku = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText:
                            appStateModel.blocks.localeText.description),
                        onSaved: (val) {
                          if(val != null)
                          setState(() => product.shortDescription = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: appStateModel.blocks.localeText.long +
                                ' ' +
                                appStateModel.blocks.localeText.description),
                        onSaved: (val) {
                          if(val != null)
                          setState(() => product.description = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                          decoration: InputDecoration(
                              labelText:
                              appStateModel.blocks.localeText.regularPrice),
                          onSaved: (val) {
                            if(val != null)
                            setState(() {
                              product.regularPrice = val;
                              product.price = val;
                            });
                          }
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText:
                            appStateModel.blocks.localeText.salesPrice),
                        onSaved: (val) {
                          if(val != null)
                          setState(() => product.salePrice = val);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrimaryColorOverride(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText:
                            appStateModel.blocks.localeText.purchaseNote),
                        onSaved: (val) {
                          if(val != null)
                          setState(() => product.purchaseNote = val);
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.vendorBloc.addProduct(product);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(appStateModel.blocks.localeText.submit),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _choose() async {
    imageFile = await _picker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _upload();
    }
  }

  void _upload() async {
    setState(() {
      isImageUploading = true;
    });
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(config.url +
            "/wp-admin/admin-ajax.php?action=build-app-online-upload_image"));
    var pic = await http.MultipartFile.fromPath("file", imageFile!.path);
    request.files.add(pic);
    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> fileUpload = jsonDecode(responseString);
    FileUploadResponse uploadedFile = FileUploadResponse.fromJson(fileUpload);

    if (uploadedFile.url.isNotEmpty) {
      ProductImage picture = ProductImage(src: uploadedFile.url);
      setState(() {
        product.images.add(picture);
        isImageUploading = false;
      });
    }
  }

  _buildCategoryTile() {
    String option = '';
    product.categories.forEach((value) =>
    {option = option.isEmpty ? value.name : option + ', ' + value.name});
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      onTap: () async {
        final data = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectCategories(product: product)));
        setState(() => product);
      },
      title: Text(appStateModel.blocks.localeText.categories),
      //isThreeLine: true,
      subtitle: option.isNotEmpty
          ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Icon(CupertinoIcons.forward),
    );
  }

  _buildAttributesTile() {
    String option = '';
    product.attributes.forEach((value) {
      if(value.options.length != 0) {
        option = option.isEmpty ? value.name : option + ', ' + value.name;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: Text(appStateModel.blocks.localeText.attributes),
        //dense: true,
        trailing: Icon(CupertinoIcons.forward),
        subtitle: option.isNotEmpty
            ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        onTap: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectAttributes(
                vendorBloc: widget.vendorBloc,
                product: product,
              ),
            ),
          );
          setState(() => product);
        });
  }
}

class FileUploadResponse {
  final String url;

  FileUploadResponse(this.url);

  FileUploadResponse.fromJson(Map<String, dynamic> json) : url = json['url'];

  Map<String, dynamic> toJson() => {
    'url': url,
  };
}
