import 'dart:async';
import 'dart:io';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'src/app.dart';
import 'src/data/gallery_options.dart';
import 'src/functions.dart';
import 'src/models/app_state_model.dart';
import 'src/models/snackbar_activity.dart';
import 'src/resources/api_provider.dart';
import 'src/themes/app_theme.dart';
import 'src/ui/blocks/products/wishlist_icon.dart';
import 'src/ui/intro/intro_slider.dart';

//Directory _appDocsDir;

void setOverrideForDesktop() {
  if (kIsWeb) return;
  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else if (Platform.isFuchsia) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  setOverrideForDesktop();
  AppStateModel model = AppStateModel();
  WidgetsFlutterBinding.ensureInitialized();

  //Uncomment this if not working due to error in SharedPreferences
  //SharedPreferences.setMockInitialValues({});
  await Firebase.initializeApp();
  await model.getLocalData();
  await model.getStoredBlocks();
  
  //Uncomment If you want to show splash screen for long time
  //await Future.delayed(Duration(seconds: 5));
  
  //UnComment when SSL site not working
  //HttpOverrides.global = new MyHttpOverrides();
  
  //Uncomment when Using Dynamic Splash
  //_appDocsDir = await getApplicationDocumentsDirectory();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final AppStateModel model = AppStateModel();
  MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final apiProvider = ApiProvider();
  late Timer _timer;
  int _start = 0;
  var splashIndex = ['0', '1', '2', '3', '4', '5'];
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    apiProviderInt();

    //Uncomment when Using Dynamic Splash
    //splashIndex.shuffle();
    //startTimer();
    
    widget.model.messageStream.listen((event) => _manageMessage(event));
    super.initState();
  }

  //Uncomment when Using Dynamic Splash
  /*File fileFromDocsDir(String filename) {
     String pathName = p.join(_appDocsDir.path, filename);
     return File(pathName);
  }*/

  void apiProviderInt() async {
    await apiProvider.init();
    await widget.model.getStoredBlocks();
    //setState(() {});
    await widget.model.updateAllBlocks();
    //setState(() {});
    //widget.model.getCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShoppingCart>(create: (_) => ShoppingCart()),
        ChangeNotifierProvider<Favourites>(create: (_) => Favourites()),
      ],
      child: ScopedModel<AppStateModel>(
          model: widget.model,
          child: ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
              return Builder(
                  builder: (context) {
                    if((widget.model.blocks.blocks.isNotEmpty || widget.model.blocks.recentProducts.isNotEmpty) && _start == 0) {
                      return MaterialApp(
                          scaffoldMessengerKey: _messangerKey,
                          localizationsDelegates: [
                            GlobalCupertinoLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                          ],
                          supportedLocales: supportedLocales,
                          locale: model.appLocale,
                          title: Config().appName,
                          debugShowCheckedModeBanner: false,
                          theme: widget.model.blocks.blockTheme.light,
                          darkTheme: widget.model.blocks.blockTheme.dark,
                          themeMode: model.themeMode,
                          //Uncomment If using intro Screens, Replace intro images and text in files inside lib/src/ui/intro/ folder
                          home: /*widget.model.hasSeenIntro == false ? IntroScreen(onFinish: () {
                            widget.model.setIntroScreenSeen();
                            widget.model.hasSeenIntro = true;
                            setState(() {});
                          }) : */App()
                      );
                    } else {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(primaryColor: Colors.white, appBarTheme: AppBarTheme(elevation: 0)),
                        darkTheme: ThemeData(primaryColor: Colors.white, appBarTheme: AppBarTheme(elevation: 0)),
                        home: Material(
                            child: Builder(
                                builder: (context) {
                                  return Scaffold(
                                    body: AnnotatedRegion<SystemUiOverlayStyle>(
                                      value: SystemUiOverlayStyle.dark,
                                      child: Center(
                                          child: Container(
                                              child: Image.asset('assets/images/splash.png', fit: BoxFit.contain))
                                      ),
                                    ),
                                  );
                                }
                            )
                        ),
                      );
                    }
                  }
              );
            }
          )),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            cancelTimer();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void cancelTimer() {
    _timer.cancel();
    setState(() {
      _start = 0;
    });
  }

  _manageMessage(SnackBarActivity event) {
    if(event.show && _messangerKey.currentState != null) {
      final snackBar = SnackBar(
          duration: event.duration,
          backgroundColor: event.success ? Colors.green :  Colors.red,
          content: Wrap(
            children: [
              Container(
                child: Text(
                  parseHtmlString(event.message),
                  maxLines: 6,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              event.loading ? Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Container(
                    height: 20,
                    width: 20,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2))
                ),
              ) : Container(),
            ],
          ));
      _messangerKey.currentState!.showSnackBar(snackBar);
    } else {
      _messangerKey.currentState!.hideCurrentSnackBar();
    }
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

/// A list of this localizations delegate's supported locales.
const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('af'),
  Locale('am'),
  Locale('ar'),
  Locale('ar', 'EG'),
  Locale('ar', 'JO'),
  Locale('ar', 'MA'),
  Locale('ar', 'SA'),
  Locale('as'),
  Locale('az'),
  Locale('be'),
  Locale('bg'),
  Locale('bn'),
  Locale('bs'),
  Locale('ca'),
  Locale('cs'),
  Locale('da'),
  Locale('de'),
  Locale('de', 'AT'),
  Locale('de', 'CH'),
  Locale('el'),
  Locale('en', 'AU'),
  Locale('en', 'CA'),
  Locale('en', 'GB'),
  Locale('en', 'IE'),
  Locale('en', 'IN'),
  Locale('en', 'NZ'),
  Locale('en', 'SG'),
  Locale('en', 'ZA'),
  Locale('es'),
  Locale('es', '419'),
  Locale('es', 'AR'),
  Locale('es', 'BO'),
  Locale('es', 'CL'),
  Locale('es', 'CO'),
  Locale('es', 'CR'),
  Locale('es', 'DO'),
  Locale('es', 'EC'),
  Locale('es', 'GT'),
  Locale('es', 'HN'),
  Locale('es', 'MX'),
  Locale('es', 'NI'),
  Locale('es', 'PA'),
  Locale('es', 'PE'),
  Locale('es', 'PR'),
  Locale('es', 'PY'),
  Locale('es', 'SV'),
  Locale('es', 'US'),
  Locale('es', 'UY'),
  Locale('es', 'VE'),
  Locale('et'),
  Locale('eu'),
  Locale('fa'),
  Locale('fi'),
  Locale('fil'),
  Locale('fr'),
  Locale('fr', 'CA'),
  Locale('fr', 'CH'),
  Locale('gl'),
  Locale('gsw'),
  Locale('gu'),
  Locale('he', 'IL'),
  Locale('he'),
  Locale('hi'),
  Locale('hr'),
  Locale('hu'),
  Locale('hy'),
  Locale('id'),
  Locale('is'),
  Locale('it'),
  Locale('ja'),
  Locale('ka'),
  Locale('kk'),
  Locale('km'),
  Locale('kn'),
  Locale('ko'),
  Locale('ky'),
  Locale('lo'),
  Locale('lt'),
  Locale('lv'),
  Locale('mk'),
  Locale('ml'),
  Locale('mn'),
  Locale('mr'),
  Locale('ms'),
  Locale('my'),
  Locale('nb'),
  Locale('ne'),
  Locale('nl'),
  Locale('or'),
  Locale('pa'),
  Locale('pl'),
  Locale('pt'),
  Locale('pt', 'BR'),
  Locale('pt', 'PT'),
  Locale('ro'),
  Locale('ru'),
  Locale('si'),
  Locale('sk'),
  Locale('sl'),
  Locale('sq'),
  Locale('sr'),
  Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'),
  Locale('sv'),
  Locale('sw'),
  Locale('ta'),
  Locale('te'),
  Locale('th'),
  Locale('tl'),
  Locale('tr'),
  Locale('uk'),
  Locale('ur'),
  Locale('uz'),
  Locale('vi'),
  Locale('zh'),
  Locale('zh', 'CN'),
  Locale('zh', 'HK'),
  Locale('zh', 'TW'),
  Locale('zu')
];
