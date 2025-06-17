import 'package:flutter/material.dart';
import 'package:prophetic_islam_admin/features/author/author_list_screen.dart';

import '../author/add_author_screen.dart';
import '../waj/add_waz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waz Somogro Admin")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Author list"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AuthorListScreen()),
              ),
            ),
            ElevatedButton(
              child: Text("Add Author"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddAuthorScreen()),
              ),
            ),
            ElevatedButton(
              child: Text("Add Waz"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddWazScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
