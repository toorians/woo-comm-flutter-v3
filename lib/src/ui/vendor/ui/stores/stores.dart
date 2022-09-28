import 'dart:io';

import 'package:app/src/blocs/vendor/stores_bloc.dart';
import '../../../../models/blocks_model.dart';
import './store_list/store_card_list.dart';
import './store_list/store_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/vendor/store_model.dart';
import 'search_store.dart';

class StoreListPage extends StatefulWidget {
  final Map<String, dynamic>? filter;
  Block? block;
  final StoresBloc storesBloc = StoresBloc();
  StoreListPage({Key? key, this.filter, this.block}) : super(key: key);
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  Color? fillColor;

  @override
  void initState() {
    super.initState();
    if(widget.filter != null) {
      widget.storesBloc.filter = widget.filter!;
    } if(widget.block == null) {
      widget.block = Block.fromJson({'blockType': BlockType.storeList, 'title': appStateModel.blocks.localeText.stores, 'maxCrossAxisExtent': 300, 'childWidth': 200, 'childHeight': 300});
    } else if(widget.block!.storeType.isNotEmpty) {
      widget.storesBloc.filter['vendor_type'] = widget.block!.storeType;
    }
    widget.storesBloc.getAllStores();
    _scrollController.addListener(_loadMoreItems);
  }

  _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        widget.storesBloc.hasMoreItems) {
      widget.storesBloc.loadMoreStores();
    }
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
      appBar: AppBar(title: buildHomeTitle(context)),
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.storesBloc.refresh();
          return;
        },
        child: StreamBuilder<List<StoreModel>>(
            stream: widget.storesBloc.storeList,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data != null ? CustomScrollView(
                controller: _scrollController,
                slivers: buildListOfBlocks(snapshot, context),
              ) : Center(child: CircularProgressIndicator());
            }
        ),
      ),
    );
  }

  Widget buildHomeTitle(BuildContext context) {

    final border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: Colors.transparent));

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
            return SearchStores(block: widget.block!);
          }));
        },
        child: TextField(
          showCursor: false,
          enabled: false,
          decoration: InputDecoration(
            hintText: appStateModel.blocks.localeText.searchStores,
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
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: false,
      elevation: 1.0,
      expandedHeight: 110,
      title: Text(widget.block!.title),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: <Widget>[
            SizedBox(height: Platform.isIOS ? 96.0 : 80.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                enableFeedback: false,
                splashColor: Colors.transparent,
                onTap: () {

                },
                child: buildHomeTitle(context),
              ),
            ),
          ],
        ),
      ),
      actions: [

      ],
    );
  }

  buildListOfBlocks(AsyncSnapshot<List<StoreModel>> snapshot, BuildContext context) {
    List<Widget> list = [];

    if(widget.block!.blockType == BlockType.storeList)
      list.add(StoreCard(stores: snapshot.data!, block: widget.block!));

    else list.add(StoreList(stores: snapshot.data!, block: widget.block!));

    list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
              widget.storesBloc.hasMoreItems
                  ? Container(
                  height: 60, child: Center(child: CircularProgressIndicator()))
                  : Container()
            ]))));

    return list;
  }
}
