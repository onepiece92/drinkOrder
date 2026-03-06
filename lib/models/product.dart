/// Product data model for the Liquid Gold app.
class Product {
  final int id;
  final String name;
  final String sub;
  final String category;
  final double price;
  final String vol;
  final String abv;
  final String age;
  final double rating;
  final int reviews;
  final String image; // emoji or asset path
  final String? badge;
  final String description;
  final List<String> tags;
  final String time;

  const Product({
    required this.id,
    required this.name,
    required this.sub,
    required this.category,
    required this.price,
    required this.vol,
    required this.abv,
    required this.age,
    required this.rating,
    required this.reviews,
    required this.image,
    this.badge,
    required this.description,
    required this.tags,
    required this.time,
  });
}
