import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/notification/widgets/NotificationListWidget.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/notification.dart';

List<NotificationModel> notificationList = [
  NotificationModel(
    type: "Order",
    title: "Notification 1",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "FlashSale",
    title: "Notification 2",
    description: "Description 2",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "Shipping",
    title: "Notification 3",
    description: "Description 3",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "NewProduct",
    title: "Notification 4",
    description: "Description 4",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "Discount",
    title: "Notification 5",
    description: "Description 5",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "Order",
    title: "Notification 6",
    description: "Description 6",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "FlashSale",
    title: "Notification 7",
    description: "Description 7",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "Shipping",
    title: "Notification 8",
    description: "Description 8",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "NewProduct",
    title: "Notification 9",
    description: "Description 9",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
  NotificationModel(
    type: "Discount",
    title: "Notification 10",
    description: "Description 10",
    isRead: false,
    createAt: DateTime.now().toString(),
  ),
];

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 70,
        right: 20,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 250,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: notificationList.isEmpty
                  ? [Text("Không có thông báo")]
                  : notificationList
                      .map((msg) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(Icons.notifications, color: Colors.blue),
                                SizedBox(width: 10),
                                Expanded(child: Text(msg.title)),
                              ],
                            ),
                          ))
                      .take(5)
                      .toList(),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NotificationListViewWidgetState> notificationListKey =
        GlobalKey<NotificationListViewWidgetState>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Notification"),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          MouseRegion(
            onEnter: (_) => showOverlay(context),
            onExit: (_) => removeOverlay(),
            child: IconButton(
              icon: Icon(Icons.notifications, size: 30),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: Responsive.isMobile(context) ? 0 : 50,
          ),
          // Sidebar
          if (!Responsive.isMobile(context))
            Expanded(
              child: Container(
                width: Responsive.isMobile(context) ? 0 : 250,
                height: Responsive.isMobile(context) ? 0 : 500,
                color: AppColors.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sidebar",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Menu Item 1"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Menu Item 2"),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(
            width: Responsive.isMobile(context)
                ? 0
                : 100, // Khoảng cách giữa sidebar và nội dung chính
          ),
          // Notification Container
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Responsive.isMobile(context)
                      ? null
                      : BorderRadius.circular(10),
                  border: Responsive.isMobile(context)
                      ? null
                      : Border.all(color: AppColors.grey),
                ),
                width: Responsive.isMobile(context) ? double.infinity : 1000,
                height: Responsive.isMobile(context) ? double.infinity : 500,
                margin: Responsive.isMobile(context)
                    ? null
                    : const EdgeInsets.only(top: 50, bottom: 50, right: 50),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          notificationListKey.currentState?.markAllAsRead();
                        },
                        child: Text(
                          "Mark all as read",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: NotificationListViewWidget(
                        key: notificationListKey,
                        notificationList: notificationList,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
