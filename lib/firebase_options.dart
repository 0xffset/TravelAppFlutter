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
    apiKey: 'AIzaSyA7kkII16jJSN4rcEFiuC2JUcBIWjUgg6k',
    appId: '1:128887085635:web:c20ac7474140ccee5c12f6',
    messagingSenderId: '128887085635',
    projectId: 'travelappflutter-6090f',
    authDomain: 'travelappflutter-6090f.firebaseapp.com',
    storageBucket: 'travelappflutter-6090f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFhSYQyBHzZ3Zh7-vvaGM5kVOn6YrdCfA',
    appId: '1:128887085635:android:50bbf92fe36eb2a85c12f6',
    messagingSenderId: '128887085635',
    projectId: 'travelappflutter-6090f',
    storageBucket: 'travelappflutter-6090f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNQIsAhXSLiFTPv6oFCUfG26mVMqWt7ac',
    appId: '1:128887085635:ios:6ac8b57400b0d1a65c12f6',
    messagingSenderId: '128887085635',
    projectId: 'travelappflutter-6090f',
    storageBucket: 'travelappflutter-6090f.appspot.com',
    iosClientId: '128887085635-95ak45hfishaeah0hnigaa2edf1l1h8l.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDNQIsAhXSLiFTPv6oFCUfG26mVMqWt7ac',
    appId: '1:128887085635:ios:fe5495eea2f94cd35c12f6',
    messagingSenderId: '128887085635',
    projectId: 'travelappflutter-6090f',
    storageBucket: 'travelappflutter-6090f.appspot.com',
    iosClientId: '128887085635-efk7uukvsjkdm8i7citnja1nvsd5h1qd.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelApp.RunnerTests',
  );
}
