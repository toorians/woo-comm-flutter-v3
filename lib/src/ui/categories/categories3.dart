import 'dart:ui';

import 'package:app/src/ui/accounts/account/account1.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../functions.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../src/models/app_state_model.dart';
import '../../models/category_model.dart';
import '../products/products/products.dart';

class Categories3 extends StatefulWidget {
  @override
  _Categories3State createState() => _Categories3State();
}

class _Categories3State extends State<Categories3> {

  late List<Category> mainCategories;
  late List<Category> subCategories;
  late Category selectedCategory;
  int mainCategoryId = 0;
  int selectedCategoryIndex = 0;
  AppStateModel appStateModel = AppStateModel();

  void onCategoryTap(Category category, BuildContext context) {
    onCategoryClick(category, context);
    /*var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter, name: category.name)));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appStateModel.blocks.localeText.categories),),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks.categories.length > 0) {

            mainCategories = model.blocks.categories.where((cat) => cat.parent == 0).toList();
            if(mainCategories.length > 0) {
              selectedCategory = mainCategories[selectedCategoryIndex];
              subCategories = model.blocks.categories.where((cat) => cat.parent == selectedCategory.id).toList();
            }

            return buildList();
          } return Center(child: Container());
        },
      ),
    );
  }

  buildList() {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: ListView.builder(
          itemCount: mainCategories.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return CategoryRow(
                category: mainCategories[index],
                onCategoryClick: onCategoryTap);
          }),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final Category category;
  final void Function(Category category, BuildContext context) onCategoryClick;

  CategoryRow({required this.category, required this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        trailing: Icon(CupertinoIcons.forward),
        isThreeLine: category.description.isEmpty ? false : true,
        onTap: () {
          onCategoryClick(category, context);
        },
        leading: Container(
          width: 60,
          height: 60,
          child: CachedNetworkImage(
            imageUrl: category.image,
            imageBuilder: (context, imageProvider) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Ink.image(
                child: InkWell(
                  onTap: () {
                    onCategoryClick(category, context);
                  },
                ),
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
            placeholder: (context, url) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.black12,
            ),
          ),
        ),
        title: Text(
          parseHtmlString(category.name),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          //textAlign: TextAlign.right,
        ),
        subtitle: category.description.isEmpty ? null : Text(category.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}
