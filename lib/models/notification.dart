class Notification {
  final String type;
  final String title;
  final String description;
  bool isRead;
  final String date = DateTime.now().toString();

  Notification({
    required this.type,
    required this.title,
    required this.description,
    required this.isRead,
  });
}
