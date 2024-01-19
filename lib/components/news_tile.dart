import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NewsTile extends StatelessWidget {
  String title;
  String? image;
  DateTime date;

  NewsTile(
      {required this.title, required this.image, required this.date, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              image ?? 'Immagine non disponibile',
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(title),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Chip(
              label: Text("${date.day}/${date.month}/${date.year}"),
              padding: const EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}
