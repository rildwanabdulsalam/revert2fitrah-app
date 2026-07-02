// Firebase configuration for the revert2fitrah project.
//
// Web is registered and live. Android and iOS still carry placeholder
// values — on those platforms the app falls back to the on-device mock auth
// until the apps are registered in the Firebase console (Project settings →
// Your apps) and their values are filled in here, either by hand or by
// running `flutterfire configure`. See FIREBASE_SETUP.md.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCXkDD5yw8BeDXFyg8aVveD8ghQSHU_XQE',
    appId: '1:781321626682:web:83132273ffd926a81c4103',
    messagingSenderId: '781321626682',
    projectId: 'revert2fitrah',
    authDomain: 'revert2fitrah.firebaseapp.com',
    storageBucket: 'revert2fitrah.firebasestorage.app',
    measurementId: 'G-B548G32XWC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_ANDROID_APP_VALUES',
    appId: 'REPLACE',
    messagingSenderId: '781321626682',
    projectId: 'revert2fitrah',
    storageBucket: 'revert2fitrah.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_APP_VALUES',
    appId: 'REPLACE',
    messagingSenderId: '781321626682',
    projectId: 'revert2fitrah',
    storageBucket: 'revert2fitrah.firebasestorage.app',
    iosBundleId: 'com.revert2fitrah.revert2fitrah',
  );
}
