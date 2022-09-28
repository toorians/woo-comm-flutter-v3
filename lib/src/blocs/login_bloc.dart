import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/customer_model.dart';
import 'package:app/src/models/errors/error.dart';
import 'package:app/src/models/snackbar_activity.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class AccountBloc {

  final apiProvider = ApiProvider();
  final appStateModel = AppStateModel();
  late StreamSubscription<User?> _sub;
  final _socialLoginLoadingFetcher = BehaviorSubject<bool>();
  ValueStream<bool> get socialLoginLoading => _socialLoginLoadingFetcher.stream;

  AccountBloc() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      createUserInFirestore(user);
    });
  }

  dispose() {
    _sub.cancel();
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser != null) {

      _socialLoginLoadingFetcher.add(true);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var data = <String, dynamic>{};
      data["token"] = googleAuth?.idToken;
      data["email"] = googleUser.email;
      bool status = await submitLogin(data);

      _socialLoginLoadingFetcher.add(false);

      FirebaseAuth.instance.signInWithCredential(credential);
      return status;
    } else {
      return false;
    }

  }

  Future<bool> signInWithFacebook(BuildContext context) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if(loginResult.accessToken?.token != null) {

      _socialLoginLoadingFetcher.add(true);

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider
          .credential(loginResult.accessToken!.token);

      // Login Wordpress
      var data = <String, dynamic>{};
      data["access_token"] = loginResult.accessToken!.token;

      bool status = await submitLogin(data);

      _socialLoginLoadingFetcher.add(false);

      FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      return status;
    } else {
      return false;
    }

  }

  Future<bool> signInWithApple(BuildContext context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    if(appleCredential.identityToken != null) {

      _socialLoginLoadingFetcher.add(true);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Login Wordpress
      var data = <String, dynamic>{};
      data["userIdentifier"] = appleCredential.userIdentifier;
      if (appleCredential.authorizationCode.isNotEmpty) {
        data["authorizationCode"] = appleCredential.authorizationCode;
      }
      if (appleCredential.email != null) {
        data["email"] = appleCredential.email;
      } else {
        //await _showDialog(context);
        //TODO If email and name is empty Request Email and Name
      }

      data["userIdentifier"] = appleCredential.userIdentifier;
      data["identityToken"] = appleCredential.userIdentifier;


      bool status = await submitLogin(data);

      _socialLoginLoadingFetcher.add(false);

      FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return status;
    } else {
      return false;
    }

  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future createUserInFirestore(User? user) async {
    if (user != null) {
      try {
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: appStateModel.user.firstName,
            id: user.uid,
            imageUrl: user.photoURL ?? appStateModel.user.avatarUrl,
            lastName: appStateModel.user.lastName,
          ),
          //appStateModel.user.id,
        );
        apiProvider.postWithCookiesEncoded("/wp-admin/admin-ajax.php?action=build-app-online-update_user_metavalue", {'bao_uid': user.uid});
        //Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      } catch (e) {
        print(e);
      }
    } else {

    }
    return;
  }



  login(BuildContext context, Map<String, dynamic> loginData) async {

    String username = loginData["username"];
    String password = loginData["password"];
    loginData['rememberme'] = 'forever';

    bool status = await submitLogin(loginData);

    String email = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(username)
        ? username
        : appStateModel.user.email;

    String pwd = password.length < 6 ? password + '*****': password;

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //createUserInFirestore(credential.user);
      //TODO Update Usermeta fireBaseUid
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _fireBaseLogin(email, pwd, context);
      } else if (e.code == 'invalid-email') {
        //This error may not occur since email is taken from user data when username provided for login
      } else if (e.code == 'weak-password') {
        //This error may not occur since password append with 5 * when less than 6
      }
      print('Error: ' + e.code);
    }

    return status;
  }

/*  _login(BuildContext context, Map<String, dynamic> data) async {
    bool status = await appStateModel.login(data, context);
    return status;
  }*/

  Future _fireBaseLogin(String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //createUserInFirestore(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        String customToken = await getCustomToken();
        UserCredential credential = await FirebaseAuth.instance.signInWithCustomToken(customToken);
        //createUserInFirestore(credential.user);
      } else if (e.code == 'user-disabled') {

      }
    }
    return;
  }

  Future register(BuildContext context, Map<String, dynamic> registerData) async {
    bool status = await submitRegister(registerData);
    if (status) {
      _registerFireBase(registerData["email"], registerData["password"], context);
    }
    return status;
  }

  Future<bool> _registerFireBase(String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserInFirestore(credential.user);
      //apiProvider.postWithCookiesEncoded("/wp-admin/admin-ajax.php?action=build-app-online-update_user_metavalue", {'bao_uid': credential.user!.uid});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _fireBaseLogin(email, password, context);
      }
    }
    return true;
  }

  Future<bool> submitLogin(Map<String, dynamic> data) async {
    //appStateModel.messageFetcher.add(SnackBarActivity(success: true, loading: true, message: 'Please wait..'));
    final response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-login', data);
    if (response.statusCode == 200) {
      Customer user = Customer.fromJson(json.decode(response.body));
      appStateModel.updateNotifier(user);
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      appStateModel.messageFetcher.add(SnackBarActivity(message: parseHtmlString(error.data[0].message), success: false));
      return false;
    } else {
      return false;
    }
  }
  Future<bool> submitRegister(Map<String, dynamic> data) async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-create-user', data);
    if (response.statusCode == 200) {
      Customer user = Customer.fromJson(json.decode(response.body));
      appStateModel.updateNotifier(user);
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      appStateModel.messageFetcher.add(SnackBarActivity(message: parseHtmlString(error.data[0].message), success: false));
      return false;
    } else {
      return false;
    }
  }

  getCustomToken() async {
    final response = await apiProvider.get('/wp-admin/admin-ajax.php?action=build-app-online-jwt_token');
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    } else {

    }
  }
}