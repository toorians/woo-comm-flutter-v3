class Config {


  /* Replace your sire url and api keys */

  String appName = 'Woo';
  String androidPackageName = 'com.mstoreapp.app';
  String iosPackageName = 'com.mstoreapp.app';

  String consumerKey = 'ck_2ea0e6f9c260d21d54dd59c117f40db0b567c0b8';
  String consumerSecret = 'cs_d2d7da18a92ac7a60dcccf1b62b96ab72383d8ea';
  String url = 'https://example.com';
  String mapApiKey = 'AIzaSyBAcvBoEuYPDBWBuejS_dqRJKzJa0OiVak';

  static Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  Map<String, dynamic> appConfig = Map<String, dynamic>();

  Config loadFromMap(Map<String, dynamic> map) {
    appConfig.addAll(map);
    return _singleton;
  }

  dynamic get(String key) => appConfig[key];

  bool getBool(String key) => appConfig[key];

  int getInt(String key) => appConfig[key];

  double getDouble(String key) => appConfig[key];

  String getString(String key) => appConfig[key];

  void clear() => appConfig.clear();

  @Deprecated("use updateValue instead")
  void setValue(key, value) => value.runtimeType != appConfig[key].runtimeType
      ? throw ("wrong type")
      : appConfig.update(key, (dynamic) => value);

  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
  }

  void addValue(String key, dynamic value) =>
      appConfig.putIfAbsent(key, () => value);

  add(Map<String, dynamic> map) => appConfig.addAll(map);

}