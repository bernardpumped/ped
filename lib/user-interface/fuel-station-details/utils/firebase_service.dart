import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FirebaseService {
  static const _tag = 'FirebaseService';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future signInwWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      LogUtil.error(_tag, 'Error happened : ${e.message}');
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
