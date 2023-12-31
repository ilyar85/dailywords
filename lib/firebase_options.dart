// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3R9ONIJgDHBvExGClou6hQzQPShAQA6E',
    appId: '1:99938623392:web:949c41b4fb36d35fc8cec5',
    messagingSenderId: '99938623392',
    projectId: 'dailywordskz',
    authDomain: 'dailywordskz.firebaseapp.com',
    storageBucket: 'dailywordskz.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQPSQZSNBiy8iLdSOppfZSq491jHBrdGQ',
    appId: '1:99938623392:android:5340e267fedbe743c8cec5',
    messagingSenderId: '99938623392',
    projectId: 'dailywordskz',
    storageBucket: 'dailywordskz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6wJsf4W4H2u_B31oJK4gwHwu9-S4uvfI',
    appId: '1:99938623392:ios:b1d5af74209807e2c8cec5',
    messagingSenderId: '99938623392',
    projectId: 'dailywordskz',
    storageBucket: 'dailywordskz.appspot.com',
    iosClientId: '99938623392-lnodgtui2tt428kccodt2p00upausl9q.apps.googleusercontent.com',
    iosBundleId: 'com.example.dailywords',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6wJsf4W4H2u_B31oJK4gwHwu9-S4uvfI',
    appId: '1:99938623392:ios:51f1088b108fe3a7c8cec5',
    messagingSenderId: '99938623392',
    projectId: 'dailywordskz',
    storageBucket: 'dailywordskz.appspot.com',
    iosClientId: '99938623392-qtbgauqdn0rv7mqro1dfbsee0a1bv3bj.apps.googleusercontent.com',
    iosBundleId: 'com.example.dailywords.RunnerTests',
  );
}
