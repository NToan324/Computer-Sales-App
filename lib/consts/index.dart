enum PromotionType {
  percent,
  amount,
}

enum RatingFilterValue {
  all,
  oneStar,
  twoStar,
  threeStar,
  fourStar,
  fiveStar,
}

extension RatingFilterValueExtension on RatingFilterValue {
  int? get value {
    switch (this) {
      case RatingFilterValue.all:
        return null;
      case RatingFilterValue.oneStar:
        return 1;
      case RatingFilterValue.twoStar:
        return 2;
      case RatingFilterValue.threeStar:
        return 3;
      case RatingFilterValue.fourStar:
        return 4;
      case RatingFilterValue.fiveStar:
        return 5;
    }
  }

  String get label {
    switch (this) {
      case RatingFilterValue.all:
        return 'All Ratings';
      case RatingFilterValue.oneStar:
        return '1 Star';
      case RatingFilterValue.twoStar:
        return '2 Stars';
      case RatingFilterValue.threeStar:
        return '3 Stars';
      case RatingFilterValue.fourStar:
        return '4 Stars';
      case RatingFilterValue.fiveStar:
        return '5 Stars';
    }
  }
}

// extension PromotionTypeExtension on PromotionType {
//   dynamic getPromotionValue(double value) {
//     switch (this) {
//       case PromotionType.percent:
//         return value / 100;
//       case PromotionType.amount:
//         return '${value.toStringAsFixed(0)} VND';
//     }
//   }
// }
