import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get current user

  User? getCurrentUser(){
    return auth.currentUser;
  }

  // sign user in
  Future<UserCredential> signInWithEmailAndPAssword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // save user info if it doesn't already exist
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    }
    // catch any error

    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign user Up
  Future<UserCredential> signUpWithEmailAndPAssword(
      String email, String password) async {
    try {
      //sign up
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info in a seperate doc
      firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    }
    // catch any error

    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign user out

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
