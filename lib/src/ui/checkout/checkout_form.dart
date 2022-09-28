import 'package:app/src/models/geoode_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../blocs/checkout_form_bloc.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout_data_model.dart';
import 'package:place_picker/place_picker.dart';
import '../../config.dart';
import '../../functions.dart';
import '../color_override.dart';
import 'checkout_one_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:place_picker/widgets/widgets.dart';

class CheckoutForm extends StatefulWidget {
  final CheckoutFormBloc checkoutFormBloc;
  final appStateModel = AppStateModel();

  CheckoutForm({Key? key, required this.checkoutFormBloc}) : super(key: key);
  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {

  Map<String, TextEditingController> _textEditingController = Map();

  final Completer<GoogleMapController> mapController = Completer();
  final Set<Marker> markers = Set();

  final _formKey = GlobalKey<FormState>();
  Config config = Config();

  @override
  void initState() {
    super.initState();
    widget.checkoutFormBloc.getCheckoutForm();
    widget.checkoutFormBloc.updateOrderReview();
    widget.appStateModel.getDeliveryDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appStateModel.blocks.localeText.checkout)),
      body: StreamBuilder<CheckoutFormData>(
          stream: widget.checkoutFormBloc.checkoutForm,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: buildFrom(context, snapshot),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

  List<Widget> buildFrom(BuildContext context, AsyncSnapshot<CheckoutFormData> snapshot) {
    List<Widget> list = [];

    String isRequiredText = ' ' + widget.appStateModel.blocks.localeText.isRequired;

    /*list.add(
      FlatButton(
        colorBrightness: Theme.of(context).brightness,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_location),
            Text(
                widget.appStateModel.blocks.localeText.selectLocation)
          ],
        ),
        onPressed: () {
          showPlacePicker(snapshot);
        },
      ),
    );*/

    if(widget.appStateModel.blocks.settings.checkoutLocationPicker || snapshot.data!.fieldgroups.billing.any((element) => element.label == 'Delivery Location' && element.required == true))
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  return widget.appStateModel.customerLocation['address'] != null ? RadioListTile<String>(
                    contentPadding: EdgeInsets.all(0),
                    value: model.customerLocation['address'],
                    groupValue: model.customerLocation['address'],
                    onChanged: (value) {
                      setState(() {
                        model.customerLocation['address'] = value;
                      });
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery address'),
                        GestureDetector(
                          onTap: () async {
                            LocationResult? locationResult = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PlacePicker(config.mapApiKey);
                            }));
                            if(locationResult != null) {
                              _assignAddress(snapshot, locationResult);
                            }
                            widget.checkoutFormBloc.updateOrderReview2();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: Icon(Icons.edit_location_outlined),
                          ),
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.customerLocation['address']),
                      ],
                    ),
                    isThreeLine: true,
                  ) : TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_location),
                        Text(
                            widget.appStateModel.blocks.localeText.selectLocation)
                      ],
                    ),
                    onPressed: () async {
                      LocationResult? locationResult = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return PlacePicker(config.mapApiKey);
                      }));
                      if(locationResult != null) {
                        _assignAddress(snapshot, locationResult);
                      }
                      widget.checkoutFormBloc.updateOrderReview2();
                    },
                  );
                }
            ),
            TextButton(
                onPressed: () => getUserLocation(snapshot),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_searching),
                    SizedBox(width: 10,),
                    Text('Or use currrent location'),
                  ],
                )
            ),
            SizedBox(height: 16,),
          ],
        ),
      );

    snapshot.data!.fieldgroups.billing.forEach((element) {

      if(element.label.isNotEmpty) {
        if((element.type.isEmpty || element.type == 'text') && element.label != 'Delivery Location' && !['lpac_longitude', 'lpac_latitude', 'lpac_is_map_shown', 'lpac_places_autocomplete'].contains(element.key)) {

          if(_textEditingController[element.key] == null) {
            _textEditingController[element.key] = TextEditingController();
            _textEditingController[element.key]!.text = element.value!;
          }

          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: _textEditingController[element.key],
                //initialValue: element.value,
                decoration: InputDecoration(
                    labelText: element.label,
                    hintText: element.placeholder.isNotEmpty ? element.placeholder : element.label
                ),
                validator: (value) {
                  if (value != null && value.isEmpty && element.required == true) {
                    return element.label + isRequiredText;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    element.value = value;
                  });
                },
                onSaved: (value) {
                  if(value != null)
                    element.value = value;
                },
              ),
            ),
          );
        }

        if(element.type == 'tel') {
          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PrimaryColorOverride(
                child: TextFormField(
                  initialValue: element.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: element.label,
                      hintText: element.placeholder != null ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + isRequiredText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      element.value = value;
                    });
                  },
                  onSaved: (value) {
                    if(value != null)
                      element.value = value;
                  },
                ),
              ),
            ),
          );
        }

        if(element.type == 'email') {
          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PrimaryColorOverride(
                child: TextFormField(
                  initialValue: element.value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: element.label,
                      hintText: element.placeholder != null ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + isRequiredText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      element.value = value;
                    });
                  },
                  onSaved: (value) {
                    if(value != null)
                      element.value = value;
                  },
                ),
              ),
            ),
          );
        }

        if(element.type == 'country' && element.dotappOptions.length > 0) {
          if(element.value == null || element.value!.isEmpty || !element.dotappOptions.any((e) => e.value == element.value)) {
            element.value = element.dotappOptions.first.value;
          }
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DropdownButtonFormField<String>(
                value: element.value,
                hint: Text(element.label),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                onChanged: (String? newValue) {
                  if(snapshot.data!.fieldgroups.billing.any((element) => element.type == 'state')) {
                    snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'state').value = '';
                  }
                  if(newValue != null) {
                    setState(() {
                      widget.checkoutFormBloc.selectedCountry = newValue;
                      element.value = newValue;
                    });
                  }
                },
                items: element.dotappOptions.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value.value,
                    child: Text(parseHtmlString(value.label)),
                  );
                }).toList(),
              ),
            ),
          );
        }

        if(element.type == 'select' && element.dotappOptions.length > 0) {
          DotappOption selectedOption;
          if(element.dotappOptions.any((option) => option.value == element.value)) {
            selectedOption = element.dotappOptions.firstWhere((option) => option.value == element.value);
            if(element.key.contains('wcfmd_delvery_time')) {
              widget.checkoutFormBloc.formData[element.key] = selectedOption.key;
            } else widget.checkoutFormBloc.formData[element.key] = selectedOption.value;
          } else selectedOption = element.dotappOptions.first;
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DropdownButtonFormField<DotappOption>(
                value: selectedOption,
                hint: Text(element.label),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                onChanged: (DotappOption? newValue) {
                  if(newValue != null) {
                    widget.checkoutFormBloc.formData[element.key] = newValue.value;
                    if(element.key.contains('wcfmd_delvery_time')) {
                      widget.checkoutFormBloc.formData[element.key] = newValue.key;
                    }
                    setState(() {
                      element.value = newValue.value;
                    });
                  }
                },
                items: element.dotappOptions.map<DropdownMenuItem<DotappOption>>((value) {
                  return DropdownMenuItem<DotappOption>(
                    value: value,
                    child: value.value.isNotEmpty ? Text(parseHtmlString(value.value)) : Container(),
                  );
                }).toList(),
              ),
            ),
          );
        }

        if(snapshot.data != null && element.type == 'state' && snapshot.data!.fieldgroups.billing.any((element) => element.type == 'country')) {
          if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry))
            if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length > 0) {
              if(!snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.any((s) => s.value == element.value)) {
                element.value = snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.first.value;
                widget.checkoutFormBloc.getCity(element.value!, widget.checkoutFormBloc.selectedCountry);
              }
              list.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: element.value,
                    hint: Text(element.label),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      if(newValue != null) {
                        widget.checkoutFormBloc.formData['billing_state'] = '';
                        widget.checkoutFormBloc.formData['shipping_state'] = '';
                        setState(() {
                          element.value = newValue;
                        });
                        widget.checkoutFormBloc.getCity(newValue, widget.checkoutFormBloc.selectedCountry);
                      }
                    },
                    items: snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.value.isNotEmpty ? value.value : '',
                        child: Text(parseHtmlString(value.label)),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
        }

        if(element.type == 'city' && element.dotappOptions.length > 0) {
          DotappOption selectedOption;
          if(element.dotappOptions.any((option) => option.value == element.value)) {
            selectedOption = element.dotappOptions.firstWhere((option) => option.value == element.value);
            widget.checkoutFormBloc.formData[element.key] = selectedOption.value;
          } else selectedOption = element.dotappOptions.first;
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: SizedBox(
                  height: 28,
                  child: DropdownButton<DotappOption>(
                    value: selectedOption,
                    hint: Text(element.label),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 0,
                      //color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (DotappOption? newValue) {
                      if(newValue != null) {
                        widget.checkoutFormBloc.formData[element.key] = newValue.value;
                        /*if(element.key.contains('wcfmd_delvery_time')) {
                          widget.checkoutFormBloc.formData[element.key] = newValue.key;
                        }*/
                        setState(() {
                          element.value = newValue.value;
                        });
                      }
                    },
                    items: element.dotappOptions.map<DropdownMenuItem<DotappOption>>((value) {
                      return DropdownMenuItem<DotappOption>(
                        value: value,
                        child: value.value.isNotEmpty ? Text(parseHtmlString(value.value)) : Container(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        } else if(element.type == 'city' && element.dotappOptions.length == 0) {
          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: _textEditingController[element.key],
                //initialValue: element.value,
                decoration: InputDecoration(
                    labelText: element.label,
                    hintText: element.placeholder.isNotEmpty ? element.placeholder : element.label
                ),
                validator: (value) {
                  if (value != null && value.isEmpty && element.required == true) {
                    return element.label + isRequiredText;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    element.value = value;
                  });
                },
                onSaved: (value) {
                  if(value != null)
                    element.value = value;
                },
              ),
            ),
          );
        }

        if(snapshot.data != null && element.type == 'state' && snapshot.data!.fieldgroups.billing.any((element) => element.value == widget.checkoutFormBloc.selectedCountry) && snapshot.data!.fieldgroups.billing.firstWhere((element) => element.value == widget.checkoutFormBloc.selectedCountry).dotappOptions.isNotEmpty)
          if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.value == widget.checkoutFormBloc.selectedCountry).dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry))
            if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.value == widget.checkoutFormBloc.selectedCountry).dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length == 0) {
              list.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PrimaryColorOverride(
                    child: TextFormField(
                      initialValue: element.value,
                      decoration: InputDecoration(
                          labelText: element.label),
                      validator: (value) {
                        if (value != null && value.isEmpty && element.required == true) {
                          return element.label + isRequiredText;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if(value != null)
                          element.value = value;
                      },
                    ),
                  ),
                ),
              );
            }
      }
    });



    if(snapshot.data!.fieldgroups.account.length > 0 && widget.appStateModel.user.id == 0)
      snapshot.data!.fieldgroups.account.forEach((element) {
        if(element.label.isNotEmpty) {
          if(element.type == 'text') {
            list.add(
              PrimaryColorOverride(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: element.value,
                    decoration: InputDecoration(
                        labelText: element.label,
                        hintText: element.placeholder != null ? element.placeholder : element.label
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty && element.required == true) {
                        return element.label + isRequiredText;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        element.value = value;
                      });
                    },
                    onSaved: (value) {
                      element.value = value;
                    },
                  ),
                ),
              ),
            );
          }

          if(element.id == 'username') {
            list.add(
              PrimaryColorOverride(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: element.value,
                    decoration: InputDecoration(
                        labelText: element.label,
                        hintText: element.placeholder.isNotEmpty ? element.placeholder : element.label
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty && element.required == true) {
                        return element.label + isRequiredText;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        element.value = value;
                      });
                    },
                    onSaved: (value) {
                      element.value = value;
                    },
                  ),
                ),
              ),
            );
          }

          if(element.type == 'password') {
            list.add(
              PrimaryColorOverride(
                child: TextFormField(
                  initialValue: element.value,
                  decoration: InputDecoration(
                      labelText: element.label,
                      hintText: element.placeholder != null ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + isRequiredText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      element.value = value;
                    });
                  },
                  onSaved: (value) {
                    element.value = value;
                  },
                ),
              ),
            );
          }

          if(element.type == 'tel') {
            list.add(
              PrimaryColorOverride(
                child: TextFormField(
                  initialValue: element.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: element.label,
                      hintText: element.placeholder.isNotEmpty ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + isRequiredText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      element.value = value;
                    });
                  },
                  onSaved: (value) {
                    element.value = value;
                  },
                ),
              ),
            );
          }

          if(element.type == 'email') {
            list.add(
              PrimaryColorOverride(
                child: TextFormField(
                  initialValue: element.value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: element.label,
                      hintText: element.placeholder != null ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + isRequiredText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      element.value = value;
                    });
                  },
                  onSaved: (value) {
                    element.value = value;
                  },
                ),
              ),
            );
          }
        }
      });

    list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
            onPressed: () {
              widget.checkoutFormBloc.formData['security'] = snapshot.data!.data.nonce.updateOrderReviewNonce;
              widget.checkoutFormBloc
                  .formData['woocommerce-process-checkout-nonce'] = snapshot.data!.data.wpnonce;
              widget.checkoutFormBloc.formData['wc-ajax'] = 'update_order_review';
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                bool pass = true;
                for(final element in snapshot.data!.fieldgroups.billing) {
                  if(element.value != null && element.value!.isNotEmpty) {
                    if(!element.key.contains('wcfmd_delvery_time'))
                      widget.checkoutFormBloc.formData[element.key] = element.value!;
                  }  else if(element.required == true && element.label != 'Delivery Location') {
                    showSnackBarError(context, element.label + isRequiredText);
                    pass = false;
                    break;
                  }
                }
                if(snapshot.data!.fieldgroups.account.isNotEmpty && widget.appStateModel.user.id == 0)
                  for(final element in snapshot.data!.fieldgroups.account) {
                    if(element.value != null && element.value.isNotEmpty)
                      widget.checkoutFormBloc.formData[element.key] = element.value;
                    else if(element.required == true) {
                      showSnackBarError(context, element.label + isRequiredText);
                      pass = false;
                      break;
                    }
                  }
                widget.checkoutFormBloc.updateOrderReview2();
                if(pass == true)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckoutOnePage(
                            checkoutFormBloc: widget.checkoutFormBloc,
                          )));
              }
            },
          ),
        )
    );

    return list;
  }

  void showPlacePicker(AsyncSnapshot<CheckoutFormData> snapshot) async {
    LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker(config.mapApiKey)));
    if (result != null) {
      if(snapshot.data!.fieldgroups.billing.any((element) => element.key == 'billing_address_2')) {
        snapshot.data!.fieldgroups.billing.firstWhere((element) => element.key == 'billing_address_2').value = result.formattedAddress!;
      }
      if(snapshot.data!.fieldgroups.billing.any((element) => element.key == 'billing_city')) {
        snapshot.data!.fieldgroups.billing.firstWhere((element) => element.key == 'billing_city').value = result.city!.name!;
      }
      if(snapshot.data!.fieldgroups.billing.any((element) => element.key == 'billing_postcode')) {
        snapshot.data!.fieldgroups.billing.firstWhere((element) => element.key == 'billing_postcode').value = result.postalCode!;
      }
      snapshot.data!.fieldgroups.billing.forEach((element) {
        if(element.type == 'country' && element.dotappOptions.length > 0) {
          if (element.dotappOptions.indexWhere(
                  (country) => country.value == result.country!.shortName!) !=
              -1) {
            element.value = result.country!.shortName!;
          }
        }
        if(element.type == 'state' && element.dotappOptions.length > 0) {
          if (element.dotappOptions.indexWhere(
                  (state) => state.value == result.administrativeAreaLevel1!.shortName!) !=
              -1) {
            element.value = result.administrativeAreaLevel1!.shortName!;
          }
        }
      });
      setState(() {});
    }
  }

  getUserLocation(AsyncSnapshot<CheckoutFormData> snapshot) async {

    LocationData? myLocation;
    String error;
    Location location = new Location();

    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }

    if(myLocation != null) {

      List<Placemark> placemarks = [];
      placemarks = await placemarkFromCoordinates(myLocation.latitude!, myLocation.longitude!);

      if(placemarks.isNotEmpty) {

        final result = placemarks.first;

        this.mapController.future.then((controller) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(myLocation!.latitude!, myLocation.longitude!),
                zoom: 8.0)),
          );
        });
        setState(() {
          markers.clear();
          markers.add(Marker(
              markerId: MarkerId("selected-location"),
              position: LatLng(myLocation!.latitude!, myLocation.longitude!)));
        });

        var location = new Map<String, String>();
        LatLng target = LatLng(myLocation.latitude!, myLocation.longitude!);

        reverseGeocode(snapshot, target);

        location['address'] = result.street!;
        location['delivery_postalCode'] = result.postalCode!;
        location['delivery_city'] = result.locality!;
        location['delivery_latitude'] = myLocation.latitude.toString();
        location['delivery_latitude'] = myLocation.longitude.toString();
        widget.appStateModel.setDeliveryLocation(location);
      }
    }

    //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    //return first;
  }

  void _assignAddress(AsyncSnapshot<CheckoutFormData> snapshot, LocationResult? result) {
    if (result != null) {
      var location = new Map<String, String>();
      if(snapshot.data!.fieldgroups.billing.any((element) => element.key == 'billing_address_2')) {
        _textEditingController['billing_address_2']!.text = result.formattedAddress!;
        location['address'] = result.formattedAddress!;
      }
      if(snapshot.data!.fieldgroups.billing.any((element) => element.key == 'billing_city')) {
        _textEditingController['billing_city']!.text = result.city!.name!;
      }
      if(snapshot.data!.fieldgroups.billing.any((element) => element.key == 'billing_postcode')) {
        _textEditingController['billing_postcode']!.text = result.postalCode!;
      }
      snapshot.data!.fieldgroups.billing.forEach((element) {
        if(element.type == 'country' && element.dotappOptions.length > 0) {
          if (element.dotappOptions.indexWhere(
                  (country) => country.value == result.country!.shortName!) !=
              -1) {
            element.value = result.country!.shortName!;
            widget.checkoutFormBloc.selectedCountry = result.country!.shortName!;
          }
        }
        if(element.type == 'state' && snapshot.data!.fieldgroups.billing.any((element) => element.type == 'country')) {
          if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry)) {
            if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length > 0) {
              if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.any((s) => s.value == element.value)) {
                if (snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.indexWhere(
                        (state) => state.value == result.administrativeAreaLevel1!.shortName!) !=
                    -1) {
                  element.value = result.administrativeAreaLevel1!.shortName!;
                }
              }
            }}}
      });
      setState(() {

      });
      if(result.latLng?.latitude != null && result.latLng?.longitude != null) {
        widget.checkoutFormBloc.formData['wcfmmp_user_location_lat'] = result.latLng!.latitude.toString();
        widget.checkoutFormBloc.formData['wcfmmp_user_location_lng'] = result.latLng!.longitude.toString();

        //For plugin https://wordpress.org/plugins/map-location-picker-at-checkout-for-woocommerce/
        widget.checkoutFormBloc.formData['lpac_latitude'] = result.latLng!.latitude.toString();
        widget.checkoutFormBloc.formData['lpac_longitude'] = result.latLng!.longitude.toString();
      }
      if(result.formattedAddress != null) {
        widget.checkoutFormBloc.formData['wcfmmp_user_location'] = result.formattedAddress!;
      }
      widget.appStateModel.setDeliveryLocation(location);
    }


  }

  Future<void> reverseGeocode(AsyncSnapshot<CheckoutFormData> snapshot, LatLng latLng) async {
    try {

      LocationResult locationResult = LocationResult();

      final response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?" +
          "latlng=${latLng.latitude},${latLng.longitude}&" +
          "key=${config.mapApiKey}"));

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      GeoCodeAddress geoCodeAddress = geoCodeAddressFromJson(response.body);

      var location = new Map<String, String>();

      locationResult.formattedAddress = geoCodeAddress.results.first.formattedAddress;
      _textEditingController['billing_address_2']!.text = geoCodeAddress.results.first.formattedAddress;
      location['address'] = geoCodeAddress.results.first.formattedAddress;
      geoCodeAddress.results.first.addressComponents.forEach((geoElement) {
        if(geoElement.types.contains('postal_code')) {
          _textEditingController['billing_postcode']!.text = geoElement.shortName;
        } else if(geoElement.types.contains('locality')) {
          _textEditingController['billing_city']!.text = geoElement.shortName;
        }
      });

      geoCodeAddress.results.first.addressComponents.forEach((geoElement) {
        if(geoElement.types.contains('country')) {
          snapshot.data!.fieldgroups.billing.forEach((element) {
            if(element.type == 'country' && element.dotappOptions.length > 0) {
              if (element.dotappOptions.indexWhere(
                      (country) => country.value == geoElement.shortName) !=
                  -1) {
                element.value = geoElement.shortName;
                widget.checkoutFormBloc.selectedCountry = geoElement.shortName;
              }
            }
          });
        }
      });

      geoCodeAddress.results.first.addressComponents.forEach((geoElement) {
        if(geoElement.types.contains('administrative_area_level_1')) {
          snapshot.data!.fieldgroups.billing.forEach((element) {
            if(element.type == 'state' && snapshot.data!.fieldgroups.billing.any((element) => element.type == 'country')) {
              if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry)) {
                if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length > 0) {
                  if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.any((s) => s.value == element.value)) {
                    if (snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.indexWhere(
                            (state) => state.value == geoElement.shortName) !=
                        -1) {
                      element.value = geoElement.shortName;
                    }
                  }
                }}}
          });
        }
      });

      setState(() {

      });

      widget.checkoutFormBloc.formData['wcfmmp_user_location_lat'] = latLng.latitude.toString();
      widget.checkoutFormBloc.formData['wcfmmp_user_location_lng'] = latLng.longitude.toString();

      //For plugin https://wordpress.org/plugins/map-location-picker-at-checkout-for-woocommerce/
      widget.checkoutFormBloc.formData['lpac_latitude'] = latLng.latitude.toString();
      widget.checkoutFormBloc.formData['lpac_longitude'] = latLng.longitude.toString();


      if(location['address'] != null) {
        widget.checkoutFormBloc.formData['wcfmmp_user_location'] = location['address']!;
      }

      widget.appStateModel.setDeliveryLocation(location);

      /*setState(() {
        locationResult = LocationResult()
          ..name = result['address_components'][0]['short_name']
          ..locality = result['address_components'][1]['short_name']
          ..latLng = latLng
          ..formattedAddress = result['formatted_address']
          ..placeId = result['place_id']
          ..postalCode = result['address_components'][5]['short_name']
          ..country = AddressComponent.fromJson(result['address_components'][4])
          ..administrativeAreaLevel1 = AddressComponent.fromJson(result['address_components'][5])
          ..administrativeAreaLevel2 = AddressComponent.fromJson(result['address_components'][4])
          ..city = AddressComponent.fromJson(result['address_components'][3])
          ..subLocalityLevel1 = AddressComponent.fromJson(result['address_components'][2])
          ..subLocalityLevel2 = AddressComponent.fromJson(result['address_components'][1]);
      });*/

      //_assignAddress(snapshot, locationResult);

    } catch (e) {
      print(e);
    }
  }
}
