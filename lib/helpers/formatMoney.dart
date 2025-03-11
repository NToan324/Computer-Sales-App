import 'package:intl/intl.dart';

String formatMoney(double amount) {
  final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
  return format.format(amount);
}
