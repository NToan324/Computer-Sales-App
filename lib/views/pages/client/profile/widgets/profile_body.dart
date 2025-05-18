import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/my_account.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/order_management.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/payment_management.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  double _selectedIndex = 0;

  List<String> profileMenuItems = [
    'My Account',
    'Order Management',
    'Payment Method',
    'Support',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final name = userProvider.userModel?.fullName ?? 'Customer';
    final point = userProvider.userModel?.loyaltyPoints ?? 0;
    final avatar = userProvider.userModel?.avatar.url;


    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Add your profile body widgets here
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: avatar != null
                              ? NetworkImage(avatar)
                              : const AssetImage('assets/images/avatar.jpeg'),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              '${point.toStringAsFixed(0)} Points',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hi, $name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profileMenuItems.length,
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemBuilder: (context, index) => InkWell(
                onTap: () => {
                  setState(() {
                    _selectedIndex = index.toDouble();
                  }),
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      )),
                  child: Center(
                    child: Text(
                      profileMenuItems[index],
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          //Show the selected profile menu item
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: _selectedIndex == 0
                  ? MyAccountView()
                  : _selectedIndex == 1
                      ? OrderManagement(
                          userId: userProvider.userModel?.id ?? '',
                      )
                      : _selectedIndex == 2
                          ? PaymentManagement()
                          : SupportAccount(),
            ),
          )
        ],
      ),
    );
  }
}
