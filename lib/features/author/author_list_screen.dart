import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prophetic_islam_admin/core/utils/app_utils.dart';
import 'package:prophetic_islam_admin/core/widgets/custom_network_image.dart';

class AuthorListScreen extends StatelessWidget {
  const AuthorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Author List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('authors').orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No authors found.'));
          }

          final authors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: authors.length,
            itemBuilder: (context, index) {
              final data = authors[index].data() as Map<String, dynamic>;
              final authorId = authors[index].id;

              return ListTile(
                leading: CircleAvatar(
                  child: CustomNetworkImage(imageUrl: AppUtils.getDirectImageUrlFromDrive(data['imageUrl']) ?? ""),
                ),
                title: Text(data['name']),
                subtitle: Text(data['speciality']),
                onTap: () {
                  // You can navigate to an author detail screen here
                },
              );
            },
          );
        },
      ),
    );
  }
}
