import 'dart:convert';
import 'package:cahyaniflutter_store/pages/CartPage.dart';
import 'package:cahyaniflutter_store/pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_edit_shoe_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _shoes = [];
  bool _isLoading = true;
  int _selectedIndex = 0; // Indeks halaman yang aktif

  @override
  void initState() {
    super.initState();
    fetchShoes();
  }

  Future<void> fetchShoes() async {
    final url = 'https://jsonplaceholder.typicode.com/posts';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _shoes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  Future<void> deleteShoe(int id) async {
    final url = 'https://jsonplaceholder.typicode.com/posts/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _shoes.removeWhere((shoe) => shoe['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus!')),
        );
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Ubah indeks halaman aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Sepatu'),
        backgroundColor: Colors.blueAccent,
      ),
      body: IndexedStack(
        index: _selectedIndex, // Menampilkan halaman sesuai indeks
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _shoes.isEmpty
                  ? Center(child: Text('Tidak ada data sepatu'))
                  : ListView.builder(
                      itemCount: _shoes.length,
                      itemBuilder: (context, index) {
                        final shoe = _shoes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/images/sepatuhome1.jpg'),
                            ),
                            title: Text(shoe['title']),
                            subtitle: Text(shoe['body']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditShoePage(shoe: shoe),
                                      ),
                                    );
                                    if (result != null && result is Map) {
                                      // Update data lokal
                                      setState(() {
                                        final index = _shoes.indexWhere((s) => s['id'] == result['id']);
                                        if (index != -1) {
                                          _shoes[index] = result; // Update data sepatu
                                        }
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Berhasil diperbarui!')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteShoe(shoe['id']); // Hapus data sepatu
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          CartPage(), // Halaman keranjang
          AccountScreen(), // Halaman profil
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditShoePage()),
                );
                if (result != null && result is Map) {
                  // Tambahkan data baru ke daftar lokal
                  setState(() {
                    _shoes.add(result);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Berhasil menambah data!')),
                  );
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
            )
          : null, // Sembunyikan tombol jika bukan di halaman home
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Indeks halaman yang aktif
        onTap: _onItemTapped,
      ),
    );
  }
}
