import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laziless/services/database.dart';
import 'package:laziless/services/update_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  String errorMsg = "";

  // create user obj based on FirebaseUser
  /* User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(
            uid: user.uid,
            photoUrl: user.photoUrl,
            name: user.displayName,
            isAnonymous: user.isAnonymous,
            email: user.email,
            phoneNumber: user.phoneNumber,
            emailVerified: user.isEmailVerified)
        : null;
  }*/

  // auth change user stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  // Sign in Anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      setInitialData(user);

      return user;
    } catch (e) {
      print(e.toString());
      errorMsg = e.toString();
      return null;
    }
  }

  // Sign in with Google

  Future initiateGoogleLogin() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      print("success");
      DocumentSnapshot snapshot = await DatabaseService(uid: user.uid)
          .goalCollection
          .document(user.uid)
          .get();

      if (snapshot.data == null) {
        setInitialData(user);
      }

      return user;
    } catch (e) {
      errorMsg = e.toString();

      return null;
    }
  }

  //Convert with Google
  Future convertWithGoogle() async {
    final currentUser = await _auth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

    try {
      await currentUser.linkWithCredential(credential);
    } catch (e) {
      print(e);
      errorMsg = e.toString();
      return null;
    }

    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = _googleSignIn.currentUser.displayName;
    userUpdateInfo.photoUrl = _googleSignIn.currentUser.photoUrl;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    final user = await _auth.currentUser();

    return user;
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    } catch (e) {
      errorMsg = e.toString();
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, context) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      print("Success");
      setInitialData(user);

      try {
        await user.sendEmailVerification();
        return user;
      } catch (e) {
        print("An error occured while trying to send email verification");
        errorMsg = e.toString();
        print(e);
      }
    } catch (e) {
      errorMsg = e.toString();

      print(e);
    }
  }

  // register with email and password
  Future convertWithEmailAndPassword(String email, String password) async {
    try {
      final currentUser = await _auth.currentUser();
      final credential =
          EmailAuthProvider.getCredential(email: email, password: password);
      await currentUser.linkWithCredential(credential);

      try {
        await currentUser.sendEmailVerification();
        return currentUser;
      } catch (e) {
        print("An error occured while trying to send email verification");
        errorMsg = e.toString();
        print(e);
      }

      FirebaseUser user = await _auth.currentUser();

      return user;
    } catch (e) {
      errorMsg = e.toString();
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> reloadCurrentUser() async {
    FirebaseUser oldUser = await FirebaseAuth.instance.currentUser();
    oldUser.reload();
    FirebaseUser newUser = await FirebaseAuth.instance.currentUser();
    // Add newUser to a Stream, maybe merge this Stream with onAuthStateChanged?
    return newUser;
  }

  Future setInitialData(FirebaseUser user) async {
// create a new document for user with the uid
    await DatabaseService(uid: user.uid).setInitialUserData();
  }

  // Sign out
  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Success";
    } catch (e) {
      print(e);
      errorMsg = e.toString();
      return null;
    }
  }

  Future deleteUser() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user.delete();
      deleteUserData(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
