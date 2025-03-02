import 'package:computer_sales_app/controllers/base_controller.dart';
import 'package:computer_sales_app/services/base_client.dart';

class APIController with BaseController {
  void getApiData() async {
    var response = await BaseClient()
        .get('https://jsonplaceholder.typicode.com/', '/todos/1')
        .catchError(handleError);
    if (response == null) return;
  }
}
