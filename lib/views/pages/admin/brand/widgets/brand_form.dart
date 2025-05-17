import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/provider/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool isActive = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialBrand;
    print('Initial brand: $data'); // Debug

    nameController = TextEditingController(text: data?['name'] ?? '');
    isActive = data?['isActive'] ?? true;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      isLoading = true;
    });

    try {
      final brandData = {
        'name': nameController.text,
        'isActive': isActive,
      };

      print('Brand data sent to API: $brandData'); // Debug

      Map<String, dynamic> result;
      if (widget.initialBrand == null) {
        result = await Provider.of<BrandProvider>(context, listen: false)
            .createBrand(brandData);
      } else {
        result = await Provider.of<BrandProvider>(context, listen: false)
            .updateBrand(widget.initialBrand!['_id'], brandData);
      }

      widget.onSubmit(result);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error submitting brand: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save brand: $e')),
      );
    }
  }

  Future<void> _handleDelete() async {
    if (widget.initialBrand == null || widget.onDelete == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await Provider.of<BrandProvider>(context, listen: false)
          .deleteBrand(widget.initialBrand!['_id']);
      widget.onDelete!();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error deleting brand: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete brand: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name',
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
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}