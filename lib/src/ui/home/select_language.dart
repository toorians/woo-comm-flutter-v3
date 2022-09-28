/*
import 'package:flutter/material.dart';
import '../../../../src/data/gallery_options.dart';
import '../../../../src/models/app_state_model.dart';
import '../../../../src/ui/accounts/login/logo.dart';
import 'package:scoped_model/scoped_model.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    final options = GalleryOptions.of(context);
    TextStyle header6 = Theme.of(context).textTheme.headline5.copyWith(
      fontSize: 18
    );
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(

      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Text(model.blocks.localeText.welcome, style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 22
                )),
                Center(child: Logo()),
                Text(model.blocks.localeText.pleaseSelectLanguage, style: header6),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                              ),
                              shadowColor: Colors.transparent,
                              primary: model.appLocale.languageCode == 'en' ? Colors.blue.withOpacity(0.1) : null,
                              elevation: 0.0,
                              padding: EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              model.updateLanguage('en');
                              GalleryOptions.update(
                                context,
                                options.copyWith(locale: model.appLocale),
                              );
                              setState(() {});
                            },
                            child: Text('English')
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                              ),
                              elevation: 0.0,
                              shadowColor: Colors.transparent,
                              primary: model.appLocale.languageCode == 'ar' ? Colors.blue.withOpacity(0.1) : null,
                              padding: EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              model.updateLanguage('ar');
                              GalleryOptions.update(
                                context,
                                options.copyWith(locale: model.appLocale),
                              );
                            },
                            child: Text('عربى')
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(model.blocks.localeText.localeTextContinue)
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
*/
