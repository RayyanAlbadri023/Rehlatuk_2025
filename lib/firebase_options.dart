// Paste your Firebase config here. Replace the values with your own from the Firebase Console.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlw1d4vLuJvPClvh2vl6zGDBMqAKKbOpE',
    appId: '1:1055428545884:android:d5a27a0c3e47a7b3e44599',
    messagingSenderId: '1055428545884',
    projectId: 'app10-db6bc',
    storageBucket: 'app10-db6bc.appspot.com',
    databaseURL: 'https://app10-db6bc-default-rtdb.firebaseio.com',
  );

  static FirebaseOptions get currentPlatform {
    return android;
  }
} 