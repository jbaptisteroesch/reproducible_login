import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This class is used as the authentication provider for the application.
class AuthModel extends ChangeNotifier {
  /// If the auth state changes, notify the provider.
  AuthModel() {
    auth.authStateChanges().listen((User? currentUser) {
      print('AuthModel: authStateChanges: currentUser: $currentUser');
      if (currentUser != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  /// Firebase authentication instance.
  FirebaseAuth auth = FirebaseAuth.instance;

  /// The user is logged in.
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  set loggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  Future<void> initAuth() async {
    final User? user = await FirebaseAuth.instance.authStateChanges().first;
    if (user != null) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }
  }

  void setPersistence() {
    auth.setPersistence(Persistence.INDEXED_DB);
  }

  /// Set [loggedIn] depending on the auth.currentUser status.
  void checkLoggedIn() {
    final User? user = auth.currentUser;
    if (user != null) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }
  }

  /// Get the current user.
  User? getUser() {
    final User? user = auth.currentUser;
    return user;
  }

  /// Log out the current user.
  Future<void> logout() async {
    await auth.signOut();
    loggedIn = false;
    notifyListeners();
  }

  /// Logged in the user with the given [email] and [password].
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code, message: error.message);
    }
  }

  /// Send a request to Firebase to reset the password for the user with the given [email].
  Future<void> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code, message: error.message);
    }
  }
}
