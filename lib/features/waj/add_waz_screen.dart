import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWazScreen extends StatefulWidget {
  final String authorId;
  final String authorName;
  final String? wazId;
  final Map<String, dynamic>? existingData;

  const AddWazScreen({
    super.key,
    required this.authorId,
    required this.authorName,
    this.wazId,
    this.existingData,
  });

  @override
  State<AddWazScreen> createState() => _AddWazScreenState();
}

class _AddWazScreenState extends State<AddWazScreen> {
  final _titleController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _titleController.text = widget.existingData!['title'] ?? '';
      _youtubeUrlController.text = widget.existingData!['youtubeUrl'] ?? '';
      _thumbnailUrlController.text = widget.existingData!['thumbnailUrl'] ?? '';
      _descriptionController.text = widget.existingData!['description'] ?? '';
    }
  }

Future<void> _submitWaz() async {
  final data = {
    'title': _titleController.text.trim(),
    'authorId': widget.authorId,
    'youtubeUrl': _youtubeUrlController.text.trim(),
    'thumbnailUrl': _thumbnailUrlController.text.trim(),
    'description': _descriptionController.text.trim(),
    'createdAt': Timestamp.now(),
  };

  if (widget.wazId != null) {
    await FirebaseFirestore.instance.collection('waz_somogro').doc(widget.wazId).update(data);
  } else {
    await FirebaseFirestore.instance.collection('waz_somogro').add(data);
  }

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Waz - ${widget.authorName}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: _youtubeUrlController, decoration: InputDecoration(labelText: 'YouTube Link (optional)')),
            TextField(
                controller: _thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL (optional)')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submitWaz, child: Text('Add Waz')),
          ],
        ),
      ),
    );
  }
}
