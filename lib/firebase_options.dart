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
    apiKey: 'AIzaSyD9aeV2ahys8nBssaeBrPn8SMtkR5_Nrl0',
    appId: '1:1006540419869:web:e57caee4f5a61c91b9e7f4',
    messagingSenderId: '1006540419869',
    projectId: 'catalog-f0e08',
    authDomain: 'catalog-f0e08.firebaseapp.com',
    storageBucket: 'catalog-f0e08.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwNIUge-_RdxhlFKTm8pNpjNlovw9-R2Q',
    appId: '1:1006540419869:android:1cb280cdf88c9eeab9e7f4',
    messagingSenderId: '1006540419869',
    projectId: 'catalog-f0e08',
    storageBucket: 'catalog-f0e08.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApkRtJkR8SHYFB2gvyeuKl_HdYDUYDj7k',
    appId: '1:1006540419869:ios:1b6c464697688c19b9e7f4',
    messagingSenderId: '1006540419869',
    projectId: 'catalog-f0e08',
    storageBucket: 'catalog-f0e08.appspot.com',
    androidClientId: '1006540419869-rf18db1gb6o6d2m21h9vklesk0q43v6c.apps.googleusercontent.com',
    iosClientId: '1006540419869-cjo0v25jp03fc033cvvbvudt2joe5g7o.apps.googleusercontent.com',
    iosBundleId: 'com.example.catalog',
  );
}
