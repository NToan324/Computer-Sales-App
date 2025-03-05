import 'package:flutter/material.dart';

class WebCartView extends StatelessWidget {
  const WebCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final List<Map<String, dynamic>> cartItems = [
    {
      "name": "Apple AirPods Pro",
      "price": 249.99,
      "image": "assets/airpods_pro.png"
    },
    {
      "name": "Apple AirPods Max",
      "price": 549.99,
      "image": "assets/airpods_max.png"
    },
    {
      "name": "Apple HomePod mini",
      "price": 99.99,
      "image": "assets/homepod_mini.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(0, (sum, item) => sum + item["price"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(cartItems[index]["image"], width: 50),
                  title: Text(cartItems[index]["name"]),
                  subtitle: Text("\$${cartItems[index]["price"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.remove), onPressed: () {}),
                      const Text("1"),
                      IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Promo Code",
                    suffixIcon: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Apply"),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal"),
                    Text("\$${subtotal.toStringAsFixed(2)}"),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {},
                  child: const Text("Continue to Checkout"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
