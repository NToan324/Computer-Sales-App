class NotificationModel {
  final String type;
  final String title;
  final String description;
  bool isRead;
  final String createAt;

  NotificationModel({
    required this.type,
    required this.title,
    required this.description,
    required this.isRead,
    required this.createAt,
  });
}
