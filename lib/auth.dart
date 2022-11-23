library auth;

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Auth._();

  factory Auth() {
    return Auth._();
  }

  Future<User?> createNewFirebaseUser(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> loginWithExistingUser(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signInWithGoogle() async {
    UserCredential? userCredential;
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);
      userCredential = await _firebaseAuth.signInWithCredential(credential);
      log('user has successfully signup with google');
    }

    return userCredential!.user;
  }

  Future<User?> signInWithFacebook() async{
    FacebookAuth facebookAuth = FacebookAuth.instance;
    LoginResult result = await facebookAuth.login();
    UserCredential? userCredential;
    if(result.accessToken!=null) {
      OAuthCredential oAuthCredential = FacebookAuthProvider.credential(
          result.accessToken!.token);
      userCredential=await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      log('successfully login with facebook');
    }
    return userCredential?.user;
  }

}
