class NewsModel {
  String title;
  String content;
  String? image;
  DateTime date;

  NewsModel({
    required this.title,
    required this.content,
    required this.image,
    required this.date,
  });

  factory NewsModel.fromJson(Map<String, dynamic> data) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    final image = data['better_featured_image']['source_url'];
    final dateString = data['date_gmt'];
    final date = DateTime.tryParse(dateString) ?? DateTime.now();

    return NewsModel(title: title, content: content, image: image, date: date);
  }
}
