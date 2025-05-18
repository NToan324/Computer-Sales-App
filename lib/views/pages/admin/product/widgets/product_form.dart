import 'dart:io' show File;
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../helpers/formatMoney.dart';
import '../../../../../services/product.service.dart';
import 'product_variant_form.dart';

// Định nghĩa ProductImage class
class ProductImage {
  final String? url;
  final String? publicId;

  ProductImage({this.url, this.publicId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'public_id': publicId,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      url: map['url'] as String?,
      publicId: map['public_id'] as String?,
    );
  }
}

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
  late TextEditingController nameController;
  File? imageFile;
  Uint8List? imageBytes;
  ProductImage? productImage;
  String? selectedCategoryId;
  String? selectedBrandId;
  bool isDisabled = false;
  List<Map<String, dynamic>> variants = [];
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    final data = widget.initialProduct;

    nameController = TextEditingController(text: data?['product_name']?.toString() ?? '');
    selectedCategoryId = data?['category']?.toString();
    selectedBrandId = data?['brand']?.toString();
    isDisabled = data?['disabled']?.toString().toLowerCase() == 'true';

    if (data?['product_image'] != null) {
      productImage = ProductImage.fromMap(data!['product_image'] as Map<String, dynamic>);
    }

    if (data?['variants'] != null) {
      if (data?['variants'] is List<ProductModel>) {
        variants = (data?['variants'] as List<ProductModel>)
            .map((v) => v.toMap())
            .toList()
            .cast<Map<String, dynamic>>();
      } else if (data?['variants'] is List<Map<String, dynamic>>) {
        variants = List<Map<String, dynamic>>.from(data?['variants']);
      } else {
        variants = [];
      }
    } else {
      variants = [];
    }
  }

  Future<Map<String, String>?> _uploadImage(dynamic image) async {
    try {
      final result = await _productService.uploadProductImage(image);
      return result;
    } catch (e) {
      print('Upload image error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        final uploadResult = await _uploadImage(bytes);
        if (uploadResult != null && uploadResult['url'] != null && uploadResult['publicId'] != null) {
          setState(() {
            imageBytes = bytes;
            imageFile = null;
            productImage = ProductImage(
              url: uploadResult['url'],
              publicId: uploadResult['publicId'],
            );
            isLoading = false;
          });
        } else {
          throw Exception('Upload failed. Please try again.');
        }
      } else {
        final file = File(pickedFile.path);
        final uploadResult = await _uploadImage(file);
        if (uploadResult != null && uploadResult['url'] != null && uploadResult['publicId'] != null) {
          setState(() {
            imageFile = file;
            imageBytes = null;
            productImage = ProductImage(
              url: uploadResult['url'],
              publicId: uploadResult['publicId'],
            );
            isLoading = false;
          });
        } else {
          throw Exception('Upload failed. Please try again.');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAddProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (nameController.text.trim().isEmpty) {
        throw Exception('Product name is required');
      }
      if (selectedCategoryId == null ||
          selectedCategoryId!.trim().isEmpty ||
          !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(selectedCategoryId!.trim())) {
        throw Exception('Please select a valid category with a 24-character ID');
      }
      if (selectedBrandId == null ||
          selectedBrandId!.trim().isEmpty ||
          !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(selectedBrandId!.trim())) {
        throw Exception('Please select a valid brand with a 24-character ID');
      }
      if (productImage == null || productImage!.url == null || productImage!.url!.isEmpty) {
        throw Exception('Please upload a valid product image');
      }
      if (!Uri.tryParse(productImage!.url!)!.isAbsolute) {
        throw Exception('Invalid image URL');
      }

      final productData = {
        'product_name': nameController.text.trim(),
        'category_id': selectedCategoryId!.trim(),
        'brand_id': selectedBrandId!.trim(),
        'product_image': productImage!.toMap(),
      };

      final result = await _productService.createProduct(productData);

      widget.onSubmit(result);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error adding product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  Future<void> _handleUpdateProduct() async {
    if (widget.initialProduct == null) {
      print('handleUpdateProduct: initialProduct is null');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final productId = widget.initialProduct!['_id']?.toString();
      print('handleUpdateProduct: productId = $productId');
      if (productId == null || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(productId)) {
        throw Exception('Invalid product ID');
      }

      final productData = <String, dynamic>{};

      final productName = nameController.text.trim();
      if (productName.isNotEmpty) {
        productData['product_name'] = productName;
      }

      final categoryId = selectedCategoryId?.trim();
      if (categoryId != null && categoryId.isNotEmpty && RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(categoryId)) {
        productData['category_id'] = categoryId;
      }

      final brandId = selectedBrandId?.trim();
      if (brandId != null && brandId.isNotEmpty && RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(brandId)) {
        productData['brand_id'] = brandId;
      }

      if (productImage != null &&
          productImage!.url != null &&
          productImage!.url!.isNotEmpty &&
          Uri.tryParse(productImage!.url!)?.isAbsolute == true &&
          productImage!.publicId != null &&
          productImage!.publicId!.isNotEmpty) {
        productData['product_image'] = productImage!.toMap();
      }

      productData['isActive'] = !isDisabled;

      if (productData.isEmpty) {
        throw Exception('No valid data to update');
      }

      print('handleUpdateProduct: Sending productData = $productData');

      final result = await _productService.updateProduct(productId, productData);
      print('handleUpdateProduct: API response = $result');

      // Kiểm tra result trước khi gọi onSubmit
      if (result is! Map<String, dynamic>) {
        throw Exception('Invalid API response format');
      }
      print('handleUpdateProduct: Calling onSubmit with result = $result');
      widget.onSubmit(result);
      print('handleUpdateProduct: onSubmit completed');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('handleUpdateProduct: Error = $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: ${e.toString().replaceAll('Exception: ', '')}')),
      );
      rethrow; // Ném lại lỗi để debug dễ hơn
    }
  }
  Future<void> _handleDelete() async {
    if (widget.initialProduct == null || widget.onDelete == null) return;

    final productId = widget.initialProduct!['_id']?.toString();
    if (productId == null || productId.isEmpty || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(productId)) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid product ID')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('handleDelete: Deleting product $productId');
      await _productService.deleteProduct(productId);
      widget.onDelete!();
      setState(() {
        isLoading = false;
      });
      print('handleDelete: Product deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('handleDelete: Error = $e');
      if (e.toString().contains('Sản phẩm không tồn tại')) {
        // Product already deleted, treat as success
        widget.onDelete!();
        print('handleDelete: Product $productId already deleted, treated as success');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: $e')),
        );
      }
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
            onSubmit: (variantData) async {
              setState(() {
                if (index != null) {
                  variants[index] = variantData;
                } else {
                  variants.add(variantData);
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
    final productProvider = Provider.of<ProductProvider>(context);

    return SizedBox(
      width: 800,
      child: Stack(
        children: [
          Row(
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
                      child: productImage?.url != null
                          ? Image.network(
                        productImage!.url!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image.network error: $error');
                          return const Center(child: Text('Error Loading Image'));
                        },
                      )
                          : imageBytes != null && imageBytes is Uint8List
                          ? Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image.memory error: $error');
                          return const Center(child: Text('Error Loading Image'));
                        },
                      )
                          : imageFile != null && !kIsWeb
                          ? Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image.file error: $error');
                          return const Center(child: Text('Error Loading Image'));
                        },
                      )
                          : const Center(child: Text('No Image')),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : _pickImage,
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
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: double.infinity,
                                child: DropdownMenu<String>(
                                  width: constraints.maxWidth,
                                  initialSelection: selectedCategoryId,
                                  onSelected: (value) => setState(() => selectedCategoryId = value),
                                  dropdownMenuEntries: productProvider.categories
                                      .map((category) => DropdownMenuEntry(
                                    value: category.id,
                                    label: category.name,
                                  ))
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
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                            'Brand',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: double.infinity,
                                child: DropdownMenu<String>(
                                  width: constraints.maxWidth,
                                  initialSelection: selectedBrandId,
                                  onSelected: (value) => setState(() => selectedBrandId = value),
                                  dropdownMenuEntries: productProvider.brands
                                      .map((brand) => DropdownMenuEntry(
                                    value: brand.id,
                                    label: brand.name,
                                  ))
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
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              );
                            },
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
                      if (widget.initialProduct != null)
                        ElevatedButton(
                          onPressed: isLoading ? null : () => _showVariantForm(),
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
                              final imageList = variant['images'] as List<dynamic>?;
                              String? imageUrl;
                              if (imageList != null && imageList.isNotEmpty) {
                                final firstImage = imageList[0] as Map<String, dynamic>?;
                                imageUrl = firstImage != null ? firstImage['url'] as String? : null;
                              } else {
                                imageUrl = null;
                              }
                              return InkWell(
                                onTap: () => _showVariantForm(initialVariant: variant, index: index),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: imageUrl != null
                                        ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Image.network error: $error');
                                        return const Text('No Image');
                                      },
                                    )
                                        : const Text('No Image'),
                                  ),
                                  title: Text(variant['variantName']?.toString() ?? 'N/A'),
                                  subtitle: Text(
                                    'Color: ${variant['variantColor'] ?? 'N/A'}, Price: ${formatMoney(variant['price'] ?? 0)}, Quantity: ${variant['quantity']?.toString() ?? 'N/A'}, Rating: ${variant['averageRating']?.toString() ?? 'N/A'}',
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
                              onPressed: isLoading
                                  ? null
                                  : (widget.initialProduct == null ? _handleAddProduct : _handleUpdateProduct),
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
                                onPressed: isLoading ? null : _handleDelete,
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
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}