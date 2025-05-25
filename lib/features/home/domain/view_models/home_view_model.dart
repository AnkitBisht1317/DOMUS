import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  bool _hasUnreadNotifications = false;
  String _userName = '';
  String _userGender = '';
  
  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Study Material',
      iconPath: 'assets/books.png',
      route: '/study-material',
    ),
    MenuItem(
      title: 'Assignments',
      iconPath: 'assets/books.png',
      route: '/assignments',
    ),
    MenuItem(
      title: 'Tests',
      iconPath: 'assets/books.png',
      route: '/tests',
    ),
    MenuItem(
      title: 'Progress',
      iconPath: 'assets/books.png',
      route: '/progress',
    ),
    MenuItem(
      title: 'Schedule',
      iconPath: 'assets/books.png',
      route: '/schedule',
    ),
    MenuItem(
      title: 'Resources',
      iconPath: 'assets/books.png',
      route: '/resources',
    ),
  ];

  HomeViewModel(this._repository) {
    _initializeData();
  }

  bool get hasUnreadNotifications => _hasUnreadNotifications;
  String get userName => _userName;
  String get userGender => _userGender;

  Future<void> _initializeData() async {
    try {
      final userProfile = await _repository.getUserProfile();
      _userName = userProfile['fullName'] ?? '';
      _userGender = userProfile['gender'] ?? '';
      notifyListeners();
      
      await _repository.updateLastAccess();
    } catch (e) {
      debugPrint('Error initializing home data: $e');
    }
  }

  void checkNotifications() async {
    try {
      // Implementation for checking notifications
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking notifications: $e');
    }
  }
} 