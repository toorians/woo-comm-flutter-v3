import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/products/products/products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AllBrands extends StatefulWidget {
  final String? title;

  const AllBrands({Key? key, this.title}) : super(key: key);
  @override
  _AllBrandsState createState() => _AllBrandsState();
}

class _AllBrandsState extends State<AllBrands> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null && widget.title!.isNotEmpty ? Text(widget.title!) : Container(),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width ~/ 100).toInt(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              padding: EdgeInsets.all(10),
              itemCount: model.blocks.brands.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    var filter = new Map<String, dynamic>();
                    filter['brand'] = model.blocks.brands[index].slug;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductsWidget(filter: filter, name: model.blocks.brands[index].name)));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        //width: 60,
                        child: CachedNetworkImage(
                          imageUrl: model.blocks.brands[index].image,
                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(parseHtmlString(model.blocks.brands[index].name), maxLines: 2, textAlign: TextAlign.center),
                      SizedBox(height: 4),
                    ],
                  ),
                );
              }
          );
        }
      ),
    );
  }
}
