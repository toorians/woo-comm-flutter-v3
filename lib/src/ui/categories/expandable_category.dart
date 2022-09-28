import 'package:app/src/functions.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:app/src/ui/products/products/products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExpandableCategoryList extends StatefulWidget {
  final List<Category> categories;
  ExpandableCategoryList({Key? key, required this.categories})
      : super(key: key);
  @override
  _ExpandableCategoryListState createState() => _ExpandableCategoryListState();
}

class _ExpandableCategoryListState extends State<ExpandableCategoryList> {
  late List<Category> mainCategories;
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();
    mainCategories = widget.categories.where((cat) => cat.parent == 0).toList();
    if (mainCategories.length != 0) selectedCategory = mainCategories[0];
  }

  void onCategoryTap(Category category) {
    onCategoryClick(category, context);
    /*setState(() {
      selectedCategory = category;
    });
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter, name: category.name)));*/
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mainCategories.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return _buildTiles(mainCategories[index]);
        });
  }

  Widget _buildTiles(Category category) {
    int index = widget.categories.indexOf(category);
    List<Category> subCategories = [];
    if (index != -1) {
      subCategories = widget.categories
          .where((item) => item.parent == widget.categories[index].id)
          .toList();
    }
    if (subCategories.isEmpty) {
      return _buildTile(category);
    } else {
      return ExpansionTile(
        key: PageStorageKey<Category>(category),
        leading: leadingIcon(category),
        title: Text(
          parseHtmlString(category.name),
          style: menuItemStyle(),
        ),
        children: subCategories.map(_buildTiles).toList(),
      );
    }
  }

  Widget _buildTile(Category category) {
    return Column(
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.arrow_right_rounded),
          dense: true,
          onTap: () {
            onCategoryTap(category);
          },
          leading: leadingIcon(category),
          title: Padding(
            padding: category.parent != 0
                ? EdgeInsets.symmetric(horizontal: 16.0)
                : EdgeInsets.all(0.0),
            child: Text(
              parseHtmlString(category.name),
              style: menuItemStyle(),
            ),
          ),
        ),
        Divider(height: 0),
      ],
    );
  }

  TextStyle menuItemStyle() {
    return TextStyle(
      fontWeight: FontWeight.w800,

      letterSpacing: 0.5,
      fontSize: 12,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black.withOpacity(0.8)
          : Colors.grey,
    );
  }

  _divider(BuildContext context) {
    return Divider(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black12
          : Colors.black,
      thickness: 0.5,
      height: 1,
      //indent: 60,
    );
  }

  Container leadingIcon(Category category) {
    return Container(
      width: 20,
      height: 20,
      child: CachedNetworkImage(
        imageUrl: category.image.isNotEmpty ? category.image : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                onCategoryTap(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          margin: EdgeInsets.all(0.0),
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        errorWidget: (context, url, error) => Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}