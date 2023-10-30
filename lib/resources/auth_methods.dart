import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_lpkl/resources/storage_methods.dart';
import 'package:instagram_lpkl/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    // required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          bio.isNotEmpty) {
        // || file != null
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to our database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl : photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);

        //
        // await _firestore.collection('users').add({
        //   'username' : username,
        //   'uid' : cred.user!.uid,
        //   'email' : email,
        //   'bio' : bio,
        //   'followers' : [],
        //   'following' : [],
        // });

        res = "success";
      }
    } 
    // on FirebaseAuthException catch(err) {
    //   if(err.code == 'invalid-email') {
    //     res = 'The email is badly formatted';
    //   } else if(err.code == 'weak-password') {
    //     res = 'Your password should be at least 6 characters';
    //   }
    // }
    
     catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Logging in user
  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "Some error occured";

    try {
      if  (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    }
    
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'wrong-password') {
        
    //   }
    // }
    
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
