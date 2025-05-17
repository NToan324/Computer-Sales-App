import 'package:computer_sales_app/models/review.model.dart.dart';
import 'package:computer_sales_app/services/base_client.dart';

class ReviewService extends BaseClient {
  Future<Map<String, dynamic>> getAllReviews(
      {required String productVariantId, int page = 1, int limit = 10}) async {
    final res = await get(
        'product/variant/$productVariantId/reviews?page=$page&limit=$limit');
    if (res['data'].isEmpty) {
      return {
        'total': res['data']['total'],
        'totalPage': res['data']['totalPage'],
        'page': res['data']['page'],
        'limit': res['data']['limit'],
        'average_rating': res['data']['average_rating'],
        'review_count': res['data']['review_count'],
        'reviews_with_rating': res['data']['reviews_with_rating'],
        'data': res['data']['data'].map<ReviewModel>((review) {
          return ReviewModel.fromJson(review);
        }).toList(),
      };
    }
    return {
      'total': res['data']['total'],
      'totalPage': res['data']['totalPage'],
      'page': res['data']['page'],
      'limit': res['data']['limit'],
      'average_rating': res['data']['average_rating'],
      'review_count': res['data']['review_count'],
      'reviews_with_rating': res['data']['reviews_with_rating'],
      'data': res['data']['data'].map<ReviewModel>((review) {
        return ReviewModel.fromJson(review);
      }).toList(),
    };
  }
}
