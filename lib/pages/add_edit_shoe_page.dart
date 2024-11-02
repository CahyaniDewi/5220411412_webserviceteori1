import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEditShoePage extends StatefulWidget {
  final Map? shoe;

  AddEditShoePage({this.shoe});

  @override
  _AddEditShoePageState createState() => _AddEditShoePageState();
}

class _AddEditShoePageState extends State<AddEditShoePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.shoe != null) {
      _titleController.text = widget.shoe!['title'];
      _bodyController.text = widget.shoe!['body'];
    }
  }

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final isUpdating = widget.shoe != null;
      final url = isUpdating
          ? 'https://jsonplaceholder.typicode.com/posts/${widget.shoe!['id']}'
          : 'https://jsonplaceholder.typicode.com/posts';

      final response = await (isUpdating
          ? http.put(
              Uri.parse(url),
              body: json.encode({
                'id': widget.shoe!['id'], 
                'title': _titleController.text,
                'body': _bodyController.text,
                'userId': 1,
              }),
              headers: {'Content-Type': 'application/json'},
            )
          : http.post(
              Uri.parse(url),
              body: json.encode({
                'title': _titleController.text,
                'body': _bodyController.text,
                'userId': 1,
              }),
              headers: {'Content-Type': 'application/json'},
            ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newShoe = {
          'id': isUpdating ? widget.shoe!['id'] : json.decode(response.body)['id'],
          'title': _titleController.text,
          'body': _bodyController.text,
        };
        Navigator.pop(context, newShoe); // Kembalikan data sepatu yang diperbarui
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data!')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoe != null ? 'Edit Catatan' : 'Tambah Catatan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nama Sepatu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Sepatu harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitData,
                      child: Text(widget.shoe != null ? 'Update' : 'Tambah'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
