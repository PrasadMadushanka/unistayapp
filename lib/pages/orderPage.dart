import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Stream<QuerySnapshot>? ordersStream;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // Fetch orders from Firestore
  fetchOrders() async {
    ordersStream = FirebaseFirestore.instance.collection("Order").snapshots();
    setState(() {});
  }

  // Delete order from Firestore
  void deleteOrder(String orderId, String productName) async {
    try {
      await FirebaseFirestore.instance.collection("Order").doc(orderId).delete();

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order for '$productName' deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete stay: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Places found."));
          }

          // Render order cards
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final order = snapshot.data!.docs[index];
              final data = order.data() as Map<String, dynamic>;

              final productName = data["Product"] ?? "Unknown Product";
              final price = data["Price"] ?? "Unknown Price";
              final phone = data["Phone"] ?? "No Contact";

              return Card(
                child: ListTile(
                  leading: Image.network(
                    data["Image"] ?? "",
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(productName),
                  subtitle: Text("Price: Rs. $price\nContact: $phone"),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteOrder(order.id, productName);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
