import 'package:flutter/material.dart';
import '../../domain/models/notification_model.dart';
import '../../data/services/firebase_messaging_service.dart';
import 'dart:developer' as developer;

class NotificationViewModel extends ChangeNotifier {
  bool _isSearching = false;
  String _searchQuery = '';
  final List<NotificationModel> _notifications = [];
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();
  String? _fcmToken;
  
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String? get fcmToken => _fcmToken;
  
  List<NotificationModel> get notifications {
    if (_searchQuery.isEmpty) {
      return _notifications;
    }
    
    return _notifications.where((notification) {
      return notification.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             notification.message.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
  
  NotificationViewModel() {
    _initializeNotifications();
    _initializeMessaging();
  }
  
  Future<void> _initializeMessaging() async {
    await _messagingService.initialize();
    _fcmToken = await _messagingService.getToken();
    developer.log('FCM Token: $_fcmToken');
    notifyListeners();
  }
  
  void _initializeNotifications() {
    // In a real app, these would come from a repository
    _notifications.addAll([
      NotificationModel(
        id: '1',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '2',
        title: 'Breaking news: Homeopathic collages at risk',
        message: 'over AEBAS compliance & Free Payment',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '3',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '4',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '5',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '6',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '7',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '8',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '9',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        iconPath: 'assets/books.png',
      ),
      NotificationModel(
        id: '10',
        title: 'Assistance Director 2025 homeopathy',
        message: 'Question paper and provisional answer key - Gujarat PSC',
        timestamp: DateTime.now().subtract(const Duration(days: 8)),
        iconPath: 'assets/books.png',
      ),
    ]);
  }
  
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
  
  void startSearch() {
    _isSearching = true;
    notifyListeners();
  }
  
  void stopSearch() {
    _isSearching = false;
    _searchQuery = '';
    notifyListeners();
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void markAsRead(String id) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
  
  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }
}