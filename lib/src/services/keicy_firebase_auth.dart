library keicy_firebase_auth_0_18;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeicyAuthentication {
  static KeicyAuthentication _instance = KeicyAuthentication();
  static KeicyAuthentication get instance => _instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  Future<Map<String, dynamic>> signInWidthEmailAndPassword({@required String? email, @required String? password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email!, password: password!);
      return {
        "success": true,
        "message": "SignIn Success",
        "data": userCredential,
      };
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "errorCode": e.code,
        "message": "Something was wrong",
      };
    } on PlatformException catch (e) {
      return {
        "success": false,
        "errorCode": e.code,
        "message": "Something was wrong",
      };
    } catch (e) {
      return {
        "success": false,
        "errorCode": 500,
        "message": "Something was wrong",
      };
    }
  }

  Future<Map<String, dynamic>> signInWithCustomToken({@required String? token}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithCustomToken(token!);
      return {
        "success": true,
        "message": "SignIn Success",
        "data": userCredential,
      };
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "errorCode": e.code,
        "message": "Something was wrong",
      };
    } on PlatformException catch (e) {
      return {
        "success": false,
        "errorCode": e.code,
        "message": "Something was wrong",
      };
    } catch (e) {
      return {
        "success": false,
        "errorCode": 500,
        "message": "Something was wrong",
      };
    }
  }

  Future<Map<String, dynamic>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return {
        "success": true,
        "message": "SignOut Success",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "errorCode": e.code,
        "message": "Something was wrong",
      };
    } on PlatformException catch (e) {
      return {
        "success": false,
        "errorCode": e.code,
        "message": "Something was wrong",
      };
    } catch (e) {
      return {
        "success": false,
        "errorCode": 500,
        "message": "Something was wrong",
      };
    }
  }
}
