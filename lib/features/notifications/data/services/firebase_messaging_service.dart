import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../features/authentication/data/repositories/user_repository_impl.dart';
import '../../domain/models/notification_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  developer.log("Handling a background message: ${message.messageId}");
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  final UserRepositoryImpl _userRepository = UserRepositoryImpl();
  
  // Singleton pattern
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  
  factory FirebaseMessagingService() {
    return _instance;
  }
  
  FirebaseMessagingService._internal();
  
  Future<void> initialize() async {
    // Set the background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        developer.log('Notification tapped: ${response.payload}');
      },
    );
    
    // For iOS, create notification channel
    await _setupNotificationChannels();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle when app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);
    
    // Check if app was opened from a notification
    await _checkInitialMessage();
    
    // Only request permission and store token if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // For Android 13+, request permission
      await _requestPermission();
      
      // Get and store the FCM token
      await getAndStoreToken();
      
      // Listen for token refreshes
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        developer.log('FCM Token refreshed: $newToken');
        _storeTokenInFirestore(newToken);
      });
    }
  }
  
  // This method can be called when user logs in
  Future<void> initializeForLoggedInUser() async {
    // For Android 13+, request permission
    await _requestPermission();
    
    // Get and store the FCM token
    await getAndStoreToken();
    
    // Listen for token refreshes if not already listening
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      developer.log('FCM Token refreshed: $newToken');
      _storeTokenInFirestore(newToken);
    });
  }
  
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true, // Explicitly request sound permission
    );
    
    developer.log('User granted permission: ${settings.authorizationStatus}');
    
    // For iOS, also set the presentation options to include sound
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true, // Explicitly enable sound for foreground notifications
    );
  }
  
  Future<void> _setupNotificationChannels() async {
    // For Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
      // Add this line to ensure visibility
    );
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  
  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    developer.log('FCM Token: $token');
    return token;
  }
  
  Future<void> getAndStoreToken() async {
    String? token = await getToken();
    if (token != null) {
      await _storeTokenInFirestore(token);
    }
  }
  
  Future<void> _storeTokenInFirestore(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.phoneNumber != null) {
        await _userRepository.saveFcmToken(user.phoneNumber!, token);
        developer.log('FCM Token stored in Firestore for user: ${user.phoneNumber}');
      }
    } catch (e) {
      developer.log('Error storing FCM token: $e');
    }
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    developer.log('Got a message whilst in the foreground!');
    developer.log('Message data: ${message.data}');
    
    // Always show notification regardless of notification property
    // This ensures foreground notifications are displayed
    _showLocalNotification(message);
    
    // Convert to notification model and add to view model
    final notificationModel = convertMessageToNotificationModel(message);
    if (notificationModel != null) {
      // Use a callback to notify the view model
      if (_onNotificationReceived != null) {
        _onNotificationReceived!(notificationModel);
      }
    }
  }
  
  // Add callback for notification received
  Function(NotificationModel)? _onNotificationReceived;
  
  // Set callback from view model
  void setOnNotificationReceived(Function(NotificationModel) callback) {
    _onNotificationReceived = callback;
  }
  
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    // Create a default notification if the message doesn't contain one
    String title = notification?.title ?? message.data['title'] ?? 'New Notification';
    String body = notification?.body ?? message.data['body'] ?? '';
    
    // Always show notification even if notification is null
    _flutterLocalNotificationsPlugin.show(
      notification?.hashCode ?? DateTime.now().millisecondsSinceEpoch.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('notification'),
          priority: Priority.max, // Changed from high to max
          importance: Importance.max,
          enableVibration: true,
          // Add these lines to ensure visibility in the system tray
          channelShowBadge: true,
          visibility: NotificationVisibility.public,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.message,
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction('open', 'Open'),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default',
        ),
      ),
      payload: message.data.toString(),
    );
  }
  
  void _handleNotificationOpen(RemoteMessage message) {
    developer.log('Notification opened app: ${message.data}');
    // Navigate to specific screen based on notification data if needed
  }
  
  Future<void> _checkInitialMessage() async {
    // Get any messages which caused the application to open from a terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    
    if (initialMessage != null) {
      developer.log('Application opened from terminated state by notification');
      // Handle the initial message - navigate to a specific screen if needed
    }
  }
  
  // Method to convert FCM message to NotificationModel
  // Update the convertMessageToNotificationModel method to handle image URLs
  NotificationModel? convertMessageToNotificationModel(RemoteMessage message) {
    // Check if there's a notification or at least data payload
    if (message.notification == null && message.data.isEmpty) return null;
    
    // Extract image URL from either notification or data payload
    String? imageUrl = message.notification?.android?.imageUrl ?? 
                  message.notification?.apple?.imageUrl ?? 
                  message.data['image_url'] ?? 
                  message.data['imageUrl'];
    
    String iconPath = 'assets/notification_icon.png'; // Default icon
    
    return NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? message.data['title'] ?? 'New Notification',
      message: message.notification?.body ?? message.data['body'] ?? '',
      timestamp: DateTime.now(),
      iconPath: iconPath,
      imageUrl: imageUrl,
      isRead: false,
    );
  }
  
  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
  
  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}