import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWazScreen extends StatefulWidget {
  const AddWazScreen({super.key});

  @override
  _AddWazScreenState createState() => _AddWazScreenState();
}

class _AddWazScreenState extends State<AddWazScreen> {
  final _titleController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? selectedAuthorId;
  List<DropdownMenuItem<String>> authorDropdownItems = [];

  @override
  void initState() {
    super.initState();
    fetchAuthors();
  }

  Future<void> fetchAuthors() async {
    final snapshot = await FirebaseFirestore.instance.collection('authors').get();
    final items = snapshot.docs
        .map((doc) => DropdownMenuItem<String>(
              value: doc.id,
              child: Text(doc['name']),
            ))
        .toList();
    setState(() {
      authorDropdownItems = items;
    });
  }

  Future<void> _submitWaz() async {
    if (selectedAuthorId == null || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Title and Author are required.')));
      return;
    }

    await FirebaseFirestore.instance.collection('waz_somogro').add({
      'title': _titleController.text.trim(),
      'authorId': selectedAuthorId,
      'youtubeUrl': _youtubeUrlController.text.trim(),
      'thumbnailUrl': _thumbnailUrlController.text.trim(),
      'description': _descriptionController.text.trim(),
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Waz Added')));
    _titleController.clear();
    _youtubeUrlController.clear();
    _thumbnailUrlController.clear();
    _descriptionController.clear();
    setState(() => selectedAuthorId = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Waz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: selectedAuthorId,
              items: authorDropdownItems,
              onChanged: (value) => setState(() => selectedAuthorId = value),
              decoration: InputDecoration(labelText: 'Select Author'),
            ),
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Waz Title')),
            TextField(
                controller: _youtubeUrlController, decoration: InputDecoration(labelText: 'YouTube URL (optional)')),
            TextField(
                controller: _thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL (optional)')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submitWaz, child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
