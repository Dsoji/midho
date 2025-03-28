import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class FirebaseApi {
  // Create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Firebase Storage instance
  final firebaseStorage = FirebaseStorage.instance;

  // Image URLs stored in Firebase
  final List<String> _imageUrls = [];

  // Uploading & Loading status
  final bool _isUploading = false;
  final bool _isLoading = false;

  /*
  GETTERS
  */
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  // Initialize Notifications
  Future<void> initNotification() async {
    try {
      // Request permission to receive notifications
      // await _firebaseMessaging.requestPermission();

      // Fetch FCM token for this device
      final fCMToken = await _firebaseMessaging.getToken();
      _logger.d("FCM Token: $fCMToken");
      if (fCMToken != null) {
        _logger.d("FCM Token: $fCMToken");
        await saveFCMToken(fCMToken);
      } else {
        _logger.e("Failed to retrieve FCM Token");
      }

      // // Fetch APN Token (for iOS devices)
      // final apnToken = await _firebaseMessaging.getAPNSToken();
      // _logger.d("APN Token: $apnToken");
    } catch (e) {
      _logger.e("Error initializing notifications: $e");
    }
  }

  // Function to save FCM token to SharedPreferences & Hive
  Future<void> saveFCMToken(String fcmtoken) async {
    try {
      await Hive.initFlutter();
      var box = await Hive.openBox('data');

      // Check if FCM token already exists
      var storedToken = box.get('fcm_token');
      if (storedToken == null) {
        // Save the new FCM token if it doesn't exist
        await box.put('fcm_token', fcmtoken);
        storedToken = fcmtoken;
        _logger.d("New FCM Token saved: $storedToken");
      } else {
        _logger.d("Existing FCM Token found: $storedToken");
      }
    } catch (e) {
      _logger.e("Error saving or fetching FCM Token: $e");
    }
  }

  // Fetch images from Firebase Storage
  // Future<void> fetchImages() async {
  //   try {
  //     _isLoading = true;

  //     final ListResult result =
  //         await firebaseStorage.ref('profile_images/').listAll();

  //     // Get download URLs
  //     final urls =
  //         await Future.wait(result.items.map((ref) => ref.getDownloadURL()));

  //     _imageUrls = urls;

  //     _logger.d("Fetched ${urls.length} images from Firebase Storage");
  //   } catch (e) {
  //     _logger.e("Error fetching images: $e");
  //   } finally {
  //     _isLoading = false;
  //     // notifyListeners(); // Uncomment if using state management
  //   }
  // }
}
