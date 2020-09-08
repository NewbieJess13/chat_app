import 'package:chatapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
class AuthMethod {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  User _userFromFirebaseUser(auth.User user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
     auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString);
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}
