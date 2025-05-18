import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/coupon.model.dart';

import '../services/coupon.service..dart';

class CouponProvider with ChangeNotifier {
  final CouponService _couponService = CouponService();
  List<CouponModel>? _coupons;
  CouponModel? _selectedCoupon;
  bool _isLoading = false;
  String? _errorMessage;

  List<CouponModel>? get coupons => _coupons;
  CouponModel? get selectedCoupon => _selectedCoupon;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Tạo mã phiếu giảm giá mới (ADMIN)
  Future<void> createCoupon({
    required String code,
    required double discountAmount,
    required int usageLimit,
    required bool isActive,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final couponData = {
        'code': code,
        'discount_amount': discountAmount,
        'usage_limit': usageLimit,
      };
      final newCoupon = await _couponService.createCoupon(couponData);
      _coupons = _coupons ?? [];
      _coupons!.add(newCoupon);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCoupon({
    required String code,
    required double discountAmount,
    required int usageLimit,
    required bool isActive,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final couponData = {
        'discount_amount': discountAmount,
        'usage_limit': usageLimit,
        'isActive': isActive,
      };
      final updatedCoupon = await _couponService.updateCoupon(code, couponData);
      if (_coupons != null) {
        final index = _coupons!.indexWhere((c) => c.code == code);
        if (index != -1) {
          _coupons![index] = updatedCoupon;
        }
      }
      if (_selectedCoupon?.code == code) {
        _selectedCoupon = updatedCoupon;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Lấy danh sách mã phiếu giảm giá (ADMIN)
  Future<void> loadCoupons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _coupons = await _couponService.getCoupons();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy chi tiết mã phiếu giảm giá theo code (USER)
  Future<void> getCouponByCode(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedCoupon = await _couponService.getCouponByCode(code);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy chi tiết mã phiếu giảm giá theo code (ADMIN)
  Future<void> getCouponByCodeAdmin(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedCoupon = await _couponService.getCouponByCodeAdmin(code);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa thông báo lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}