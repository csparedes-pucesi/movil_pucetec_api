class CategoryModel {
    final String? id;
    final String? name;
    final String? description;

    CategoryModel({
        this.id,
        this.name,
        this.description,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
    };
}