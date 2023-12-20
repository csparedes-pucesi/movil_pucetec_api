// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:movil_pucetec_api/models/category_model.dart';

List<ProductModel> welcomeFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String welcomeToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String id;
  String name;
  int unitPrice;
  String description;
  String presentation;
  Category category;

  ProductModel({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.description,
    required this.presentation,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        name: json["name"],
        unitPrice: json["unitPrice"],
        description: json["description"],
        presentation: json["presentation"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "unitPrice": unitPrice,
        "description": description,
        "presentation": presentation,
        "category": category.toJson(),
      };
}
