import 'package:app/src/ui/blocks/blocks.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/blocs/products_bloc.dart';
import 'package:app/src/blocs/vendor/store_bloc.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/models/vendor/store_details.dart';
import 'package:app/src/models/vendor/store_model.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:app/src/ui/accounts/account/account_floating_button.dart';
import 'package:app/src/ui/blocks/banners/banner_grid.dart';
import 'package:app/src/ui/blocks/banners/banner_list.dart';
import 'package:app/src/ui/blocks/banners/banner_scroll.dart';
import 'package:app/src/ui/blocks/banners/banner_slider.dart';
import 'package:app/src/ui/blocks/category/category_grid.dart';
import 'package:app/src/ui/blocks/category/category_list.dart';
import 'package:app/src/ui/blocks/category/category_list_tile.dart';
import 'package:app/src/ui/blocks/category/category_presets.dart';
import 'package:app/src/ui/blocks/category/category_scroll.dart';
import 'package:app/src/ui/blocks/category/category_slider.dart';
import 'package:app/src/ui/blocks/products/product_list.dart';
import 'package:app/src/ui/blocks/products/product_scroll.dart';
import 'package:app/src/ui/blocks/products/product_slider.dart';
import 'package:app/src/ui/checkout/cart/cart4.dart';
import 'package:app/src/ui/home/search.dart';
import 'package:app/src/ui/products/barcode_products.dart';
import 'package:app/src/ui/products/product_detail/cart_icon.dart';
import 'package:app/src/ui/products/product_detail/product_detail.dart';
import 'package:app/src/ui/products/products/product_grid.dart';
import 'package:app/src/ui/products/products/products.dart';
import 'package:app/src/ui/widgets/MD5Indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StoreHomePage extends StatefulWidget {
  final storeHomeBloc = StoreHomeBloc();
  final StoreModel store;
  StoreHomePage({Key? key, required this.store}) : super(key: key);
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {

  AppStateModel appStateModel = AppStateModel();
  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    ApiProvider().filter['vendor'] = '';
    if (appStateModel.blocks.vendorType == 'product_vendor') {
      apiProvider.filter['wcpv_product_vendors'] = widget.store.id.toString();
    } else {
      apiProvider.filter['vendor'] = widget.store.id.toString();
    }
    widget.storeHomeBloc.fetchStoreDetails();
  }

  @protected
  void dispose() {
    apiProvider.filter.remove('vendor');
    apiProvider.filter.remove('wcpv_product_vendors');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StoreDetails>(
        stream: widget.storeHomeBloc.storeDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Theme(
                data: Theme.of(context).brightness == Brightness.dark ? snapshot.data?.theme?.dark == null ? Theme.of(context) : snapshot.data!.theme!.dark : snapshot.data?.theme?.light == null ? Theme.of(context) : snapshot.data!.theme!.light,
                child: StoreHome(store: widget.store, storeHomeBloc: widget.storeHomeBloc, categories: snapshot.data!.categories)
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                //brightness: Theme.of(context).brightness,
                iconTheme: IconTheme.of(context).copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                ),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
        }
    );
  }
}

class StoreHome extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  final StoreHomeBloc storeHomeBloc;
  final StoreModel store;
  final List<Category> categories;
  StoreHome({Key? key, required this.store, required this.storeHomeBloc, required this.categories}) : super(key: key);
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  late TabController _controller;
  late Category selectedCategory;
  List<Category> mainCategories = [];
  Color? fillColor;

  @override
  void initState() {
    super.initState();
    widget.productsBloc.productsFilter['id'] = '0';
    widget.productsBloc.fetchAllProducts('0');

    if(widget.categories.length > 1) {
      mainCategories = widget.categories.where((cat) => cat.parent == 0).toList();
      if(mainCategories.length > 1)
        this.mainCategories.insert(0, Category(name: appStateModel.blocks.localeText.all, id: 0,  parent: 0, image: ''));
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !widget.storeHomeBloc.loadingHomeProducts) {
        if(_controller.index == 0) {
          widget.storeHomeBloc.loadMoreProducts();
        } else {
          widget.productsBloc.loadMore(widget.productsBloc.productsFilter['id']);
        }
      }
    });
    _controller = TabController(vsync: this, length: mainCategories.length);
    _controller.index = 0;
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if(widget.productsBloc.productsFilter['id'] != mainCategories[_controller.index].id.toString()) {
      widget.productsBloc.productsFilter['id'] =
          mainCategories[_controller.index].id.toString();
      widget.productsBloc.fetchAllProducts(mainCategories[_controller.index].id.toString());
      if(_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      setState(() {
        selectedCategory = mainCategories[_controller.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StoreDetails>(
        stream: widget.storeHomeBloc.storeDetails,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            TabBar? bottomAppBar = mainCategories.length > 1 && snapshot.data!.settings.tabBar ? TabBar(
              controller: _controller,
              isScrollable: snapshot.data!.settings.bottomTabBarStyle.isScrollable,
              //indicatorColor: model.blocks.settings.bottomTabBarStyle.indicatorColor,
              indicatorWeight: snapshot.data!.settings.bottomTabBarStyle.indicatorWeight,
              indicatorPadding: EdgeInsets.all(snapshot.data!.settings.bottomTabBarStyle.indicatorPadding),
              //unselectedLabelColor: Theme.of(context).primaryColorBrightness == Brightness.dark ? Colors.white.withOpacity(.8): Colors.black.withOpacity(0.5),
              //labelColor: Theme.of(context).primaryColorBrightness == Brightness.dark ? Colors.white: Colors.black,
              //unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
              indicatorSize: TabBarIndicatorSize.label,
              /*indicator: MD2Indicator(
                  indicatorHeight: 5,
                  indicatorColor: Theme.of(context).primaryColorBrightness == Brightness.dark ? Colors.white: Colors.black,
                  indicatorSize: MD2IndicatorSize.full //3 different modes tiny-normal-full
              ),*/
              tabs: mainCategories.map<Widget>((Category category) => Tab(
                  text: parseHtmlString(category.name))).toList(),
            ) : null;
            return Scaffold(
                appBar: _buildAppBar(bottomAppBar, snapshot.data!.settings.appBarStyle),
                body: _controller.index == 0 ?
                snapshot.data!.blocks.isNotEmpty || snapshot.data!.products.isNotEmpty
                    ? Container(
                  //color: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      for (var i = 0; i < snapshot.data!.blocks.length; i++)
                        SliverBlock(block: snapshot.data!.blocks[i]),
                      if (snapshot.data!.products.length > 0)
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
                                ]))),
                      SliverToBoxAdapter(child: SizedBox(height: 38),)
                    ],
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(),
                ) : _buildCategoryPage(),
              floatingActionButton: StreamBuilder<StoreDetails>(
                  stream: widget.storeHomeBloc.storeDetails,
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data != null) {
                      return VendorFloatingButton(store: widget.store, whatsapp: snapshot.data!.settings.whatsapp, email: snapshot.data!.settings.email, phoneNumber: snapshot.data!.settings.phoneNumber);
                    } else return Container(height: 0);

                  }
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                brightness: Theme.of(context).brightness,
                iconTheme: IconTheme.of(context).copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                ),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
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

    list.add(buildSubcategories());
    if (snapshot.data != null) {
      list.add(SliverStaggeredGrid.count(
        crossAxisCount: 4,
        children: snapshot.data!.map<Widget>((item) {
          return ProductItemCard(product: item);
        }).toList(),
        staggeredTiles: snapshot.data!.map<StaggeredTile>((_) => StaggeredTile.fit(2))
            .toList(),
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
      ));

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
    List<Category> subCategories = widget.categories
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
                          var filter = new Map<String, dynamic>();
                          filter['id'] =
                              subCategories[index].id.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsWidget(
                                      filter: filter,
                                      name: parseHtmlString(subCategories[index].name))));
                        },
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 18 / 18,
                              child: subCategories[index].image.isNotEmpty
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
                              ) : Container(),
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
            selectedCategory.image,
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


  Widget buildRecentProductGridList(List<Product> snapshot) {
    return SliverStaggeredGrid.count(
      crossAxisCount: 4,
      children: snapshot.map<Widget>((item) {
        return ProductItemCard(product: item);
      }).toList(),
      staggeredTiles: snapshot.map<StaggeredTile>((_) => StaggeredTile.fit(2))
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

  onCategoryClick(Category category, List<Category> categories) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: category.name)));
  }

  _buildAppBar(TabBar? bottomAppBar, AppBarStyle appBarStyle) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    switch (appBarStyle.appBarType) {
      case 'STYLE1':
        return AppBar(
          elevation: 1.0,
          titleSpacing: 0,
          centerTitle: false,
          bottom: bottomAppBar,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: HeaderLogo(icon: widget.store.icon),
          ),
          actions: [
            appBarStyle.cart ? CartIcon() : Container(width: 0),
            appBarStyle.searchIcon ? IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryIconTheme.color),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE2':
        return AppBar(
          titleSpacing: 0,
          elevation: 1.0,
          bottom: bottomAppBar,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: HeaderLogo(icon: widget.store.icon),
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
              icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryIconTheme.color),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE3':
        return AppBar(
          centerTitle: false,
          titleSpacing: 0,
          bottom: bottomAppBar,
          title: Padding(
            padding: isRtl ? appBarStyle.barcode ? EdgeInsets.only(right: 0.0) : EdgeInsets.only(right: 16.0) : appBarStyle.barcode ? EdgeInsets.only(left: 0.0) : EdgeInsets.only(left: 16.0),
            child: appBarStyle.logo ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: HeaderLogo(icon: widget.store.icon),
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
              icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryIconTheme.color),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE4':
        return AppBar(
          centerTitle: false,
          titleSpacing: 0,
          bottom: bottomAppBar,
          title: Padding(
            padding: isRtl ? EdgeInsets.only(right: 16.0) : EdgeInsets.only(left: 16.0),
            child: appBarStyle.logo ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: HeaderLogo(icon: widget.store.icon),
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
              icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryIconTheme.color),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      case 'STYLE5':
        return AppBar(
          centerTitle: false,
          titleSpacing: 0,
          bottom: bottomAppBar,
          title: Padding(
            padding: isRtl ? appBarStyle.barcode ? EdgeInsets.only(right: 0.0) : EdgeInsets.only(right: 16.0) : appBarStyle.barcode ? EdgeInsets.only(left: 0.0) : EdgeInsets.only(left: 16.0),
            child: appBarStyle.logo ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: HeaderLogo(icon: widget.store.icon),
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
              icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryIconTheme.color),) : Container(width: 0),
            (appBarStyle.cart || appBarStyle.searchIcon) ? Container() : Container(width: 16)
          ],
        );
      default:
        return AppBar(
          titleSpacing: 0,
          //elevation: 1.0,
          bottom: bottomAppBar,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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

    final border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: Colors.transparent));

    return Container(
      height: 40,
      padding: EdgeInsetsDirectional.only(end: 10),
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
                hintText: appStateModel.blocks.localeText.searchProducts,
                fillColor: fillColor,
                filled: true,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                errorBorder: border,
                focusedErrorBorder: border,
                disabledBorder: border,
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

  _onPressCartIcon(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CartPage(),
          fullscreenDialog: true,
        ));
  }
}

class HeaderLogo extends StatelessWidget {

  const HeaderLogo({
    Key? key,
    required this.icon,
    this.textColor = const Color(0xFF757575),
    this.style = FlutterLogoStyle.markOnly,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  final Color textColor;

  final FlutterLogoStyle style;

  final Duration duration;

  final Curve curve;

  final String icon;

  @override
  Widget build(BuildContext context) {
    final double iconSize = 42;
    return AnimatedContainer(
      height: iconSize,
      duration: duration,
      child: Image.network(
        this.icon,
        fit: BoxFit.contain,
      ),
    );
  }
}
