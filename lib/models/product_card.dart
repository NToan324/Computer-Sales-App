class ProductCardPromotion {
  final String name;
  final String description;
  final double price;
  final String image;
  final double promotionValue;

  ProductCardPromotion(
      {required this.promotionValue,
      required this.name,
      required this.description,
      required this.price,
      required this.image});
}
