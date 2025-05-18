import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/cart_item_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/promocode_section_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/remove_cart_widget.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

enum ShippingMethod {
  pickupAtStore,
  expressDelivery,
}

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  ShippingMethod _selectedMethod = ShippingMethod.expressDelivery;
  List<ProductModel> products = [];
  int? _itemToRemove;
  final int _quantityToRemove = 1;

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
          value: ShippingMethod.pickupAtStore,
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
          value: ShippingMethod.expressDelivery,
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
        activeColor: AppColors.primary,
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

  Widget _buildSummary(List<ProductForCartModel> cartItems) {
    double calculateSubTotal() {
      double subTotal = 0;
      for (var item in cartItems) {
        subTotal += item.unitPrice * item.quantity;
      }
      return subTotal;
    }

    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
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
          _buildRowWithLabel(
              label: 'Subtotal', value: formatMoney(calculateSubTotal())),
          _buildRowWithLabel(label: 'Shipping', value: formatMoney(0)),
          _buildRowWithLabel(label: 'Total', value: formatMoney(5000000)),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'payment', arguments: {
                  'cartItems': cartItems,
                  'shippingMethod': _selectedMethod.name,
                });
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
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      );
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).getCartByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final cartItems = cartProvider.cartItems;
        final isError = cartProvider.errorMessage;
        return Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBarMobile(
                title: 'My Cart',
                isBack: true,
              ),
              body: ListView(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: [
                            if (isError.isNotEmpty && cartItems.isEmpty)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/No_Internet.png', // Đường dẫn ảnh bạn muốn hiển thị
                                        width: 250, // Chiều rộng bạn muốn
                                        height: 250, // Chiều cao bạn muốn
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          'No internet connection. Please check your network settings.',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!Responsive.isMobile(context) &&
                                cartItems.isNotEmpty)
                              _buildHeaderRow(),
                            cartProvider.isLoading
                                ? ListView.builder(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return const SkeletonHorizontalProduct();
                                    })
                                : cartItems.isEmpty
                                    ? Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/NoItem.png',
                                            width: 400,
                                            height: 400,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              "You haven't placed any order yet",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: 150,
                                            child: MyButton(
                                              text: 'Order Now',
                                              onTap: (_) {
                                                Navigator.pushNamed(
                                                  context,
                                                  'product',
                                                  arguments: {
                                                    'showBackButton': true,
                                                  },
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    : SlidableAutoCloseBehavior(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 20),
                                          itemCount: cartItems.length,
                                          itemBuilder: (context, index) {
                                            final itemCart = cartItems[index];
                                            return Slidable(
                                              key: ValueKey(
                                                  itemCart.productVariantId),
                                              closeOnScroll: true,
                                              endActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  CustomSlidableAction(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    onPressed: (_) => {
                                                      cartProvider
                                                          .handleDeleteToCart(
                                                              itemCart
                                                                  .productVariantId),
                                                      showCustomSnackBar(
                                                          context,
                                                          'Delete product from cart successfully',
                                                          type: SnackBarType
                                                              .success)
                                                    },
                                                    backgroundColor:
                                                        AppColors.pink,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                            Icons
                                                                .delete_outline,
                                                            color:
                                                                AppColors.red,
                                                            size: 28),
                                                        Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.red,
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
                                                  itemCart: itemCart,
                                                  onQuantityChanged:
                                                      (quantity) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                            if (!Responsive.isMobile(context) &&
                                cartItems.isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 40),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: _buildShippingOptions(),
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: 250,
                                          child: _buildSummary(cartItems),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            if (!Responsive.isMobile(context)) FooterWidget()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar:
                  Responsive.isMobile(context) && cartItems.isNotEmpty
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
                removeItem: () {},
              ),
            ],
          ],
        );
      },
    );
  }
}
