import 'package:intl/intl.dart';

String formatMoney(double amount) {
  final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
  return format.format(amount);
}

String formatDate(String date) {
  final format = DateFormat('dd/MM/yyyy');
  return format.format(DateTime.parse(date));
}

double parseMoney(String money) {
  return double.tryParse(money
          .replaceAll(',', '')
          .replaceAll('.', '')
          .replaceAll('VNĐ', '')) ??
      0;
}
