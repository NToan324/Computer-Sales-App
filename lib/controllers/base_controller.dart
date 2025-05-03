import 'package:computer_sales_app/components/custom/dialog.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';

mixin BaseController {
  void handleError(error) {
    var message = error.message;
    if (error is BadRequestException) {
      //show dialog
      DialogHelper.showDialog(description: message);
    } else if (error is FetchDataException) {
      DialogHelper.showDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showDialog(description: 'Oops! Server is not responding');
    } else if (error is UnAuthorizedException) {
      DialogHelper.showDialog(description: 'Unauthorized');
    } else {}
  }
}
