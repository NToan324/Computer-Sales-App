import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class CategoryService extends BaseClient {
  Future<List<CategoryModel>> getCategories() async {
    final res = await get('category');
    return (res['data'] as List<dynamic>)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
