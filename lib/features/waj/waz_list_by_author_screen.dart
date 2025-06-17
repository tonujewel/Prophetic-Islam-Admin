import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WazListByAuthorScreen extends StatelessWidget {
  final String authorId;
  final String authorName;

  const WazListByAuthorScreen({
    super.key,
    required this.authorId,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$authorName\'s Waz')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('waz_somogro')
            .where('authorId', isEqualTo: authorId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Waz found for this author.'));
          }

          final wazList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wazList.length,
            itemBuilder: (context, index) {
              final data = wazList[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title'] ?? 'Untitled'),
                subtitle: Text(data['description'] ?? ''),
                leading: data['thumbnailUrl'] != null && data['thumbnailUrl'] != ''
                    ? Image.network(data['thumbnailUrl'], width: 60, height: 60, fit: BoxFit.cover)
                    : Icon(Icons.video_library),
                onTap: () {
                  // Optional: Open YouTube URL if available
                  final url = data['youtubeUrl'];
                  if (url != null && url.isNotEmpty) {
                    // Use url_launcher to open in browser or in-app webview
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
