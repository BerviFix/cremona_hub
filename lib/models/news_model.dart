import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import the necessary package

class NewsModel {
  String title;
  String content;
  String? image;
  String date;
  int id;

  NewsModel({
    required this.title,
    required this.content,
    required this.image,
    required this.date,
    required this.id,
  });

  factory NewsModel.fromJson(Map<String, dynamic> data) {
    final title = data['title']['rendered'];
    final content = data['content']['rendered'];
    final image = data['better_featured_image']['source_url'];
    final id = data['id'];
    final dateString = data['date_gmt'];
    final dateRaw = DateTime.tryParse(dateString) ?? DateTime.now();

    initializeDateFormatting('it_IT', null);

    final date =
        DateFormat('dd MMM yyyy HH:mm', 'it_IT').format(dateRaw).toString();

    return NewsModel(
        title: title, content: content, image: image, date: date, id: id);
  }
}
