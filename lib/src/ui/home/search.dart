import 'dart:async';
import 'package:app/src/ui/products/products/product_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/blocks/search_field.dart';
import '../../ui/products/products/product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../ui/products/products/product_grid.dart';
import '../../models/app_state_model.dart';
import '../../blocs/search_bloc.dart';
import '../../models/product_model.dart';

class Search extends StatefulWidget {
  final Map<String, dynamic>? filter;
  final SearchBloc searchBloc = SearchBloc();

  Search({Key? key, this.filter}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  AppStateModel appStateModel = AppStateModel();

  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();
  Timer? _debounce;
  bool listView = false;

  @override
  void initState() {
    if(_debounce != null) _debounce!.cancel();
    if(widget.filter != null) {
      widget.searchBloc.filter = widget.filter!;
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && widget.searchBloc.moreItems) {
        widget.searchBloc.loadMoreSearchResults(inputController.text);
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    if(_debounce != null) _debounce!.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(inputController.text.isNotEmpty) {
        widget.searchBloc.fetchSearchResults(inputController.text);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: false,
        elevation: 0,
        title: SearchBarField(
          searchTextController: inputController,
          hintText: appStateModel.blocks.localeText.searchProducts,
          onChanged: (value) {_onSearchChanged();},
          autofocus: true,
        ),
      ),
      body: StreamBuilder<bool>(
        stream: widget.searchBloc.searchLoading,
        builder: (context, snapshotLoading) {
          return StreamBuilder<List<Product>>(
            stream: widget.searchBloc.searchResults,
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              if(snapshotLoading.hasData && snapshotLoading.data!) {
                return Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasData) {
                if(snapshot.data!.length != 0) {
                  return listView ? ProductGridPage(products: snapshot.data!) : buildProductList(snapshot, context);
                } else if(inputController.text.isNotEmpty) return Center(child: Text(appStateModel.blocks.localeText.noResults));
                    else return appStateModel.blocks.settings.popularSearches.length > 0 ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 4),
                        child: Text(appStateModel.blocks.localeText.popular, style: Theme.of(context).textTheme.caption),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        child: Wrap(
                            children: appStateModel.blocks.settings.popularSearches.map((searches) =>
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        inputController.text = searches;
                                      });
                                      _onSearchChanged();
                                    },
                                    child: Chip(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0.0),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      label: Text(searches),
                                    ),
                                  ),
                                )
                            ).toList()
                        ),
                      )
                    ]
                ) : Container();
              } else {
                return appStateModel.blocks.settings.popularSearches.length > 0 ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 4),
                        child: Text(appStateModel.blocks.localeText.popularSearches, style: Theme.of(context).textTheme.caption),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        child: Wrap(
                          children: appStateModel.blocks.settings.popularSearches.map((searches) =>
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      inputController.text = searches;
                                    });
                                    _onSearchChanged();
                                  },
                                  child: Chip(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    padding: EdgeInsets.all(0),
                                    label: Text(searches),
                                  ),
                                ),
                              )
                          ).toList()
                        ),
                      )
                    ]
                ) : Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildListView(snapshot, context) {
    return ListView.builder(controller: _scrollController, itemCount: snapshot.data.length, itemBuilder: (BuildContext context, int index) {
      return GroceryProductItem(product: snapshot.data[index]);
    });
  }

  Widget buildProductList(snapshot, context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        ProductGridPage(products: snapshot.data!),
        StreamBuilder<bool>(
          stream: widget.searchBloc.hasMoreItems,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if(snapshot.hasData && snapshot.data == true) {
              return SliverToBoxAdapter(child: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )));
            } else return SliverToBoxAdapter(child: Container());
          },
        )
      ],
    );
  }

  /*Widget buildRecentProductGridList(snapshot) {
    return SliverStaggeredGrid.count(
      crossAxisCount: 4,
      children: snapshot.data.map<Widget>((item) {
        return ProductItemCard(product: item);
      }).toList(),
      staggeredTiles: snapshot.data.map<StaggeredTile>((_) => StaggeredTile.fit(2))
          .toList(),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }*/

}