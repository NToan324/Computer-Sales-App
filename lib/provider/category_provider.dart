import 'package:computer_sales_app/models/category.model.dart';
import 'package:flutter/material.dart';

import '../services/category.service.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categories = [];
  List<CategoryModel> filteredCategories = [];
  List<String> filters = [];
  String? searchQuery;

  final CategoryService categoryService = CategoryService();

  // Lấy danh sách tất cả danh mục
  Future<void> fetchCategories() async {
    try {
      final response = await categoryService.getCategories();
      categories = response;
      filteredCategories = response; // Ban đầu, danh sách lọc giống danh sách gốc
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Tìm kiếm danh mục theo tên
  Future<void> searchCategories(String query) async {
    try {
      if (query.isEmpty) {
        filteredCategories = categories; // Nếu không có query, trả về danh sách gốc
      } else {
        final response = await categoryService.searchCategories(query);
        filteredCategories = response;
      }
      searchQuery = query;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to search categories: $e');
    }
  }

  // Lọc danh mục (ví dụ: theo trạng thái isActive)
  Future<void> applyFilters({bool? isActive}) async {
    try {
      filteredCategories = categories.where((category) {
        bool matches = true;
        if (isActive != null) {
          matches = matches && category.isActive == isActive;
        }
        return matches;
      }).toList();

      // Cập nhật danh sách bộ lọc hiển thị
      final Set<String> combined = {
        if (isActive != null) isActive ? 'Active' : 'Inactive',
      };
      updateFilters(combined.toList());
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to apply filters: $e');
    }
  }

  // Xóa bộ lọc
  Future<void> clearFilters() async {
    filters.clear();
    filteredCategories = categories;
    notifyListeners();
  }

  // Xóa bộ lọc theo tên
  Future<void> removeFilterByName(String name) async {
    filters.removeWhere((item) => item == name);
    // Cập nhật lại danh sách lọc
    await applyFilters(
      isActive: filters.contains('Active') ? true : filters.contains('Inactive') ? false : null,
    );
  }

  // Cập nhật danh sách bộ lọc
  void updateFilters(List<String> newFilters) {
    filters = newFilters;
    notifyListeners();
  }

// Tạo danh mục mới
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final newCategoryData = await categoryService.createCategory(categoryData);
      final newCategory = CategoryModel.fromMap(newCategoryData);
      categories.add(newCategory);
      filteredCategories = categories; // Cập nhật danh sách hiển thị
      notifyListeners();
      return newCategoryData; // Return the created category data
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  // Cập nhật danh mục
  Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> categoryData) async {
    try {
      final updatedCategoryData = await categoryService.updateCategory(id, categoryData);
      final updatedCategory = CategoryModel.fromMap(updatedCategoryData);
      final index = categories.indexWhere((category) => category.id == id);
      if (index != -1) {
        categories[index] = updatedCategory;
        filteredCategories = categories; // Cập nhật danh sách hiển thị
        notifyListeners();
      }
      return updatedCategoryData; // Return the updated category data
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(String id) async {
    try {
      await categoryService.deleteCategory(id);
      categories.removeWhere((category) => category.id == id);
      filteredCategories = categories; // Cập nhật danh sách hiển thị
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // Upload ảnh danh mục
  Future<Map<String, String>> uploadCategoryImage(dynamic image) async {
    try {
      final result = await categoryService.uploadCategoryImage(image);
      notifyListeners();
      return result;
    } catch (e) {
      throw Exception('Failed to upload category image: $e');
    }
  }

  // Lấy danh mục theo ID
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final categoryData = await categoryService.getCategoryById(id);
      return CategoryModel.fromMap(categoryData);
    } catch (e) {
      throw Exception('Failed to fetch category by ID: $e');
    }
  }

  // Getter cho danh sách danh mục đã lọc
  List<CategoryModel> getFilteredCategories() {
    return filteredCategories;
  }

  // Getter cho danh sách danh mục gốc
  List<CategoryModel> getCategories() {
    return categories;
  }

  // Cập nhật danh sách danh mục
  void setCategories(List<CategoryModel> newCategories) {
    categories = newCategories;
    filteredCategories = newCategories;
    notifyListeners();
  }
}