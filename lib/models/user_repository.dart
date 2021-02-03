import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

///  Reference Link (https://firebase.flutter.dev/docs/auth/usage/#emailpassword-registration--sign-in)
class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Future<User> logInWithGoogle() async {
    // Trigger the Google Authentication flow.
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential.
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    return (await _firebaseAuth.signInWithCredential(credential)).user;
  }

  Future<User> logInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;
    // 一樣就是 false 不一樣就是 true;
    return currentUser != null;
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> logOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<void> sendPasswordResetEmail({@required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}
