import 'package:flutter/cupertino.dart';

class Product{
  String id;
  String name;
  String description;
  num cost;
  Map<String, dynamic> pictures;
  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.cost,
    @required this.pictures
});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      name: json['Name'],
      description: json['Description'],
      cost: json['Cost'],
      pictures: json['Picture']
    );

}
}