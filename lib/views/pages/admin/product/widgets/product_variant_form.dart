import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProductVariantForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialProduct;
  final Map<String, dynamic>? initialVariant;

  const ProductVariantForm({
    super.key,
    required this.onSubmit,
    this.initialProduct,
    this.initialVariant,
  });

  @override
  State<ProductVariantForm> createState() => _ProductVariantFormState();
}

class _ProductVariantFormState extends State<ProductVariantForm> {
  late TextEditingController variantNameController;
  late TextEditingController variantColorController;
  late TextEditingController variantDescriptionController;
  late TextEditingController priceController;
  late TextEditingController discountController;
  late TextEditingController quantityController;
  List<dynamic> images = []; // Lưu trữ Uint8List, File, hoặc Map (từ API)
  bool isActive = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final initialVariant = widget.initialVariant;
    print('Initial variant: $initialVariant'); // Debug
    variantNameController = TextEditingController(text: initialVariant?['variantName'] ?? '');
    variantColorController = TextEditingController(text: initialVariant?['variantColor'] ?? '');
    variantDescriptionController = TextEditingController(text: initialVariant?['variantDescription'] ?? '');
    priceController = TextEditingController(text: initialVariant?['price']?.toString() ?? '');
    discountController = TextEditingController(text: initialVariant?['discount']?.toString() ?? '0');
    quantityController = TextEditingController(text: initialVariant?['quantity']?.toString() ?? '');
    isActive = initialVariant?['isActive'] ?? true;

    // Xử lý images từ initialVariant
    if (initialVariant?['images'] != null) {
      final imageList = initialVariant!['images'] as List;
      images = imageList.map((img) {
        if (img is Map<String, dynamic>) {
          return img; // Đã là Map từ API
        } else if (img is String) {
          return {'url': img, 'publicId': ''}; // Chỉ có URL (từ form trước đó)
        }
        return {'url': '', 'publicId': ''}; // Placeholder
      }).toList();
    }
  }

  Future<Map<String, String>> _uploadImage(dynamic image) async {
    // Giả lập API upload hình ảnh
    // Trong thực tế, gửi Uint8List hoặc File lên server và nhận về url/publicId
    await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian upload
    return {
      'url': 'https://example.com/uploaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      'publicId': 'uploaded_${DateTime.now().millisecondsSinceEpoch}'
    };
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        final uploadResult = await _uploadImage(bytes);
        setState(() {
          images.add(uploadResult); // Thêm Map với url và publicId
        });
      } else {
        final file = File(pickedFile.path);
        final uploadResult = await _uploadImage(file);
        setState(() {
          images.add(uploadResult); // Thêm Map với url và publicId
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: variantNameController,
              decoration: const InputDecoration(
                labelText: 'Variant Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: variantColorController,
              decoration: const InputDecoration(
                labelText: 'Variant Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: variantDescriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Variant Description *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Price *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: const InputDecoration(
                labelText: 'Discount (0 to 0.5)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final discount = double.tryParse(value) ?? 0;
                if (discount > 0.5) {
                  discountController.text = '0.5';
                  discountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: discountController.text.length),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Quantity *',
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.initialVariant != null && widget.initialVariant!['averageRating'] != null) ...[
              const SizedBox(height: 20),
              Text(
                'Average Rating: ${widget.initialVariant!['averageRating']}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Add Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (images.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Images',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...images.asMap().entries.map((entry) {
                    final index = entry.key;
                    final image = entry.value;
                    String? imageUrl;
                    if (image is Map<String, dynamic>) {
                      imageUrl = image['url'] as String?;
                    } else if (image is String) {
                      imageUrl = image;
                    }
                    return ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: imageUrl != null
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Image.network error: $error');
                            return const Text('Error');
                          },
                        )
                            : const Text('No Image'),
                      ),
                      title: Text('Image ${index + 1}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            images.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            Row(
              children: [
                Checkbox(
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value!),
                ),
                const Text('Active'),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (variantNameController.text.isEmpty ||
                      variantDescriptionController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      quantityController.text.isEmpty ||
                      images.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields')),
                    );
                    return;
                  }

                  final variantData = {
                    'product_id': widget.initialProduct?['_id'] ?? '',
                    'variantName': variantNameController.text,
                    'variantColor': variantColorController.text,
                    'variantDescription': variantDescriptionController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'discount': double.tryParse(discountController.text) ?? 0.0,
                    'quantity': int.tryParse(quantityController.text) ?? 0,
                    'images': images, // Đã là List<Map> với url và publicId
                    'isActive': isActive,
                    if (widget.initialVariant != null) 'averageRating': widget.initialVariant!['averageRating'],
                  };
                  print('Submitted variantData: $variantData'); // Debug
                  widget.onSubmit(variantData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(200, 48),
                ),
                child: const Text(
                  'Save Variant',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}