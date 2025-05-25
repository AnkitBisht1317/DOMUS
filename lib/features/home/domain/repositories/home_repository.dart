abstract class HomeRepository {
  Future<void> updateLastAccess();
  Future<void> updateNotificationStatus(bool hasUnreadNotifications);
  Future<Map<String, dynamic>> getUserProfile();
} 