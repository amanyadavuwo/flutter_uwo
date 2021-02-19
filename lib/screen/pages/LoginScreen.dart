import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert' show json;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;
  String _contactText;


  FacebookLogin facebookSignIn = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn();



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(msg: "11111111111");
  }

  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> signInWithFacebook() async {
    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final AuthCredential credential=FacebookAuthProvider.credential(accessToken.token);

        final UserCredential  authResult = await _auth.signInWithCredential(credential);
        final User user = authResult.user;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = await _auth.currentUser;
        assert(currentUser.uid == user.uid);


        _showMessage('''
         Logged in!
        
         name: ${user.displayName}
         email: ${user.email}
         photo: ${user.photoURL}
         no: ${user.phoneNumber}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
  void _showMessage(String message) {
    Logger().i(message);
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential  authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = await _auth.currentUser;
    assert(currentUser.uid == user.uid);


    return user;
  }

  Future<void> _handleSignIn() async {
    try {
      await signInWithGoogle();
    } catch (error) {
      Fluttertoast.showToast(msg: "11111111111"+error.toString());
      Logger().i(error);
      print("*****************************");
      print(error);
    }
  }

  Future<void> _handleSignIn2() async {
    try {
      await signInWithFacebook();
    } catch (error) {
      Fluttertoast.showToast(msg: "11111111111"+error.toString());
      Logger().i(error);
      print("*****************************");
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      color: Colors.amber,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Signup Option'),
            ElevatedButton(
              child: const Text('google'),
              onPressed: _handleSignIn,
            ),
            ElevatedButton(
              child: const Text('facebook'),
              onPressed: _handleSignIn2,
            )
          ],
        ),
      ),
    );
  }
}
