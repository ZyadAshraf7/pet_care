// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJbb7HpIXH17paVdws43yfsHPSMKikqQk',
    appId: '1:648689792538:android:a1ac771e1ead8b773d83a3',
    messagingSenderId: '648689792538',
    projectId: 'pet-care-4f39a',
    storageBucket: 'pet-care-4f39a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxdIqm0kkwyeDojj73quxyQqfYFP1ftAs',
    appId: '1:648689792538:ios:7a21954336c5b0f23d83a3',
    messagingSenderId: '648689792538',
    projectId: 'pet-care-4f39a',
    storageBucket: 'pet-care-4f39a.appspot.com',
    iosClientId: '648689792538-o6vv9nd029hgs504eql1et5m42fnjtvl.apps.googleusercontent.com',
    iosBundleId: 'com.example.petCare',
  );
}
