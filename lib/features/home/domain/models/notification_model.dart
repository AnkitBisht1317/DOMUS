class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String iconPath;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.iconPath,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    String? iconPath,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      iconPath: iconPath ?? this.iconPath,
      isRead: isRead ?? this.isRead,
    );
  }
}
