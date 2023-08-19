import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? currentUser;
  bool isUserLoggedIn = false;
  bool isUserRegistered = false;
  String? languageSelected;
  String? studyPlan;
  int? wordsCountForStudy;
  List<String>? selectedCategories;
  int? userPoints;
  List<String>? learnedWords;
  List<String>? wordsInErrors;
  bool canStartNewLesson = true;
  bool soundsEnabled = true;
  bool notificationsEnabled = true;
  DateTime? lastLessonCompletionTime;

  Future<void> initialize() async {
    // Check user login state
    currentUser = _auth.currentUser;
    isUserLoggedIn = currentUser != null;

    if (isUserLoggedIn) {
      // Load user data from Firestore
      DocumentSnapshot userData =
          await _db.collection('users').doc(currentUser!.uid).get();

      isUserRegistered = userData.exists;
      if (isUserRegistered) {
        languageSelected = userData.get('language');
        studyPlan = userData.get('studyPlan');
        wordsCountForStudy = userData.get('wordsCountForStudy');
        selectedCategories =
            List<String>.from(userData.get('selectedCategories'));
        userPoints = userData.get('points');
        learnedWords = List<String>.from(userData.get('learnedWords'));
        wordsInErrors = List<String>.from(userData.get('wordsInErrors'));
        canStartNewLesson = userData.get('canStartNewLesson');
        soundsEnabled = userData.get('soundsEnabled');
        notificationsEnabled = userData.get('notificationsEnabled');
        lastLessonCompletionTime =
            (userData.get('lastLessonCompletionTime') as Timestamp).toDate();
      }
    }
  }

  Future<User?> loginUser(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Метод для авторизации через Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
      return null;
    } catch (error) {
      print("Error in Google Sign In: $error");
      return null;
    }
  }

  // Метод для авторизации через Facebook
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final AccessToken? result = loginResult.accessToken;

      if (result != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.token);
        final UserCredential authResult =
            await _auth.signInWithCredential(facebookAuthCredential);
        return authResult.user;
      }
      return null;
    } catch (error) {
      print("Error in Facebook Sign In: $error");
      return null;
    }
  }

  // Метод для авторизации через Apple
  Future<User?> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleIDCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final OAuthCredential appleAuthCredential =
          OAuthProvider('apple.com').credential(
        idToken: appleIDCredential.identityToken,
        rawNonce: appleIDCredential.authorizationCode, // Изменил эту часть
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(appleAuthCredential);
      return authResult.user;
    } catch (error) {
      print("Error in Apple Sign In: $error");
      return null;
    }
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      throw error;
    }
  }

  Future<void> setRememberedUser(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('rememberedUser', uid);
  }

  Future<String?> getRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rememberedUser');
  }

  Future<void> removeRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('rememberedUser');
  }

  Future<void> setStudyPlan(String plan) async {
    studyPlan = plan;

    if (isUserLoggedIn && isUserRegistered) {
      await _db.collection('users').doc(currentUser!.uid).update({
        'studyPlan': plan,
      });
    }
  }

  Future<void> setWordsCountForStudy(int count) async {
    wordsCountForStudy = count;

    if (isUserLoggedIn && isUserRegistered) {
      await _db.collection('users').doc(currentUser!.uid).update({
        'wordsCountForStudy': count,
      });
    }
  }

  Future<void> saveUserCategories(List<String> categories) async {
    if (isUserLoggedIn && isUserRegistered) {
      await _db.collection('users').doc(currentUser!.uid).update({
        'selectedCategories': categories,
      });
    }
  }
}
