import 'package:flutter/material.dart';
import 'package:unistaynew/services/database.dart';
import 'package:unistaynew/services/shared_pref.dart';
import 'package:unistaynew/widget/support_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  final String image, name, detail, price, address, phone, capacity;
  const ProductDetail({
    super.key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    required this.address,
    required this.phone,
    required this.capacity,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image;

  getSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    mail = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void saveOrder() async {
    final orderDetails = {
      "Product": widget.name,
      "Price": widget.price,
      "Name": name,
      "Email": mail,
      "Image": widget.image,
      "Phone": widget.phone,
      "Address": widget.address,
      "Detail": widget.detail,
      "Status": "Pending",
    };

    await DatabaseMethods().orderDetails(orderDetails);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Stay added to Cart successfully!")),
    );
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unable to launch call for $phoneNumber")),
        );
      }
    } catch (e) {
      print("Error making phone call: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error making phone call: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.image, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: AppWidget.semiboldTextFieldStyle()),
                  Text(
                    "Rs.${widget.price}.00",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.address, style: AppWidget.LightTextFieldStyle()),
                  const SizedBox(height: 8),
                  Text(
                    "Phone: ${widget.phone}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Details: ${widget.detail}",
                    style: AppWidget.LightTextFieldStyle(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          saveOrder(); // Save the order
                          makePhoneCall(widget.phone); // Make the call
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xE86EB069),
                        ),
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          makePhoneCall(widget.phone); // Call directly
                        },
                        icon: const Icon(Icons.phone, color: Colors.white),
                        label: const Text(
                          "Call Now",
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
