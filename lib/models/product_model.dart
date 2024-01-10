import 'dart:convert';
import 'package:movil_pucetec_api/models/category_model.dart';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    final String? id;
    final String? name;
    final double? unitPrice;
    final String? description;
    final String? presentation;
    final CategoryModel? category;

    ProductModel({
        this.id,
        this.name,
        this.unitPrice,
        this.description,
        this.presentation,
        this.category,
    });

    // Método copyWith
    ProductModel copyWith({
      String? id,
      String? name,
      double? unitPrice,
      String? description,
      String? presentation,
      CategoryModel? category,
    }) {
      return ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        unitPrice: unitPrice ?? this.unitPrice,
        description: description ?? this.description,
        presentation: presentation ?? this.presentation,
        category: category ?? this.category,
      );
    }

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        name: json["name"],
        unitPrice: json["unitPrice"] is int
            ? (json["unitPrice"] as int).toDouble()
            : json["unitPrice"] as double?,
        description: json["description"],
        presentation: json["presentation"],
        category: json["category"] == null
            ? null
            : CategoryModel.fromJson(json["category"]),
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
