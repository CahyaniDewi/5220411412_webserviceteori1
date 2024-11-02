import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_edit_shoe_page.dart';

class ShoeListPage extends StatefulWidget {
  @override
  _ShoeListPageState createState() => _ShoeListPageState();
}

class _ShoeListPageState extends State<ShoeListPage> {
  List shoes = [];

  @override
  void initState() {
    super.initState();
    fetchShoes();
  }

  Future<void> fetchShoes() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      setState(() {
        shoes = json.decode(response.body);
      });
    }
  }

  Future<void> deleteShoe(int id) async {
    final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));
    if (response.statusCode == 200) {
      setState(() {
        shoes.removeWhere((shoe) => shoe['id'] == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Sepatu'),
      ),
      body: ListView.builder(
        itemCount: shoes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(shoes[index]['title']),
            subtitle: Text(shoes[index]['body']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // Menangkap hasil dari halaman edit
                    final updatedShoe = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditShoePage(shoe: shoes[index])),
                    );

                    // Memperbarui data lokal jika hasilnya tidak null
                    if (updatedShoe != null) {
                      setState(() {
                        final shoeIndex = shoes.indexWhere((s) => s['id'] == updatedShoe['id']);
                        if (shoeIndex != -1) {
                          shoes[shoeIndex] = updatedShoe; // Update data lokal dengan yang baru
                        } else {
                          debugPrint("Sepatu tidak ditemukan untuk diperbarui: ${updatedShoe['id']}");
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Berhasil diperbarui!')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteShoe(shoes[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
