import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/item_cart.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/cart_item_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/promocode_section_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/remove_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';

class MobileCartView extends StatefulWidget {
  const MobileCartView({super.key});

  @override
  _MobileCartViewState createState() => _MobileCartViewState();
}

class _MobileCartViewState extends State<MobileCartView> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'Item 1',
      price: 10000000.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 4,
    ),
    CartItem(
      name: 'Item 2',
      price: 20.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 1,
    ),
    CartItem(
      name: 'Item 3',
      price: 30.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 3,
    ),
    CartItem(
      name: 'Item 4',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
    CartItem(
      name: 'Item 5',
      price: 50.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 6,
    ),
    CartItem(
      name: 'Item 6',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 6,
    ),
    CartItem(
      name: 'Item 7',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
    CartItem(
      name: 'Item 8',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
    CartItem(
      name: 'Item 9',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
    CartItem(
      name: 'Item 10',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
    CartItem(
      name: 'Item 11',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
    CartItem(
      name: 'Item 12',
      price: 40.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 5,
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: const CustomAppBarMobile(
            title: "Cart",
          ),
          body: Container(
            color: AppColors.gray,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: SlidableAutoCloseBehavior(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 400),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Slidable(
                                key: ValueKey(item.name),
                                closeOnScroll: true,
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    CustomSlidableAction(
                                      borderRadius: BorderRadius.circular(16),
                                      onPressed: (context) {
                                        _confirmRemoveItem(index);
                                      },
                                      backgroundColor: AppColors.pink,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.delete_outline,
                                            color: AppColors.red,
                                            size: 28,
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyle(
                                                color: AppColors.red,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                child: CartItemWidget(
                                  item: item,
                                  onQuantityChanged: (quantity) {
                                    setState(
                                      () {
                                        cartItems[index] = CartItem(
                                          name: item.name,
                                          price: item.price,
                                          image: item.image,
                                          quantity: quantity,
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 30, left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(95, 0, 0, 0),
                          offset: Offset(0, 5),
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                    child: PromocodeSectionWidget(
                      cartItems: cartItems,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_itemToRemove != null)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          ),
        if (_itemToRemove != null)
          RemoveCartWidget(
            cartItems: cartItems,
            itemToRemove: _itemToRemove,
            cancelRemoveItem: _cancelRemoveItem,
            quantityToRemove: _quantityToRemove,
            removeItem: _removeItem,
          )
      ],
    );
  }
}
