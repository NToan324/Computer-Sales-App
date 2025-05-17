import 'package:computer_sales_app/models/brand.model.dart';
import 'package:flutter/material.dart';

import '../services/brand.service.dart';

class BrandProvider with ChangeNotifier {
  List<BrandModel> brands = [];
  List<BrandModel> filteredBrands = [];
  final BrandService brandService = BrandService();

  List<BrandModel> getFilteredBrands() {
    return filteredBrands;
  }

  Future<void> fetchBrands() async {
    try {
      final response = await brandService.getBrands();
      brands = response;
      filteredBrands = response;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch brands: $e');
    }
  }

  Future<Map<String, dynamic>> createBrand(Map<String, dynamic> brandData) async {
    try {
      final newBrandData = await brandService.createBrand(brandData);
      final newBrand = BrandModel.fromJson(newBrandData);
      brands.add(newBrand);
      filteredBrands = brands;
      notifyListeners();
      return newBrandData;
    } catch (e) {
      throw Exception('Failed to create brand: $e');
    }
  }

  Future<Map<String, dynamic>> updateBrand(String id, Map<String, dynamic> brandData) async {
    try {
      final updatedBrandData = await brandService.updateBrand(id, brandData);
      final updatedBrand = BrandModel.fromJson(updatedBrandData);
      final index = brands.indexWhere((brand) => brand.id == id);
      if (index != -1) {
        brands[index] = updatedBrand;
        filteredBrands = brands;
        notifyListeners();
      }
      return updatedBrandData;
    } catch (e) {
      throw Exception('Failed to update brand: $e');
    }
  }

  Future<void> deleteBrand(String id) async {
    try {
      await brandService.deleteBrand(id);
      brands.removeWhere((brand) => brand.id == id);
      filteredBrands = brands;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete brand: $e');
    }
  }
}