import 'package:computer_sales_app/models/coupon.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class CouponService extends BaseClient {
  // Tạo mã phiếu giảm giá mới (ADMIN)
  Future<CouponModel> createCoupon(Map<String, dynamic> couponData) async {
    try {
      final response = await post('coupon', couponData);
      if (response['statusCode'] != 200) {
        throw Exception(response['message'] ?? 'Failed to create coupon');
      }
      return CouponModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to create coupon: $e');
    }
  }

  // Cập nhật mã phiếu giảm giá (ADMIN)
  Future<CouponModel> updateCoupon(String code, Map<String, dynamic> couponData) async {
    try {
      final response = await put('coupon/$code', couponData);
      if (response['statusCode'] != 200) {
        throw Exception(response['message'] ?? 'Failed to update coupon');
      }
      return CouponModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update coupon: $e');
    }
  }

  // Lấy danh sách mã phiếu giảm giá (ADMIN)
  Future<List<CouponModel>> getCoupons() async {
    try {
      final response = await get('coupon');
      print('API Response: $response');
      if (response['status'] != 200) {
        throw Exception(response['message'] ?? 'Failed to fetch coupons');
      }
      final couponList = response['data']['data'] as List<dynamic>;
      return couponList
          .map((json) => CouponModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(' ');
    }
  }

  // Lấy chi tiết mã phiếu giảm giá theo code (USER hoặc không cần xác thực)
  Future<CouponModel> getCouponByCode(String code) async {
    try {
      final response = await get('coupon/$code'); // Reverted to '/coupon/$code'
      if (response['statusCode'] != 200 || response['data'].isEmpty) {
        return CouponModel(
          code: '',
          discountAmount: 0,
          usageCount: 0,
          usageLimit: 0,
          ordersUsed: [],
          isActive: false,
        );
      }
      return CouponModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch coupon: $e');
    }
  }

  // Lấy chi tiết mã phiếu giảm giá theo code (ADMIN)
  Future<CouponModel> getCouponByCodeAdmin(String code) async {
    try {
      final response = await get('coupon/admin/$code');
      if (response['statusCode'] != 200 || response['data'].isEmpty) {
        return CouponModel(
          code: '',
          discountAmount: 0,
          usageCount: 0,
          usageLimit: 0,
          ordersUsed: [],
          isActive: false,
        );
      }
      return CouponModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch coupon (admin): $e');
    }
  }
}