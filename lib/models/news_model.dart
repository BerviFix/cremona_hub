class NewsModel {
  String title;
  String content;
  String? image;

  NewsModel({
    required this.title,
    required this.content,
    required this.image,
  });

  factory NewsModel.fromJson(Map<String, dynamic> data) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    final image = data['better_featured_image']['source_url'];

    return NewsModel(title: title, content: content, image: image);
  }
}
