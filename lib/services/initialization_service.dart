import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Word {
  final String word;
  final String rus;
  final String transcription;

  Word({required this.word, required this.rus, required this.transcription});
}

class WordOption {
  final String word;
  final String rus;
  final String transcription;

  WordOption({required this.word, required this.rus, required this.transcription});
}


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
    try {
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
    } catch (e) {
      print("Error during initialization: $e");
    }
  }

  Future<User?> loginUser(String email, String password) async {
    //try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    //} catch (e) {
    //  print("Error during login: $e");
    //  return null;
    //}
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
    try {
      studyPlan = plan;

      if (isUserLoggedIn) {
        await _db.collection('users').doc(currentUser!.uid).set(
          {'studyPlan': plan},
          SetOptions(merge: true),
        );
        print('Study plan updated successfully for user ${currentUser!.uid}');
      } else {
        print('User is not logged in. Cannot update study plan.');
      }
    } catch (e) {
      print(
          'Failed to update study plan for user ${currentUser!.uid}. Error: $e');
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
    try {
      if (isUserLoggedIn) {
        await _db.collection('users').doc(currentUser!.uid).set(
          {'selectedCategories': categories},
          SetOptions(merge: true),
        );
        print(
            'User categories updated successfully for user ${currentUser!.uid}');
      } else {
        print('User is not logged in. Cannot update categories.');
      }
    } catch (e) {
      print(
          'Failed to update user categories for user ${currentUser!.uid}. Error: $e');
    }
  }

  Future<void> resetAllUserData() async {
    try {
      // 1. Очистить сохраненные данные в Firestore для текущего пользователя.
      if (currentUser != null) {
        await _db.collection('users').doc(currentUser!.uid).delete();
      }

      // 2. Очистить сохраненные настройки в `SharedPreferences`.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Очистить текущую авторизацию пользователя.
      await _auth.signOut();

      print('All user data has been reset.');
    } catch (e) {
      print('Error during data reset: $e');
    }
  }

Future<List<Word>> getRandomWordsForLesson() async {
  List<Word> selectedWords = [];
  Set<int> randomIndexes = {};

  for (String category in selectedCategories!) {
    CollectionReference wordsRef = _db.collection('categories').doc(category).collection('words');

    int wordsCount = (await wordsRef.get()).size;

    while (randomIndexes.length < wordsCountForStudy!) {
      int randIndex = Random().nextInt(wordsCount);
      if (!randomIndexes.contains(randIndex)) {
        randomIndexes.add(randIndex);
      }
    }

    for (int index in randomIndexes) {
      DocumentSnapshot wordDoc = (await wordsRef.get()).docs[index];
      Word word = Word(
        word: wordDoc['word'],
        rus: wordDoc['rus'],
        transcription: wordDoc['transcription'],
      );
      selectedWords.add(word);
    }
  }

  return selectedWords;
}
Future<List<WordOption>> getWordOptionsFor(Word correctWord, String category) async {
  List<WordOption> options = [];
  
  // Получаем все слова из категории
  CollectionReference wordsRef = _db.collection('categories').doc(category).collection('words');
  List<DocumentSnapshot> allWordsInCategory = (await wordsRef.get()).docs;
  
  // Исключаем правильное слово из списка
  allWordsInCategory.removeWhere((doc) => doc['word'] == correctWord.word);
  
  // Выбираем три случайных слова
  allWordsInCategory.shuffle();
  for (int i = 0; i < 3; i++) {
    WordOption wordOption = WordOption(
      word: allWordsInCategory[i]['word'],
      rus: allWordsInCategory[i]['rus'],
      transcription: allWordsInCategory[i]['transcription'],
    );
    options.add(wordOption);
  }

  // Добавляем правильное слово в список вариантов
  options.add(WordOption(
    word: correctWord.word,
    rus: correctWord.rus,
    transcription: correctWord.transcription,
  ));

  // Перемешиваем варианты, чтобы правильный ответ был не на одном и том же месте
  options.shuffle();

  return options;
}

}
