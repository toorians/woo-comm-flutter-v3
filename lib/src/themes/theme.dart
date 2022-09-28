import 'package:app/src/functions.dart';
import 'package:app/src/models/theme/flex_color_theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/theme/hex_color.dart';

import 'google_font.dart';

class BlockThemes {
  BlockThemes({
    required this.light,
    required this.dark,
    required this.themeMode,
    required this.googleFontsTextTheme,
    required this.useFlexTheme,
  });

  ThemeData light;
  ThemeData dark;
  ThemeMode themeMode;
  TextTheme Function([TextTheme]) googleFontsTextTheme;
  bool useFlexTheme;

  factory BlockThemes.fromJson(Map<String, dynamic> json) {
    return BlockThemes(
      useFlexTheme: json['useFlexTheme'] == true ? true : false,
      light: json['useFlexTheme'] == true ? flexThemeFromJson(json['flexLight'], 'light') : json['light'] == null ? ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                primary: Colors.blue,
                elevation: 0.0,
                onPrimary:  Colors.white,
                shadowColor: Colors.black,
                minimumSize: Size(600.0, 48.0),
                padding: EdgeInsets.all(0),
              )
          ),
      ) : _buildTheme(json['light'], json['elevatedButtonTheme']),
      dark: json['useFlexTheme'] == true ? flexThemeFromJson(json['flexDark'], 'dark') : json['dark'] == null ? ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              primary: Colors.blue ,
              elevation: 0.0,
              onPrimary:  Colors.white,
              shadowColor: Colors.black,
              minimumSize: Size(600.0, 48.0),
              padding: EdgeInsets.all(0),
            )
        ),
      ) : _buildTheme(json['dark'], json['elevatedButtonTheme']),
      //dark: json['dark'] == null ? BlockTheme.fromJson() : BlockTheme.fromJson(json['dark'] as Map<String, dynamic>),
      themeMode: json['themeMode'] == 'ThemeMode.dark' ? ThemeMode.dark : json['themeMode'] == 'ThemeMode.light' ? ThemeMode.light : ThemeMode.system,
      googleFontsTextTheme: GoogleFonts.robotoTextTheme,
    );
  }
}

ThemeData _buildTheme(dynamic json, dynamic buttonTheme) {
  //TODO Reaplce null with some value only if you get error for null
  Color primaryColor = _nullOrEmptyOrFalse(json['primaryColor']) ? Colors.white : HexColor(json['primaryColor']).toString() == 'Color(0xffffffff)' ? Colors.white : HexColor(json['primaryColor']);
  Color accentColor = _nullOrEmptyOrFalse(json['accentColor']) ? Colors.purple : HexColor(json['accentColor']);
  Color buttonColor = _nullOrEmptyOrFalse(json['buttonColor']) ? Colors.blue : HexColor(json['buttonColor']);
  double buttonRadius = _nullOrEmptyOrFalse(buttonTheme) ? 0 : _nullOrEmptyOrFalse(buttonTheme['borderRadius']) ? 0.0 : double.parse(buttonTheme['borderRadius'].toString());

  return ThemeData(
    // primaryTextTheme: GoogleFonts.montserratTextTheme(ThemeData(primaryColor: primaryColor).primaryTextTheme),
    // textTheme: GoogleFonts.montserratTextTheme(ThemeData(brightness: Brightness.light).textTheme),
    // accentTextTheme: GoogleFonts.montserratTextTheme(ThemeData(accentColor: accentColor).accentTextTheme),
    brightness: json['brightness'] == 'Brightness.dark' ? Brightness.dark : Brightness.light,
    primarySwatch: createPrimarySwatch(HexColor(json['primaryColor'])),
    primaryColor: primaryColor,
    primaryColorLight: _nullOrEmptyOrFalse(json['primaryColorLight']) ? null : HexColor(json['primaryColorLight']),
    primaryColorDark: _nullOrEmptyOrFalse(json['primaryColorDark']) ? null : HexColor(json['primaryColorDark']),
    //accentColor: _nullOrEmptyOrFalse(json['accentColor']) ? null : HexColor(json['accentColor']),
    canvasColor: _nullOrEmptyOrFalse(json['canvasColor']) ? null : HexColor(json['canvasColor']),
    shadowColor: _nullOrEmptyOrFalse(json['shadowColor']) ? null : HexColor(json['shadowColor']),
    scaffoldBackgroundColor: _nullOrEmptyOrFalse(json['scaffoldBackgroundColor']) ? null : HexColor(json['scaffoldBackgroundColor']),
    bottomAppBarColor: _nullOrEmptyOrFalse(json['bottomAppBarColor']) ? null : HexColor(json['bottomAppBarColor']),
    cardColor: _nullOrEmptyOrFalse(json['cardColor']) ? null : HexColor(json['cardColor']),
    dividerColor: _nullOrEmptyOrFalse(json['dividerColor']) ? null : HexColor(json['dividerColor']),
    focusColor: _nullOrEmptyOrFalse(json['focusColor']) ? null : HexColor(json['focusColor']),
    hoverColor: _nullOrEmptyOrFalse(json['hoverColor']) ? null : HexColor(json['hoverColor']),
    highlightColor: _nullOrEmptyOrFalse(json['highlightColor']) ? null : HexColor(json['highlightColor']),
    splashColor: _nullOrEmptyOrFalse(json['splashColor']) ? null : HexColor(json['splashColor']),
    selectedRowColor: _nullOrEmptyOrFalse(json['selectedRowColor']) ? null : HexColor(json['selectedRowColor']),
    unselectedWidgetColor: _nullOrEmptyOrFalse(json['unselectedWidgetColor']) ? null : HexColor(json['unselectedWidgetColor']),
    disabledColor: _nullOrEmptyOrFalse(json['disabledColor']) ? null : HexColor(json['disabledColor']),
    buttonColor: _nullOrEmptyOrFalse(json['buttonColor']) ? null : HexColor(json['buttonColor']),
    secondaryHeaderColor: _nullOrEmptyOrFalse(json['secondaryHeaderColor']) ? null : HexColor(json['secondaryHeaderColor']),
    //textSelectionColor: _nullOrEmptyOrFalse(json['textSelectionColor']) ? null : HexColor(json['textSelectionColor']),
    //cursorColor: _nullOrEmptyOrFalse(json['cursorColor']) ? null : HexColor(json['cursorColor']),
    //textSelectionHandleColor: _nullOrEmptyOrFalse(json['textSelectionHandleColor']) ? null : HexColor(json['textSelectionHandleColor']),
    backgroundColor: _nullOrEmptyOrFalse(json['backgroundColor']) ? null : HexColor(json['backgroundColor']),
    dialogBackgroundColor: _nullOrEmptyOrFalse(json['dialogBackgroundColor']) ? null : HexColor(json['dialogBackgroundColor']),
    indicatorColor: _nullOrEmptyOrFalse(json['indicatorColor']) ? null : HexColor(json['indicatorColor']),
    hintColor: _nullOrEmptyOrFalse(json['hintColor']) ? null : HexColor(json['hintColor']),
    errorColor: _nullOrEmptyOrFalse(json['errorColor']) ? null : HexColor(json['errorColor']),
    toggleableActiveColor: _nullOrEmptyOrFalse(json['toggleableActiveColor']) ? null : HexColor(json['toggleableActiveColor']),
    fontFamily: _nullOrEmptyOrFalse(json['fontFamily']) ? null : getGoogleFont(json['fontFamily']).fontFamily,
    appBarTheme: _nullOrEmptyOrFalse(json['appBarTheme']) ? AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: HexColor(json['primaryColor']).isDark ? Brightness.dark : Brightness.light,
      ),
    ) : _buildAppBarTheme(json['appBarTheme']),
    elevatedButtonTheme: _nullOrEmptyOrFalse(buttonTheme) ? ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
          ),
          primary: Colors.blue ,
          elevation: 0.0,
          onPrimary:  Colors.white,
          shadowColor: Colors.black,
          minimumSize: Size(600.0, 48.0),
          padding: EdgeInsets.all(0),
        )
    ) : ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
          ),
          primary: _nullOrEmptyOrFalse(buttonTheme['primary']) ? Colors.blue : HexColor(buttonTheme['primary']),
          elevation: _nullOrEmptyOrFalse(buttonTheme['elevation']) ? 0.0 : double.parse(buttonTheme['elevation'].toString()),
          onPrimary: _nullOrEmptyOrFalse(buttonTheme['onPrimary']) ? Colors.white : HexColor(buttonTheme['onPrimary']),
          shadowColor: _nullOrEmptyOrFalse(buttonTheme['shadowColor']) ? Colors.black : HexColor(buttonTheme['shadowColor']),
          minimumSize: Size(_nullOrEmptyOrFalse(buttonTheme['minWidth']) ? 600.0 : double.parse(buttonTheme['minWidth'].toString()), _nullOrEmptyOrFalse(buttonTheme['minHeight']) ? 48.0 : double.parse(buttonTheme['minHeight'].toString())),
          padding: EdgeInsets.all(_nullOrEmptyOrFalse(buttonTheme['padding']) ? 0.0 : double.parse(buttonTheme['padding'].toString())),
        )
    ),
    textButtonTheme: _nullOrEmptyOrFalse(buttonTheme) ? null : TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: _nullOrEmptyOrFalse(buttonTheme['primary']) ? Colors.blue : HexColor(buttonTheme['primary']),
      ),
    ),
    bottomNavigationBarTheme: _nullOrEmptyOrFalse(json['bottomNavigationBarTheme']) ? null : _buildBottomNavigationBarThemeTheme(json['bottomNavigationBarTheme']),
    navigationBarTheme: _nullOrEmptyOrFalse(json['navigationBarTheme']) ? null : _buildNavigationBarThemeTheme(json['navigationBarTheme']),
    tabBarTheme: _nullOrEmptyOrFalse(json['tabBarTheme']) ? null : _buildTabBarTheme(json['tabBarTheme']),
    buttonTheme: ButtonThemeData(
      buttonColor: buttonColor,
      //shape: StadiumBorder(),
      textTheme: ButtonTextTheme.primary,
      height: 45.0,
      colorScheme: new ColorScheme(
          primary: buttonColor,
          primaryContainer: buttonColor.brighten(5),
          secondary: Color(0xff03dac6),
          secondaryContainer: const Color(0xff018786),
          surface: buttonColor.isDark ? Colors.white : Colors.black,
          background: Colors.white,
          error: Color(0xffb00020),
          onPrimary: buttonColor.isDark ? Colors.white : Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: buttonColor.isDark ? Brightness.dark : Brightness.light
      ),
    ),
    colorScheme: _nullOrEmptyOrFalse(json['colorScheme']) ? null : _buildColorsScheme(json['colorScheme'])
  );
}

_buildColorsScheme(Map<String, dynamic>? json) {
  json ??= <String, dynamic>{};
  return ColorScheme(
    primary: json['primary'] == null ? Color(0xff6200ee) : HexColor(json['primary']),
    primaryContainer: json['primaryVariant'] == null ? Color(0xff3700b3) : HexColor(json['primaryVariant']),
    secondary: json['secondary'] == null ? Color(0xff03dac6) : HexColor(json['secondary']),
    secondaryContainer: json['secondaryVariant'] == null ? Color(0xff018786) : HexColor(json['secondaryVariant']),
    surface: json['surface'] == null ? Colors.white : HexColor(json['surface']),
    background: json['background'] == null ? Colors.white : HexColor(json['background']),
    error: json['error'] == null ? Color(0xffb00020) : HexColor(json['error']),
    onPrimary: json['onPrimary'] == null ? Colors.white : HexColor(json['onPrimary']),
    onSecondary: json['onSecondary'] == null ? Colors.black : HexColor(json['onSecondary']),
    onSurface: json['onSurface'] == null ? Colors.black : HexColor(json['onSurface']),
    onBackground: json['onSurface'] == null ? Colors.black : HexColor(json['onSurface']),
    onError: json['onError'] == null ? Colors.white : HexColor(json['onError']),
    errorContainer: json['errorContainer'] == null ? Color(0xffb00020) : HexColor(json['errorContainer']),
    brightness: json['brightness'] == 'Brightness.dark' ? Brightness.dark : Brightness.light,
  );
}

MaterialColor createPrimarySwatch(final Color? color) {
  // Null default fallback is default material primary light color.
  final Color _color = color ?? FlexColor.materialLightPrimary;
  const List<double> strengths = <double> //
  [0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
  final Map<int, Color> swatch = <int, Color>{};
  final int r = _color.red;
  final int g = _color.green;
  final int b = _color.blue;
  for (final double strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(_color.value, swatch);
}

_buildNavigationBarThemeTheme(json) {
  return NavigationBarThemeData(
    backgroundColor: _nullOrEmptyOrFalse(json['backgroundColor']) ? Colors.blue : HexColor(json['backgroundColor']),
    indicatorColor: _nullOrEmptyOrFalse(json['indicatorColor']) ? Colors.black54 : HexColor(json['indicatorColor']),
  );
}

_buildBottomNavigationBarThemeTheme(json) {
  return BottomNavigationBarThemeData(
    elevation: _nullOrEmptyOrFalse(json['elevation']) ? null : double.parse(json['elevation'].toString()),
    selectedItemColor: _nullOrEmptyOrFalse(json['selectedItemColor']) ? Colors.blue : HexColor(json['selectedItemColor']),
    unselectedItemColor: _nullOrEmptyOrFalse(json['unselectedItemColor']) ? Colors.black54 : HexColor(json['unselectedItemColor']),
    backgroundColor: _nullOrEmptyOrFalse(json["backgroundColor"]) ? Colors.white : HexColor(json["backgroundColor"]),
  );
}

TabBarTheme _buildTabBarTheme(json) {
  return TabBarTheme(
    labelColor: _nullOrEmptyOrFalse(json["labelColor"]) ? Color(0xFF000000) : HexColor(json["labelColor"]),
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: _nullOrEmptyOrFalse(json["labelColor"]) ? Color(0xFF000000) : HexColor(json["labelColor"]),
          width: _nullOrEmptyOrFalse(json["indicatorSize"]) ? 4.0 : double.parse(json["indicatorSize"].toString()),
        ),
      ),
    ),
    unselectedLabelColor: _nullOrEmptyOrFalse(json["unselectedLabelColor"]) ? Color(0xFF3D3D3D) : HexColor(json["unselectedLabelColor"]),
    //labelPadding:  _nullOrEmptyOrFalse(json["labelPadding"]) ? 0.0 : double.parse(json["labelPadding"].toString()),
    //indicatorSize: _nullOrEmptyOrFalse(json["indicatorSize"]) ? 0.0 : double.parse(json["indicatorSize"].toString()),
    //labelStyle: json["labelStyle"] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json["labelStyle"] as Map<String, dynamic>),
    //unselectedLabelStyle: json["unselectedLabelStyle"] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json["unselectedLabelStyle"] as Map<String, dynamic>),
  );
}

IconThemeData getIconThemeData(Map<String, dynamic> json) {
  return IconThemeData(
    color: _nullOrEmptyOrFalse(json['color']) ? Color(0xFF000000) : HexColor(json['color']),
    opacity: isNumeric(json['opacity']) ? double.parse(json['opacity'].toString()) : 1.0,
    size:  isNumeric(json['size']) ? double.parse(json['size'].toString()) : 24,
  );
}

class BlockIconTheme {
  BlockIconTheme({
    required this.color,
    required this.opacity,
    required this.size,
  });

  Color color;
  double opacity;
  double size;

  factory BlockIconTheme.fromJson(Map<String, dynamic> json) {
    return BlockIconTheme(
      color: _nullOrEmptyOrFalse(json['color']) ? Color(0xFF000000) : HexColor(json['color']),
      opacity: _nullOrEmptyOrFalse(json['opacity']) ? 1.0 : double.parse(json['opacity'].toString()),
      size:  _nullOrEmptyOrFalse(json['size']) ? 14 : double.parse(json['size'].toString()),
    );
  }
}

class BlockTextTheme {
  BlockTextTheme({
    required this.headline1,
    required this.headline2,
    required this.headline3,
    required this.headline4,
    required this.headline5,
    required this.headline6,
    required this.subtitle1,
    required this.subtitle2,
    required this.bodyText1,
    required this.bodyText2,
    required this.caption,
    required this.button,
    required this.overline,
  });

  BlockTextStyle headline1;
  BlockTextStyle headline2;
  BlockTextStyle headline3;
  BlockTextStyle headline4;
  BlockTextStyle headline5;
  BlockTextStyle headline6;
  BlockTextStyle subtitle1;
  BlockTextStyle subtitle2;
  BlockTextStyle bodyText1;
  BlockTextStyle bodyText2;
  BlockTextStyle caption;
  BlockTextStyle button;
  BlockTextStyle overline;

  factory BlockTextTheme.fromJson(Map<String, dynamic> json) {
    return BlockTextTheme(
      headline1: json['headline1'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['headline1'] as Map<String, dynamic>),
      headline2: json['headline2'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['headline2'] as Map<String, dynamic>),
      headline3: json['headline3'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['headline3'] as Map<String, dynamic>),
      headline4: json['headline4'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['headline4'] as Map<String, dynamic>),
      headline5: json['headline5'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['headline5'] as Map<String, dynamic>),
      headline6: json['headline6'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['headline6'] as Map<String, dynamic>),
      subtitle1: json['subtitle1'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['subtitle1'] as Map<String, dynamic>),
      subtitle2: json['subtitle2'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['subtitle2'] as Map<String, dynamic>),
      bodyText1: json['bodyText1'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['bodyText1'] as Map<String, dynamic>),
      bodyText2: json['bodyText2'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['bodyText2'] as Map<String, dynamic>),
      caption: json['caption'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['caption'] as Map<String, dynamic>),
      button: json['button'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['button'] as Map<String, dynamic>),
      overline: json['overline'] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json['overline'] as Map<String, dynamic>),
    );
  }
}

class BlockTextStyle {
  BlockTextStyle({
    required this.color,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.letterSpacing,
    required this.wordSpacing,
    //required this.textBaseline,
  });

  Color color;
  String fontFamily;
  double fontSize;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double letterSpacing;
  double wordSpacing;
  //String textBaseline;

  factory BlockTextStyle.fromJson(Map<String, dynamic> json) {
    return BlockTextStyle(
      color: _nullOrEmptyOrFalse(json['color']) ? Colors.black : HexColor(json['color']),
      fontFamily: _nullOrEmptyOrFalse(json['fontFamily']) ? 'Default' : json['fontFamily'].toString(),
      fontSize:  _nullOrEmptyOrFalse(json['fontSize']) ? 14 : double.parse(json['fontSize'].toString()),
      fontWeight: _nullOrEmptyOrFalse(json['fontWeight']) ? FontWeight.normal : getFontWeight(json['fontWeight'].toString()),
      fontStyle: json['fontStyle'] == 'FontStyle.italic' ? FontStyle.italic : FontStyle.normal,
      letterSpacing: _nullOrEmptyOrFalse(json['letterSpacing']) ? 0 : double.parse(json['letterSpacing'].toString()),
      wordSpacing: _nullOrEmptyOrFalse(json['wordSpacing']) ? 0 : double.parse(json['wordSpacing'].toString()),
      //textBaseline: json["textBaseline"] == null ? null : json["textBaseline"],
    );
  }

  Map<String, dynamic> toJson() => {
    'color': color == null ? null : toHexColor(color),
    'fontFamily': fontFamily == null ? null : fontFamily,
    'fontSize': fontSize == null ? null : fontSize.toDouble(),
    'fontWeight': fontWeight == null ? null : fontWeight.toString(),
    'fontStyle': fontStyle == null ? null : fontStyle.toString(),
    'letterSpacing': letterSpacing == null ? null : letterSpacing.toDouble(),
    'wordSpacing': wordSpacing == null ? null : wordSpacing.toDouble(),
    //'textBaseline': textBaseline == null ? null : textBaseline,
  };
}

class BlockButtonTheme {
  BlockButtonTheme({
    required this.minWidth,
    required this.height,
    required this.padding,
    required this.buttonColor,
    required this.disabledColor,
    required this.focusColor,
    required this.hoverColor,
    required this.highlightColor,
    required this.splashColor,
    required this.colorScheme,
  });

  double minWidth;
  double height;
  double padding;
  Color buttonColor;
  Color disabledColor;
  Color focusColor;
  Color hoverColor;
  Color highlightColor;
  Color splashColor;
  BlockColorScheme colorScheme;

  factory BlockButtonTheme.fromJson(Map<String, dynamic> json) {
    return BlockButtonTheme(
      minWidth: json['minWidth'] == null ? 88.0 : double.parse(json['minWidth'].toString()),
      height: json['height'] == null ? 36.0 : double.parse(json['height'].toString()),
      padding: json['padding'] == null ? 0 : double.parse(json['padding'].toString()),
      buttonColor: _nullOrEmptyOrFalse(json['buttonColor']) ? Color(0xff6200ee) : HexColor(json['buttonColor']),
      disabledColor: _nullOrEmptyOrFalse(json['disabledColor']) ? Color(0xff6200ee) : HexColor(json['disabledColor']),
      focusColor: _nullOrEmptyOrFalse(json['focusColor']) ? Color(0xff6200ee) : HexColor(json['focusColor']),
      hoverColor: _nullOrEmptyOrFalse(json['hoverColor']) ? Color(0xff6200ee) : HexColor(json['hoverColor']),
      highlightColor: _nullOrEmptyOrFalse(json['highlightColor']) ? Color(0xff6200ee) : HexColor(json['highlightColor']),
      splashColor: _nullOrEmptyOrFalse(json['splashColor']) ? Color(0xff6200ee) : HexColor(json['splashColor']),
      colorScheme: _nullOrEmptyOrFalse(json['colorScheme']) ? BlockColorScheme.fromJson({}) : BlockColorScheme.fromJson(json['colorScheme'] as Map<String, dynamic>),
    );
  }
}

class BlockColorScheme {
  BlockColorScheme({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.surface,
    required this.background,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.onBackground,
    required this.onError,
    required this.brightness,
  });

  Color primary;
  Color primaryVariant;
  Color secondary;
  Color secondaryVariant;
  Color surface;
  Color background;
  Color error;
  Color onPrimary;
  Color onSecondary;
  Color onSurface;
  Color onBackground;
  Color onError;
  Brightness brightness;

  factory BlockColorScheme.fromJson(Map<String, dynamic> json) {
    return BlockColorScheme(
      primary: json['primary'] == null ? Color(0xff6200ee) : HexColor(json['primary']),
      primaryVariant: json['primaryVariant'] == null ? Color(0xff3700b3) : HexColor(json['primaryVariant']),
      secondary: json['secondary'] == null ? Color(0xff03dac6) : HexColor(json['secondary']),
      secondaryVariant: json['secondaryVariant'] == null ? Color(0xff018786) : HexColor(json['secondaryVariant']),
      surface: json['surface'] == null ? Colors.white : HexColor(json['surface']),
      background: json['background'] == null ? Colors.white : HexColor(json['background']),
      error: json['error'] == null ? Color(0xffb00020) : HexColor(json['error']),
      onPrimary: json['onPrimary'] == null ? Colors.white : HexColor(json['onPrimary']),
      onSecondary: json['onSecondary'] == null ? Colors.black : HexColor(json['onSecondary']),
      onSurface: json['onSurface'] == null ? Colors.black : HexColor(json['onSurface']),
      onBackground: json['onBackground'] == null ? Colors.black : HexColor(json['onBackground']),
      onError: json['onError'] == null ? Colors.white : HexColor(json['onError']),
      brightness: json['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
    );
  }
}

AppBarTheme _buildAppBarTheme(json) {
  return AppBarTheme(
    elevation: _nullOrEmptyOrFalse(json['elevation']) ? null : double.parse(json['elevation'].toString()),
    color: _nullOrEmptyOrFalse(json['color']) ? Colors.blue : HexColor(json['color']),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: HexColor(json['color']).isDark ? Brightness.dark : Brightness.light,
    ),
    iconTheme: _nullOrEmptyOrFalse(json['iconTheme']) ? null : _buildIconTheme(json['iconTheme']),
    titleTextStyle: _nullOrEmptyOrFalse(json['titleTextStyle']) ? null : _buildTileTextStyle(json['titleTextStyle']),
  );
}

IconThemeData _buildIconTheme(Map<String, dynamic> json) {
  return IconThemeData(
    color: _nullOrEmptyOrFalse(json['color']) ? Color(0xFF000000) : HexColor(json['color']),
    opacity: isNumeric(json['opacity']) ? double.parse(json['opacity'].toString()) : 1.0,
    size:  isNumeric(json['size']) ? double.parse(json['size'].toString()) : 24,
  );
}

TextStyle _buildTileTextStyle(Map<String, dynamic> json) {
  return TextStyle(
    color: _nullOrEmptyOrFalse(json['color']) ? Color(0xFF000000) : HexColor(json['color']),
    fontFamily: _nullOrEmptyOrFalse(json['fontFamily']) ? null : json['fontFamily'].toString(),
    fontSize:  _nullOrEmptyOrFalse(json['fontSize']) ? 16 : double.parse(json['fontSize'].toString()),
    fontWeight:  _nullOrEmptyOrFalse(json['fontWeight']) ? FontWeight.w400 : getFontWeight(json['fontWeight']),
    fontStyle:  json['fontStyle'] == 'FontStyle.italic' ? FontStyle.italic : FontStyle.normal,
    letterSpacing:  _nullOrEmptyOrFalse(json['letterSpacing']) ? 0 : double.parse(json['letterSpacing'].toString()),
    wordSpacing:  _nullOrEmptyOrFalse(json['wordSpacing']) ? 0 : double.parse(json['wordSpacing'].toString()),
    textBaseline:  json['textBaseline'] == 'TextBaseline.ideographic' ? TextBaseline.ideographic : TextBaseline.alphabetic,
  );
}

bool _nullOrEmptyOrFalse(dynamic json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}

FontWeight getFontWeight(String fontWeight) {
  switch (fontWeight) {
    case 'FontWeight.normal':
      return FontWeight.normal;
    case 'FontWeight.bold':
      return FontWeight.bold;
    case 'FontWeight.w100':
      return FontWeight.w100;
    case 'FontWeight.w200':
      return FontWeight.w200;
    case 'FontWeight.w300':
      return FontWeight.w300;
    case 'FontWeight.w400':
      return FontWeight.w400;
    case 'FontWeight.w500':
      return FontWeight.w500;
    case 'FontWeight.w600':
      return FontWeight.w600;
    case 'FontWeight.w700':
      return FontWeight.w700;
    case 'FontWeight.w800':
      return FontWeight.w800;
    case 'FontWeight.w900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

MaterialColor _getPrimarySwatch(dynamic json) {
  switch (json.toString()) {
    case 'MaterialColor(primary value: Color(0xfff44336))':
      return Colors.red;
    case 'MaterialColor(primary value: Color(0xffe91e63))':
      return Colors.pink;
    case 'MaterialColor(primary value: Color(0xff9c27b0))':
      return Colors.purple;
    case 'MaterialColor(primary value: Color(0xff673ab7))':
      return Colors.deepPurple;
    case 'MaterialColor(primary value: Color(0xff3f51b5))':
      return Colors.indigo;
    case 'MaterialColor(primary value: Color(0xff2196f3))':
      return Colors.blue;
    case 'MaterialColor(primary value: Color(0xff03a9f4))':
      return Colors.lightBlue;
    case 'MaterialColor(primary value: Color(0xff00bcd4))':
      return Colors.cyan;
    case 'MaterialColor(primary value: Color(0xff009688))':
      return Colors.teal;
    case 'MaterialColor(primary value: Color(0xff4caf50))':
      return Colors.green;
    case 'MaterialColor(primary value: Color(0xff8bc34a))':
      return Colors.lightGreen;
    case 'MaterialColor(primary value: Color(0xffcddc39))':
      return Colors.lime;
    case 'MaterialColor(primary value: Color(0xffffeb3b))':
      return Colors.yellow;
    case 'MaterialColor(primary value: Color(0xffffc107))':
      return Colors.amber;
    case 'MaterialColor(primary value: Color(0xffff9800))':
      return Colors.orange;
    case 'MaterialColor(primary value: Color(0xffff5722))':
      return Colors.deepOrange;
    case 'MaterialColor(primary value: Color(0xff795548))':
      return Colors.brown;
    case 'MaterialColor(primary value: Color(0xff607d8b))':
      return Colors.blueGrey;
    default:
      return Colors.blue;
  }
}
