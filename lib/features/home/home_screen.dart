import 'package:flutter/material.dart';

import '../author/author_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waz Somogro")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AuthorListScreen()),
          ),
          child: Text("Author List"),
        ),
      ),
    );
  }
}
