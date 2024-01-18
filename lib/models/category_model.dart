class CategoryModel {
  final String name;
  final int id;

  CategoryModel({required this.name, required this.id});

  factory CategoryModel.fromJson(Map<String, dynamic> data) {
    return CategoryModel(
      name: data['name'],
      id: data['id'],
    );
  }
}
