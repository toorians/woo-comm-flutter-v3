import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flex_color_scheme/src/flex_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import '../../../src/models/app_state_model.dart';
import '../../config.dart';
import '../../functions.dart';

class ReferAndEarn extends StatefulWidget {
  final appStateModel = AppStateModel();
  ReferAndEarn({Key? key}) : super(key: key);

  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Theme.of(context).colorScheme.secondary.isDark ? Brightness.dark : Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Builder(builder: (context) => buildOrderStatusScreen(context))
    );
  }

  Container buildOrderStatusScreen(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:
            Alignment(0.9, 0.9),
            colors:  <Color>[
              secondary,
              Theme.of(context).colorScheme.secondaryVariant
            ],
          )
      ),
      child: Stack(
        children: [
          Positioned(
              left: width *.25,
              top: height * .05,
              child: Icon(Icons.star_border,size: 30,color: Colors.lime,)
          ),
          Positioned(
              right: width * -.12,
              top: height * .01,
              child: Icon(Icons.ac_unit_outlined,size: 100,color: Colors.white24,)
          ),
          Positioned(
              right: width *.25,
              top: height * .15,
              child: Icon(Icons.star_border,size: 15,color: Colors.lime,)
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Icon(CupertinoIcons.money_dollar_circle_fill, size: 144, color: Colors.white),
                  SizedBox(height: 16),
                  Text(widget.appStateModel.blocks.localeText.shareAndEarnMoney,
                    style: TextStyle(
                      fontSize: 15,
                      color: onSecondary,
                      fontWeight: FontWeight.w800,
                      //letterSpacing: 1
                    ),),
                  SizedBox(height: 4),
                  Text(Config().url + '/my-account/?wwref=' + widget.appStateModel.user.id.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: onSecondary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      //letterSpacing: 1
                    ),),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.secondaryVariant,
                          elevation: 0,
                          onPrimary: Theme.of(context).colorScheme.onSecondary,
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () async {
                          final url = Config().url + '?wwref=' + widget.appStateModel.user.id.toString();
                          if(widget.appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
                            final DynamicLinkParameters parameters = DynamicLinkParameters(
                              uriPrefix: widget.appStateModel.blocks.settings.dynamicLink,
                              link: Uri.parse(url),
                              socialMetaTagParameters:  SocialMetaTagParameters(
                                title: 'Check this app',
                                description: 'Shop and earn money',
                              ),
                              androidParameters: AndroidParameters(
                                packageName: Config().androidPackageName,
                                minimumVersion: 0,
                              ),
                              iosParameters: IOSParameters(
                                bundleId: Config().iosPackageName,
                              ),
                            );

                            final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
                            Share.share(dynamicLink.shortUrl.toString());

                          } else Share.share(url);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.share),
                              SizedBox(width: 8),
                              Text(widget.appStateModel.blocks.localeText.share),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondaryVariant,
                            elevation: 0,
                            onPrimary: Theme.of(context).colorScheme.onSecondary,
                            padding: EdgeInsets.all(0),
                          ),
                          onPressed: () async {
                            final url = Config().url + '?wwref=' + widget.appStateModel.user.id.toString();
                            if(widget.appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
                              final DynamicLinkParameters parameters = DynamicLinkParameters(
                                uriPrefix: widget.appStateModel.blocks.settings.dynamicLink,
                                link: Uri.parse(url),
                                socialMetaTagParameters:  SocialMetaTagParameters(
                                  title: 'Check this app',
                                  description: 'Shop and earn money',
                                ),
                                androidParameters: AndroidParameters(
                                  packageName: Config().androidPackageName,
                                  minimumVersion: 0,
                                ),
                                iosParameters: IOSParameters(
                                  bundleId: Config().iosPackageName,
                                ),
                              );

                              final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
                              Share.share(dynamicLink.shortUrl.toString());

                              Clipboard.setData(ClipboardData(text: dynamicLink.shortUrl.toString()));
                            } else Clipboard.setData(ClipboardData(text: url));
                            showSnackBarSuccess(context, 'Referral link copied');
                          }, child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.copy),
                                SizedBox(width: 8),
                                Text(widget.appStateModel.blocks.localeText.copy, style: TextStyle(color: onSecondary),),
                              ],
                            ),
                          )),
                    ],
                  ),
                  /*SizedBox(height: 8),
                  TextButton(
                      onPressed: () async {
                        final url = Config().url + '?wwref=' + widget.appStateModel.user.id.toString();
                        if(widget.appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
                          final DynamicLinkParameters parameters = DynamicLinkParameters(
                            uriPrefix: widget.appStateModel.blocks.settings.dynamicLink,
                            link: Uri.parse(url),
                            socialMetaTagParameters:  SocialMetaTagParameters(
                              title: 'Check this app',
                            ),
                            androidParameters: AndroidParameters(
                              packageName: Config().androidPackageName,
                              minimumVersion: 0,
                            ),
                            iosParameters: IosParameters(
                              bundleId: Config().iosPackageName,
                              minimumVersion: '0',
                            ),
                          );
                          final Uri dynamicUrl = await parameters.buildUrl();
                          Clipboard.setData(ClipboardData(text: dynamicUrl.toString()));
                        } else Clipboard.setData(ClipboardData(text: url));
                        showSnackBarSuccess(context, 'Referral link copied');
                      }, child: Text('Copy', style: TextStyle(color: onSecondary),)),*/
                ],
              ),
            ),
          ),
        ],
      ) ,
    );
  }
}