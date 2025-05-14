import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/cart_item_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/promocode_section_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/remove_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

enum ShippingMethod { standard, express }

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  ShippingMethod _selectedMethod = ShippingMethod.standard;
  List<ProductModel> products = [];

  List<CartItem> cartItems = [];

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

  Widget _buildHeaderRow() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('PRODUCT', style: _headerTextStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text('QUANTITY', style: _headerTextStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text('TOTAL',
                      textAlign: TextAlign.start, style: _headerTextStyle()),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.black12,
          height: 40,
        ),
      ],
    );
  }

  TextStyle _headerTextStyle() {
    return const TextStyle(
      fontSize: 14,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildShippingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose shipping mode',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        _buildRadioTile(
          value: ShippingMethod.standard,
          title: Row(
            children: const [
              Text('Store pickup (In 20 min)',
                  style: TextStyle(fontSize: 12, color: Colors.black)),
              SizedBox(width: 10),
              Icon(Icons.circle, color: Colors.black54, size: 10),
              SizedBox(width: 5),
              Text(
                'FREE',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        _buildRadioTile(
          value: ShippingMethod.express,
          title: const Text('Delivery at home (Under 2 - 4 days)',
              style: TextStyle(fontSize: 12, color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildRadioTile(
      {required ShippingMethod value, required Widget title}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Radio<ShippingMethod>(
        value: value,
        groupValue: _selectedMethod,
        onChanged: (ShippingMethod? newValue) {
          setState(() {
            _selectedMethod = newValue!;
          });
        },
      ),
      title: title,
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRowWithLabel(
          label: 'Voucher',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 222, 255, 222),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Shipping Free',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 0, 69, 23),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.black, size: 14),
            ],
          ),
        ),
        _buildRowWithLabel(label: 'Subtotal', value: formatMoney(5000000)),
        _buildRowWithLabel(label: 'Shipping', value: 'FREE'),
        _buildRowWithLabel(label: 'Total', value: formatMoney(5000000)),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'payment');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Checkout',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRowWithLabel(
      {required String label, Widget? child, String? value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          child ??
              Text(
                value ?? '',
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    products = Provider.of<ProductProvider>(context).products;
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarMobile(
            title: 'My Cart',
            isBack: true,
          ),
          body: ListView(children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: [
                      if (!Responsive.isMobile(context)) _buildHeaderRow(),
                      Container(
                        color: Colors.white,
                        child: SlidableAutoCloseBehavior(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Slidable(
                                key: ValueKey(item.productVariantId),
                                closeOnScroll: true,
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    CustomSlidableAction(
                                      borderRadius: BorderRadius.circular(16),
                                      onPressed: (_) =>
                                          _confirmRemoveItem(index),
                                      backgroundColor: AppColors.pink,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.delete_outline,
                                              color: AppColors.red, size: 28),
                                          Text(
                                            'Remove',
                                            style: TextStyle(
                                              color: AppColors.red,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CartItemWidget(
                                    item: item,
                                    onQuantityChanged: (quantity) {
                                      setState(() {
                                        cartItems[index] = CartItem(
                                          productVariantId:
                                              item.productVariantId,
                                          unitPrice: item.unitPrice,
                                          quantity: item.quantity,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (!Responsive.isMobile(context))
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 900,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: _buildShippingOptions(),
                                ),
                                Flexible(
                                  child: SizedBox(
                                    width: 250,
                                    child: _buildSummary(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!Responsive.isMobile(context)) FooterWidget()
                    ],
                  ),
                ],
              ),
            ),
          ]),
          bottomNavigationBar: Responsive.isMobile(context)
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 28),
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
                  child: PromocodeSectionWidget(cartItems: cartItems),
                )
              : null,
        ),
        if (_itemToRemove != null) ...[
          Positioned.fill(child: Container(color: Colors.black54)),
          RemoveCartWidget(
            cartItems: cartItems,
            itemToRemove: _itemToRemove,
            cancelRemoveItem: _cancelRemoveItem,
            quantityToRemove: _quantityToRemove,
            removeItem: _removeItem,
          ),
        ],
      ],
    );
  }
}
