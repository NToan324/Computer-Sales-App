import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function()? onDelete; // Thêm hành động xóa
  final String buttonLabel;
  final Map<String, dynamic>? initialProduct;

  const ProductForm({
    super.key,
    required this.onSubmit,
    this.onDelete, // Optional delete function
    required this.buttonLabel,
    this.initialProduct,
  });

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
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imageUrlController.text.isEmpty
                      ? const Center(child: Text("No Image"))
                      : Image.network(
                        imageUrlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text("No Image"));
                        },
                      ),
                ),
                const SizedBox(height: 20),
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

          const SizedBox(width: 16),

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
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product Type Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Product Type",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: double.infinity,
                            child: DropdownMenu<String>(
                              width: constraints.maxWidth,
                              initialSelection: productType,
                              onSelected: (value) => setState(() => productType = value!),
                              dropdownMenuEntries: ['Laptop', 'Headphones', 'Smartphone', 'Mouse']
                                  .map((brand) => DropdownMenuEntry(value: brand, label: brand))
                                  .toList(),
                              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                              menuStyle: MenuStyle(
                                maximumSize: WidgetStatePropertyAll(
                                  Size(constraints.maxWidth, double.infinity),
                                ),
                                backgroundColor: WidgetStatePropertyAll(Colors.white),
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Product Brand Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Product Brand",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: double.infinity,
                            child: DropdownMenu<String>(
                              width: constraints.maxWidth,
                              initialSelection: productBrand,
                              onSelected: (value) => setState(() => productBrand = value!),
                              dropdownMenuEntries: ['Asus', 'Dell', 'Lenovo', 'Logitect']
                                  .map((brand) => DropdownMenuEntry(value: brand, label: brand))
                                  .toList(),
                              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                              menuStyle: MenuStyle(
                                maximumSize: WidgetStatePropertyAll(
                                  Size(constraints.maxWidth, double.infinity),
                                ),
                                backgroundColor: WidgetStatePropertyAll(Colors.white),
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "Stock Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: originalPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                          decoration: const InputDecoration(
                            labelText: "Original Price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: sellingPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: "Selling Price",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isDisabled,
                        onChanged: (value) => setState(() => isDisabled = value!),
                      ),
                      const Text("Disable Product"),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                    child: Text(widget.buttonLabel, style: TextStyle(color: Colors.white)),
                  ),
                  if (widget.onDelete != null) // Hiển thị nút "Delete" nếu có
                    ElevatedButton(
                      onPressed: widget.onDelete,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Delete", style: TextStyle(color: Colors.white)),
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
