import 'package:cometnews/components/utils.dart';
import 'package:cometnews/screens/signup.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get _authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> logininWithEmailandPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signupWithEmailandPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signout() async{
    await _firebaseAuth.signOut();
  }
}
