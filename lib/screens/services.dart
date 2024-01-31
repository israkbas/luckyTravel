import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Giriş yap fonksiyonu
  Future signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  // Çıkış yap fonksiyonu
  Future<void> signOut() async {
    await _auth.signOut();
  }

//gmail ile giriş yap fonksiyonu
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Firestore kullanarak kullanıcı bilgilerini kaydetme
      final user = userCredential.user;

      FirebaseFirestore.instance
          .collection('Login')
          .doc(user!.uid.toString())
          .set({
        'userName': user.displayName,
        'userMail': user.email,
        'uid': user.uid
      });

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // kayıt ol fonksiyonu
  Future<User?> createPerson(String name, String surname, String email,
      String password, String nickname) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection('Login').doc(user.user!.uid.toString()).set({
      'userName': name,
      'userSurname': surname,
      'userMail': email,
      'userNickname': nickname,
      'userPassword': password,
    });

    return user.user;
  }
}
