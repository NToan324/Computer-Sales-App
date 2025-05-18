import 'dart:io' show File;
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/provider/category_provider.dart';
import 'package:computer_sales_app/services/category.service.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function()? onDelete;
  final String buttonLabel;
  final Map<String, dynamic>? initialCategory;

  const CategoryForm({
    super.key,
    required this.onSubmit,
    this.onDelete,
    required this.buttonLabel,
    this.initialCategory,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController nameController;
  File? imageFile;
  Uint8List? imageBytes;
  Map<String, dynamic>? categoryImage;
  bool isActive = true;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    final data = widget.initialCategory;
    print('initState: initialCategory = $data');

    nameController = TextEditingController(text: data?['category_name']?.toString() ?? '');
    isActive = data?['isActive'] ?? true;

    if (data?['category_image'] != null && data!['category_image'] is Map<String, dynamic>) {
      final imageMap = data['category_image'] as Map<String, dynamic>;
      if (imageMap['url'] != null && imageMap['public_id'] != null) {
        categoryImage = imageMap;
        print('initState: categoryImage = $categoryImage');
      } else {
        print('initState: Invalid category_image format: $imageMap');
      }
    }
  }

  Future<Map<String, String>?> _uploadImage(dynamic image) async {
    try {
      final result = await _categoryService.uploadCategoryImage(image);
      print('uploadImage: result = $result');
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
            categoryImage = {
              'url': uploadResult['url'],
              'public_id': uploadResult['publicId'],
            };
            isLoading = false;
            print('pickImage: Web image uploaded, categoryImage = $categoryImage');
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
            categoryImage = {
              'url': uploadResult['url'],
              'public_id': uploadResult['publicId'],
            };
            isLoading = false;
            print('pickImage: Mobile image uploaded, categoryImage = $categoryImage');
          });
        } else {
          throw Exception('Upload failed. Please try again.');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('pickImage: Error = $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSubmit() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (nameController.text.trim().isEmpty) {
        throw Exception('Category name is required');
      }
      if (categoryImage == null || categoryImage!['url'] == null || categoryImage!['url'].isEmpty) {
        throw Exception('Please upload a valid category image');
      }
      if (!Uri.tryParse(categoryImage!['url'])!.isAbsolute) {
        throw Exception('Invalid image URL');
      }

      final categoryData = {
        'category_name': nameController.text.trim(),
        'isActive': isActive,
        'category_image': categoryImage,
      };

      print('handleSubmit: Sending categoryData = $categoryData');
      Map<String, dynamic> result;
      if (widget.initialCategory == null) {
        result = await Provider.of<CategoryProvider>(context, listen: false)
            .createCategory(categoryData);
      } else {
        final categoryId = widget.initialCategory!['_id']?.toString();
        if (categoryId == null || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(categoryId)) {
          throw Exception('Invalid category ID');
        }
        result = await Provider.of<CategoryProvider>(context, listen: false)
            .updateCategory(categoryId, categoryData);
      }

      print('handleSubmit: API response = $result');
      widget.onSubmit(result);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category saved successfully')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('handleSubmit: Error = $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save category: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  Future<void> _handleDelete() async {
    if (widget.initialCategory == null || widget.onDelete == null) return;

    final categoryId = widget.initialCategory!['_id']?.toString();
    if (categoryId == null || categoryId.isEmpty || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(categoryId)) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid category ID')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('handleDelete: Deleting category $categoryId');
      await _categoryService.deleteCategory(categoryId);
      widget.onDelete!();
      setState(() {
        isLoading = false;
      });
      print('handleDelete: Category deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('handleDelete: Error = $e');
      if (e.toString().contains('Danh mục không tồn tại')) {
        widget.onDelete!();
        print('handleDelete: Category $categoryId already deleted, treated as success');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
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
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: categoryImage != null && categoryImage!['url'] != null
                          ? Image.network(
                        categoryImage!['url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image.network error: $error');
                          return const Center(child: Text('Error Loading Image'));
                        },
                      )
                          : imageBytes != null
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
                          labelText: 'Category Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleSubmit,
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}