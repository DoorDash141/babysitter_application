import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAhO-uHe_lp2XnbVzLokTWXwd1NHVsg3z8',
    appId: '1:783128069171:web:19b84a1e46fdeeab9b0f46',
    messagingSenderId: '783128069171',
    projectId: 'babysitter2-7ea8c',
    authDomain: 'babysitter2-7ea8c.firebaseapp.com',
    storageBucket: 'babysitter2-7ea8c.appspot.com',
    measurementId: 'G-RLRWNY5WTQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9LqcAPu71RNDjMfZjVREEzKQazgZQU2k',
    appId: '1:783128069171:android:5619bcfb16dcdc639b0f46',
    messagingSenderId: '783128069171',
    projectId: 'babysitter2-7ea8c',
    storageBucket: 'babysitter2-7ea8c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAuHbfC2ZhOH9iFYosh-EK4sQoU2oPMDI',
    appId: '1:783128069171:ios:154b26b43e95c6409b0f46',
    messagingSenderId: '783128069171',
    projectId: 'babysitter2-7ea8c',
    storageBucket: 'babysitter2-7ea8c.appspot.com',
    iosBundleId: 'com.example.babysitterApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAuHbfC2ZhOH9iFYosh-EK4sQoU2oPMDI',
    appId: '1:783128069171:ios:154b26b43e95c6409b0f46',
    messagingSenderId: '783128069171',
    projectId: 'babysitter2-7ea8c',
    storageBucket: 'babysitter2-7ea8c.appspot.com',
    iosBundleId: 'com.example.babysitterApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhO-uHe_lp2XnbVzLokTWXwd1NHVsg3z8',
    appId: '1:783128069171:web:5a031d97795286509b0f46',
    messagingSenderId: '783128069171',
    projectId: 'babysitter2-7ea8c',
    authDomain: 'babysitter2-7ea8c.firebaseapp.com',
    storageBucket: 'babysitter2-7ea8c.appspot.com',
    measurementId: 'G-WZ0V2DCQ40',
  );
}
