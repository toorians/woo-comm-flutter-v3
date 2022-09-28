import 'package:app/src/ui/products/product_detail/cart_icon.dart';
import 'package:app/src/ui/products/products/product_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import '../../../../src/ui/home/search.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../ui/products/products/product_grid.dart';
import '../../../blocs/products_bloc.dart';
import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/category_model.dart';
import '../../../models/product_model.dart';
import '../product_detail/product_detail.dart';
import '../product_filter/filter2.dart';
import 'product.dart';


class ProductsWidget extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  final Map<String, dynamic> filter;
  final String? name;
  final AppStateModel model = AppStateModel();

  ProductsWidget({Key? key, required this.filter, this.name}) : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  late TabController _tabController;
  Category? selectedCategory;
  late List<Category> subCategories;
  bool listView = false;
  Color? fillColor;

  @override
  void initState() {
    super.initState();
    widget.model.selectedRange = RangeValues(0, widget.model.blocks.maxPrice.toDouble());
    if(widget.filter['id'] == null) {
      widget.filter['id'] = '0';
    }
    widget.productsBloc.productsFilter = widget.filter;
    subCategories = widget.model.blocks.categories
        .where(
            (cat) => cat.parent.toString() == widget.productsBloc.productsFilter['id'])
        .toList();
    if (subCategories.length != 0) {
      subCategories.insert(
          0, Category(name: widget.model.blocks.localeText.all, id: int.parse(widget.filter['id'])));
    }
    _tabController = TabController(vsync: this, length: subCategories.length);
    _tabController.index = 0;
    widget.productsBloc.fetchAllProducts(widget.productsBloc.productsFilter['id']);
    widget.productsBloc.fetchProductsAttributes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && widget.productsBloc.hasMoreItems.value == true) {
        widget.productsBloc.loadMore(widget.productsBloc.productsFilter['id']);
      }
    });
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if(widget.productsBloc.productsFilter['id'] != subCategories[_tabController.index].id.toString()) {
      widget.productsBloc.productsFilter['id'] =
          subCategories[_tabController.index].id.toString();
      widget.model.selectedRange =
          RangeValues(0, widget.model.blocks.maxPrice.toDouble());
      widget.productsBloc.fetchAllProducts(subCategories[_tabController.index].id.toString());
      if(_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      setState(() {
        selectedCategory = subCategories[_tabController.index];
      });
    }
  }

  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(color: Colors.transparent));

  @override
  void dispose() {
    super.dispose();
    widget.productsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.white.withOpacity(0.05),
      appBar: AppBar(
        /*leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
            icon:Icon(Icons.arrow_back,color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,)
        ),*/
        //backgroundColor: Theme.of(context).primaryColor,
        bottom: subCategories.length != 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(90),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      buildSearchField(context),
                      TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        indicatorWeight: widget.model.blocks.settings.bottomTabBarStyle.indicatorWeight,
                        indicatorSize: widget.model.blocks.settings.bottomTabBarStyle.tabBarIndicatorSize,
                        tabs: subCategories
                            .map<Widget>((Category category) => Tab(
                                text: parseHtmlString(category.name)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              )
            : PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Align(
              alignment: Alignment.centerLeft,
              child: buildSearchField(context)
          ),
        ),
        title: widget.name != null
            ? Text(parseHtmlString(widget.name!))
            : Container(),
        actions: <Widget>[
          IconButton(
            icon: listView ? Icon(
              CupertinoIcons.rectangle_grid_2x2,
              semanticLabel: 'Grid View',
            ) : Icon(
              CupertinoIcons.rectangle_grid_1x2,
              semanticLabel: 'List View',
            ),
            onPressed: () {
              setState(() {
                listView = !listView;
              });
            },
          ),
          IconButton(
            icon: Icon(
              FlutterRemix.arrow_up_down_line,
              semanticLabel: 'filter',
              //color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
            ),
              onPressed:() => _showPopupMenu()
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
              //color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FilterProduct2(
                        productsBloc: widget.productsBloc),
                  ));
            },
          ),
          if(!widget.model.blocks.settings.catalogueMode)
            CartIcon()
        ],
      ),
      body: StreamBuilder(
      stream: widget.productsBloc.allProducts,
      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.length != 0) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                listView ? ProductListPage(products: snapshot.data!) : ProductGridPage(products: snapshot.data!),
                SliverToBoxAdapter(child: Container(
                    height: 60,
                    child: StreamBuilder(
                        stream: widget.productsBloc.hasMoreItems,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return snapshot.hasData && snapshot.data == false
                              ? Center(child: Text(widget.model.blocks.localeText.noMoreProducts))
                              : Center(child: CircularProgressIndicator());
                        }
                    )))
              ],
            );
          } else {
            return StreamBuilder<bool>(
                stream: widget.productsBloc.isLoadingProducts,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    return Center(
                      child: Container(),
                    );
                });
          }
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  Container buildSearchField(BuildContext context) {

    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        enableFeedback: false,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Search(filter: widget.productsBloc.productsFilter);
          }));
        },
        child: TextField(
          showCursor: false,
          enabled: false,
          decoration: InputDecoration(
            hintText: selectedCategory != null ? widget.model.blocks.localeText.searchIn + ' ' + parseHtmlString(selectedCategory!.name) : widget.model.blocks.localeText.search,
            hintStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).hintColor
            ),
            fillColor: fillColor,
            filled: true,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            disabledBorder: border,
            contentPadding: EdgeInsets.all(4),
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 18, color: Theme.of(context).hintColor
            ),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu() async {
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(150, 60, 50, 100),
      items: [
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.date), value: ['date', 'ASC']
        ),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.priceHighToLow), value: ['price', 'DESC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.priceLowToHigh), value: ['price', 'ASC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.newArrivals), value: ['date', 'DESC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.popular), value: ['popularity', 'ASC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.rating), value: ['rating', 'ASC']),
      ],
      elevation: 4.0,
    );
    if(result != null)
    _sort(result[0], result[1]);
  }

  _sort(String orderBy, String order) {
    widget.productsBloc.productsFilter['order'] = order;
    widget.productsBloc.productsFilter['orderby'] = orderBy;
    widget.productsBloc.reset();
    widget.productsBloc.fetchAllProducts(widget.productsBloc.productsFilter['id']);
  }

  onProductClick(data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: data);
    }));
  }

  _buildProductList(List<Product> data) {
    List<Widget> list = [];

    data.forEach((element) {
      list.add(ProductItemCard(product: element));
    });

    return list;
  }
}

