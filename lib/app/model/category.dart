
class CategoryModel {
    int id;
    String name;
    String imageUrl;
    String desc;

    CategoryModel({
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.desc,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        imageUrl: json["imageURL"] ?? "",
        desc: json["description"] ?? "",
    );
}
