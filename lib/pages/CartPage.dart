import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cartItems = [
      {
        'title': 'Sepatu A',
        'image': 'assets/images/shoe_a.jpg',
        'description': 'Deskripsi sepatu A'
      },
      {
        'title': 'Sepatu B',
        'image': 'assets/images/shoe_b.jpg',
        'description': 'Deskripsi sepatu B'
      },
      {
        'title': 'Sepatu C',
        'image': 'assets/images/shoe_c.jpg',
        'description': 'Deskripsi sepatu C'
      },
      {
        'title': 'Sepatu D',
        'image': 'assets/images/shoe_d.jpg',
        'description': 'Deskripsi sepatu D'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        padding: EdgeInsets.all(8.0),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    cartItems[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cartItems[index]['title']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    cartItems[index]['description']!,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
