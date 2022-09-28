import 'package:app/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:app/src/models/location_model.dart';
import 'banners/custom_card.dart';

class PlaceSelector extends StatefulWidget {
  @override
  _PlaceSelectorState createState() => _PlaceSelectorState();
}

class _PlaceSelectorState extends State<PlaceSelector> {

  CustomLocation? selectedPlace;
  AppStateModel appStateModel = AppStateModel();

  TextEditingController searchTextController = TextEditingController();

  List<CustomLocation> searchPlaces = [];

  @override
  void initState() {
    if(appStateModel.blocks.settings.locations.any((element) => element.name == appStateModel.customerLocation['name'])){
      selectedPlace = appStateModel.blocks.settings.locations.singleWhere((element) => element.name == appStateModel.customerLocation['name']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if(model.blocks.settings.locations.length > 0)
        return Scaffold(
          appBar: AppBar(
            title: Text('Select your location'),
            bottom: PreferredSize(
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                  height: 64.0,
                  child: buildSearchField(context, model),
                ),
                preferredSize: Size.fromHeight(64.0)),
          ),
          body: searchTextController.text.isNotEmpty ? ListView.builder(
              itemCount: searchPlaces.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _buildTiles(searchPlaces[index]);
              }) : ListView.builder(
              itemCount: model.blocks.settings.locations.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _buildTiles(model.blocks.settings.locations[index]);
              }),
        ); else return Scaffold(
            appBar: AppBar(),
          );
      }
    );
  }

  Widget _buildTiles(CustomLocation place) {
    return CustomCard(
      child: RadioListTile<CustomLocation>(
            title: Text(place.name),
            value: place,
            groupValue: selectedPlace,
            onChanged: (value) {
              setState(() {selectedPlace = value;});
              var location = new Map<String, dynamic>();
              location['address'] = place.address;
              location['pincode'] = place.pincode;
              location['name'] = place.name;
              location['latitude'] = place.latitude.toString();
              location['longitude'] = place.longitude.toString();
              AppStateModel().setPickedLocation(location);
              if(Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
    );
  }

  Widget buildSearchField(BuildContext context, AppStateModel model) {
    return SearchBarField(onChanged: (value) {
      setState(() {
        searchPlaces = model.blocks.settings.locations.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
      });
    }, searchTextController: searchTextController, hintText: 'Search Place',);
  }
}


class SearchBarField extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController searchTextController;
  final String hintText;
  const SearchBarField({Key? key, required this.onChanged, required this.searchTextController, required this.hintText}) : super(key: key);
  @override
  _SearchBarFieldState createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: TextFormField(
              controller: widget.searchTextController,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                ),
                fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Theme.of(context).focusColor,
                    width: 0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Theme.of(context).focusColor,
                    width: 0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Theme.of(context).focusColor,
                    width: 0,
                  ),
                ),
                contentPadding: EdgeInsets.all(6),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
