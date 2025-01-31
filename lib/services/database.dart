import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addAllProducts(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .add(userInfoMap);
  }

  Future AddProduct(
      Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname)
        .add(userInfoMap);
  }

  UpdateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .update({"Status": "Deliverd"});
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllProducts(String Products) async {
    return FirebaseFirestore.instance.collection(Products).snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllDetails() async {
    return FirebaseFirestore.instance.collection("Products").snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Email", isEqualTo: email)
        .snapshots();
  }

  Future orderDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> allOrders() async {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Status", isEqualTo: "On the way")
        .snapshots();
  }

  Future<QuerySnapshot> search(String searchText) async {
  return FirebaseFirestore.instance
      .collection("Products")
      .where("UpdatedName", isGreaterThanOrEqualTo: searchText)
      .where("UpdatedName", isLessThan: searchText + '\uf8ff')
      .get();
}

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection("Products").doc(productId).delete();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }



}

