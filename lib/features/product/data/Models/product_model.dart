class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  ProductModel({required this.id, required this.name, required this.price, required this.description, this.imageUrl = ''});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['ID'] ?? json['id'] ?? 0,
        name: json['name'] ?? '',
        price: double.tryParse((json['price'] ?? 0).toString()) ?? 0.0,
        description: json['description'] ?? '',
        imageUrl: json['image_url'] ?? '',
      );
}