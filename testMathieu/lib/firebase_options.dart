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
    apiKey: 'AIzaSyAcNIb5zg0zkjknzeOSPAo201B48WWtuE0',
    appId: '1:756586477961:web:117088e522544813ff8958',
    messagingSenderId: '756586477961',
    projectId: 'login-register-firebase-51bc0',
    authDomain: 'login-register-firebase-51bc0.firebaseapp.com',
    storageBucket: 'login-register-firebase-51bc0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw-3umnq18rB2KbuGIn4ASy8_OGTKpkm4',
    appId: '1:756586477961:android:3f6cac6981059a29ff8958',
    messagingSenderId: '756586477961',
    projectId: 'login-register-firebase-51bc0',
    storageBucket: 'login-register-firebase-51bc0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPmRC37rct4XYL8MCWNpERBbl3rXzaN6g',
    appId: '1:756586477961:ios:2424216fa0ebeda5ff8958',
    messagingSenderId: '756586477961',
    projectId: 'login-register-firebase-51bc0',
    storageBucket: 'login-register-firebase-51bc0.appspot.com',
    iosBundleId: 'com.example.testmathieu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPmRC37rct4XYL8MCWNpERBbl3rXzaN6g',
    appId: '1:756586477961:ios:2424216fa0ebeda5ff8958',
    messagingSenderId: '756586477961',
    projectId: 'login-register-firebase-51bc0',
    storageBucket: 'login-register-firebase-51bc0.appspot.com',
    iosBundleId: 'com.example.testmathieu',
  );
}