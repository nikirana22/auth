library auth;

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
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
      log('Google signin Account is not null');
      GoogleSignInAuthentication authentication = await account.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);
      userCredential = await _firebaseAuth.signInWithCredential(credential);
      log('user has successfully signup with google');
    }

    return userCredential!.user;
  }
}
