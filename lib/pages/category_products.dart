import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unistaynew/pages/product_detail.dart';
import 'package:unistaynew/services/database.dart';
import 'package:unistaynew/widget/support_widget.dart';

// ignore: must_be_immutable
class CategoryProduct extends StatefulWidget {
  String category;
  CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  getontheload() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: CategoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Image.network(
                            ds["Image"],
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Rs." + ds["Price"] + ".00",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 24, 176, 253),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiboldTextFieldStyle_2(),
                          ),
                          Text(
                            ds["Address"],
                            style: AppWidget.smallboldTextFieldStyle(),
                          ),
                          Text(
                            ds["Phone"],
                            style: AppWidget.semiboldTextFieldStyle_2(),
                          ),
                          const Spacer(),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                              detail: ds["Detail"],
                                              name: ds["Name"],
                                              image: ds["Image"],
                                              price: ds["Price"],
                                              address: ds["Address"],
                                              phone: ds["Phone"],
                                              capacity: ds["Capacity"],
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 24, 176, 253),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text(
                                  "   View   ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allProducts()),
          ],
        ),
      ),
    );
  }
}
