import 'package:flutter/material.dart';
import 'package:cremona_hub/pages/archive_category.dart';
import 'package:cremona_hub/pages/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lime,
        ),
        useMaterial3: true,
      ),
      home: const NewsListScreen(),
      routes: {
        '/home': (context) => const NewsListScreen(),
        '/archive_category': (context) => const ArchiveCategory(),
      },
    );
  }
}
