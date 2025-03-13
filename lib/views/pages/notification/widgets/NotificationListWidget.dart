import 'package:computer_sales_app/views/pages/notification/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/notification.dart' as custom;

class NotificationListViewWidget extends StatefulWidget {
  final List<custom.Notification> notificationList;

  const NotificationListViewWidget({super.key, required this.notificationList});

  @override
  NotificationListViewWidgetState createState() =>
      NotificationListViewWidgetState();
}

class NotificationListViewWidgetState
    extends State<NotificationListViewWidget> {
  bool _allRead = false;

  void markAllAsRead() {
    setState(() {
      _allRead = true;
      for (var notification in widget.notificationList) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        return Expanded(
          child: ListTile(
            leading: notificationList[index].type == 'Order'
                ? const Icon(Icons.shopping_cart)
                : notificationList[index].type == 'FlashSale'
                    ? const Icon(Icons.flash_on)
                    : notificationList[index].type == 'Shipping'
                        ? const Icon(Icons.local_shipping)
                        : notificationList[index].type == 'NewProduct'
                            ? const Icon(Icons.new_releases)
                            : const Icon(Icons.discount),
            title: Text(
              notificationList[index].title,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              notificationList[index].description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            trailing: notificationList[index].isRead
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.circle, color: Colors.red),
          ),
        );
      },
    );
  }
}
