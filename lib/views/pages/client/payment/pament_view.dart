import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/services/order.service.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/order_summary.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/payment_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late Future<String> _futureLocation;
  bool isLoading = false;
  String email = '';
  String name = '';
  String address = '';
  String paymentMethod = 'BANK_TRANSFER';
  String shippingMethod = 'Express delivery';
  double currentPoint = 0;
  double totalAmountFinal = 0;

  Future<String> getCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('location_current');
    return location ?? 'Enter your location';
  }

  Future<void> handleCreateOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (cartProvider.cartItems.isEmpty) {
      showCustomSnackBar(context, 'Your cart is empty');
      return;
    }
    if (name.isEmpty || email.isEmpty || address.isEmpty) {
      showCustomSnackBar(context, 'Please fill in all fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    OrderService orderService = OrderService();
    try {
      await orderService.createOrder(
        name: name,
        email: email,
        address: address,
        paymentMethod: paymentMethod,
        items: cartProvider.cartItems.map((item) {
          return OrderItemModel(
            productVariantId: item.productVariantId,
            productVariantName: item.productVariantName,
            quantity: item.quantity,
            unit_price: item.unitPrice,
            discount: item.discount,
            images: ImageModel(url: item.images.url),
          );
        }).toList(),
      );
    } on FetchDataException catch (e) {
      if (mounted) {
        showCustomSnackBar(context, e.message);
      }
      return;
    } on BadRequestException catch (e) {
      if (mounted) {
        showCustomSnackBar(context, e.message);
      }
      return;
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Failed to create order');
      }
      setState(() {
        isLoading = false;
      });
      return;
    }

    //Removew cart in local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/order-success.png', height: 200),
            const SizedBox(height: 20),
            const Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            MyButton(
                text: 'View Order',
                onTap: (_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('order-view');
                }),
            const SizedBox(height: 10),
            MyButton(
              text: 'Back to Home',
              variantIsOutline: true,
              onTap: (_) {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('home');
              },
            ),
          ],
        ),
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureLocation = getCurrentLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.getCartByUserId();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUserData();

      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
              {};
      shippingMethod = args['shippingMethod'] ?? 'Express delivery';

      name = userProvider.userModel?.fullName ?? 'Unknown';
      email = userProvider.userModel?.email ?? 'example@gmail.com';
      currentPoint = userProvider.userModel?.loyaltyPoints ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: CustomAppBarMobile(title: 'Payment', isBack: true),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _futureLocation,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final currentLocation = snapshot.data ?? 'District 1, HCM';
            if (address.isEmpty) {
              address = currentLocation;
            }
            return Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                final cartItems = cartProvider.cartItems;
                final totalAmount = cartProvider.subTotalPrice;
                final isLoading = cartProvider.isLoading;
                return Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        isMobile
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OrderSummary(
                                      cartItems: cartItems,
                                      isLoading: isLoading,
                                    ),
                                    const SizedBox(height: 24),
                                    Center(
                                      child: PaymentDetails(
                                        totalAmount: totalAmount,
                                        address: currentLocation,
                                        name: name,
                                        email: email,
                                        shippingMethod: shippingMethod,
                                        currentPoint: currentPoint,
                                        onUpdateTotalPrice: (totalPrice) {
                                          setState(() {
                                            totalAmountFinal = totalPrice;
                                          });
                                        },
                                        onChangeValue: ({
                                          required String name,
                                          required String address,
                                          required String email,
                                          required String paymentMethod,
                                        }) {
                                          setState(() {
                                            this.name = name;
                                            this.address = address;
                                            this.email = email;
                                            this.paymentMethod = paymentMethod;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 64, vertical: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: OrderSummary(
                                        cartItems: cartItems,
                                        isLoading: isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Expanded(
                                      flex: 1,
                                      child: PaymentDetails(
                                        totalAmount: totalAmount,
                                        address: currentLocation,
                                        name: name,
                                        email: email,
                                        shippingMethod: shippingMethod,
                                        currentPoint: currentPoint,
                                        handleCreateOrder: () {
                                          handleCreateOrder();
                                        },
                                        onUpdateTotalPrice: (totalPrice) {
                                          setState(() {
                                            totalAmountFinal = totalPrice;
                                          });
                                        },
                                        onChangeValue: ({
                                          required String name,
                                          required String address,
                                          required String email,
                                          required String paymentMethod,
                                        }) {
                                          setState(() {
                                            this.name = name;
                                            this.address = address;
                                            this.email = email;
                                            this.paymentMethod = paymentMethod;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 24),
                        if (!isMobile) FooterWidget()
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: isMobile
          ? Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 28, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tổng tiền
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        formatMoney(totalAmountFinal),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Nút thanh toán
                  SizedBox(
                    height: 40,
                    child: MyButton(
                        text: 'Order Now',
                        fontSize: 16,
                        isLoading: isLoading,
                        onTap: (_) {
                          handleCreateOrder();
                        }),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
