import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prophetic_islam_admin/core/utils/app_utils.dart';
import 'package:prophetic_islam_admin/core/widgets/custom_network_image.dart';
import 'add_waz_screen.dart';

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
        stream: FirebaseFirestore.instance.collection('waz_somogro').where('authorId', isEqualTo: authorId).snapshots(),
        builder: (context, snapshot) {
          // 🔄 Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ❌ Show error if any
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          final wazList = snapshot.data?.docs ?? [];

          // 📭 No data found
          if (wazList.isEmpty) {
            return Center(child: Text('No Waz for this author.'));
          }

          // ✅ Show list
          return ListView.builder(
            itemCount: wazList.length,
            itemBuilder: (context, index) {
              final data = wazList[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text(
                  data['description'] ?? '',
                  maxLines: 2,
                ),
                leading: data['thumbnailUrl'] != null && data['thumbnailUrl'].toString().isNotEmpty
                    ? CustomNetworkImage(
                        imageUrl: AppUtils.getDirectImageUrlFromDrive(data['thumbnailUrl']) ?? "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.video_library, size: 40),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddWazScreen(
                            authorId: authorId,
                            authorName: authorName,
                            wazId: wazList[index].id,
                            existingData: data,
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Delete Waz?'),
                          content: Text('Are you sure you want to delete this waz?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await FirebaseFirestore.instance.collection('waz_somogro').doc(wazList[index].id).delete();
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
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
          MaterialPageRoute(
            builder: (_) => AddWazScreen(
              authorId: authorId,
              authorName: authorName,
            ),
          ),
        ),
      ),
    );
  }
}
