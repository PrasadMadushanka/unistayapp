import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:random_string/random_string.dart';
import 'package:unistaynew/services/database.dart';
import 'package:unistaynew/widget/support_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController capacitycontroller = TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null && namecontroller.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      // ignore: unused_local_variable
      var downloadUrl = await (await task).ref.getDownloadURL();

      String firstletter = namecontroller.text.substring(0, 1).toUpperCase();

      Map<String, dynamic> addProduct = {
        "Name": namecontroller.text,
        "Image": downloadUrl,
        "SearchKey": firstletter,
        "UpdatedName": namecontroller.text.toUpperCase(),
        "Price": pricecontroller.text,
        "Detail": detailcontroller.text,
        "Address": addresscontroller.text,
        "Phone": phonecontroller.text,
        "Capacity": capacitycontroller.text,
      };

      await DatabaseMethods()
          .AddProduct(addProduct, value!)
          .then((value) async {
        await DatabaseMethods().addAllProducts(addProduct);
        selectedImage = null;
        namecontroller.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(#25b0d8),
            content: Text(
              "Product has been uploaded successfully!",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      });
    }
  }

  String? value, value2, value3;
  final List<String> categoryitem = [
    'Single Room',
    'Double Room',
    'One-day Room',
    'Others'
  ];

  final List<String> categorygender = [
    'Male',
    'Female',
    'Both',
  ];

  final List<String> capacityitem = [
    '1 person',
    '2 person',
    '4 person',
    'Other'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Center(
          child: Text(
            "Add Room",
            style: AppWidget.semiboldTextFieldStyle(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
              left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Room Image",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Home Name",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  maxLength: 15,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Rental Fee",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: pricecontroller,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Address",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: addresscontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  maxLength: 50,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Contact Number",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: phonecontroller,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "For",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categorygender
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiboldTextFieldStyle_2(),
                            )))
                        .toList(),
                    onChanged: ((value2) => setState(() {
                          this.value2 = value2;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Male"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value2,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Room Category",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categoryitem
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiboldTextFieldStyle_2(),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Room Capacity",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: capacityitem
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiboldTextFieldStyle_2(),
                            )))
                        .toList(),
                    onChanged: ((value3) => setState(() {
                          this.value3 = value3;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Capacity"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value3,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Room Details",
                style: AppWidget.LightTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  maxLines: 5,
                  controller: detailcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  maxLength: 300,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      uploadItem();
                    },
                    child: const Text(
                      "Add Product",
                      style:
                          TextStyle(fontSize: 22.0, color: Color(0xE86EB069)),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  '@ 2024 UniStay All Right Reserved.',
                  style: TextStyle(
                    fontSize: 8.0, // Adjust size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
