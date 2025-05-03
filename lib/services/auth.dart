import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create custom user object from Firebase User
  Userdata? _userFromFirebaseUser(User? user) {
    return user != null ? Userdata(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<Userdata?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }


  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }



  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
