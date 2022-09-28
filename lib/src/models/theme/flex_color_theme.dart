import 'package:app/src/models/theme/hex_color.dart';
import 'package:app/src/themes/google_font.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

ThemeData flexThemeFromJson(Map<String, dynamic>? json, String themeMode) {
  return themeMode == 'light' ? json is Map<String, dynamic> ? FlexThemeData.light(
    scheme: json["useBuiltIn"] == true ? getFlexScheme(json["scheme"]) : null,
    colors: json["useBuiltIn"] != true ? flexThemesColorsfromJson(json["colors"]) : null,
    surfaceMode: getSurfaceMode(json["surfaceMode"]),
    blendLevel: isInt(json["blendLevel"].toString()) ? int.parse(json["blendLevel"].toString()) : 18,
    appBarStyle: getAppBarStyle(json["appBarStyle"]),
    appBarOpacity: isDouble(json["appBarOpacity"].toString()) ? double.parse(json["appBarOpacity"].toString()) : 0.95,
    appBarElevation: isDouble(json["appBarElevation"].toString()) ? double.parse(json["appBarElevation"].toString()) : 0.0,
    transparentStatusBar: json["transparentStatusBar"] == true ? true : false,
    tabBarStyle: getTabBarStyle(json["tabBarStyle"]),
    tooltipsMatchBackground: json["tooltipsMatchBackground"] == false ? false : true,
    swapColors: json["swapColors"] == false ? false : true,
    lightIsWhite: json["lightIsWhite"] == false ? false : true,
    //useSubThemes: json["useSubThemes"] == false ? false : true,
    visualDensity: getVisualDensity(json["visualDensity"]),
    fontFamily: getGoogleFont(json['fontFamily']).fontFamily,

    useMaterial3: json["useMaterial3"] == true ? true : false,
    useMaterial3ErrorColors: json["useM3ErrorColors"] == true ? true : false,
    tones: json["usedFlexToneSetup"] != null ? getTones(json["usedFlexToneSetup"], Brightness.light) : null,
    keyColors: json["keyColors"] != null ? getKeyColors(json["keyColors"]) : null,

    subThemesData: json["subThemesData"] == null ? subThemesDataFromJson({}) : subThemesDataFromJson(json["subThemesData"]),
  ) : FlexThemeData.light(
    scheme: FlexScheme.blue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.material,
    appBarOpacity: 0.95,
    appBarElevation: 0.0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: true,
    lightIsWhite: true,
    //useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use this font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: false,
      interactionEffects: true,
      bottomNavigationBarOpacity: 0.95,
      bottomNavigationBarElevation: 0.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
  ) : json is Map<String, dynamic> ? FlexThemeData.dark(
    scheme: json["useBuiltIn"] == true ? getFlexScheme(json["scheme"]) : null,
    colors: json["useBuiltIn"] != true ? flexThemesColorsfromJson(json["colors"]) : null,
    surfaceMode: getSurfaceMode(json["surfaceMode"]),
    blendLevel: isInt(json["blendLevel"].toString()) ? int.parse(json["blendLevel"].toString()) : 18,
    appBarStyle: getAppBarStyle(json["appBarStyle"]),
    appBarOpacity: isDouble(json["appBarOpacity"].toString()) ? double.parse(json["appBarOpacity"].toString()) : 0.95,
    appBarElevation: isDouble(json["appBarElevation"].toString()) ? double.parse(json["appBarElevation"].toString()) : 0.0,
    transparentStatusBar: json["transparentStatusBar"] == false ? false : true,
    tabBarStyle: getTabBarStyle(json["tabBarStyle"]),
    tooltipsMatchBackground: json["tooltipsMatchBackground"] == false ? false : true,
    swapColors: json["swapColors"] == false ? false : true,
    //useSubThemes: json["useSubThemes"] == false ? false : true,
    visualDensity: getVisualDensity(json["visualDensity"]),
    fontFamily: getGoogleFont(json['fontFamily']).fontFamily,

    useMaterial3: json["useMaterial3"] == true ? true : false,
    useMaterial3ErrorColors: json["useM3ErrorColors"] == true ? true : false,
    tones: json["usedFlexToneSetup"] != null ? getTones(json["usedFlexToneSetup"], Brightness.dark) : null,
    keyColors: json["keyColors"] != null ? getKeyColors(json["keyColors"]) : null,

    subThemesData: json["subThemesData"] == null ? subThemesDataFromJson({}) : subThemesDataFromJson(json["subThemesData"]),
  ) : FlexThemeData.dark(
    scheme: FlexScheme.blue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.material,
    appBarOpacity: 0.95,
    appBarElevation: 0.0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: true,
    useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use this font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: false,
      interactionEffects: true,
      bottomNavigationBarOpacity: 0.95,
      bottomNavigationBarElevation: 0.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
  );
}

getTones(int usedFlexToneSetup, Brightness brightness) {
  if (usedFlexToneSetup == 2) {
    return FlexTones.soft(brightness);
  }
  if (usedFlexToneSetup == 3) {
    return FlexTones.vivid(brightness);
  }
  if (usedFlexToneSetup == 4) {
    return FlexTones.vividSurfaces(brightness);
  }
  if (usedFlexToneSetup == 5) {
    return FlexTones.highContrast(brightness);
  } return null;
}

FlexKeyColors getKeyColors(Map<String, dynamic>? json) {
  return json is Map<String, dynamic> ? FlexKeyColors(
    useSecondary: json["useSecondary"] == true ? true : false,
    useTertiary: json["useTertiary"] == true ? true : false,
    keepPrimary: json["keepPrimary"] == true ? true : false,
    keepSecondary: json["keepSecondary"] == true ? true : false,
    keepTertiary: json["keepTertiary"] == true ? true : false,
    keepPrimaryContainer: json["keepPrimaryContainer"] == true ? true : false,
    keepSecondaryContainer: json["keepSecondaryContainer"] == true ? true : false,
    keepTertiaryContainer: json["keepTertiaryContainer"] == true ? true : false,
  ) : FlexKeyColors();
}

FlexSchemeColor flexThemesColorsfromJson(Map<String, dynamic>? json) {
  return json is Map<String, dynamic> ? FlexSchemeColor(
    primary: json['primary'] != null ? HexColor(json['primary']) : Colors.blue,
    secondary: json['primary'] != null ? HexColor(json['secondary']) : Colors.orange,
    appBarColor: json['appBarColor'] == null ? Colors.white : HexColor(
        json['appBarColor']),
    error: json['error'] == null ? null : HexColor(json['error']),
    primaryContainer: json['primaryContainer'] != null ? HexColor(json['primaryContainer']) : Colors.blue,
    secondaryContainer: json['secondaryContainer'] != null ? HexColor(json['secondaryContainer']) : Colors.blue,
    tertiary: json['tertiary'] != null ? HexColor(json['tertiary']) : Colors.blue,
    tertiaryContainer: json['tertiaryContainer'] != null ? HexColor(json['tertiaryContainer']) : Colors.blue,
  ) : FlexSchemeColor(primary: Colors.blue, secondary:Colors.orange);
}

FlexSubThemesData? subThemesDataFromJson(Map<String, dynamic> json) {
  return FlexSubThemesData(
    useTextTheme: json["useTextTheme"] == false ? false : true,
    fabUseShape: json["fabUseShape"] == true ? true : false,
    interactionEffects: json["interactionEffects"] == false ? false : true,
    bottomNavigationBarOpacity: isDouble(json["bottomNavigationBarOpacity"].toString()) ? double.parse(json["bottomNavigationBarOpacity"].toString()) : 0.95,
    bottomNavigationBarElevation: isDouble(json["bottomNavigationBarElevation"].toString()) ? double.parse(json["bottomNavigationBarElevation"].toString()) : 0.0,
    inputDecoratorIsFilled: json["inputDecoratorIsFilled"] == false ? false : true,
    inputDecoratorBorderType: getInputDecoratorBorderType(json["inputDecoratorBorderType"]),
    inputDecoratorUnfocusedHasBorder: json["inputDecoratorUnfocusedHasBorder"] == false ? false : true,
    blendOnColors: json["blendOnColors"] == false ? false : true,
    blendTextTheme: json["blendTextTheme"] == false ? false : true,
    popupMenuOpacity: isDouble(json["popupMenuOpacity"].toString()) ? double.parse(json["popupMenuOpacity"].toString()) : 0.95,
    blendOnLevel: isInt(json["blendOnLevel"].toString()) ? int.parse(json["blendOnLevel"].toString()) : 0,
    useFlutterDefaults: json["useFlutterDefaults"] == true ? true : false,
    defaultRadius: isDouble(json["defaultRadius"].toString()) ? double.parse(json["defaultRadius"].toString()) : null,
    inputDecoratorRadius: isDouble(json["inputDecoratorRadius"].toString()) ? double.parse(json["inputDecoratorRadius"].toString()) : null,
    inputDecoratorSchemeColor: json["inputDecoratorSchemeColor"] != null ? getSchemeColor(json["inputDecoratorSchemeColor"]) : null,
    inputDecoratorUnfocusedBorderIsColored: json["inputDecoratorUnfocusedBorderIsColored"] == false ? false : true,
    appBarBackgroundSchemeColor: json["appBarBackgroundSchemeColor"] != null ? getSchemeColor(json["appBarBackgroundSchemeColor"]) : null,
    tabBarIndicatorSchemeColor: json["tabBarIndicatorSchemeColor"] != null ? getSchemeColor(json["tabBarIndicatorSchemeColor"]) : null,
    tabBarItemSchemeColor: json["tabBarItemSchemeColor"] != null ? getSchemeColor(json["tabBarItemSchemeColor"]) : null,
    bottomNavigationBarSelectedLabelSchemeColor: json["bottomNavigationBarSelectedLabelSchemeColor"] != null ? getSchemeColor(json["bottomNavigationBarSelectedLabelSchemeColor"]) : null,
    bottomNavigationBarUnselectedLabelSchemeColor: json["bottomNavigationBarUnselectedLabelSchemeColor"] != null ? getSchemeColor(json["bottomNavigationBarUnselectedLabelSchemeColor"]) : null,
    bottomNavigationBarMutedUnselectedLabel: json["bottomNavigationBarMutedUnselectedLabel"] == false ? false : true,
    bottomNavigationBarSelectedIconSchemeColor: json["bottomNavigationBarSelectedIconSchemeColor"] != null ? getSchemeColor(json["bottomNavigationBarSelectedIconSchemeColor"]) : null,
    bottomNavigationBarUnselectedIconSchemeColor: json["bottomNavigationBarUnselectedIconSchemeColor"] != null ? getSchemeColor(json["bottomNavigationBarUnselectedIconSchemeColor"]) : null,
    bottomNavigationBarMutedUnselectedIcon: json["bottomNavigationBarMutedUnselectedIcon"] == false ? false : true,
    bottomNavigationBarBackgroundSchemeColor: json["bottomNavigationBarBackgroundSchemeColor"] != null ? getSchemeColor(json["bottomNavigationBarBackgroundSchemeColor"]) : null,
    bottomNavigationBarShowSelectedLabels: json["bottomNavigationBarShowSelectedLabels"] == false ? false : true,
    bottomNavigationBarShowUnselectedLabels: json["bottomNavigationBarShowUnselectedLabels"] == false ? false : true,
    navigationBarSelectedLabelSchemeColor: json["navigationBarSelectedLabelSchemeColor"] != null ? getSchemeColor(json["navigationBarSelectedLabelSchemeColor"]) : null,
    navigationBarUnselectedLabelSchemeColor: json["navigationBarUnselectedLabelSchemeColor"] != null ? getSchemeColor(json["navigationBarUnselectedLabelSchemeColor"]) : null,
    navigationBarMutedUnselectedLabel: json["navigationBarMutedUnselectedLabel"] == false ? false : true,
    navigationBarSelectedIconSchemeColor: json["navigationBarSelectedIconSchemeColor"] != null ? getSchemeColor(json["navigationBarSelectedIconSchemeColor"]) : null,
    navigationBarUnselectedIconSchemeColor: json["navigationBarUnselectedIconSchemeColor"] != null ? getSchemeColor(json["navigationBarUnselectedIconSchemeColor"]) : null,
    navigationBarMutedUnselectedIcon: json["navigationBarMutedUnselectedIcon"] == false ? false : true,
    navigationBarIndicatorSchemeColor: json["navigationBarIndicatorSchemeColor"] != null ? getSchemeColor(json["navigationBarIndicatorSchemeColor"]) : null,
    navigationBarIndicatorOpacity: isDouble(json["navigationBarIndicatorOpacity"].toString()) ? double.parse(json["navigationBarIndicatorOpacity"].toString()) : null,
    navigationBarBackgroundSchemeColor: json["navigationBarBackgroundSchemeColor"] != null ? getSchemeColor(json["navigationBarBackgroundSchemeColor"]) : null,
    navigationBarOpacity: isDouble(json["navigationBarOpacity"].toString()) ? double.parse(json["navigationBarOpacity"].toString()) : 1,
    navigationBarHeight: isDouble(json["navigationBarHeight"].toString()) ? double.parse(json["navigationBarHeight"].toString()) : null,
    navigationBarLabelBehavior: json["navigationBarLabelBehavior"] == "NavigationDestinationLabelBehavior.onlyShowSelected" ? NavigationDestinationLabelBehavior.onlyShowSelected : json["navigationBarLabelBehavior"] == "NavigationDestinationLabelBehavior.alwaysHide" ? NavigationDestinationLabelBehavior.alwaysHide : NavigationDestinationLabelBehavior.alwaysShow,
    textButtonRadius: isDouble(json["textButtonRadius"].toString()) ? double.parse(json["textButtonRadius"].toString()) : null,
    elevatedButtonRadius: isDouble(json["elevatedButtonRadius"].toString()) ? double.parse(json["elevatedButtonRadius"].toString()) : null,
    outlinedButtonRadius: isDouble(json["outlinedButtonRadius"].toString()) ? double.parse(json["outlinedButtonRadius"].toString()) : null,
    textButtonSchemeColor: json["textButtonSchemeColor"] != null ? getSchemeColor(json["textButtonSchemeColor"]) : null,
    elevatedButtonSchemeColor: json["elevatedButtonSchemeColor"] != null ? getSchemeColor(json["elevatedButtonSchemeColor"]) : null,
    outlinedButtonSchemeColor: json["outlinedButtonSchemeColor"] != null ? getSchemeColor(json["outlinedButtonSchemeColor"]) : null,
    toggleButtonsRadius: isDouble(json["toggleButtonsRadius"].toString()) ? double.parse(json["toggleButtonsRadius"].toString()) : null,
    toggleButtonsSchemeColor: json["toggleButtonsSchemeColor"] != null ? getSchemeColor(json["toggleButtonsSchemeColor"]) : null,
    switchSchemeColor: json["switchSchemeColor"] != null ? getSchemeColor(json["switchSchemeColor"]) : null,
    radioSchemeColor: json["radioSchemeColor"] != null ? getSchemeColor(json["radioSchemeColor"]) : null,
    fabRadius: isDouble(json["fabRadius"].toString()) ? double.parse(json["fabRadius"].toString()) : null,
    fabSchemeColor: json["fabSchemeColor"] != null ? getSchemeColor(json["fabSchemeColor"]) : null,
    chipSchemeColor: json["chipSchemeColor"] != null ? getSchemeColor(json["chipSchemeColor"]) : null,
    chipRadius: isDouble(json["chipRadius"].toString()) ? double.parse(json["chipRadius"].toString()) : null,
    popupMenuRadius: isDouble(json["popupMenuRadius"].toString()) ? double.parse(json["popupMenuRadius"].toString()) : null,
    checkboxSchemeColor: json["checkboxSchemeColor"] != null ? getSchemeColor(json["checkboxSchemeColor"]) : null,
    unselectedToggleIsColored: json["unselectedToggleIsColored"] == true ? true : false,
    dialogBackgroundSchemeColor: json["dialogBackgroundSchemeColor"] != null ? getSchemeColor(json["dialogBackgroundSchemeColor"]) : null,
    dialogRadius: isDouble(json["dialogRadius"].toString()) ? double.parse(json["dialogRadius"].toString()) : null,
    timePickerDialogRadius: isDouble(json["timePickerDialogRadius"].toString()) ? double.parse(json["timePickerDialogRadius"].toString()) : null,
    bottomSheetRadius: isDouble(json["bottomSheetRadius"].toString()) ? double.parse(json["bottomSheetRadius"].toString()) : null,
    snackBarBackgroundSchemeColor: json["snackBarBackgroundSchemeColor"] != null ? getSchemeColor(json["snackBarBackgroundSchemeColor"]) : null,
    cardRadius: isDouble(json["cardRadius"].toString()) ? double.parse(json["cardRadius"].toString()) : null,
  );
}

bool isDouble(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isInt(String? s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

SchemeColor? getSchemeColor(String value) {
  switch (value) {
    case "SchemeColor.primary":
      return SchemeColor.primary;
    case "SchemeColor.onPrimary":
      return SchemeColor.onPrimary;
    case "SchemeColor.primaryContainer":
      return SchemeColor.primaryContainer;
    case "SchemeColor.onPrimaryContainer":
      return SchemeColor.onPrimaryContainer;
    case "SchemeColor.secondary":
      return SchemeColor.secondary;
    case "SchemeColor.onSecondary":
      return SchemeColor.onSecondary;
    case "SchemeColor.secondaryContainer":
      return SchemeColor.secondaryContainer;
    case "SchemeColor.onSecondaryContainer":
      return SchemeColor.onSecondaryContainer;
    case "SchemeColor.tertiary":
      return SchemeColor.tertiary;
    case "SchemeColor.onTertiary":
      return SchemeColor.onTertiary;
    case "SchemeColor.tertiaryContainer":
      return SchemeColor.tertiaryContainer;
    case "SchemeColor.onTertiaryContainer":
      return SchemeColor.onTertiaryContainer;
    case "SchemeColor.error":
      return SchemeColor.error;
    case "SchemeColor.onError":
      return SchemeColor.onError;
    case "SchemeColor.errorContainer":
      return SchemeColor.errorContainer;
    case "SchemeColor.onErrorContainer":
      return SchemeColor.onErrorContainer;
    case "SchemeColor.background":
      return SchemeColor.background;
    case "SchemeColor.onBackground":
      return SchemeColor.onBackground;
    case "SchemeColor.surface":
      return SchemeColor.surface;
    case "SchemeColor.onSurface":
      return SchemeColor.onSurface;
    case "SchemeColor.surfaceVariant":
      return SchemeColor.surfaceVariant;
    case "SchemeColor.onSurfaceVariant":
      return SchemeColor.onSurfaceVariant;
    case "SchemeColor.outline":
      return SchemeColor.outline;
    case "SchemeColor.shadow":
      return SchemeColor.shadow;
    case "SchemeColor.inverseSurface":
      return SchemeColor.inverseSurface;
    case "SchemeColor.onInverseSurface":
      return SchemeColor.onInverseSurface;
    case "SchemeColor.inversePrimary":
      return SchemeColor.inversePrimary;
    case "SchemeColor.primaryVariant":
      return SchemeColor.primaryContainer;
    case "SchemeColor.secondaryVariant":
      return SchemeColor.secondaryContainer;
    default: return null;
  }
}

getFlexScheme(flexScheme) {
  switch (flexScheme) {
    case 'FlexScheme.material':
      return FlexScheme.material;
    case 'FlexScheme.materialHc':
      return FlexScheme.materialHc;
    case 'FlexScheme.blue':
      return FlexScheme.blue;
    case 'FlexScheme.indigo':
      return FlexScheme.indigo;
    case 'FlexScheme.hippieBlue':
      return FlexScheme.hippieBlue;
    case 'FlexScheme.aquaBlue':
      return FlexScheme.aquaBlue;
    case 'FlexScheme.brandBlue':
      return FlexScheme.brandBlue;
    case 'FlexScheme.deepBlue':
      return FlexScheme.deepBlue;
    case 'FlexScheme.sakura':
      return FlexScheme.sakura;
    case 'FlexScheme.mandyRed':
      return FlexScheme.mandyRed;
    case 'FlexScheme.red':
      return FlexScheme.red;
    case 'FlexScheme.redWine':
      return FlexScheme.redWine;
    case 'FlexScheme.purpleBrown':
      return FlexScheme.purpleBrown;
    case 'FlexScheme.green':
      return FlexScheme.green;
    case 'FlexScheme.money':
      return FlexScheme.money;
    case 'FlexScheme.jungle':
      return FlexScheme.jungle;
    case 'FlexScheme.greyLaw':
      return FlexScheme.greyLaw;
    case 'FlexScheme.wasabi':
      return FlexScheme.wasabi;
    case 'FlexScheme.gold':
      return FlexScheme.gold;
    case 'FlexScheme.mango':
      return FlexScheme.mango;
    case 'FlexScheme.amber':
      return FlexScheme.amber;
    case 'FlexScheme.vesuviusBurn':
      return FlexScheme.vesuviusBurn;
    case 'FlexScheme.deepPurple':
      return FlexScheme.deepPurple;
    case 'FlexScheme.ebonyClay':
      return FlexScheme.ebonyClay;
    case 'FlexScheme.barossa':
      return FlexScheme.barossa;
    case 'FlexScheme.sakura':
      return FlexScheme.sakura;
    case 'FlexScheme.bigStone':
      return FlexScheme.bigStone;
    case 'FlexScheme.damask':
      return FlexScheme.damask;
    case 'FlexScheme.bahamaBlue':
      return FlexScheme.bahamaBlue;
    case 'FlexScheme.mallardGreen':
      return FlexScheme.mallardGreen;
    case 'FlexScheme.espresso':
      return FlexScheme.espresso;
    case 'FlexScheme.outerSpace':
      return FlexScheme.outerSpace;
    case 'FlexScheme.blueWhale':
      return FlexScheme.blueWhale;
    case 'FlexScheme.sanJuanBlue':
      return FlexScheme.sanJuanBlue;
    case 'FlexScheme.rosewood':
      return FlexScheme.rosewood;
    case 'FlexScheme.blumineBlue':
      return FlexScheme.blumineBlue;
    case 'FlexScheme.shark':
      return FlexScheme.shark;
    case 'FlexScheme.custom':
      return FlexScheme.custom;
    case 'FlexScheme.flutterDash':
      return FlexScheme.flutterDash;
    case 'FlexScheme.dellGenoa':
      return FlexScheme.dellGenoa;
    case 'FlexScheme.verdunHemlock':
      return FlexScheme.verdunHemlock;
    default:
      return FlexScheme.blumineBlue;
  }
}

getSurfaceMode(json) {
  switch (json) {
    case 'custom':
      return FlexSurfaceMode.custom;
    case 'highBackgroundLowScaffold':
      return FlexSurfaceMode.highBackgroundLowScaffold;
    case 'highScaffoldLevelSurface':
      return FlexSurfaceMode.highScaffoldLevelSurface;
    case 'highScaffoldLowSurface':
      return FlexSurfaceMode.highScaffoldLowSurface;
    case 'highScaffoldLowSurfaces':
      return FlexSurfaceMode.highScaffoldLowSurfaces;
    case 'levelSurfacesLowScaffoldVariantDialog':
      return FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog;
    case 'levelSurfacesLowScaffold':
      return FlexSurfaceMode.levelSurfacesLowScaffold;
    case 'level':
      return FlexSurfaceMode.level;
    case 'highSurfaceLowScaffold':
      return FlexSurfaceMode.highSurfaceLowScaffold;
    case 'highScaffoldLowSurfacesVariantDialog':
      return FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog;
    default:
      return FlexSurfaceMode.highScaffoldLowSurface;
  }
}

getAppBarStyle(json) {
  switch (json) {
    case 'FlexAppBarStyle.custom':
      return FlexAppBarStyle.custom;
    case 'FlexAppBarStyle.primary':
      return FlexAppBarStyle.primary;
    case 'FlexAppBarStyle.surface':
      return FlexAppBarStyle.surface;
    case 'FlexAppBarStyle.background':
      return FlexAppBarStyle.background;
    default:
      return FlexAppBarStyle.material;
  }
}

getTabBarStyle(json) {
  switch (json) {
    case 'FlexTabBarStyle.flutterDefault':
      return FlexTabBarStyle.flutterDefault;
    case 'FlexTabBarStyle.forBackground':
      return FlexTabBarStyle.forBackground;
    case 'FlexTabBarStyle.universal':
      return FlexTabBarStyle.universal;
    default:
      return FlexTabBarStyle.forAppBar;
  }
}

getVisualDensity(json) {
  switch (json) {
    case 'FlexColorScheme.comfortablePlatformDensity':
      return FlexColorScheme.comfortablePlatformDensity;
    default:
      return FlexColorScheme.comfortablePlatformDensity;
  }
}

getInputDecoratorBorderType(json) {
  switch (json) {
    case 'FlexInputBorderType.outline':
      return FlexInputBorderType.outline;
    default:
      return FlexInputBorderType.underline;
  }
}
