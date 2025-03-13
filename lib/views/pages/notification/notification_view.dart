import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/notification/widgets/NotificationListWidget.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/notification.dart' as custom;

void main(List<String> args) {
  runApp(const NotificationView());
}

List<custom.Notification> notificationList = [
  custom.Notification(
      type: "Order",
      title: "Notification 1",
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
      isRead: false),
  custom.Notification(
      type: "FlashSale",
      title: "Notification 2",
      description: "lorem",
      isRead: false),
  custom.Notification(
      type: "Shipping",
      title: "Notification 3",
      description: "lorem",
      isRead: false),
  custom.Notification(
      type: "NewProduct",
      title: "Notification 4",
      description: "lorem",
      isRead: false),
  custom.Notification(
      type: "Voucher",
      title: "Notification 5",
      description: "lorem",
      isRead: false),
  custom.Notification(
      type: "Order",
      title: "Notification 6",
      description: "lorem",
      isRead: false),
  custom.Notification(
      type: "FlashSale",
      title: "Notification 7",
      description: "lorem",
      isRead: false),
  custom.Notification(
      type: "Shipping",
      title: "Notification 8",
      description: "lorem",
      isRead: false),
];

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NotificationListViewWidgetState> notificationListKey =
        GlobalKey<NotificationListViewWidgetState>();

    return MaterialApp(
        home: Scaffold(
      appBar: CustomAppBarMobile(title: "Notification"),
      body: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                Responsive.isMobile(context) ? null : BorderRadius.circular(10),
            border: Responsive.isMobile(context)
                ? null
                : Border.all(color: AppColors.grey),
          ),
          width: Responsive.isMobile(context) ? double.infinity : 1000,
          padding: const EdgeInsets.all(20),
          margin: Responsive.isMobile(context)
              ? null
              : const EdgeInsets.only(right: 100, top: 20, bottom: 20),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        notificationListKey.currentState?.markAllAsRead();
                      },
                      child: Text("Mark all as read",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
                indent: Responsive.isMobile(context) ? 20 : 0,
                endIndent: Responsive.isMobile(context) ? 20 : 0,
              ),
              Expanded(
                child: NotificationListViewWidget(
                    key: notificationListKey,
                    notificationList: notificationList),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
