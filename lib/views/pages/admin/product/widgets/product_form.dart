import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final String buttonLabel;
  final Map<String, dynamic>? initialProduct;

  const ProductForm({
    Key? key,
    required this.onSubmit,
    required this.buttonLabel,
    this.initialProduct,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController originalPriceController;
  late TextEditingController sellingPriceController;
  late TextEditingController imageUrlController;
  late TextEditingController descriptionController;

  String productType = 'Laptop';
  String productBrand = 'Asus';
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialProduct;

    codeController = TextEditingController(text: data?['code'] ?? '');
    nameController = TextEditingController(text: data?['name'] ?? '');
    stockController = TextEditingController(text: data?['stock']?.toString() ?? '');
    originalPriceController = TextEditingController(text: data?['originalPrice']?.toString() ?? '');
    sellingPriceController = TextEditingController(text: data?['sellingPrice']?.toString() ?? '');
    imageUrlController = TextEditingController(text: data?['imageUrl'] ?? '');
    descriptionController = TextEditingController(text: data?['description'] ?? '');
    productType = data?['type'] ?? 'Laptop';
    productBrand = data?['brand'] ?? 'Asus';
    isDisabled = data?['disabled'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1/3 bên trái — hình ảnh + imageUrl
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imageUrlController.text.isEmpty
                      ? const Center(child: Text("No Image"))
                      : Image.network(imageUrlController.text, fit: BoxFit.cover),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          /// 2/3 bên phải — form sản phẩm
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: "Product Code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: productType,
                    items: ['Laptop', 'PC', 'Accessory'].map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) => setState(() => productType = value!),
                    decoration: const InputDecoration(
                      labelText: "Product Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: productBrand,
                    items: ['Asus', 'Dell', 'HP', 'Logitech'].map((brand) {
                      return DropdownMenuItem(value: brand, child: Text(brand));
                    }).toList(),
                    onChanged: (value) => setState(() => productBrand = value!),
                    decoration: const InputDecoration(
                      labelText: "Product Brand",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stock Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: originalPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Original Price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: sellingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Selling Price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: isDisabled,
                        onChanged: (value) => setState(() => isDisabled = value!),
                      ),
                      const Text("Disable Product"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Product Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final productData = {
                        'code': codeController.text,
                        'name': nameController.text,
                        'type': productType,
                        'brand': productBrand,
                        'stock': int.tryParse(stockController.text) ?? 0,
                        'originalPrice': double.tryParse(originalPriceController.text) ?? 0.0,
                        'sellingPrice': double.tryParse(sellingPriceController.text) ?? 0.0,
                        'disabled': isDisabled,
                        'description': descriptionController.text,
                        'imageUrl': imageUrlController.text,
                      };
                      widget.onSubmit(productData);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(widget.buttonLabel),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
