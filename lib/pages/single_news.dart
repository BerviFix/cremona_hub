import 'package:cremona_hub/main.dart';
import 'package:cremona_hub/models/single_news_model.dart';
import 'package:cremona_hub/repositories/news_single_prima_cremona_repository.dart';
import 'package:cremona_hub/repositories/news_single_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleNews extends StatefulWidget {
  const SingleNews({Key? key}) : super(key: key);

  @override
  _SingleNewsState createState() => _SingleNewsState();
}

class _SingleNewsState extends State<SingleNews> {
  final NewsSingleRepository singleNews = NewsSingleRepository();
  final NewsSinglePrimaCremonaRepository singleNewsPrimaCremona =
      NewsSinglePrimaCremonaRepository();
  late Future<SingleNewsModel> singleNewsFuture;
  late int newsID;
  late String source;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      newsID = args['newsID'];
      source = args['source'];
    }

    if (source == 'Cremona Oggi') {
      singleNewsFuture = singleNews.getSingleNews(newsID);
    } else if (source == 'Prima Cremona') {
      singleNewsFuture = singleNewsPrimaCremona.getSingleNews(newsID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: singleNewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                stripHtmlTags(
                  snapshot.data!.title,
                ),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.link_rounded),
                  onPressed: () async {
                    final Uri url = Uri.parse(snapshot.data!.url);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(stripHtmlTags(snapshot.data!.title),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: HtmlWidget(snapshot.data!.content),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
