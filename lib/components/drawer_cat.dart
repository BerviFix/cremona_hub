import 'package:flutter/material.dart';
import 'package:cremona_hub/models/category_model.dart';

class DrawerCat extends StatelessWidget {
  final Future<List<CategoryModel>> categoriesListFuture;

  const DrawerCat({required this.categoriesListFuture, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: <Widget>[
        SizedBox(
          height: 70, // To change the height of DrawerHeader
          width: double.infinity, // To Change the width of DrawerHeader
          child: DrawerHeader(
            child: Image.asset(
              'assets/cremonahub4.png',
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            //return to home
            Navigator.pop(context);
          },
        ),
        FutureBuilder(
          future: categoriesListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _getLeading(snapshot.data![index].name),
                    title: Text(snapshot.data![index].name),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/archive_category',
                        arguments: {
                          'categoryID': snapshot.data![index].id,
                          'categoryName': snapshot.data![index].name,
                        },
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}

Icon? _getLeading(String title) {
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
