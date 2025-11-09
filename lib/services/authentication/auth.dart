import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // AuthStatus get status=>state;
  Stream<User?> get stateChange => _auth.authStateChanges();
  String get id => _auth.currentUser!.uid;
    final GoogleSignIn googleUser = GoogleSignIn.instance;
  Future<void> firebaseSignIn(String email,String password) async {

    if (email.isEmpty || password.isEmpty) {
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email) ||
        password.isEmpty) {
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("error in signing in from firebase try other method $e");
      throw Exception("can't login");
    }
  }

  Future<void> firebaseSignUp(String email,String password) async {
    if (email.isEmpty || password.isEmpty) {
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email) ||
        password.isEmpty) {
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("error in signing in from firebase try other method $e");
      throw Exception("can't login");
    }
  }

  Future<void> firebaseSignOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _auth.signOut();
        print("Firebase signed out");
      } else {
        print("No Firebase user signed in");
        throw Exception("No Firebase user signed in");
      }
    } catch (e) {
      print("Firebase sign out error: $e");
      throw Exception("Logout failed");
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      await googleUser.initialize(
        serverClientId:
            "180944349847-vq3edq9229g8qkg84f86thbej6r74nl9.apps.googleusercontent.com",
      );
      final GoogleSignInAccount account = await googleUser.authenticate();
      final credential = GoogleAuthProvider.credential(
        accessToken: account.id,
        idToken: account.authentication.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  Future<dynamic> signOutWithGoogle() async {
    try {
      await googleUser.signOut();
      await googleUser.disconnect();
    } catch (e) {
      throw Exception(e);
    }
  }
}