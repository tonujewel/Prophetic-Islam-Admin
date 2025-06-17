import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAuthorScreen extends StatefulWidget {
  const AddAuthorScreen({super.key});

  @override
  _AddAuthorScreenState createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _specialityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Future<void> _submitAuthor() async {
    final name = _nameController.text.trim();
    final bio = _bioController.text.trim();
    final speciality = _specialityController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if ([name, bio, speciality, imageUrl].any((v) => v.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required.')));
      return;
    }

    await FirebaseFirestore.instance.collection('authors').add({
      'name': name,
      'bio': bio,
      'speciality': speciality,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Author Added')));
    _nameController.clear();
    _bioController.clear();
    _specialityController.clear();
    _imageUrlController.clear();
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
