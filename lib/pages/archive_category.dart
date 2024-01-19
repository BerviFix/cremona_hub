import 'package:flutter/material.dart';
import 'package:cremona_hub/components/news_tile.dart';
import 'package:cremona_hub/models/news_model.dart';
import 'package:cremona_hub/repositories/category_archive_repository.dart';

class ArchiveCategory extends StatefulWidget {
  const ArchiveCategory({Key? key}) : super(key: key);

  @override
  _ArchiveCategoryState createState() => _ArchiveCategoryState();
}

class _ArchiveCategoryState extends State<ArchiveCategory> {
  final CategoryArchiveRepository listNews = CategoryArchiveRepository();
  late Future<List<NewsModel>> newsListFuture;
  late int categoryID;
  late String categoryName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      categoryID = args['categoryID'];
      categoryName = args['categoryName'] as String;
    }

    newsListFuture = listNews.getNewsArchive(categoryID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.lime,
        scrolledUnderElevation: 10,
        title: Row(
          children: [
            _getIcon(categoryName) ?? const Text(''),
            const SizedBox(
                width: 8), // Aggiungi uno spazio tra l'icona e il testo
            Text(categoryName),
          ],
        ),
      ),
      body: FutureBuilder(
        future: newsListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data?.length ?? 0,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return NewsTile(
                  title: snapshot.data![index].title,
                  image: snapshot.data![index].image ?? '',
                  date: snapshot.data![index].date,
                );
              },
            );
          }
        },
      ),
    );
  }
}

Icon? _getIcon(String title) {
  final Map<String, IconData> categoryIcons = {
    'ambiente': Icons.eco,
    'cronaca': Icons.article,
    'cultura': Icons.book,
    'economia': Icons.euro,
    'elezioni': Icons.gavel,
    'chiesa': Icons.church,
    'cinema': Icons.movie,
    'mondo': Icons.public,
    'danza': Icons.sports_kabaddi,
    'eventi': Icons.event,
  };

  final lowercasedTitle = title.toLowerCase();

  for (var keyword in categoryIcons.keys) {
    if (lowercasedTitle.contains(keyword)) {
      return Icon(categoryIcons[keyword]);
    }
  }
  return null;
}
