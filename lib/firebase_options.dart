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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyADeDx7aMPlkq3n2eVPZsoofWcilg4e4h8',
    appId: '1:144612262372:web:4253d08c877b85917f47f1',
    messagingSenderId: '144612262372',
    projectId: 'vacoapp-b796b',
    authDomain: 'vacoapp-b796b.firebaseapp.com',
    storageBucket: 'vacoapp-b796b.appspot.com',
    measurementId: 'G-2F229D6RBN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACFkrRhKVn9dQsZRwHb05tQH3MnLV2gKA',
    appId: '1:144612262372:android:5626f0262d8b5aef7f47f1',
    messagingSenderId: '144612262372',
    projectId: 'vacoapp-b796b',
    storageBucket: 'vacoapp-b796b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfgtcz14z4Xzu2XBmCvruk9mIkhLRLbA0',
    appId: '1:144612262372:ios:04fcec7623a65f967f47f1',
    messagingSenderId: '144612262372',
    projectId: 'vacoapp-b796b',
    storageBucket: 'vacoapp-b796b.appspot.com',
    androidClientId: '144612262372-7ecmakhpvmkcp98ardeo6rlvo9dn4a5p.apps.googleusercontent.com',
    iosClientId: '144612262372-2e98v2qe3v2o3inq8273kjju94113kv1.apps.googleusercontent.com',
    iosBundleId: 'com.example.pruebaVacoApp',
  );
}
