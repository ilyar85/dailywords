import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InitializationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
