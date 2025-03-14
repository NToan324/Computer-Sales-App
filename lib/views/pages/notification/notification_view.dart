import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/notification/widgets/NotificationListWidget.dart';
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

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NotificationListViewWidgetState> notificationListKey =
        GlobalKey<NotificationListViewWidgetState>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            Responsive.isMobile(context) ? null : BorderRadius.circular(10),
        border: Responsive.isMobile(context)
            ? null
            : Border.all(color: AppColors.grey),
      ),
      width: Responsive.isMobile(context) ? double.infinity : 1000,
      margin: Responsive.isMobile(context)
          ? null
          : const EdgeInsets.only(right: 100, top: 20, bottom: 20),
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
                key: notificationListKey, notificationList: notificationList),
          ),
        ],
      ),
    );
  }
}
