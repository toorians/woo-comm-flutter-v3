import 'dart:async';
import 'stores/store_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/blocks_model.dart';
import '../../models/app_state_model.dart';
import '../../models/vendor/search_store_state_model.dart';
import '../../models/vendor/store_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchStores extends StatefulWidget {
  final SearchStoreStateModel model = SearchStoreStateModel();

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
    if(_debounce.isActive) _debounce.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    widget.model.filter['search'] = inputController.text;
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(inputController.text.isNotEmpty) {
        widget.model.getAllStores();
      } else {
        widget.model.emptyStores();
      }
    });
  }

  late Timer _debounce;
  Color? fillColor;
  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: buildCupertinoTextField(context),
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
                    if ((model.stores != null && model.stores.isNotEmpty)) {
                      return CustomScrollView(
                        controller: _scrollController,
                        slivers: buildListOfBlocks(model.stores, model),
                      );
                    } else if(model.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return appStateModel.blocks.settings.popularSearches.length > 1 ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                              child: Text('Popular Search', style: Theme.of(context).textTheme.subtitle1),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                              child: Wrap(
                                children: _buildSearchList(appStateModel.blocks.settings.popularSearches)
                              ),
                            )
                          ],
                        ),
                      ) : Container();
                    }
                  })),
        ));
  }

  Row buildCupertinoTextField(BuildContext context) {
    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CupertinoTextField(
                controller: inputController,
                keyboardType: TextInputType.text,
                onChanged: (value) => _onSearchChanged(),
                placeholder: appStateModel.blocks.localeText.searchStores,
                prefix: Padding(
                  padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.2),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: fillColor,
                ),
              ),
        ),
        SizedBox(width: 8),
        Container(
          child: InkWell(
            onTap: Navigator.of(context).pop,
            child: Text(appStateModel.blocks.localeText.cancel,
                style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                  color: fillColor,
                )),
          ),
        ),
      ],
    );
  }

  _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        widget.model.hasMoreItems) {
      widget.model.loadMoreStores();
    }
  }

  List<Widget> buildListOfBlocks(
      List<StoreModel> stores, SearchStoreStateModel model) {
    List<Widget> list = [];
    list.add(StoreList(stores: stores, block: Block.fromJson({})));
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

  _buildSearchList(List<String> popularSearches) {
    List<Widget> list = [];
    popularSearches.forEach((element) {
      list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.dark ? Color(0xff696969) : Color(0xfff2f2f2),
                    padding: EdgeInsets.all(8),
                    onPrimary: Theme.of(context).textTheme.bodyText1!.color,
                    minimumSize: Size(56, 12)
                ),
                onPressed: () {
                  inputController.text = element;
                  widget.model.filter['search'] = inputController.text;
                  widget.model.getAllStores();
                },
                child: Text(element, style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 12
                ))
            ),
          )
      );
    });
    return list;
  }

}
