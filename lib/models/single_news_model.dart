class SingleNewsModel {
  String title;
  String content;
  String? image;
  String url;

  SingleNewsModel({
    required this.title,
    required this.content,
    required this.image,
    required this.url,
  });

  factory SingleNewsModel.fromJson(Map<String, dynamic> data) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    final image = data['better_featured_image']['source_url'];
    final url = data['link'];

    return SingleNewsModel(
        title: title, content: content, image: image, url: url);
  }

  factory SingleNewsModel.fromJsonPrimaCremona(Map<String, dynamic> data) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    const image =
        'https://img.freepik.com/premium-vector/photo-icon-picture-icon-image-sign-symbol-vector-illustration_64749-4409.jpg';
    final url = data['link'];

    return SingleNewsModel(
        title: title, content: content, image: image, url: url);
  }
}
