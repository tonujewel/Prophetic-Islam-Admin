import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prophetic_islam_admin/core/utils/app_utils.dart';
import '../waj/waz_list_by_author_screen.dart';
import 'add_author_screen.dart';

class AuthorListScreen extends StatelessWidget {
  const AuthorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Author List")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('authors').orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final authors = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: authors.length,
            itemBuilder: (context, index) {
              final data = authors[index].data() as Map<String, dynamic>;
              final authorId = authors[index].id;

              return Card(
                elevation: 2,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(AppUtils.getDirectImageUrlFromDrive(data['imageUrl']) ?? ""),
                    ),
                  ),
                  title: Text(data['name']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WazListByAuthorScreen(
                        authorId: authorId,
                        authorName: data['name'],
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddAuthorScreen(
                              authorId: authorId,
                              existingData: data,
                            ),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Delete Author?'),
                            content: Text('Are you sure you want to delete this author?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await FirebaseFirestore.instance.collection('authors').doc(authorId).delete();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddAuthorScreen()),
        ),
      ),
    );
  }
}
