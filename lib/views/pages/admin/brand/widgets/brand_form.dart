import 'dart:io' show File;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../services/brand.service.dart';

class BrandForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function()? onDelete;
  final String buttonLabel;
  final Map<String, dynamic>? initialBrand;

  const BrandForm({
    super.key,
    required this.onSubmit,
    this.onDelete,
    required this.buttonLabel,
    this.initialBrand,
  });

  @override
  State<BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends State<BrandForm> {
  late TextEditingController nameController;
  File? imageFile;
  Uint8List? imageBytes;
  Map<String, dynamic>? brandImage;
  bool isActive = true;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final BrandService _brandService = BrandService();

  @override
  void initState() {
    super.initState();
    final data = widget.initialBrand;
    print('initState: initialBrand = $data');

    // Initialize controllers and state
    nameController = TextEditingController(text: data?['brand_name']?.toString() ?? '');
    isActive = data?['isActive'] is bool ? data!['isActive'] : true;

    // Handle brand_image
    if (data?['brand_image'] != null && data!['brand_image'] is Map<String, dynamic>) {
      final imageMap = data['brand_image'] as Map<String, dynamic>;
      if (imageMap['url'] != null && imageMap['url'].toString().isNotEmpty) {
        brandImage = {
          'url': imageMap['url'].toString(),
          'public_id': imageMap['public_id']?.toString() ?? '',
        };
      } else {
        print('initState: Invalid brand_image, url is missing or empty: $imageMap');
      }
    } else {
      print('initState: brand_image is null or not a Map: ${data?['brand_image']}');
    }

    // Log initialized values for debugging
    print('initState: nameController.text = ${nameController.text}');
    print('initState: isActive = $isActive');
  }

  Future<Map<String, String>?> _uploadImage(dynamic image) async {
    try {
      final result = await _brandService.uploadBrandImage(image);
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
        if (uploadResult != null && uploadResult['url'] != null && uploadResult['url']!.isNotEmpty) {
          setState(() {
            imageBytes = bytes;
            imageFile = null;
            brandImage = {
              'url': uploadResult['url']!,
              'public_id': uploadResult['publicId'] ?? '',
            };
            isLoading = false;
            print('pickImage: Web image uploaded, brandImage = $brandImage');
          });
        } else {
          throw Exception('Upload failed. Please try again.');
        }
      } else {
        final file = File(pickedFile.path);
        final uploadResult = await _uploadImage(file);
        if (uploadResult != null && uploadResult['url'] != null && uploadResult['url']!.isNotEmpty) {
          setState(() {
            imageFile = file;
            imageBytes = null;
            brandImage = {
              'url': uploadResult['url']!,
              'public_id': uploadResult['publicId'] ?? '',
            };
            isLoading = false;
            print('pickImage: Mobile image uploaded, brandImage = $brandImage');
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
      // Validation
      final brandName = nameController.text.trim();
      if (brandName.isEmpty) {
        throw Exception('Tên thương hiệu không được để trống');
      }
      if (brandImage == null || brandImage!['url'] == null || brandImage!['url'].isEmpty) {
        throw Exception('URL hình ảnh không được để trống');
      }
      if (!Uri.tryParse(brandImage!['url'])!.isAbsolute) {
        throw Exception('URL hình ảnh không hợp lệ');
      }

      // Prepare brand data
      final brandData = {
        'brand_name': brandName,
        'brand_image': {
          'url': brandImage!['url'],
          'public_id': brandImage!['public_id'] ?? '',
        },
      };

      // Include isActive only for updates
      if (widget.initialBrand != null) {
        brandData['isActive'] = isActive;
      }

      print('handleSubmit: Sending brandData = $brandData');

      Map<String, dynamic> result;
      if (widget.initialBrand == null) {
        result = await _brandService.createBrand(brandData);
        print('handleSubmit: Create API response = $result');
      } else {
        final brandId = widget.initialBrand!['_id']?.toString();
        if (brandId == null || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(brandId)) {
          throw Exception('ID thương hiệu không hợp lệ');
        }
        result = await _brandService.updateBrand(brandId, brandData);
        print('handleSubmit: Update API response = $result');
      }

      // Validate result
      if (result is! Map<String, dynamic>) {
        throw Exception('Invalid API response format');
      }

      // Call onSubmit and show success message
      widget.onSubmit(result);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thương hiệu đã được lưu thành công')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('handleSubmit: Error = $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lưu thương hiệu thất bại: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    if (widget.initialBrand == null || widget.onDelete == null) return;

    final brandId = widget.initialBrand!['_id']?.toString();
    if (brandId == null || brandId.isEmpty || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(brandId)) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID thương hiệu không hợp lệ')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('handleDelete: Deleting brand $brandId');
      await _brandService.deleteBrand(brandId);
      widget.onDelete!();
      setState(() {
        isLoading = false;
      });
      print('handleDelete: Brand deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thương hiệu đã được xóa thành công')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('handleDelete: Error = $e');
      if (e.toString().contains('Thương hiệu không tồn tại')) {
        widget.onDelete!();
        print('handleDelete: Brand $brandId already deleted, treated as success');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thương hiệu đã được xóa thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thương hiệu thất bại: $e')),
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
                      child: brandImage != null && brandImage!['url'] != null && brandImage!['url'].isNotEmpty
                          ? Image.network(
                        brandImage!['url'],
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
                        'Chọn Hình Ảnh',
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
                          labelText: 'Tên Thương Hiệu',
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
                          const Text('Kích Hoạt'),
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
                                  'Xóa',
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