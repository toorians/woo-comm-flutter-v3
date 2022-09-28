import 'package:app/src/data/gallery_options.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../account/account1.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStateModel().blocks.localeText.theme),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return ListView(
              children: [
                CustomCard(
                  child: RadioListTile<ThemeMode>(
                      title: Text(model.blocks.localeText.system),
                      value: ThemeMode.system,
                      groupValue: model.themeMode,
                      onChanged: (value) {
                        model.updateTheme(value);
                      }),
                ),
                CustomCard(
                  child: RadioListTile<ThemeMode>(
                      title: Text(model.blocks.localeText.light),
                      value: ThemeMode.light,
                      groupValue: model.themeMode,
                      onChanged: (value) {
                        model.updateTheme(value);
                      }),
                ),
                CustomCard(
                  child: RadioListTile<ThemeMode>(
                      title: Text(model.blocks.localeText.dark),
                      value: ThemeMode.dark,
                      groupValue: model.themeMode,
                      onChanged: (value) {
                        model.updateTheme(value);
                      }),
                )
              ],
            );
          }
      ),
    );
  }
}