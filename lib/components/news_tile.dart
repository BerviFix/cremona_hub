import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NewsTile extends StatelessWidget {
  String title;
  String? image;

  NewsTile({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          image ?? 'Immagine non disponibile',
          width: 100,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      title: HtmlWidget(title),
    );
  }
}
