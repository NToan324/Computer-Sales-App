import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:computer_sales_app/consts/app_colors.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBar.dart';
import 'package:computer_sales_app/utils/widget/button.dart';

class MobileCartView extends StatefulWidget {
  const MobileCartView({super.key});

  @override
  _MobileCartViewState createState() => _MobileCartViewState();
}

class _MobileCartViewState extends State<MobileCartView> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'Item 1',
      price: 10.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 4,
    ),
    CartItem(
      name: 'Item 2',
      price: 20.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 1,
    ),
    CartItem(
      name: 'Item 3',
      price: 30.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 3,
    ),
    CartItem(
      name: 'Item 4',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
    CartItem(
      name: 'Item 5',
      price: 50.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 6,
    ),
    CartItem(
      name: 'Item 6',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 6,
    ),
    CartItem(
      name: 'Item 7',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
    CartItem(
      name: 'Item 8',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
    CartItem(
      name: 'Item 9',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
    CartItem(
      name: 'Item 10',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
    CartItem(
      name: 'Item 11',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
    CartItem(
      name: 'Item 12',
      price: 40.0,
      image: Image.asset('assets/images/laptop_banner.jpg'),
      quantity: 5,
    ),
  ];

  final TextEditingController _promoCodeController = TextEditingController();

  int? _itemToRemove;
  int _quantityToRemove = 1;

  void _confirmRemoveItem(int index) {
    setState(() {
      _itemToRemove = index;
      _quantityToRemove = cartItems[index].quantity;
    });
  }

  void _removeItem() {
    if (_itemToRemove != null) {
      setState(() {
        final item = cartItems[_itemToRemove!];
        if (_quantityToRemove >= item.quantity) {
          cartItems.removeAt(_itemToRemove!);
        } else {
          cartItems[_itemToRemove!].quantity -= _quantityToRemove;
        }
        _itemToRemove = null;
      });
    }
  }

  void _cancelRemoveItem() {
    setState(() {
      _itemToRemove = null;
    });
  }

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  double get deliveryFee => 5.0; // Example delivery fee
  double _discount = 10.0;
  double get discount => _discount;
  set discount(double value) {
    setState(() {
      _discount = value;
    });
  }

  double get total => subtotal + deliveryFee - discount;

  void _applyPromoCode() {
    if (_promoCodeController.text == 'DISCOUNT') {
      discount = 20.0;
    } else {
      discount = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: const CustomAppBar(title: "My Cart"),
          body: Stack(
            children: <Widget>[
              Column(
                children: [
                  Expanded(
                    child: SlidableAutoCloseBehavior(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 400),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Slidable(
                            key: ValueKey(item.name),
                            closeOnScroll: true,
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    _confirmRemoveItem(index);
                                  },
                                  label: 'Delete',
                                  backgroundColor: AppColors.pink,
                                  foregroundColor: AppColors.red,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: CartItemWidget(
                              item: item,
                              onQuantityChanged: (quantity) {
                                setState(() {
                                  cartItems[index] = CartItem(
                                    name: item.name,
                                    price: item.price,
                                    image: item.image,
                                    quantity: quantity,
                                  );
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black,
                        offset: Offset(0, 5),
                        blurRadius: 20.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextField(
                          textAlign: TextAlign.start,
                          controller: _promoCodeController,
                          decoration: InputDecoration(
                            hintText: 'Promo Code',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            suffixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Button(
                                    text: "Apply", onPressed: _applyPromoCode)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSummaryRow('Subtotal', subtotal),
                      _buildSummaryRow('Delivery Fee', deliveryFee),
                      _buildSummaryRow('Discount', -discount),
                      const Divider(),
                      _buildSummaryRow('Total', total, isTotal: true),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Button(
                          onPressed: () {
                            // Checkout
                          },
                          text: 'Proceed to checkout',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_itemToRemove != null)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          ),
        if (_itemToRemove != null)
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Remove from cart?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: AppColors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    indent: 0,
                    endIndent: 0,
                    thickness: 1,
                  ),
                  const SizedBox(height: 5),
                  CartItemWidget(
                    item: cartItems[_itemToRemove!],
                    onQuantityChanged: (newQuantity) {
                      setState(() {
                        _quantityToRemove = newQuantity;
                      });
                    },
                    maxQuantity: cartItems[_itemToRemove!].quantity,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _cancelRemoveItem,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColors.lightGrey),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _removeItem,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColors.primary),
                          ),
                          child: const Text('Yes, Remove',
                              style: TextStyle(color: AppColors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  Image image;
  String name;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });
}

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;
  final int? maxQuantity;

  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
    this.maxQuantity,
  });

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuantity != oldWidget.initialQuantity) {
      setState(() {
        _quantity = widget.initialQuantity;
      });
    }
  }

  void _incrementQuantity() {
    if (widget.maxQuantity == null || _quantity < widget.maxQuantity!) {
      setState(() {
        _quantity++;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.remove, size: 16),
              onPressed: _decrementQuantity,
              padding: EdgeInsets.zero,
              color: AppColors.black,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: AppColors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.add, size: 16),
              onPressed: _incrementQuantity,
              color: AppColors.white,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final int? maxQuantity;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: item.image.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                    color: AppColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    color: AppColors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Spacer(),
            QuantitySelector(
              initialQuantity: item.quantity,
              onQuantityChanged: onQuantityChanged,
              maxQuantity: maxQuantity,
            ),
          ],
        ),
      ),
    );
  }
}
