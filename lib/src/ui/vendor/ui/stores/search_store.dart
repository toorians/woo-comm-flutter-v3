import 'dart:async';
import '../../../../ui/blocks/search_field.dart';
import '../../../../models/blocks_model.dart';
import './store_list/store_card_list.dart';
import './store_list/store_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/vendor/search_store_state_model.dart';
import '../../../../models/vendor/store_model.dart';

class SearchStores extends StatefulWidget {
  final Block block;
  final SearchStoreStateModel model = SearchStoreStateModel();
  SearchStores({Key? key, required this.block}) : super(key: key);
  @override
  _SearchStoresState createState() => _SearchStoresState();
}

class _SearchStoresState extends State<SearchStores> {

  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    widget.model.stores = [];
    widget.model.filter['search'] = '';
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void dispose() {
    inputController.dispose();
    _scrollController.removeListener(_loadMoreItems);
    _scrollController.dispose();
    if(_debounce != null && _debounce!.isActive) _debounce!.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    widget.model.filter['search'] = inputController.text;
    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(inputController.text.isNotEmpty) {
        widget.model.getAllStores();
      } else {
        widget.model.emptyStores();
      }
    });
  }

  Timer? _debounce;

  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0,
          title: buildTitle(context),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await widget.model.refresh();
            return;
          },
          child: ScopedModel<SearchStoreStateModel>(
              model: widget.model,
              child: ScopedModelDescendant<SearchStoreStateModel>(
                  builder: (context, child, model) {
                if ((model.stores != null && model.stores.length > 0)) {
                  return CustomScrollView(
                        controller: _scrollController,
                        slivers: buildListOfBlocks(model.stores, model),
                      );
                } else if(model.loading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              })),
        ));
  }

  Widget buildTitle(BuildContext context) {
    return SearchBarField(
      searchTextController: inputController,
      hintText: appStateModel.blocks.localeText.searchStores,
      autofocus: true,
      onChanged: (value) => _onSearchChanged(),
    );
  }

  List<Widget> buildListOfBlocks(
      List<StoreModel> stores, SearchStoreStateModel model) {
    List<Widget> list = [];

    if(widget.block.blockType == BlockType.storeList)
      list.add(StoreCard(stores: stores, block: widget.block));

    else list.add(StoreList(stores: stores, block: widget.block));

    list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
              model.hasMoreItems
                  ? Container(
                  height: 60, child: Center(child: CircularProgressIndicator()))
                  : Container()
            ]))));
    return list;
  }

  _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        widget.model.hasMoreItems) {
      widget.model.loadMoreStores();
    }
  }
}
