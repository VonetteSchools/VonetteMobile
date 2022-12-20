// ignore_for_file: avoid_print
// ignore_for_file: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _getMessageFromErrorCode(String e) {
    switch (e) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email Already Used By Other User.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong Email/Password Combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No User Found With This Email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User Disabled By Administrator";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too Many Login Requests";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Server Error, Please Try Again Later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email Address Is Invalid.";
      case "requires-recent-login":
        return "This Operation Is Sensitive And Requires Recent Authentication. Login Again.";
      default:
        return "Login failed. Please Try Again.";
    }
  }

  // create user obj based on firebase User?
  UserInApp? _userFromFireBaseUser(User? user) {
    return user != null
        ? UserInApp(
            username: user.displayName, uid: user.uid, email: user.email)
        : null;
  }

  // returns the current user state; this is monitored by the provider
  // service in several files. Check main.dart as example
  Stream<UserInApp?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFireBaseUser(user));
  }

  // sign in with email and password
  Future signInEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      UserInApp? userInApp = _userFromFireBaseUser(user);
      return [0, userInApp];
    } on FirebaseAuthException catch (e) {
      String error = _getMessageFromErrorCode(e.code);
      return [null, error];
    }
  }

  // register with email and password
  Future regEmailPass(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await user?.updateDisplayName(username);
      await user?.reload();
      User? latestUser = FirebaseAuth.instance.currentUser;

      UserInApp? userInApp = _userFromFireBaseUser(latestUser);
      await DatabaseService(user: userInApp)
          .firstTimeCreateDM("https://tinyurl.com/2p8cdr9d");
      return [0, userInApp];
    } on FirebaseAuthException catch (e) {
      String error = _getMessageFromErrorCode(e.code);
      return [null, error];
    }
  }

  //update password for the current user
  Future updateUserPassword(String password) async {
    try {
      await _auth.currentUser?.updatePassword(password);
      await _auth.currentUser?.reload();
      User? latestUser = FirebaseAuth.instance.currentUser;
      UserInApp? userInApp = _userFromFireBaseUser(latestUser);
      return [userInApp];
    } on FirebaseAuthException catch (e) {
      print(e);
      String error = _getMessageFromErrorCode(e.code);
      print(error);
      return [null, error];
    }
  }

  // signout method for user
  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future get signInWithGoogle async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential result = await _auth.signInWithCredential(authCredential);

      User? user = result.user;
      UserInApp? userInApp = _userFromFireBaseUser(user);
      List docs = await DatabaseService(user: userInApp).getUIDList;
      
      for(String s in docs) {
        if (s == user?.uid) {
          return [userInApp];
        }
      }
      await DatabaseService(user: userInApp).firstTimeCreateDM(user?.photoURL);
      return [userInApp];
      
    } on FirebaseAuthException catch (e) {
      String error = _getMessageFromErrorCode(e.code);
      return [null, error];
    }
  }
}
