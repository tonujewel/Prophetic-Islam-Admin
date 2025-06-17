import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAuthorScreen extends StatefulWidget {
  final String? authorId;
  final Map<String, dynamic>? existingData;

  const AddAuthorScreen({super.key, this.authorId, this.existingData});

  @override
  _AddAuthorScreenState createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _specialityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _nameController.text = widget.existingData!['name'];
      _bioController.text = widget.existingData!['bio'];
      _specialityController.text = widget.existingData!['speciality'];
      _imageUrlController.text = widget.existingData!['imageUrl'];
    }
  }

  Future<void> _submitAuthor() async {
    final data = {
      'name': _nameController.text.trim(),
      'bio': _bioController.text.trim(),
      'speciality': _specialityController.text.trim(),
      'imageUrl': _imageUrlController.text.trim(),
    };

    if (widget.authorId != null) {
      // Edit
      await FirebaseFirestore.instance.collection('authors').doc(widget.authorId).update(data);
    } else {
      // Add
      await FirebaseFirestore.instance.collection('authors').add(data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Author")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _bioController, decoration: InputDecoration(labelText: 'Bio')),
            TextField(controller: _specialityController, decoration: InputDecoration(labelText: 'Speciality')),
            TextField(controller: _imageUrlController, decoration: InputDecoration(labelText: 'Image URL')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submitAuthor, child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
