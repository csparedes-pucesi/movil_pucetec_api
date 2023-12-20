import 'dart:convert';
import 'package:movil_pucetec_api/model/category_model.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final String? id;
  final String? name;
  final int? unitPrice;
  final String? description;
  final String? presentation;
  final Category? category;

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
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "unitPrice": unitPrice,
        "description": description,
        "presentation": presentation,
        "category": category?.toJson(),
      };
}
