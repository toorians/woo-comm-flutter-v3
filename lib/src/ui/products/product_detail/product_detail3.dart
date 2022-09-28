import 'package:app/src/themes/hex_color.dart';
import 'package:app/src/ui/blocks/blocks.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/ui/pages/webview.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/src/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../../config.dart';
import '../../../ui/products/products/product_grid.dart';
import '../reviews/reviewDetail.dart';
import '../reviews/write_review.dart';
import '../../../ui/checkout/cart/cart4.dart';
import '../../../functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import '../../../models/app_state_model.dart';
import '../../../models/releated_products.dart';
import '../../../models/review_model.dart';
import '../../../blocs/product_detail_bloc.dart';
import '../../../models/product_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cart_icon.dart';
import 'custom_card.dart';
import 'package:html/dom.dart' as dom;

const double listTileTopPadding = 8;

class ProductDetail3 extends StatefulWidget {
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  final Product product;
  final appStateModel = AppStateModel();
  ProductDetail3({Key? key, required this.product}) : super(key: key);
  @override
  _ProductDetail3State createState() => _ProductDetail3State();
}

class _ProductDetail3State extends State<ProductDetail3> {

  bool addingToCart = false;
  bool buyingNow = false;
  int _quantity = 1;
  Map<String, dynamic> addOnsFormData = Map<String, dynamic>();
  final addonFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.productDetailBloc.getProduct(widget.product);
    widget.productDetailBloc.getProductsDetails(widget.product.id);
    widget.productDetailBloc.getReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
        stream: widget.productDetailBloc.product,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              //extendBodyBehindAppBar: true,
              floatingActionButton: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    if (model.blocks.settings.productPageChat) {
                      return FloatingActionButton(
                        onPressed: () async {
                          final url = snapshot.data!.vendor.phone != null && snapshot.data!.vendor.phone!.isNotEmpty
                              ? 'https://wa.me/' +
                              snapshot.data!.vendor.phone.toString()
                              : 'https://wa.me/' +
                              model.blocks.settings.phoneNumber.toString();
                          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        },
                        tooltip: 'Chat',
                        child: Icon(Icons.chat_bubble),
                      );
                    } else {
                      return Container();
                    }
                  }),
              body: CustomScrollView(
                slivers: _buildSlivers(context, snapshot.data!),
              ),
              bottomNavigationBar: widget.appStateModel.blocks.settings.productFooterAddToCart ? StreamBuilder<Product>(
                  stream: widget.productDetailBloc.product,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                          child: widget.appStateModel.blocks.settings.buyNowButton ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    addToCart(context, snapshot.data!);
                                  },
                                  child: addingToCart ? Container(
                                      width: 17,
                                      height: 17,
                                      child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(
                                              Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                                          strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                                  addToCart),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).colorScheme.secondary,
                                    onPrimary:  Theme.of(context).colorScheme.onSecondary,
                                  ),
                                  onPressed: () {
                                    buyNow(context, snapshot.data!);
                                  },
                                  child: buyingNow ? Container(
                                      width: 17,
                                      height: 17,
                                      child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(
                                              Theme.of(context).colorScheme.onSecondary),
                                          strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                                  buyNow),
                                ),
                              ),
                            ],
                          ) : ElevatedButton(
                            onPressed: snapshot.data!.stockStatus != 'outofstock'
                                ? () {
                              addToCart(context, snapshot.data!);
                            } : null,
                            child: snapshot.data!.stockStatus == 'outofstock' ? Text(widget
                                .appStateModel.blocks.localeText.outOfStock,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                    color: Theme
                                        .of(context)
                                        .errorColor)) : addingToCart ? Container(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(
                                        Theme
                                            .of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .onPrimary),
                                    strokeWidth: 2.0)) : Text(widget.appStateModel.blocks
                                .localeText.
                            addToCart),
                          ),
                        ),
                      );
                    } else {
                      return Container(height: 0);
                    }
                  }
              ) : Container(height: 0),
            );
          } else {
            return Scaffold(appBar: AppBar(),
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _buildSlivers(BuildContext context, Product product) {

    List<Widget> list = [];

    list.add(_buildAppBar(product));

    list.add(_buildNamePrice(product));

    if (product.availableVariations.isNotEmpty &&
        product.availableVariations.length > 0) {
      if (product.variationOptions.length == 1 && product.availableVariations.every((element) => element.image.src.isNotEmpty)) {
        list.add(SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Text(product.variationOptions[0].name, style: Theme.of(context).textTheme.headline6),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: List<Widget>.generate(product.availableVariations.length, (int index) {
                    return Container(
                        child: buildProductVariationsImages(product.availableVariations[index], product));
                  },
                  ),
                ),
              ),
            ],
          ),
        ));
      } else {
        for (var i = 0; i < product.variationOptions.length; i++) {
          if (product.variationOptions[i].optionList.length != 0) {
            //list.add(buildOptionHeader(product.variationOptions[i].name));
            list.add(buildProductVariations(product.variationOptions[i], product));
          }
        }
      }
    }

    //list.add(_buildQuantityInput());

    if(widget.appStateModel.blocks.settings.catalogueMode != true) {
      if(widget.appStateModel.blocks.settings.productFooterAddToCart == false)
        if(widget.appStateModel.blocks.settings.buyNowButton) {
          list.add(_buildAddToCartAndBuyNow(context, product));
        } else list.add(_buildAddToCart(context, product));
    }

    if(removeAllHtmlTags(product.description).length > 1)
      list.add(_productDescription(product));

    if(removeAllHtmlTags(product.shortDescription).length > 1)
      list.add(_productShortDescription(product));

    if(widget.appStateModel.blocks.productPageLayout.length > 0) {
      for (var i = 0; i < widget.appStateModel.blocks.productPageLayout.length; i++)
        list.add(SliverBlock(block: widget.appStateModel.blocks.productPageLayout[i]));
    }

    list.add(buildWriteYourReview(product));

    //list.add(relatedProductsTitle(title: widget.appStateModel.blocks.localeText.relatedProducts));
    list.add(buildLisOfReleatedProducts());


    //list.add(crossProductsTitle(title: widget.appStateModel.blocks.localeText.justForYou));
    list.add(buildLisOfCrossSellProducts());

    //list.add(upsellProductsTitle(title: widget.appStateModel.blocks.localeText.youMayAlsoLike));
    list.add(buildLisOfUpSellProducts());

    return list;
  }

  Widget buildProductVariationsImages(AvailableVariation variation, Product product) {
    return InkWell(
      onTap: () {
        product.variationOptions[0].selected = variation.option.first.value;
        product.variationId = variation.variationId
            .toString();
        if(variation.displayPrice != null)
          product.regularPrice = variation.displayPrice!
              .toDouble();
        product.formattedPrice = variation.formattedPrice;
        if(variation.formattedSalesPrice != null)
          product.formattedSalesPrice = variation.formattedSalesPrice;

        if(variation.image.fullSrc.isNotEmpty && variation.image.fullSrc.isNotEmpty)
          product.images[0].src = variation.image.fullSrc;

        if (variation.displayRegularPrice !=
            variation.displayPrice) {
          product.salePrice = variation.displayRegularPrice!
              .toDouble();
        }
        else {
          product.formattedSalesPrice = null;
        }
        setState(() {});
      },
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              border: Border.all(color: product.variationId == variation.variationId.toString() ? Theme.of(context).primaryColor : Theme.of(context).focusColor)
          ),
          child: Image.network(variation.image.src)),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  Widget _buildQuantityInput() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue: _quantity.toString(),
          decoration: InputDecoration(labelText: 'Quantity'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _quantity = int.parse(value);
            });
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(Product product) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
        floating: false,
        pinned: true,
        snap: false,
        backgroundColor: isDark ? Colors.black : Colors.white,
        expandedHeight: MediaQuery.of(context).size.width - 50,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black
        ),
        actionsIconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black
        ),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: CarouselSlider(
            options: CarouselOptions(height: MediaQuery.of(context).size.width),
            items: product.images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        imageUrl: image.src,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.white),
                        errorWidget: (context, url, error) => Container(color: Colors.white),
                      )
                  );
                },
              );
            }).toList(),
          ),
          //background:
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                CupertinoIcons.share,
                semanticLabel: 'Share',
              ),
              onPressed: () async {
                if(widget.appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
                  String wwref = '?wwref=' + widget.appStateModel.user.id.toString();
                  final url = Uri.parse(product.permalink + '?product_id=' + product.id.toString() + '&title=' + product.name + wwref);
                  final DynamicLinkParameters parameters = DynamicLinkParameters(
                    uriPrefix: widget.appStateModel.blocks.settings.dynamicLink,
                    link: url,
                    socialMetaTagParameters:  SocialMetaTagParameters(
                      title: product.name,
                    ),
                    androidParameters: AndroidParameters(
                      packageName: Config().androidPackageName,
                      minimumVersion: 0,
                    ),
                    iosParameters: IOSParameters(
                      bundleId: Config().iosPackageName,
                    ),
                  );

                  final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
                  Share.share(dynamicLink.shortUrl.toString());

                } else Share.share(product.permalink);
              }),
          if(!widget.appStateModel.blocks.settings.catalogueMode)
            CartIcon(),
        ]
    );
  }

  Widget _buildNamePrice(Product product) {
    return SliverToBoxAdapter(
      child: CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, listTileTopPadding, listTileTopPadding, 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(parseHtmlString(product.name)),
              ProductPrice(product: product)
            ],
          ),
        ),
      ),
    );
  }

  Widget _productDescription(Product product) {
    return SliverToBoxAdapter(
      child: CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(8, listTileTopPadding, 8, listTileTopPadding),
          title: Html(
            data: product.description,
            style: _buildStyle(),
            onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
              if(url != null)
                _launchUrl(url, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _productShortDescription(Product product) {
    return SliverToBoxAdapter(
      child: CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(8, listTileTopPadding, 8, listTileTopPadding),
          title: Html(
            data: product.shortDescription,
            style: _buildStyle(),
            onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
              if(url != null)
                _launchUrl(url, context);
            },
          ),
        ),
      ),
    );
  }

  _buildStyle() {
    return {
      "*": Style(textAlign: TextAlign.justify),
      "p": Style(color: Theme.of(context).hintColor),
    };
  }

  buildProductVariations(VariationOption variationOption, Product product) {
    return SliverToBoxAdapter(
      child: CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, listTileTopPadding, 16, listTileTopPadding),
          title: Text(variationOption.name, style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold
          )),
          subtitle: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: variationOption.attributeType == 'image' && variationOption.optionList.any((element) => element.image != null) ? List<Widget>.generate(variationOption.optionList.length, (int index) {
                return GestureDetector(
                  onTap: () => _onSelectVariation(variationOption, index, product),
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: variationOption.selected == variationOption.optionList[index].slug ? Colors.black : Colors.black.withOpacity(0.3),
                      ),
                    ),
                    height: 50,
                    width: 50,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          child: CachedNetworkImage(
                            imageUrl: variationOption.optionList[index].image!,
                            imageBuilder: (context, imageProvider) => Ink.image(
                              child: InkWell(
                                splashColor: Theme.of(context).hintColor,
                              ),
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                            placeholder: (context, url) => Container(color: Colors.white),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          child: variationOption.selected == variationOption.optionList[index].slug ? Center(child: Icon(Icons.check, color: Colors.white),) : null,
                        ),
                      ],
                    ),
                  ),
                );
              }) : variationOption.attributeType == 'color' && variationOption.optionList.any((element) => element.color != null) ? List<Widget>.generate(variationOption.optionList.length, (int index) {

                Color borderColor;
                String checkColor = Theme.of(context).brightness == Brightness.light ? '#ffffff' : '#000000';
                if (variationOption.optionList[index].color == checkColor) {
                  borderColor = Colors.black;
                } else {
                  borderColor = HexColor(variationOption.optionList[index].color);
                }

                return GestureDetector(
                  onTap: () => _onSelectVariation(variationOption, index, product),
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: variationOption.selected == variationOption.optionList[index].slug ? borderColor : borderColor.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    height: 50,
                    width: 50,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        color: HexColor(variationOption.optionList[index].color),
                      ),
                      child: variationOption.selected == variationOption.optionList[index].slug ? Center(child: Icon(Icons.check, color: Colors.white),) : null,
                    ),
                  ),
                );
              }) : List<Widget>.generate(variationOption.optionList.length, (int index) {
                return GestureDetector(
                  onTap: () => _onSelectVariation(variationOption, index, product),
                  child: Chip(
                    shape: StadiumBorder(),
                    backgroundColor: variationOption.selected ==
                        variationOption.optionList[index].slug ? Theme.of(context).colorScheme.secondary : Colors.white10,
                    label: Text(
                      variationOption.optionList[index].name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.0,
                        color: variationOption.selected == variationOption.optionList[index].slug
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartAndBuyNow(BuildContext context, Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8.0),
        child: product.stockStatus == 'outofstock' ? ElevatedButton(
          onPressed: null,
          child: Text(widget.appStateModel.blocks.localeText.outOfStock),
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  addToCart(context, product);
                },
                child: addingToCart ? Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                        strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                addToCart),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary:  Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {
                  buyNow(context, product);
                },
                child: buyingNow ? Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onSecondary),
                        strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                buyNow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCart(BuildContext context, Product product) {
    return SliverList(
        delegate: SliverChildListDelegate([
          CustomCard(
            child: Container(
                padding: EdgeInsets.fromLTRB(16, listTileTopPadding, 16, listTileTopPadding),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: product.stockStatus != 'outofstock'
                            ? () {
                          addToCart(context, product);
                        } : null,
                        child: product.stockStatus == 'outofstock' ? Text(widget.appStateModel.blocks.localeText.outOfStock,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!.copyWith(
                                color: Theme.of(context)
                                    .errorColor)) : addingToCart ? Container(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                                strokeWidth: 2.0)) : product.type != 'external' ? Text(widget.appStateModel.blocks.localeText.
                        addToCart) : Text(widget.appStateModel.blocks.localeText.
                        buyNow),
                      ),
                    ])),
          ),
        ]));
  }

  Widget buildWriteYourReview(Product product) {
    return SliverToBoxAdapter(
      child: CustomCard(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, listTileTopPadding, 16.0, listTileTopPadding),
          child: Column(
            children:
            [
              StreamBuilder<List<ReviewModel>>(
                  stream: widget.productDetailBloc.allReviews,
                  builder: (context, AsyncSnapshot<List<ReviewModel>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.length > 0) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewsDetail(product: product, productDetailBloc: widget.productDetailBloc)));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              trailing: Icon(CupertinoIcons.forward),
                              title: Text(widget.appStateModel.blocks.localeText.reviews + '(' + snapshot.data!.length.toString() +')'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: product.averageRating.toString(),
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(text: '/5', style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SmoothStarRating(
                                    color: Colors.amber,
                                    borderColor: Colors.amber,
                                    size: 20 ,
                                    rating: double.parse(product.averageRating),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewsPage(productId: product.id)));
                },
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  trailing: Icon(CupertinoIcons.forward),
                  title: Text(widget.appStateModel.blocks.localeText.writeYourReview),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget relatedProductsTitle(String title) {
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData && snapshot.data!.relatedProducts.length > 0) {
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              sliver: SliverToBoxAdapter(
                child: Text(title, style: Theme.of(context).textTheme.subtitle2),
              ),
            );
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget crossProductsTitle(String title) {
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData && snapshot.data!.crossProducts.length > 0) {
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              sliver: SliverToBoxAdapter(
                child: Text(title, style: Theme.of(context).textTheme.subtitle2),
              ),
            );
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget upsellProductsTitle(String title) {
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData && snapshot.data!.upsellProducts.length > 0) {
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              sliver: SliverToBoxAdapter(
                child: Text(title, style: Theme.of(context).textTheme.subtitle2),
              ),
            );
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfReleatedProducts() {
    String title = widget.appStateModel.blocks.localeText.relatedProducts;
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(
                snapshot.data!.relatedProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfCrossSellProducts() {
    String title =
        widget.appStateModel.blocks.localeText.justForYou;
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(
                snapshot.data!.crossProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfUpSellProducts() {
    String title =
        widget.appStateModel.blocks.localeText.youMayAlsoLike;
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(
                snapshot.data!.upsellProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildProductList(
      List<Product> products, BuildContext context, String title) {
    if (products.length > 0) {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
        sliver: SliverStaggeredGrid.count(
          crossAxisCount: 4,
          children: products.map<Widget>((item) {
            return ProductItemCard(product: item);
          }).toList(),
          staggeredTiles: products.map<StaggeredTile>((_) => StaggeredTile.fit(2))
              .toList(),
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
        ),
      );
      //USE for product scroll
      //ProductScroll(products: products, context: context, title: title);
    } else {
      return Container(
        child: SliverToBoxAdapter(),
      );
    }
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    if(product.type != 'external') {
      setState(() {
        addingToCart = true;
      });
      var data = new Map<String, dynamic>();
      data['product_id'] = product.id.toString();
      //data['add-to-cart'] = product.id.toString();
      data['quantity'] = _quantity.toString();
      var doAdd = true;
      if (product.type == 'variable' &&
          product.variationOptions != null) {
        for (var i = 0; i < product.variationOptions.length; i++) {
          if (product.variationOptions[i].selected != null) {
            String key = product.variationOptions[i].attribute.toLowerCase().replaceAll(' ', '-').replaceAll("'", "");
            if(!key.startsWith('pa_')) {
              key = 'pa_' + key;
            }
            data['variation[attribute_' + key + ']'] = product.variationOptions[i].selected;
            data['attribute_' + key] = product.variationOptions[i].selected;
          } else if (product.variationOptions[i].selected == null &&
              product.variationOptions[i].optionList.length != 0) {
            showSnackBarError(context, widget.appStateModel.blocks.localeText.select + ' ' + product.variationOptions[i].name);
            doAdd = false;
            break;
          } else if (product.variationOptions[i].selected == null &&
              product.variationOptions[i].optionList.length == 0) {
            showSnackBarError(context, widget.appStateModel.blocks.localeText.select + ' ' + product.variationOptions[i].name);
            doAdd = false;
            /*setState(() {
              product.stockStatus = 'outofstock';
            });*/
            doAdd = false;
            break;
          }
        }
        if (product.variationId != null) {
          data['variation_id'] = product.variationId;
        }
      }
      if (doAdd) {
        if (addonFormKey.currentState != null && addonFormKey.currentState!.validate()) {
          addonFormKey.currentState!.save();
          data.addAll(addOnsFormData);
        }
        bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
      }
      setState(() {
        addingToCart = false;
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WebViewPage(url: product.addToCartUrl, title: product.name),
          ));
    }
  }

  Future<void> buyNow(BuildContext context, Product product) async {
    setState(() {
      buyingNow = true;
    });
    var data = new Map<String, dynamic>();
    data['product_id'] = product.id.toString();
    //data['add-to-cart'] = product.id.toString();
    data['quantity'] = _quantity.toString();
    var doAdd = true;
    if (product.type == 'variable' &&
        product.variationOptions != null) {
      for (var i = 0; i < product.variationOptions.length; i++) {
        if (product.variationOptions[i].selected != null) {
          String key = product.variationOptions[i].attribute.toLowerCase().replaceAll(' ', '-').replaceAll("'", "");
          if(!key.startsWith('pa_')) {
            key = 'pa_' + key;
          }
          data['variation[attribute_' + key + ']'] = product.variationOptions[i].selected;
          data['attribute_' + key] = product.variationOptions[i].selected;
        } else if (product.variationOptions[i].selected == null &&
            product.variationOptions[i].optionList.length != 0) {
          showSnackBarError(context, widget.appStateModel.blocks.localeText.select + ' ' + product.variationOptions[i].name);
          doAdd = false;
          break;
        } else if (product.variationOptions[i].selected == null &&
            product.variationOptions[i].optionList.length == 0) {
          showSnackBarError(context, widget.appStateModel.blocks.localeText.select + ' ' + product.variationOptions[i].name);
          doAdd = false;
          /*setState(() {
              product.stockStatus = 'outofstock';
            });*/
          doAdd = false;
          break;
        }
      }
      if (product.variationId != null) {
        data['variation_id'] = product.variationId;
      }
    }
    if (doAdd) {
      if (addonFormKey.currentState != null && addonFormKey.currentState!.validate()) {
        addonFormKey.currentState!.save();
        data.addAll(addOnsFormData);
      }
      bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CartPage(),
          ));
    }
    setState(() {
      buyingNow = false;
    });
  }

  void _launchUrl(String url, BuildContext context) {
    if(url.contains('https://wa.me/') || url.contains('mailto:') || url.contains('sms:') || url.contains('tel:') || url.contains('https://m.me/')) {
      launchUrl(Uri.parse(url));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: url)));
    }
  }

  _onSelectVariation(VariationOption variationOption, int index, Product product) {
    setState(() {
      variationOption.selected = variationOption.optionList[index].slug;
      product.stockStatus = 'instock';
    });
    if (product.variationOptions
        .every((option) => option.selected != null)) {
      var selectedOptions = [];
      var matchedOptions = [];
      for (var i = 0;
      i < product.variationOptions.length;
      i++) {
        selectedOptions
            .add(product.variationOptions[i].selected);
      }
      for (var i = 0;
      i < product.availableVariations.length;
      i++) {
        matchedOptions = [];
        for (var j = 0;
        j < product.availableVariations[i].option.length;
        j++) {
          if (selectedOptions.contains(product
              .availableVariations[i].option[j].slug) ||
              product.availableVariations[i].option[j].slug
                  .isEmpty) {
            matchedOptions.add(product.availableVariations[i].option[j].slug);
          }
        }
        if (matchedOptions.length == selectedOptions.length) {
          setState(() {
            product.variationId = product.availableVariations[i].variationId.toString();
            if(product.availableVariations[i].displayPrice != null)
              product.regularPrice = product.availableVariations[i].displayPrice!
                  .toDouble();
            product.formattedPrice = product.availableVariations[i].formattedPrice;
            if(product.availableVariations[i].formattedSalesPrice != null)
              product.formattedSalesPrice = product.availableVariations[i].formattedSalesPrice;

            if(product.availableVariations[i].image.fullSrc.isNotEmpty && product
                .availableVariations[i].image.fullSrc.isNotEmpty)
              product.images[0].src = product
                  .availableVariations[i].image.fullSrc;

            if (product.availableVariations[i]
                .displayRegularPrice !=
                product.availableVariations[i].displayPrice) {
              product.salePrice = product
                  .availableVariations[i].displayRegularPrice!
                  .toDouble();
            }
            else
              product.formattedSalesPrice = null;
          });
          if (!product.availableVariations[i].isInStock) {
            setState(() {
              product.stockStatus = 'outofstock';
            });
          }
          break;
        }
      }
      /*if (matchedOptions.length != selectedOptions.length) {
                        setState(() {
                          product.stockStatus = 'outofstock';
                        });
                      }*/
    }
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {

    bool onSale = (this.product.onSale && product.formattedSalesPrice != null && product.formattedSalesPrice!.isNotEmpty);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4.0, 16, 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 4,
        children: <Widget>[
          Text(onSale && product.formattedSalesPrice != null ? parseHtmlString(product.formattedSalesPrice!) : '',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              )),
          //onSale ? SizedBox(width: 6.0) : SizedBox(width: 0.0),
          Text(
              (product.formattedPrice != null &&
                  product.formattedPrice!.isNotEmpty)
                  ? parseHtmlString(product.formattedPrice!)
                  : '',
              style: onSale && (product.formattedSalesPrice != null &&
                  product.formattedSalesPrice!.isNotEmpty) ? Theme.of(context).textTheme.caption!.copyWith(
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  decorationColor: Theme.of(context).textTheme.caption!.color!.withOpacity(0.5)
              ) : Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              )
          ),
        ],
      ),
    );
  }
}
