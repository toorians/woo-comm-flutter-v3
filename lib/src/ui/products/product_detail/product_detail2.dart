import 'package:app/src/themes/hex_color.dart';
import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/blocks/blocks.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/models/vendor/store_model.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:app/src/ui/pages/webview.dart';
import 'package:app/src/ui/vendor/ui/vendor_app/vendor_home.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/src/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config.dart';
import '../../../ui/products/products/product_grid.dart';
import '../../../ui/products/product_grid/products_widgets/product_addons_new.dart';
import '../../color_override.dart';
import '../reviews/reviewDetail.dart';
import '../reviews/write_review.dart';
import '../reviews/review_list.dart';
import '../../../ui/checkout/cart/cart4.dart';
import '../../../functions.dart';
import './../product_grid/products_widgets/add_button_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import '../../../models/app_state_model.dart';
import '../../accounts/login/login.dart';
import '../../../models/releated_products.dart';
import '../../../models/review_model.dart';
import '../../../blocs/product_detail_bloc.dart';
import '../../../models/product_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ask_a_question.dart';
import 'cart_icon.dart';
import 'gallery_view.dart';
import 'package:html/dom.dart' as dom;

class ProductDetail2 extends StatefulWidget {
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  final Product product;
  final appStateModel = AppStateModel();
  ProductDetail2({Key? key, required this.product}) : super(key: key);
  @override
  _ProductDetail2State createState() => _ProductDetail2State();
}

class _ProductDetail2State extends State<ProductDetail2> {

  bool addingToCart = false;
  bool buyingNow = false;
  bool _swiperAutoPlay = true;
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
              floatingActionButton: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    if (model.blocks.settings.productPageChat) {
                      return Padding(
                        padding: widget.appStateModel.blocks.settings.productFooterAddToCart ? EdgeInsets.only(bottom: 30.0) : EdgeInsets.only(bottom: 0.0),
                        child: FloatingActionButton(
                          onPressed: () async {
                            final url = snapshot.data!.vendor.phone != null && snapshot.data!.vendor.phone!.isNotEmpty
                                ? 'https://wa.me/' +
                                snapshot.data!.vendor.phone.toString()
                                : 'https://wa.me/' +
                                model.blocks.settings.phoneNumber.toString();
                            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            //canLaunch not working for some android device
                            /*if (await canLaunch(url)) {
                                  await launchUri(Uri.parse(url));
                                } else {
                                  throw 'Could not launch $url';
                                }*/
                          },
                          tooltip: 'Chat',
                          child: Icon(Icons.chat_bubble),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              body: CustomScrollView(
                slivers: _buildSlivers(context, snapshot.data!),
              ),
              bottomNavigationBar: widget.appStateModel.blocks.settings.productFooterAddToCart ? _qSelector(snapshot.data!) : null,
            );
          } else {
            return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _buildSlivers(BuildContext context, Product product) {
    List<Widget> list = [];

    list.add(_buildAppBar(product));

    list.add(_buildImageGallery(product));

    list.add(_productName(product));

    list.add(_productPriceRating(product));

    if(product.vendor.name.isNotEmpty &&
        product.vendor.icon.isNotEmpty) list.add(buildStore(product));


    if (product.availableVariations.isNotEmpty &&
        product.availableVariations.length > 0) {
      for (var i = 0; i < product.variationOptions.length; i++) {
        if (product.variationOptions[i].optionList.length != 0) {
          list.add(buildOptionHeader(product.variationOptions[i].name));
          list.add(buildProductVariations(product.variationOptions[i], product));
        }
      }
    }

    //if(product.addons.length > 0)
    list.add(ProductAddons(
        product: product,
        addOnsFormData: addOnsFormData,
        addonFormKey: addonFormKey));

    //list.add(_buildQuantityInput());

    if(widget.appStateModel.blocks.settings.catalogueMode != true) {
      if(widget.appStateModel.blocks.settings.productFooterAddToCart == false)
        if(widget.appStateModel.blocks.settings.buyNowButton) {
          list.add(_buildAddToCartAndBuyNow(context, product));
        } else list.add(_buildAddToCart(context, product));
    }

    if(product.vendor.id != '0' && widget.appStateModel.blocks.vendorType == 'wcfm')
      list.add(SliverToBoxAdapter(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return AskAQuestion(
                          productId: product.id.toString(), vendorId: product.vendor.id.toString());
                    }));
              },
              child: Text(widget.appStateModel.blocks.localeText.askAQuestion)),
        ),
      )
      );

    if(removeAllHtmlTags(product.description).length > 1)
      list.add(_productDescription(product));

    if(removeAllHtmlTags(product.shortDescription).length > 1)
      list.add(_productShortDescription(product));

    //list.add(_productAttributes(product));

    if(widget.appStateModel.blocks.productPageLayout.length > 0) {
      for (var i = 0; i < widget.appStateModel.blocks.productPageLayout.length; i++)
        list.add(SliverBlock(block: widget.appStateModel.blocks.productPageLayout[i]));
    }

    list.add(relatedProductsTitle(widget.appStateModel.blocks.localeText.relatedProducts));
    list.add(buildLisOfReleatedProducts());


    list.add(crossProductsTitle(widget.appStateModel.blocks.localeText.justForYou));
    list.add(buildLisOfCrossSellProducts());

    list.add(upsellProductsTitle(widget.appStateModel.blocks.localeText.youMayAlsoLike));
    list.add(buildLisOfUpSellProducts());

    list.add(buildWriteYourReview(product));

    //list.add(ReviewList(productDetailBloc: widget.productDetailBloc));

    list.add(SliverToBoxAdapter(
      child: Container(
        height: 60,
      ),
    ));

    return list;
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
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

  Widget _buildImageGallery(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.width,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              splashColor: Theme.of(context).hintColor,
              onTap: () => null,
              child: CachedNetworkImage(
                imageUrl: product.images[index].src,
                imageBuilder: (context, imageProvider) => Ink.image(
                  child: InkWell(
                    splashColor: Theme.of(context).hintColor,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return GalleryView(
                                images: product.images);
                          }));
                    },
                  ),
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
                placeholder: (context, url) => Container(color: Colors.white),
                errorWidget: (context, url, error) =>
                    Container(color: Colors.white),
              ),
            );
          },
          itemCount: product.images.length,
          pagination: new SwiperPagination(),
          autoplay: _swiperAutoPlay,
        ),
      ),
    );
  }

  Widget _productName(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(product.name, style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }

  Widget _productPriceRating(Product product) {
    return SliverToBoxAdapter(
      child: ProductPrice(product: product, onSale: product.onSale),
    );
  }

  Widget _productDescription(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Html(
          data: product.description,
          style: _buildStyle(),
          onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
            if(url != null)
              _launchUrl(url, context);
          },
        ),
      ),
    );
  }

  Widget _productShortDescription(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Html(
          data: product.shortDescription,
          style: _buildStyle(),
          onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
            if(url != null)
              _launchUrl(url, context);
          },
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

  Widget _buildAddToCart(BuildContext context, Product product) {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
              )),
        ]));
  }

  Widget _buildAddToCartAndBuyNow(BuildContext c, Product product) {
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
                  addToCart(c, product);
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

  Widget buildOptionHeader(String name) {
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            name,
            style: Theme.of(context).textTheme.subtitle2,
          )),
    );
  }

  buildProductVariations(VariationOption variationOption, Product product) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
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
    );
  }

  Widget buildLisOfReleatedProducts() {
    String title =
        widget.appStateModel.blocks.localeText.relatedProducts;
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
        padding: const EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 4.0),
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

  Widget buildWriteYourReview(Product product) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
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
                            trailing: Icon(CupertinoIcons.forward),
                            title: Text(widget.appStateModel.blocks.localeText.reviews + '(' + snapshot.data!.length.toString() +')'
                              ,
                              style: Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.w700
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                            child: Row(

                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: product.averageRating.toString(),
                                    style: Theme.of(context).textTheme.headline5!.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: '/5', style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
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

            Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewsPage(productId: product.id)));
                },
                child: ListTile(
                  trailing: Icon(CupertinoIcons.forward),
                  title: Text(widget.appStateModel.blocks.localeText.writeYourReview),
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStore(Product product) {
    return SliverToBoxAdapter(
        child: buildStoreTile(context, product.vendor));
  }

  buildStoreTile(BuildContext context, Vendor store) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    StoreHomePage(store: StoreModel.fromJson({'id': int.parse(store.id), 'icon': store.icon, 'name': store.name}))));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(store.icon),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(store.name,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            //  Text(store.email),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Product product) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return SliverAppBar(
              floating: false,
              pinned: true,
              snap: false,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      CupertinoIcons.share,
                      semanticLabel: 'Share',
                    ),
                    onPressed: () async {
                      if(model.blocks.settings.dynamicLink.isNotEmpty) {
                        String wwref =  '?wwref=' + widget.appStateModel.user.id.toString();
                        final url = Uri.parse(product.permalink + '?product_id=' + product.id.toString() + '&title=' + product.name + wwref);
                        final DynamicLinkParameters parameters = DynamicLinkParameters(
                          uriPrefix: model.blocks.settings.dynamicLink,
                          link: url,
                          socialMetaTagParameters:  SocialMetaTagParameters(
                            title: product.name,
                            //description: product.name,
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
                WishListAppBarIcon(id: product.id),
                if(!widget.appStateModel.blocks.settings.catalogueMode)
                  CartIcon(),
              ]
          );
        }
    );
  }

  Widget _qSelector(Product product) {
    return SafeArea(
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).canvasColor,
          height: 55,
          child: Row(
            children: <Widget>[
              widget.appStateModel.blocks.settings.multiVendor && product.vendor.id != '0' ? Container(
                height: MediaQuery.of(context).size.height,
                width: 120,
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StoreHomePage(store: StoreModel.fromJson({'id': int.parse(product.vendor.id), 'icon': product.vendor.icon, 'name': product.vendor.name}))));
                      },
                      child: Container(
                        width: 58,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // height:30,
                              alignment: Alignment.topCenter,
                              child: Icon(
                                FlutterRemix.store_2_line,
                                color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.secondary : Colors.white,
                                semanticLabel: 'Store',size: 20,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(widget.appStateModel.blocks.localeText.stores,style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontSize: 12
                            ),)
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            height: 55,
                            width: 4,
                            child:VerticalDivider(
                              color: Colors.grey,
                            )
                        ),
                        Container(
                          width: 58,
                          child: InkWell(
                            onTap: () {
                              _chatWithVendorOrAdmin();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  //height:30,
                                  alignment: Alignment.topCenter,
                                  child: Icon(
                                    Icons.chat_bubble_outline,
                                    color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.secondary : Colors.white,
                                    semanticLabel: 'Contact',size: 20,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(widget.appStateModel.blocks.localeText.contacts,style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                    fontSize: 12
                                ),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ) : Container(
                height: MediaQuery.of(context).size.height,
                width: 60,
                child: CartIcon(),
              ),
              ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                return Expanded(
                  child: Container(
                    height: 55,
                    child: AddButtonDetail(
                      product: product,
                      model: model,
                      addonFormKey: addonFormKey,
                      addOnsFormData: addOnsFormData,),
                  ),
                );
              }
              )
            ],
          )),
    );
  }

  _chatWithVendorOrAdmin() {
    if(widget.appStateModel.user.id > 0) {
      if(widget.product.vendor.UID != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FireBaseChat(otherUserId: widget.product.vendor.UID!);
        }));
      } else {
        List ids = AppStateModel().blocks.siteSettings.adminUIDs;
        if(ids.length > 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FireBaseChat(otherUserId: AppStateModel().blocks.siteSettings.adminUIDs.first)));
        }
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  Future<void> addToCart(BuildContext c, Product product) async {

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
          product.variationOptions.length > 0) {
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
        bool status = await context.read<ShoppingCart>().addToCartWithData(data, c);
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
        product.variationOptions.isNotEmpty) {
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

  Widget _buildQuantityInput() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryColorOverride(
          child: TextFormField(
            initialValue: _quantity.toString(),
            decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.quantity),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _quantity = int.parse(value);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _productAttributes(Product product) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.attributes[index].name, style: Theme.of(context).textTheme.subtitle2,),
                Text(parseHtmlString(_getOptions(product.attributes[index].options)))
              ],
            ),
            height: 30.0);
      }, childCount: product.attributes.length,
      ),
    );
  }

  String _getOptions(List<String> options) {
    String s = '';
    for(var i = 0; i < options.length; i++) {
      s = s + options[i];
      if(options.length > i + 1) {
        s = ' ';
      }
    }
    return s;
  }

  Widget relatedProductsTitle(String title) {
    return StreamBuilder<RelatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
          if (snapshot.hasData && snapshot.data!.relatedProducts.length > 0) {
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              sliver: SliverToBoxAdapter(
                child: Text(title, style: Theme.of(context).textTheme.headline6),
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
                child: Text(title, style: Theme.of(context).textTheme.headline6),
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
                child: Text(title, style: Theme.of(context).textTheme.headline6),
              ),
            );
          } else {
            return SliverToBoxAdapter();
          }
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
    required this.onSale,
    required this.product,
  }) : super(key: key);

  final bool onSale;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16, 4.0),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: <Widget>[
          Text(onSale && (product.formattedSalesPrice != null)
              ? parseHtmlString(product.formattedSalesPrice!) : '',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              )),
          //onSale ? SizedBox(width: 6.0) : SizedBox(width: 0.0),
          Text(
              (product.formattedPrice != null)
                  ? parseHtmlString(product.formattedPrice!)
                  : '',
              style: onSale && (product.formattedSalesPrice != null) ? Theme.of(context).textTheme.bodyText1!.copyWith(
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.caption!.color,
                  decorationColor: Theme.of(context).textTheme.caption!.color
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
