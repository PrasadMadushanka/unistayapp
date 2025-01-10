import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:unistaynew/services/constant.dart';
import 'package:unistaynew/services/database.dart';
import 'package:unistaynew/services/shared_pref.dart';
import 'package:unistaynew/widget/support_widget.dart';

// ignore: must_be_immutable
class ProductDetail extends StatefulWidget {
  String image, name, detail, price, address, phone, capacity;
  ProductDetail(
      {super.key,
      required this.detail,
      required this.name,
      required this.image,
      required this.price,
      required this.address,
      required this.phone,
      required this.capacity});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image;
  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    mail = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          title: const Text(''),
          centerTitle: true,
          backgroundColor: const Color(0xfff2f2f2),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Go back to previous page
            },
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      backgroundColor: const Color(0xfff2f2f2),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    widget.image,
                    height: 320,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.semiboldTextFieldStyle(),
                        ),
                        Text(
                          "Rs.${widget.price}.00",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 24, 176, 253),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.address,
                      style: AppWidget.semiboldTextFieldStyle_2(),
                    ),
                    Text(
                      "Contact: ${widget.phone}",
                      style: AppWidget.semiboldTextFieldStyle_2(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Details",
                      style: AppWidget.semiboldTextFieldStyle_2(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.detail,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const Spacer(),
                    Center(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  makePayment(widget.price);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 24, 176, 253),
                                      borderRadius: BorderRadius.circular(10)),
                                  // width: MediaQuery.of(context).size.width,
                                  child: const Center(
                                    child: Text(
                                      "Book Now",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.add,
                                size: 40,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Icons.call_outlined,
                                size: 36,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'LKR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secter'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ama'))
          .then((value) {});

      displayPaymentSheet();
    } catch (e, s) {
      print('exception: $e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> orderInfoMap = {
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": mail,
          "Image": image,
          "ProductImage": widget.image,
          "Status": "on the way",
        };

        await DatabaseMethods().orderDetails(orderInfoMap);
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull!"),
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error is : ----> $error $stackTrace");
      });
    } on StripeException catch (e) {
      print("Error is : -----> $e");
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(content: Text("Cancel")));
    } catch (e) {
      print("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_type[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    // Remove any non-numeric characters (such as spaces or commas)
    final formattedAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');
    final calculatedAmount = (int.parse(formattedAmount) * 100);
    return calculatedAmount.toString();
  }
}
