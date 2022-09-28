import 'package:flutter/material.dart';
import '../../../blocs/contact_7_form_bloc.dart';
import '../../../models/category_model.dart';
import '../../../models/contact_form.dart';

class ContactForm7 extends StatefulWidget {
  final contactFormBloc = ContactFormBloc();
  final Category category;
  ContactForm7({Key? key, required this.category}) : super(key: key);

  @override
  _ContactForm7State createState() => _ContactForm7State();
}

class _ContactForm7State extends State<ContactForm7> {

  var formData = new Map<String, dynamic>();

  @override
  void initState() {
    widget.contactFormBloc.id.add(widget.category.id);
    widget.contactFormBloc.result.listen((event) => handleMessage(event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.category.name),
        elevation: 1,
      ),
      body: buildStreamBuilder(),
    );
  }

  StreamBuilder<Contact7Form> buildStreamBuilder() {
    return StreamBuilder(
        stream: widget.contactFormBloc.form,
        builder: (context, AsyncSnapshot<Contact7Form> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.all(16),
              children: buildListOfBlocks(snapshot),
            );
          } else return Center(child: CircularProgressIndicator());
        });
  }

  List<Widget> buildListOfBlocks(AsyncSnapshot<Contact7Form> snapshot) {
    List<Widget> list = [];

    for (ContactFormField contactFormField in snapshot.data!.properties.form.fields) {
      if(contactFormField.basetype == 'text') {
        list.add(
            TextFormField(
              onChanged: (value) {
                setState(() {
                  formData[contactFormField.name] = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  formData[contactFormField.name] = value;
                });
              },
              decoration: InputDecoration(
                  labelText: contactFormField.name.capitalize(),
              ),
            )
        );
      }

      if(contactFormField.basetype == 'url') {
        list.add(
            TextFormField(
              keyboardType: TextInputType.url,
              onChanged: (value) {
                setState(() {
                  formData[contactFormField.name] = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  formData[contactFormField.name] = value;
                });
              },
              decoration: InputDecoration(
                labelText: contactFormField.name.capitalize(),
              ),
            )
        );
      }

      if(contactFormField.basetype == 'email') {
        list.add(TextFormField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          onSaved: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          decoration: InputDecoration(
            labelText: contactFormField.name.capitalize(),
          ),
        ));
      }

      if(contactFormField.basetype == 'phone') {
        list.add(TextFormField(
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          onSaved: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          decoration: InputDecoration(
            labelText: contactFormField.name.capitalize(),
          ),
        ));
      }

      if(contactFormField.basetype == 'textarea') {
        list.add(TextFormField(
          onChanged: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          onSaved: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          decoration: InputDecoration(
            labelText: contactFormField.name.capitalize(),
          ),
        ));
      }

      if(contactFormField.basetype == 'tel') {
        list.add(TextFormField(
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          onSaved: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          decoration: InputDecoration(
            labelText: contactFormField.name.capitalize(),
          ),
        ));
      }

      if(contactFormField.basetype == 'number') {
        list.add(TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          onSaved: (value) {
            setState(() {
              formData[contactFormField.name] = value;
            });
          },
          decoration: InputDecoration(
            labelText: contactFormField.name.capitalize(),
          ),
        ));
      }
    }

    list.add(SizedBox(height: 24));

    list.add(
        ElevatedButton(
          child: StreamBuilder<bool>(
              stream: widget.contactFormBloc.loading,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Text('Please wait');
                } else {
                  return Text('Save');
                }
              }
          ),
          onPressed: () => widget.contactFormBloc.submitForm(formData),
        )
    );

    list.add(StreamBuilder<Contact7FormResult>(
      stream: widget.contactFormBloc.result,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.all(16.0),
          child: Text(snapshot.data!.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: snapshot.data!.status == 'mail_sent' ? Colors.green : Theme.of(context).errorColor
          ),),
        );
        } else {
          return Container();
        }
      }
    ));


    return list;
  }

  handleMessage(Contact7FormResult event) {

  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}".replaceAll('-', ' ');
  }
}