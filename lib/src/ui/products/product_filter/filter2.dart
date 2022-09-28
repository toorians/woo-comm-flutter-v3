import 'package:flutter/material.dart';
import '../../../blocs/products_bloc.dart';
import '../../../models/app_state_model.dart';
import 'package:intl/intl.dart';
import '../../../models/attributes_model.dart';
import 'package:intl/intl.dart' as intl;

class FilterProduct2 extends StatefulWidget {
  final ProductsBloc productsBloc;

  const FilterProduct2({Key? key, required this.productsBloc}) : super(key: key);
  @override
  _FilterProduct2State createState() => _FilterProduct2State();
}

class _FilterProduct2State extends State<FilterProduct2> {
  var filter = new Map<String, dynamic>();
  final appStateModel = AppStateModel();
  late String selectedAttribute;

  @override
  void initState() {
    super.initState();
    selectedAttribute = 'price';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.filter),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: widget.productsBloc.allAttributes,
            builder: (context, AsyncSnapshot<List<AttributesModel>> snapshot) {
              return snapshot.hasData ? _buildFilter(snapshot) : Container();
            }),
      ),
    );
  }

  _buildFilter(AsyncSnapshot<List<AttributesModel>> snapshot) {
    Color backGroundColor = Theme.of(context).brightness == Brightness.light
        ? Color(0xFFf3f4ef)
        : Colors.black;
    return Stack(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 50),
                  color: backGroundColor,
                  width: 150,
                  child: ListView.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (BuildContext ctxt, int index) {
                        if (index == 0) {
                          return Container(
                            decoration: BoxDecoration(
                              color: selectedAttribute == 'price'
                                  ? Theme.of(context).brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black
                                  : backGroundColor,
                              border: isDirectionRTL(context) ? Border(
                                right: BorderSide(
                                  color: selectedAttribute == 'price'
                                      ? Theme.of(context).colorScheme.secondary
                                      : backGroundColor,
                                  width: 4.0,
                                ),
                              ) : Border(
                                left: BorderSide(
                                  color: selectedAttribute == 'price'
                                      ? Theme.of(context).colorScheme.secondary
                                      : backGroundColor,
                                  width: 4.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              selected: selectedAttribute == 'price',
                              title: Text(appStateModel.blocks.localeText.price, maxLines: 2,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedAttribute = 'price';
                                });
                              },
                            ),
                          );
                        } else
                          return Container(
                            decoration: BoxDecoration(
                              color: selectedAttribute ==
                                      snapshot.data![index - 1].id
                                  ? Theme.of(context).brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black
                                  : backGroundColor,
                              border: Border(
                                left: BorderSide(
                                  //                   <--- left side
                                  color: selectedAttribute ==
                                          snapshot.data![index - 1].id
                                      ? Theme.of(context).colorScheme.secondary
                                      : backGroundColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              selected:
                                  selectedAttribute == snapshot.data![index - 1].id,
                              title:
                                  Text(snapshot.data![index - 1].name, maxLines: 2,
                                      style: Theme.of(context).textTheme.bodyText1,
                                  ),
                              onTap: () {
                                setState(() {
                                  selectedAttribute = snapshot.data![index - 1].id;
                                });
                              },
                            ),
                          );
                      }),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        padding: EdgeInsets.all(18),
                        elevation: 0,
                        primary: Colors.black54,
                      ),
                      child: Text(appStateModel.blocks.localeText.reset),
                      onPressed: () {
                        widget.productsBloc.clearFilter();
                      },
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: Stack(
              children: [
                if (selectedAttribute == 'price')
                  _priceFilter()
                else Container(
                  padding: EdgeInsets.only(bottom: 50),
                  child: _buildTerms(snapshot.data!.singleWhere((element) => selectedAttribute == element.id)),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          padding: EdgeInsets.all(18),
                        elevation: 0,
                      ),
                      /*elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(0.0)),*/
                      child: Text(appStateModel.blocks.localeText.apply),
                      onPressed: () {
                        widget.productsBloc.applyFilter(
                            widget.productsBloc.productsFilter['id'],
                            appStateModel.selectedRange.start,
                            appStateModel.selectedRange.end);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ],
    );
  }

  _resetFilter() {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(1),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: ListTile(
            title: Text('Reset All', textAlign: TextAlign.center),
            onTap: () {
              widget.productsBloc.clearFilter();
            }),
      ),
    );
  }

  _priceFilter() {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: appStateModel.blocks.siteSettings.priceDecimal,
        name: appStateModel.selectedCurrency);
    return ListView(
      children: [
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${formatter.format(appStateModel.selectedRange.start)}'),
                  Text(
                      '${formatter.format(appStateModel.selectedRange.end)}'),
                ],
              ),
            ),
            Container(
              child: RangeSlider(
                  min: 0,
                  max: appStateModel.blocks.maxPrice.toDouble(),
                  divisions: appStateModel.maxPrice.toInt(),
                  values: appStateModel.selectedRange,
                  labels: RangeLabels(
                      '${formatter.format(appStateModel.selectedRange.start)}',
                      '${formatter.format(appStateModel.selectedRange.end)}'),
                  onChanged: (RangeValues newRange) {
                    //appStateModel.updateRangeValue(newRange);
                    setState(() {
                      appStateModel.selectedRange = newRange;
                    });
                  }),
            ),
          ],
        )
      ],
    );
  }

  _buildTerms(AttributesModel attribute) {
    return ListView.builder(
        itemCount: attribute.terms.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return CheckboxListTile(
            title: Text(attribute.terms[index].name),
            value: attribute.terms[index].selected,
            onChanged: (bool? value) {
              if(value != null)
              setState(() {
                attribute.terms[index].selected = value;
              });
            },
          );
        });
  }

  static bool isDirectionRTL(BuildContext context){
    return intl.Bidi.isRtlLanguage( Localizations.localeOf(context).languageCode);
  }
}
