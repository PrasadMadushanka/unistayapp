import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:random_string/random_string.dart';
import 'package:unistaynew/Admin/admin_login.dart';
import 'package:unistaynew/pages/onboarding.dart';
import 'package:unistaynew/services/auth.dart';
import 'package:unistaynew/services/shared_pref.dart';
import 'package:unistaynew/widget/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getthesharedpref() async {
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: name == null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: const Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(children: [
                      Text(
                        "My Profile",
                        style: AppWidget.semiboldTextFieldStyle(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedImage != null
                          ? GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.file(
                                    selectedImage!,
                                    height: 170,
                                    width: 170.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(
                                    image!,
                                    height: 150,
                                    width: 150.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      //name

                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 35,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: AppWidget.LightTextFieldStyle(),
                                    ),
                                    Text(
                                      name!,
                                      style:
                                          AppWidget.semiboldTextFieldStyle_2(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),

                      //email

                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mail_outline,
                                  size: 35,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: AppWidget.LightTextFieldStyle(),
                                    ),
                                    Text(
                                      email!,
                                      style:
                                          AppWidget.semiboldTextFieldStyle_2(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),

                      //signout

                      GestureDetector(
                        onTap: () async {
                          await AuthMethods().SignOut().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Onboarding()));
                          });
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.logout_outlined,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "LogOut",
                                    style: AppWidget.semiboldTextFieldStyle_2(),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),

                      //delete

                      GestureDetector(
                        onTap: () async {
                          await AuthMethods().deleteUser().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Onboarding()));
                          });
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outlined,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Delete Account",
                                    style: AppWidget.semiboldTextFieldStyle_2(),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminLogin()));
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.login,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Loggin as Admin",
                                        style: AppWidget
                                            .semiboldTextFieldStyle_2(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Row(
                          //this is logo , name and slogan
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'images/logo.png', //  logo image
                              width: 80.0,
                              height: 80.0,
                            ),
                            const Column(
                              children: [
                                Text(
                                  'UniStay',
                                  style: TextStyle(
                                    fontSize: 42.0, // Adjust size as needed
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Private Accommodation',
                                  style: TextStyle(
                                    fontSize: 12.0, // Adjust size as needed
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                        child: Text(
                          '@ 2024 UniStay All Right Reserved.',
                          style: TextStyle(
                            fontSize: 14.0, // Adjust size as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ])),
              ));
  }
}
