import 'package:firebase_auth/firebase_auth.dart';

abstract class EmailAuthFunc {
  // Future signInStatus();
  Future signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future getCurrentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class EmailAuth implements EmailAuthFunc {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    //return user;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) async {
    var user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
