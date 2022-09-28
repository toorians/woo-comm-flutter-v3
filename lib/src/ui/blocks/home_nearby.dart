import 'package:app/src/ui/blocks/blocks.dart';
import 'package:app/src/ui/blocks/place_selector.dart';
import 'package:app/src/ui/blocks/drawer.dart';
import 'package:app/src/ui/products/products/product_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../ui/products/products/product_grid.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../ui/blocks/app_bar.dart';
import './../../models/vendor/store_state_model.dart';
import './../../ui/home/place_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../models/app_state_model.dart';
import './../../models/blocks_model.dart';

class HomeNearBy extends StatefulWidget {
  final Map<String, dynamic>? filter;
  final StoreStateModel model = StoreStateModel();

  HomeNearBy({Key? key, this.filter}) : super(key: key);

  @override
  _HomeNearByState createState() => _HomeNearByState();
}

class _HomeNearByState extends State<HomeNearBy> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  @override
  void initState() {
    super.initState();
    /*if (widget.filter != null) {
      widget.model.filter = widget.filter!;
    }
    widget.model.getAllStores();*/
    _scrollController.addListener(_loadMoreItems);
  }

  _loadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !appStateModel.loadingHomeProducts) {
        appStateModel.loadMoreRecentProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreItems);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppStateModel().blocks.settings.appBarStyle.drawer ? MyDrawer() : null,
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return (model.blocks.blocks.isNotEmpty || model.blocks.recentProducts.isNotEmpty) ? CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomSliverAppBar(appBarStyle: model.blocks.settings.appBarStyle, onTapAddress: _onTapAddress),
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
            ): CustomScrollView(
              slivers: [
                buildSliverAppBar(),
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                )),
              ],
            );
          }
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      snap: false,
      titleSpacing: 0,
      elevation: 1.0,
      centerTitle: false,
      title: Container(),
    );
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
      setState(() {});
      /*widget.model.getAllStores();*/
      await appStateModel.updateAllBlocks();
      setState(() {});
    }
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


}
