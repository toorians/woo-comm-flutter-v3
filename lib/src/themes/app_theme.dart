import 'package:app/src/models/theme/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinycolor2/tinycolor2.dart';
import '../models/blocks_model.dart';

class GalleryThemeData {

  static ThemeData lightThemeData(BuildContext context, AppTheme theme) =>
      themeDataLight(context, theme);
  static ThemeData darkThemeData(BuildContext context, AppTheme theme) => themeDataDark(context, theme);

  static ThemeData lightArabicThemeData(BuildContext context, AppTheme theme) =>
      themeArabicDataLight(context, theme);
  static ThemeData darkArabicThemeData = themeArabicDataDark();

  static ThemeData themeDataLight(BuildContext context, AppTheme theme) {

    MaterialColor primarySwatch = _getPrimarySwatch(theme.primarySwatch);
    Color buttonColor = HexColor(theme.buttonColor);
    Color primaryColor = HexColor(theme.primaryColor).toString() == 'Color(0xffffffff)' ? Colors.white : HexColor(theme.primaryColor);
    Color accentColor = HexColor(theme.accentColor);

    return ThemeData(
      primarySwatch: primarySwatch,
      primaryColor: primaryColor,
      accentColor: accentColor,
      // primaryTextTheme: GoogleFonts.montserratTextTheme(ThemeData(primaryColor: primaryColor, brightness: primaryColor.isDark ? Brightness.dark : Brightness.light).primaryTextTheme),
      // textTheme: GoogleFonts.montserratTextTheme(ThemeData(brightness: Brightness.light).textTheme),
      // accentTextTheme: GoogleFonts.montserratTextTheme(ThemeData(accentColor: accentColor).accentTextTheme),
      appBarTheme: AppBarTheme(
        //textTheme: _textTheme.apply(bodyColor: Colors.white),
        //color: Colors.white,
        elevation: 0.0,
        //iconTheme: IconThemeData(color: Colors.white),
        //brightness: Brightness.dark,
      ),
      /*inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey.withOpacity(0.2)
      ),*/
      //primaryIconTheme: IconThemeData(color: Colors.black),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black,
        labelColor: Colors.black),
        buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: buttonColor,
            primaryVariant: buttonColor.brighten(5),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            elevation: 0,
            onPrimary: Colors.white,
            shadowColor: Colors.black,
            minimumSize: Size(400.0, 48.0),
            padding: EdgeInsets.all(0.0),
          )
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData themeDataDark(BuildContext context, AppTheme theme) {
    ThemeData theme = ThemeData(brightness: Brightness.dark);
    return ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.robotoTextTheme(theme.textTheme),
        primaryTextTheme: GoogleFonts.robotoTextTheme(theme.primaryTextTheme),
        accentTextTheme: GoogleFonts.robotoTextTheme(theme.accentTextTheme),
        buttonColor:Color(0xff03dac6),
        buttonTheme: ButtonThemeData(
          buttonColor:Color(0xff03dac6),
          //shape: StadiumBorder(),
          textTheme: ButtonTextTheme.primary,
          height: 45.0,
          colorScheme: new ColorScheme(
              primary: Color(0xff03dac6),
              primaryVariant: const Color(0xff03dac6),
              secondary: const Color(0xff03dac6),
              secondaryVariant: const Color(0xff03dac6),
              background: const Color(0xff000000),
              surface: const Color(0xff121212),
              error: Color(0xffb00020),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light),
        ),
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: Colors.black87,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              elevation: 0,
              primary: Color(0xff03dac6),
              onPrimary: Colors.black,
              shadowColor: Colors.black,
              minimumSize: Size(400.0, 48.0),
              padding: EdgeInsets.all(0.0),
            )
        ),
    );
  }

  static ThemeData themeArabicDataLight(BuildContext context, AppTheme theme) {

    MaterialColor primarySwatch = _getPrimarySwatch(theme.primarySwatch);
    Color buttonColor = HexColor(theme.buttonColor);
    Color primaryColor = HexColor(theme.primaryColor).toString() == 'Color(0xffffffff)' ? Colors.white : HexColor(theme.primaryColor);
    Color accentColor = HexColor(theme.accentColor);

    return ThemeData(
      primarySwatch: primarySwatch,
      primaryColor: primaryColor,
      accentColor: accentColor,
      //*** For White App Bar ***/
      //primaryTextTheme: _textTheme.apply(bodyColor: Colors.black),
      appBarTheme: AppBarTheme(
        //textTheme: _textTheme.apply(bodyColor: Colors.white),
        //color: Colors.white,
        elevation: 0.0,
        //iconTheme: IconThemeData(color: Colors.white),
        //brightness: Brightness.dark,
      ),
      //primaryIconTheme: IconThemeData(color: Colors.black),
      tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.black),
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: buttonColor,
            primaryVariant: buttonColor.brighten(5),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
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
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData themeArabicDataDark() {
    return ThemeData(
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
          buttonColor:Color(0xff03dac6),
          //shape: StadiumBorder(),
          textTheme: ButtonTextTheme.primary,
          height: 45.0,
          colorScheme: new ColorScheme(
              primary: Color(0xff03dac6),
              primaryVariant: const Color(0xff03dac6),
              secondary: const Color(0xff03dac6),
              secondaryVariant: const Color(0xff03dac6),
              background: const Color(0xff000000),
              surface: const Color(0xff121212),
              error: Color(0xffb00020),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light),
        ),
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        backgroundColor: Colors.black,
        cardColor: Colors.black87
    );
  }
}

_getPrimarySwatch(s) {
  switch (s) {
    case 'Colors.red':
      return Colors.red;
    case 'Colors.pink':
      return Colors.pink;
    case 'Colors.purple':
      return Colors.purple;
    case 'Colors.deepPurple':
      return Colors.deepPurple;
    case 'Colors.indigo':
      return Colors.indigo;
    case 'Colors.blue':
      return Colors.blue;
    case 'Colors.lightBlue':
      return Colors.lightBlue;
    case 'Colors.cyan':
      return Colors.cyan;
    case 'Colors.teal':
      return Colors.teal;
    case 'Colors.green':
      return Colors.green;
    case 'Colors.lightGreen':
      return Colors.lightGreen;
    case 'Colors.lime':
      return Colors.lime;
    case 'Colors.yellow':
      return Colors.yellow;
    case 'Colors.amber':
      return Colors.amber;
    case 'Colors.orange':
      return Colors.orange;
    case 'Colors.deepOrange':
      return Colors.deepOrange;
    case 'Colors.brown':
      return Colors.brown;
    case 'Colors.blueGrey':
      return Colors.blueGrey;
    default:
      return Colors.blue;
  }
}