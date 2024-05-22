// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDlDNQ7cW4YpX1wZpowh6FhpT7hp7nQ59o',
    appId: '1:451783298102:web:e408ece6e901ab1059dc97',
    messagingSenderId: '451783298102',
    projectId: 'fluttersigninfc',
    authDomain: 'fluttersigninfc.firebaseapp.com',
    storageBucket: 'fluttersigninfc.appspot.com',
    measurementId: 'G-V7VC084634',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe-4gFQINLd10yXe5PazcvGgqZhD-jHA0',
    appId: '1:451783298102:android:7c925485b9aba09559dc97',
    messagingSenderId: '451783298102',
    projectId: 'fluttersigninfc',
    storageBucket: 'fluttersigninfc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYy_UG5V1fX39RJg_rRa_Co0mja8Rt_K0',
    appId: '1:451783298102:ios:a840cab3a4c8804659dc97',
    messagingSenderId: '451783298102',
    projectId: 'fluttersigninfc',
    storageBucket: 'fluttersigninfc.appspot.com',
    iosClientId: '451783298102-bs80miq6vonkjmmfsprjirjhu1n04vu1.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodDeliveryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYy_UG5V1fX39RJg_rRa_Co0mja8Rt_K0',
    appId: '1:451783298102:ios:a840cab3a4c8804659dc97',
    messagingSenderId: '451783298102',
    projectId: 'fluttersigninfc',
    storageBucket: 'fluttersigninfc.appspot.com',
    iosClientId: '451783298102-bs80miq6vonkjmmfsprjirjhu1n04vu1.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodDeliveryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDlDNQ7cW4YpX1wZpowh6FhpT7hp7nQ59o',
    appId: '1:451783298102:web:aeb748a44266d1b959dc97',
    messagingSenderId: '451783298102',
    projectId: 'fluttersigninfc',
    authDomain: 'fluttersigninfc.firebaseapp.com',
    storageBucket: 'fluttersigninfc.appspot.com',
    measurementId: 'G-VT6YPJXGJC',
  );

}