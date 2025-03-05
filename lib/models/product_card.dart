class ProductPromotion {
  String name;
  String description;
  double price;
  double discount;
  String imageUrl;
  String category;

  // Constructor
  ProductPromotion({
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.imageUrl,
    required this.category,
  });

  double getDiscountedPrice() {
    return price - (price * (discount / 100));
  }
}
