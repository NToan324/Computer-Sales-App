import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/views/pages/client/notification/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/notification.dart';

class NotificationListViewWidget extends StatefulWidget {
  final List<NotificationModel> notificationList;

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
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 100,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Leading
              Icon(
                notificationList[index].type == 'Order'
                    ? Icons.shopping_cart
                    : notificationList[index].type == 'FlashSale'
                        ? Icons.flash_on
                        : notificationList[index].type == 'Shipping'
                            ? Icons.local_shipping
                            : notificationList[index].type == 'NewProduct'
                                ? Icons.new_releases
                                : Icons.discount,
                size: 30,
              ),
              Expanded(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notificationList[index].title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(formatDate(notificationList[index].createAt)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 800,
                            ),
                            child: Text(
                              notificationList[index].description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        Icon(
                          notificationList[index].isRead
                              ? Icons.check_circle
                              : Icons.circle,
                          color: notificationList[index].isRead
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
