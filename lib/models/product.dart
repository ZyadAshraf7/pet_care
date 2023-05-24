class Product {
  String? name;
  // String? description;
  String? imageUrl;
  double? price;
  // int? quantity;

  Product(
      {this.name, this.imageUrl, this.price,});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // description = json['description'];
    imageUrl = json['imageUrl'];
    price = (json['price']as num).toDouble() ;
    // quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    // data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['price'] = this.price;
    // data['quantity'] = this.quantity;
    return data;
  }
}