enum PromotionType {
  percent,
  amount,
}

extension PromotionTypeExtension on PromotionType {
  dynamic getPromotionValue(double value) {
    switch (this) {
      case PromotionType.percent:
        return value / 100; 
      case PromotionType.amount:
        return '${value.toStringAsFixed(0)} VND'; 
    }
  }
}
