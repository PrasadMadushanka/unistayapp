import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final QueryDocumentSnapshot productData;

  const EditProductScreen({super.key, required this.productData});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isUploadingImage = false;

  String? selectedCategory;
  String? selectedCapacity;
  String? selectedFor;

  final List<String> categoryItems = [
    'Single Room',
    'Double Room',
    'One-day Room',
    'Others'
  ];
  final List<String> capacityItems = [
    '1 person',
    '2 person',
    '4 person',
    'Other'
  ];
  final List<String> forItems = ['Male', 'Female', 'Both'];

  @override
  @override
  void initState() {
    super.initState();
    // Pre-fill fields with the current product data
    nameController.text = widget.productData["Name"] ?? "";
    priceController.text = widget.productData["Price"] ?? "";
    addressController.text = widget.productData["Address"] ?? "";
    phoneController.text = widget.productData["Phone"] ?? "";
    detailController.text = widget.productData["Detail"] ?? "";

    // Pre-fill dropdowns with default values if fields are missing
  }

  Future<void> pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      setState(() {
        isUploadingImage = true;
      });
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('productImages/$fileName');

      final uploadTask = firebaseStorageRef.putFile(image);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    } finally {
      setState(() {
        isUploadingImage = false;
      });
    }
  }

  Future<void> updateProduct() async {
    try {
      String? imageUrl = widget.productData["Image"]; // Use existing image URL

      // If a new image is selected, upload it
      if (selectedImage != null) {
        imageUrl = await uploadImage(selectedImage!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to upload image."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Update product details in Firebase
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(widget.productData.id) // Reference the document by its ID
          .update({
        "Name": nameController.text,
        "Price": priceController.text,
        "Address": addressController.text,
        "Phone": phoneController.text,
        "Detail": detailController.text,
        "Image": imageUrl, // Update the image URL
        "RoomCategory": selectedCategory,
        "RoomCapacity": selectedCapacity,
        "For": selectedFor,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back to the product list
    } catch (e) {
      print("Error updating product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update product."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            const Text(
              "Product Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  selectedImage == null
                      ? Image.network(
                          widget.productData["Image"],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          selectedImage!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: pickImage,
                    ),
                  ),
                ],
              ),
            ),
            if (isUploadingImage)
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 20),

            // Name Field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Price Field
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Address Field
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Phone Field
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Detail Field
            TextField(
              controller: detailController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Details",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Room Category Dropdown
            const Text("Room Category"),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              items: categoryItems
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              isExpanded: true,
            ),

            const SizedBox(height: 16.0),

            // Room Capacity Dropdown
            const Text("Room Capacity"),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCapacity,
              onChanged: (value) {
                setState(() {
                  selectedCapacity = value;
                });
              },
              items: capacityItems
                  .map((capacity) => DropdownMenuItem(
                        value: capacity,
                        child: Text(capacity),
                      ))
                  .toList(),
              isExpanded: true,
            ),

            const SizedBox(height: 16.0),

            // For Dropdown
            const Text("For"),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedFor,
              onChanged: (value) {
                setState(() {
                  selectedFor = value;
                });
              },
              items: forItems
                  .map((forOption) => DropdownMenuItem(
                        value: forOption,
                        child: Text(forOption),
                      ))
                  .toList(),
              isExpanded: true,
            ),

            const SizedBox(height: 32.0),

            // Save Changes Button
            Center(
              child: ElevatedButton(
                onPressed: updateProduct,
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 22.0, color: Color(0xE86EB069)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
