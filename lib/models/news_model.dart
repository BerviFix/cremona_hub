import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewsModel {
  String title;
  String content;
  String? image;
  String date;
  int id;
  String? source;

  NewsModel({
    required this.title,
    required this.content,
    this.image,
    required this.date,
    required this.id,
    this.source,
  });

  factory NewsModel.fromJson(Map<String, dynamic> data, String? source) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    final image =
        data['better_featured_image']['source_url'] ?? 'https://is.gd/kPDB0f';
    final id = data['id'];
    final dateString = data['date_gmt'];
    final dateRaw = DateTime.tryParse(dateString) ?? DateTime.now();

    initializeDateFormatting('it_IT', null);

    final date =
        DateFormat('dd MMM yyyy HH:mm', 'it_IT').format(dateRaw).toString();

    return NewsModel(
        title: title,
        content: content,
        image: image,
        date: date,
        id: id,
        source: source);
  }

  factory NewsModel.fromJsonPrimaCremona(
      Map<String, dynamic> data, String? source, String imageUrl) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    final id = data['id'];
    final dateString = data['date_gmt'];
    final dateRaw = DateTime.tryParse(dateString) ?? DateTime.now();

    initializeDateFormatting('it_IT', null);

    final date =
        DateFormat('dd MMM yyyy HH:mm', 'it_IT').format(dateRaw).toString();

    return NewsModel(
        title: title,
        content: content,
        date: date,
        id: id,
        source: source,
        image: imageUrl);
  }
}
