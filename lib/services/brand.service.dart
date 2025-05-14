import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class BrandService extends BaseClient {
  Future<List<BrandModel>> getBrands() async {
    final res = await get('brand');
    return (res['data']['brands'] as List<dynamic>)
        .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
