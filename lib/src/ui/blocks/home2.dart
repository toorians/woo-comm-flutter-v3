import 'package:app/src/ui/blocks/banners/banner_top_slider.dart';
import 'package:app/src/ui/blocks/blocks.dart';
import 'package:app/src/ui/blocks/drawer.dart';
import 'package:app/src/ui/products/product_detail/cart_icon.dart';
import 'package:app/src/ui/products/products/product_list_page.dart';
import '../products/barcode_products.dart';
import '../../blocs/products_bloc.dart';
import '../home/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/app_state_model.dart';
import '../../models/category_model.dart';
import '../../models/blocks_model.dart' hide Image, Key, Theme;
import 'package:flutter/rendering.dart';
import './../../models/app_state_model.dart';
import './../../models/blocks_model.dart';
import './../../models/category_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Home2 extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  Home2({Key? key}) : super(key: key);
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  late Category selectedCategory;
  bool _isVisible = false;
  Color? fillColor;

  @override
  void initState() {
    super.initState();
    widget.productsBloc.productsFilter['id'] = '0';
    widget.productsBloc.fetchAllProducts('0');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !appStateModel.loadingHomeProducts) {
        appStateModel.loadMoreRecentProducts();
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse && (40 <= _scrollController.position.pixels &&
          !_scrollController.position.outOfRange)) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward && 40 >= _scrollController.position.pixels) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return Scaffold(
          body: Scaffold(
            drawer: model.blocks.settings.appBarStyle.drawer ? MyDrawer() : null,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Builder(
                builder: (context) {
                  return buildHomeTitle(context, model.blocks.settings.appBarStyle);
                }
              ),
              backgroundColor: _isVisible ? Theme.of(context).appBarTheme.color :  Colors.transparent,
              elevation: 0.0,
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                for (var i = 0; i < model.blocks.blocks.length; i++)
                  if(model.blocks.blocks[i].blockType == BlockType.bannerSlider && i == 0)
                    BannerTopSlider(block: model.blocks.blocks[i])
                  else SliverBlock(block: model.blocks.blocks[i]),
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
          ),
        );
      }
    );
  }

  Widget buildHomeTitle(BuildContext context, AppBarStyle appBarStyle) {

    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    switch ('STYLE1') {
      case 'STYLE1':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if(appBarStyle.drawer)
            Container(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(
                  Icons.reorder,
                  //color: (Theme.of(context).appBarTheme.backgroundColor == Colors.white || Theme.of(context).appBarTheme.iconTheme == null ) ? Theme.of(context).hintColor : Theme.of(context).appBarTheme.iconTheme!.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
                ),
              ),
            ),
            if(!appBarStyle.drawer)
              Container(
              child: InkWell(
                onTap: () => _scanBarCode(),
                child: Icon(
                  CupertinoIcons.barcode_viewfinder,
                  //color: (Theme.of(context).appBarTheme.backgroundColor == Colors.white || Theme.of(context).appBarTheme.iconTheme == null ) ? Theme.of(context).hintColor : Theme.of(context).appBarTheme.iconTheme!.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  enableFeedback: false,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Search();
                    }));
                  },
                  child: Stack(
                    children: [
                      TextField(
                        showCursor: false,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: appStateModel.blocks.localeText.searchProducts,
                          hintStyle: TextStyle(
                            fontSize: 16,
                          ),
                          fillColor: fillColor,
                          filled: true,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 0,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(6),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            size: 18,
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        end: 0,
                        top: -4,
                        child: appBarStyle.drawer && appBarStyle.barcode ? IgnorePointer(
                          ignoring: false,
                          child: IconButton(
                              onPressed: () {
                                _scanBarCode();
                              },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).disabledColor,)
                          ),
                        ) : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CartIcon(),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Uncomment this comment search bar, If you want to put a logo instead of search bar
            /*Expanded(
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Image.asset('lib/assets/images/logo.png'),
          ),
        ),*/
            Container(
              child: InkWell(
                onTap: () => _scanBarCode(),
                child: Icon(
                  CupertinoIcons.barcode_viewfinder,
                  //color: (Theme.of(context).appBarTheme.backgroundColor == Colors.white || Theme.of(context).appBarTheme.iconTheme == null ) ? Theme.of(context).hintColor : Theme.of(context).appBarTheme.iconTheme!.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
                ),
              ),
            ),
            /*Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Account(),
                    fullscreenDialog: true,
                  ));
            },
            child: Icon(
              MStoreIcons.account_circle_line,
              color: Theme.of(context).appBarTheme.backgroundColor.toString() == 'Color(0xffffffff)' ? Theme.of(context).hintColor : Theme.of(context).primaryIconTheme.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
            ),
          ),
        ),*/
            Expanded(
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  enableFeedback: false,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Search();
                    }));
                  },
                  child: TextField(
                    showCursor: false,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: appStateModel.blocks.localeText.searchProducts,
                      hintStyle: TextStyle(
                        fontSize: 16,

                      ),
                      fillColor: fillColor,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(6),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CartIcon(),
            /*InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Search();
            }));
          },
          child: Icon(FlutterIcons.search_fea),
        )*/
          ],
        );
    }
  }

  _scanBarCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if(barcodeScanRes != '-1'){
      showDialog(builder: (context) => FindBarCodeProduct(result: barcodeScanRes, context: context), context: context);
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
