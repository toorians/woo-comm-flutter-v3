import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:app/src/ui/blocks/blocks.dart';
import 'package:app/src/ui/blocks/place_selector.dart';
import 'package:app/src/ui/products/products/product_list_page.dart';
import 'package:app/src/ui/blocks/drawer.dart';
import 'package:app/src/ui/products/product_detail/cart_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../ui/home/place_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../products/products/product_grid.dart';
import '../../functions.dart';
import '../../blocs/products_bloc.dart';
import '../checkout/cart/cart4.dart';
import '../home/search.dart';
import '../products/barcode_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/app_state_model.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../products/product_detail/product_detail.dart';
import '../products/products/products.dart';
import '../../models/blocks_model.dart' hide Image, Key, Theme;
import 'package:flutter/rendering.dart';
import './../../models/app_state_model.dart';
import './../../models/blocks_model.dart';
import './../../models/category_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'header_logo.dart';

class Home extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  late TabController _controller;
  late Category selectedCategory;
  Color? fillColor;

  @override
  void initState() {
    super.initState();
    widget.productsBloc.productsFilter['id'] = '0';
    widget.productsBloc.fetchAllProducts('0');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !appStateModel.loadingHomeProducts) {
        if(_controller.index == 0) {
          appStateModel.loadMoreRecentProducts();
        } else {
          widget.productsBloc.loadMore(widget.productsBloc.productsFilter['id']);
        }
      }
    });
    _controller = TabController(vsync: this, length: appStateModel.mainCategories.length);
    _controller.index = 0;
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if(widget.productsBloc.productsFilter['id'] != appStateModel.mainCategories[_controller.index].id.toString()) {
      widget.productsBloc.productsFilter['id'] =
          appStateModel.mainCategories[_controller.index].id.toString();
      widget.productsBloc.fetchAllProducts(appStateModel.mainCategories[_controller.index].id.toString());
      if(_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      setState(() {
        selectedCategory = appStateModel.mainCategories[_controller.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {

          //ThemeData theme = Theme.of(context);

          PreferredSizeWidget? bottomAppBar = model.blocks.settings.tabBar ? TabBar(
            isScrollable: model.blocks.settings.bottomTabBarStyle.isScrollable,
            indicatorWeight: model.blocks.settings.bottomTabBarStyle.indicatorWeight,
            indicatorSize: model.blocks.settings.bottomTabBarStyle.tabBarIndicatorSize,
            indicatorPadding: EdgeInsets.all(model.blocks.settings.bottomTabBarStyle.indicatorPadding),
            controller: _controller,
            tabs: model.mainCategories.map<Widget>((Category category) => Tab(
                text: category.name.replaceAll(new RegExp(r'&amp;'), '&'))).toList(),
          ) : null;
          return Scaffold(
              drawer: model.blocks.settings.appBarStyle.drawer ? MyDrawer() : null,
              appBar: _buildAppBar(bottomAppBar, model.blocks.settings.appBarStyle),
              body: _controller.index == 0 ?
              RefreshIndicator(
                  onRefresh: () async {
                    await model.updateAllBlocks();
                    return;
                  },
                  child: Container(
                    //color: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        for (var i = 0; i < model.blocks.blocks.length; i++)
                          SliverBlock(block: model.blocks.blocks[i]),
                        if (model.blocks.recentProducts.length > 0 && model.blocks.settings.homePageProducts)
                          ProductGridPage(products: model.blocks.recentProducts),
                        if (model.blocks.recentProducts.length > 0 && model.blocks.settings.homePageProducts)
                          SliverPadding(
                              padding: EdgeInsets.all(0.0),
                              sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    Container(
                                        height: 60,
                                        child: ScopedModelDescendant<AppStateModel>(
                                            builder: (context, child, model) {
                                              if (model.blocks.recentProducts.length > 0 && model.hasMoreRecentItem == false) {
                                                return Center(
                                                  child: Text(
                                                    model.blocks.localeText.noMoreProducts,
                                                  ),
                                                );
                                              } else {
                                                return Center(child: CircularProgressIndicator());
                                              }
                                            }))
                                  ])))
                      ],
                    ),
                  )
              ) : _buildCategoryPage()
          );
        }
    );
  }

  _buildCategoryPage() {
    return StreamBuilder(
        stream: widget.productsBloc.allProducts,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.grey[900],
              child: CustomScrollView(
                controller: _scrollController,
                slivers: buildLisOfCategoryBlocks(snapshot),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  List<Widget> buildLisOfCategoryBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = [];

    //list.add(addCategoryBanner());

    /// UnComment this if you use rounded corner category list in body.
    list.add(buildSubcategories());

    if (snapshot.data != null) {

    list.add(ProductGridPage(products: snapshot.data!));
    /*
      list.add(SliverStaggeredGrid.count(
        crossAxisCount: 4,
        children: snapshot.data!.map<Widget>((item) {
          return ProductItemCard(product: item);
        }).toList(),
        staggeredTiles: snapshot.data!.map<StaggeredTile>((_) => StaggeredTile.fit(2))
            .toList(),
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
      ));*/

      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    height: 60,
                    child: StreamBuilder(
                        stream: widget.productsBloc.hasMoreItems,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return snapshot.hasData && snapshot.data == false
                              ? Container()
                              : Center(child: CircularProgressIndicator());
                        }
                      //child: Center(child: CircularProgressIndicator())
                    ))
              ]))));
    }

    return list;
  }

  Widget buildSubcategories() {
    List<Category> subCategories = appStateModel.blocks.categories
        .where((element) => element.parent == selectedCategory.id)
        .toList();
    return subCategories.length != 0
        ? SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        height: 150,
        width: 120,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                height: 100,
                width: 100,
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: StadiumBorder(),
                      margin: EdgeInsets.all(5.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child: InkWell(
                        onTap: () {
                          onCategoryClick(subCategories[index], context);
                        },
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 18 / 18,
                              child: subCategories[index].image != null
                                  ? CachedNetworkImage(
                                imageUrl: subCategories[index].image,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                //TODO ADD AssetImage as placeholder
                                placeholder: (context, url) => Container(color: Colors.black12),
                                //TODO ADD AssetImage as placeholder
                                errorWidget: (context, url, error) =>
                                    Container(color: Colors.white),
                              )/*Image.network(
                                subCategories[index].image,
                                fit: BoxFit.cover,
                              )*/
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        var filter = new Map<String, dynamic>();
                        filter['id'] = subCategories[index].id.toString();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsWidget(
                                    filter: filter,
                                    name: subCategories[index].name)));
                      },
                      child: Text(
                        parseHtmlString(subCategories[index].name),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    )
        : SliverToBoxAdapter();
  }

  Widget addCategoryBanner() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 16.0, 10.0, 10.0),
        height: 170,
        width: 50,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        child: Card(
          elevation: 0.5,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: CachedNetworkImage(
            imageUrl:
            selectedCategory.image != null ? selectedCategory.image : '',
            imageBuilder: (context, imageProvider) => Ink.image(
              child: InkWell(
                onTap: () => _categoryBannerClick(selectedCategory),
              ),
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) =>
                Container(color: Colors.black12),
          ),
        ),
      ),
    );
  }

  _categoryBannerClick(Category selectedCategory) {
    var filter = new Map<String, dynamic>();
    filter['id'] = selectedCategory.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: selectedCategory.name)));

  }


  Widget buildRecentProductGridList(BlocksModel snapshot) {
    return SliverStaggeredGrid.count(
      crossAxisCount: 4,
      children: snapshot.recentProducts.map<Widget>((item) {
        return ProductItemCard(product: item);
      }).toList(),
      staggeredTiles: snapshot.recentProducts.map<StaggeredTile>((_) => StaggeredTile.fit(2))
          .toList(),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }


  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
          product: product
      );
    }));
  }

  _buildAppBar(PreferredSizeWidget? bottomAppBar, AppBarStyle appBarStyle) {
    //bool isRtl = Directionality.of(context) == TextDirection.rtl;
    switch (appBarStyle.appBarType) {
      case 'STYLE1':
        return AppBar(
          //automaticallyImplyLeading: false,
          elevation: 1.0,
          titleSpacing: 0,
          centerTitle: false,
          bottom: bottomAppBar,
          title: appBarStyle.logo ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: HeaderLogo(),
          ) : TextButton(
            onPressed: () async {
              _onTapAddress();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.mapMarkerAlt),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 155,
                    child: ScopedModelDescendant<AppStateModel>(
                        builder: (context, child, model) {
                          if (model.customerLocation['address'] != null)
                            return Text(model.customerLocation['address'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                                fontSize: 14
                            ));
                          else
                            return Text(model.blocks.localeText.selectLocation, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                                fontSize: 14
                            ));
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            appBarStyle.cart ? CartIcon() : Container(width: 0),
            appBarStyle.searchIcon ? IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(CupertinoIcons.search),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE2':
        return AppBar(
          //automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 1.0,
          bottom: bottomAppBar,
          centerTitle: false,
          title: appBarStyle.logo ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: HeaderLogo(),
          ) : TextButton(
            onPressed: () async {
              _onTapAddress();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.mapMarkerAlt),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 155,
                    child: ScopedModelDescendant<AppStateModel>(
                        builder: (context, child, model) {
                          if (model.customerLocation['address'] != null)
                            return Text(model.customerLocation['address'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                                fontSize: 14
                            ));
                          else
                            return Text(model.blocks.localeText.selectLocation, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                                fontSize: 14
                            ));
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            appBarStyle.cart ? CartIcon() : Container(width: 0),
            appBarStyle.searchIcon ?
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(CupertinoIcons.search),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE3':
        return AppBar(
          centerTitle: false,
          //automaticallyImplyLeading: false,
          titleSpacing: 0,
          bottom: bottomAppBar,
          leading: appBarStyle.drawer ? null : appBarStyle.barcode ? IconButton(
              onPressed: () {_barCodeScan();},
              icon: Icon(CupertinoIcons.barcode_viewfinder)) : null,
          title: Padding(
            padding: appBarStyle.drawer || appBarStyle.barcode ? EdgeInsetsDirectional.only(start: 0.0) : EdgeInsetsDirectional.only(start: 16.0),
            child: appBarStyle.logo ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: HeaderLogo(),
            ) : InkWell(
              borderRadius: BorderRadius.circular(15),
              enableFeedback: false,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              child: InkWell(
                borderRadius: BorderRadius.circular(0),
                enableFeedback: false,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Search();
                  }));
                },
                child: CupertinoTextField(
                  keyboardType: TextInputType.text,
                  placeholder: appStateModel.blocks.localeText.searchProducts,
                  placeholderStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).textTheme.caption!.color
                  ),
                  enabled: false,
                  prefix: Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.6),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            appBarStyle.cart ?
            CartIcon() : Container(width: 0),appBarStyle.searchIcon ? IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(CupertinoIcons.search),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE4':
        return AppBar(
          centerTitle: false,
          //automaticallyImplyLeading: false,
          titleSpacing: 0,
          bottom: bottomAppBar,
          //leading: appBarStyle.barcode ? Icon(CupertinoIcons.barcode_viewfinder) : null,
          title: Padding(
            padding: appBarStyle.drawer || appBarStyle.barcode ? EdgeInsetsDirectional.only(start: 0.0) : EdgeInsetsDirectional.only(start: 16.0),
            child: appBarStyle.logo ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: HeaderLogo(),
            ) : InkWell(
              borderRadius: BorderRadius.circular(15),
              enableFeedback: false,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              child: buildCupertinoSearchFiled(context, appBarStyle),
            ),
          ),
          actions: [
            appBarStyle.cart ? CartIcon() : Container(width: 0),
            appBarStyle.searchIcon ? IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(CupertinoIcons.search),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE5':
        return AppBar(
          centerTitle: false,
          //automaticallyImplyLeading: false,
          titleSpacing: 0,
          bottom: bottomAppBar,
          leading: appBarStyle.drawer ? null : appBarStyle.barcode ? Icon(CupertinoIcons.barcode_viewfinder) : null,
          title: Padding(
            padding: appBarStyle.drawer || appBarStyle.barcode ? EdgeInsetsDirectional.only(start: 0.0) : EdgeInsetsDirectional.only(start: 16.0),
            child: appBarStyle.logo ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: HeaderLogo(),
            ) : buildHomeTitle(context, appBarStyle),
          ),
          actions: [
            appBarStyle.cart ? CartIcon() : Container(width: 0),
            appBarStyle.searchIcon ? IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(CupertinoIcons.search),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      default:
        return AppBar(
          //automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 1.0,
          bottom: bottomAppBar,
          centerTitle: false,
          title: Padding(
            padding: appBarStyle.drawer || appBarStyle.barcode ? EdgeInsetsDirectional.only(start: 0.0) : EdgeInsetsDirectional.only(start: 16.0),
            child: buildHomeTitle(context, appBarStyle),
          ),
          actions: [
            CartIcon(),
          ],
        );
    }
  }

  Widget buildCupertinoSearchFiled(BuildContext context, AppBarStyle appBarStyle) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4.0),
          enableFeedback: false,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Search();
            }));
          },
          child: CupertinoTextField(
            keyboardType: TextInputType.text,
            placeholder: appStateModel.blocks.localeText.searchProducts,
            placeholderStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Theme.of(context).textTheme.caption!.color
            ),
            enabled: false,
            prefix: Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
              child: Icon(
                Icons.search,
                color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.6),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        Positioned.directional(
          textDirection:Directionality.of(context),
          end: 0,
          child: appBarStyle.barcode ? IgnorePointer(
            ignoring: false,
            child: IconButton(
                onPressed: () {
                  _barCodeScan();
                },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).disabledColor,)
            ),
          ) : Container(),
        )
      ],
    );
  }

  Widget buildHomeTitle(BuildContext context, AppBarStyle appBarStyle) {

    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        enableFeedback: false,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Search();
          }));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            TextField(
              showCursor: false,
              enabled: false,
              decoration: InputDecoration(
                hintText: AppStateModel().blocks.localeText.searchProducts,
                fillColor: fillColor,
                filled: true,
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(6),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                ),
              ),
            ),
            Positioned.directional(
              textDirection:Directionality.of(context),
              end: 0,
              child: appBarStyle.barcode ? IgnorePointer(
                ignoring: false,
                child: IconButton(
                    onPressed: () {
                      _barCodeScan();
                    },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).disabledColor,)
                ),
              ) : Container(),
            )
          ],
        ),
      ),
    );
  }

  _barCodeScan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if(barcodeScanRes != '-1'){
      showDialog(builder: (context) => FindBarCodeProduct(result: barcodeScanRes, context: context), context: context);
    }
  }

  _onTapAddress() async {
    if(appStateModel.blocks.settings.customLocation) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PlaceSelector();
      }));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PlacePickerHome();
      }));
    }
    //widget.model.getAllStores();
    await appStateModel.updateAllBlocks();
    setState(() {});
  }

  _onPressCartIcon(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CartPage(),
          fullscreenDialog: true,
        ));
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width,
    color: color,
    child: tabBar,
  );
}
