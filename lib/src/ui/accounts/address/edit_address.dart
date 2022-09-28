import 'package:app/src/ui/widgets/buttons/button_text.dart';
import 'package:flutter/material.dart';
import '../../../blocs/checkout_form_bloc.dart';
import '../../../models/app_state_model.dart';
import '../../../models/checkout_data_model.dart';
import '../../../config.dart';
import '../../../functions.dart';
import '../../color_override.dart';

class EditAddress extends StatefulWidget {
  final CheckoutFormBloc checkoutFormBloc = CheckoutFormBloc();
  final appStateModel = AppStateModel();
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {

  final _formKey = GlobalKey<FormState>();
  Config config = Config();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    widget.checkoutFormBloc.getCheckoutForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appStateModel.blocks.localeText.address)),
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


    snapshot.data!.fieldgroups.billing.forEach((element) {
      if(element.label.isNotEmpty) {
        if(element.type.isEmpty || element.type == 'text') {
          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PrimaryColorOverride(
                child: TextFormField(
                  initialValue: element.value,
                  decoration: InputDecoration(
                      labelText: element.label,
                      hintText: element.placeholder.isNotEmpty ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + ' ' + widget.appStateModel.blocks.localeText.isRequired;
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
                      hintText: element.placeholder.isNotEmpty ? element.placeholder : element.label
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty && element.required == true) {
                      return element.label + ' ' + widget.appStateModel.blocks.localeText.isRequired;
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
                      return element.label + ' ' + widget.appStateModel.blocks.localeText.isRequired;
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
          list.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: SizedBox(
                  height: 28,
                  child: DropdownButton<String>(
                    value: element.value,
                    hint: Text(element.label),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 0,
                      //color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (String? newValue) {
                      if(snapshot.data!.fieldgroups.billing.any((element) => element.type == 'state')) {
                        snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'state').value = '';
                      }
                      if(newValue != null)
                        setState(() {
                          widget.checkoutFormBloc.selectedCountry = newValue;
                          element.value = newValue;
                        });
                    },
                    items: element.dotappOptions.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.value != null ? value.value : '',
                        child: Text(parseHtmlString(value.label)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        }

        if(element.type == 'select' && element.dotappOptions.length > 0) {
          DotappOption selectedOption;
          if(element.dotappOptions.any((option) => option.value == element.value)) {
            selectedOption = element.dotappOptions.firstWhere((option) => option.value == element.value);
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
                    setState(() {
                      element.value = newValue.value;
                    });
                  }
                },
                items: element.dotappOptions.map<DropdownMenuItem<DotappOption>>((value) {
                  return DropdownMenuItem<DotappOption>(
                    value: value,
                    child: value.value != null ? Text(parseHtmlString(value.value)) : Container(),
                  );
                }).toList(),
              ),
            ),
          );
        }

        if(element.type == 'state' && snapshot.data!.fieldgroups.billing.any((element) => element.type == 'country')) {
          if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.any((country) => country.value == widget.checkoutFormBloc.selectedCountry))
            if(snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.length > 0) {
              if(!snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.any((s) => s.value == element.value)) {
                element.value = snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.first.value;
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
                      }
                    },
                    items: snapshot.data!.fieldgroups.billing.firstWhere((element) => element.type == 'country').dotappOptions.singleWhere((country) => country.value == widget.checkoutFormBloc.selectedCountry).regions.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.value != null ? value.value : '',
                        child: Text(parseHtmlString(value.label)),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
        }

        if(element.type == 'state' && snapshot.data!.fieldgroups.billing.any((element) => element.value == widget.checkoutFormBloc.selectedCountry))
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
                          return element.label + ' ' + widget.appStateModel.blocks.localeText.isRequired;
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


    list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            child:  ButtonText(isLoading: loading, text: widget.appStateModel.blocks.localeText.localeTextContinue),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                bool pass = true;
                for(final element in snapshot.data!.fieldgroups.billing) {
                  if(element.value != null && element.value!.isNotEmpty)
                    widget.checkoutFormBloc.formData[element.key] = element.value!;
                  else if(element.required == true) {
                    showSnackBarError(context, element.label + ' ' + widget.appStateModel.blocks.localeText.isRequired);
                    pass = false;
                    break;
                  }
                }
                if(pass == true) {
                  setState(() {
                    loading = true;
                  });
                  await widget.checkoutFormBloc.updateAddress();
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                }
              }
            },
          ),
        )
    );

    return list;
  }

}
