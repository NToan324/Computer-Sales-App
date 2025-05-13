import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'product_variant_form.dart';

class ProductForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function()? onDelete;
  final String buttonLabel;
  final Map<String, dynamic>? initialProduct;

  const ProductForm({
    super.key,
    required this.onSubmit,
    this.onDelete,
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
  late TextEditingController descriptionController;
  File? imageFile;
  Uint8List? imageBytes;
  String productType = 'Laptop';
  String productBrand = 'Asus';
  bool isDisabled = false;
  List<Map<String, dynamic>> variants = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final data = widget.initialProduct;
    print('initialProduct: $data');

    codeController = TextEditingController(text: data?['code'] ?? '');
    nameController = TextEditingController(text: data?['name'] ?? '');
    stockController = TextEditingController(text: data?['stock']?.toString() ?? '');
    originalPriceController = TextEditingController(text: data?['originalPrice']?.toString() ?? '');
    sellingPriceController = TextEditingController(text: data?['sellingPrice']?.toString() ?? '');
    descriptionController = TextEditingController(text: data?['description'] ?? '');
    productType = data?['type'] ?? 'Laptop';
    productBrand = data?['brand'] ?? 'Asus';
    isDisabled = data?['disabled'] ?? false;
    variants = List<Map<String, dynamic>>.from(data?['variants'] ?? []);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          pickedFile.readAsBytes().then((bytes) {
            setState(() {
              imageBytes = bytes;
              imageFile = null;
            });
          });
        } else {
          imageFile = File(pickedFile.path);
          imageBytes = null;
        }
      });
    }
  }

  void _showVariantForm({Map<String, dynamic>? initialVariant, int? index}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            initialVariant == null ? 'Add Product Variant' : 'Edit Product Variant',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: ProductVariantForm(
            onSubmit: (variantData) {
              setState(() {
                if (index != null) {
                  variants[index] = variantData; // Cập nhật variant
                } else {
                  variants.add(variantData); // Thêm variant mới
                }
              });
              Navigator.of(context).pop();
            },
            initialProduct: widget.initialProduct,
            initialVariant: initialVariant,
          ),
        );
      },
    );
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
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Error Loading Image'));
                          },
                        )
                      : imageFile != null && !kIsWeb
                          ? Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Text('Error Loading Image'));
                              },
                            )
                          : const Center(child: Text('No Image')),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Choose Image',
                    style: TextStyle(color: Colors.white),
                  ),
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
                      labelText: 'Product Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Type',
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
                                  .map((type) => DropdownMenuEntry(value: type, label: type))
                                  .toList(),
                              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                              menuStyle: MenuStyle(
                                maximumSize: WidgetStatePropertyAll(
                                  Size(constraints.maxWidth, double.infinity),
                                ),
                                backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Brand',
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
                              dropdownMenuEntries: ['Asus', 'Dell', 'Lenovo', 'Logitech']
                                  .map((brand) => DropdownMenuEntry(value: brand, label: brand))
                                  .toList(),
                              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                              menuStyle: MenuStyle(
                                maximumSize: WidgetStatePropertyAll(
                                  Size(constraints.maxWidth, double.infinity),
                                ),
                                backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
                      labelText: 'Stock Quantity',
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
                            labelText: 'Original Price',
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
                            labelText: 'Selling Price',
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
                      const Text('Disable Product'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.initialProduct != null)
                    ElevatedButton(
                      onPressed: () => _showVariantForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(
                        'Add Variant',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (variants.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Variants',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...variants.asMap().entries.map((entry) {
                          final index = entry.key;
                          final variant = entry.value;
                          final image = variant['images']?.isNotEmpty == true ? variant['images'][0] : null;
                          return InkWell(
                            onTap: () => _showVariantForm(initialVariant: variant, index: index),
                            child: ListTile(
                              leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: image != null
                                    ? kIsWeb
                                        ? Image.memory(
                                            image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Text('No Image');
                                            },
                                          )
                                        : Image.file(
                                            image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Text('No Image');
                                            },
                                          )
                                    : const Text('No Image'),
                              ),
                              title: Text(variant['variant_name']),
                              subtitle: Text(
                                'Color: ${variant['variant_color'] ?? 'N/A'}, Price: ${variant['price']}, Quantity: ${variant['quantity']}, Rating: ${variant['avarage_rating'] ?? 'N/A'}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    variants.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
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
                              'image': kIsWeb ? imageBytes : imageFile,
                              'variants': variants,
                            };
                            widget.onSubmit(productData);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            widget.buttonLabel,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (widget.onDelete != null) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onDelete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ],
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