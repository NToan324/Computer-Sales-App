import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/services/order.service.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/order_item.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/timeline_list.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  OrderService orderService = OrderService();

  List<OrderModel> orders = [];

  Future<void> fetchOrders() async {
    try {
      final response = await orderService.getOrdersById();
      setState(() {
        orders = response;
      });
      // Handle the response as needed
    } catch (e) {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildOrderView(List<OrderModel> orders, String state) {
    final filteredOrders =
        orders.where((order) => order.status == state).toList();

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text(
          "No orders available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Responsive(
      mobile: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return OrderItem(order: filteredOrders[index], state: state);
        },
      ),
      desktop: Center(
        child: Container(
          color: Colors.grey[200], // Nền xám cho giao diện web
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 800), // Giới hạn chiều rộng
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền trắng
                borderRadius: BorderRadius.circular(12), // Bo góc nhẹ
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25), // Màu bóng nhẹ
                    blurRadius: 10, // Độ mờ của bóng
                    spreadRadius: 2, // Độ lan của bóng
                    offset: const Offset(0, 4), // Bóng đổ xuống dưới
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: TimelineList(orders: filteredOrders, state: state),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Responsive.isMobile(context)
            ? AppBar(
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'Order Management',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  tabs: const [
                    Tab(
                      child: Text(
                        'Track Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Shipping',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Cancelled',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            : null,
        body: Container(
          color: Responsive.isMobile(context) ? Colors.white : Colors.grey[200],
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: _tabController,
            children: [
              buildOrderView(orders, 'PENDING'),
              buildOrderView(orders, 'SHIPPING'),
              buildOrderView(orders, 'CANCELLED'),
            ],
          ),
        ),
      ),
    );
  }
}
