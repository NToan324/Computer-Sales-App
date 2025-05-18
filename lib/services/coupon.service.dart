import 'package:computer_sales_app/models/coupon.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class CouponService extends BaseClient {
  //get coupons by code
  Future<CouponModel> getCouponByCode(String code) async {
    final response = await get('/coupon/$code');
    if (response['data'].isEmpty) {
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
  }
}
