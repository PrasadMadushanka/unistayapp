import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unistaynew/Admin/EditProductScreen.dart';


class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot productData;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.productData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      elevation: 5.0,
      child: ListTile(
        leading: Image.network(
          productData["Image"],
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(productData["Name"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: Rs. ${productData["Price"]}"),
            Text("Address: ${productData["Address"]}"),
            Text("Phone: ${productData["Phone"]}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductScreen(productData: productData),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
