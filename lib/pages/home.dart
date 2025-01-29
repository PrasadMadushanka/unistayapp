import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List categories = [
    "images/single-bed-room.jpg",
    "images/double-bed-room.jpeg",
    "images/one-day.jpeg",
    "images/other.jpeg"
  ];

  List homename = ["Single Room", "Double Room", "One-day Room", "Others"];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    // ignore: unused_local_variable
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring();
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if (element['UpdatedName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey, ${name!}",
                              style: AppWidget.semiboldTextFieldStyle(),
                            ),
                            Text(
                              "Good Morning",
                              style: AppWidget.LightTextFieldStyle(),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            image!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchcontroller,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Homes",
                            hintStyle: AppWidget.LightTextFieldStyle(),
                            prefixIcon: search
                                ? GestureDetector(
                                    onTap: () {
                                      search = false;
                                      tempSearchStore = [];
                                      queryResultSet = [];
                                      searchcontroller.text = "";
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.close))
                                : const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  )),
                      ),
                    ),
                    const SizedBox(
                      height: 0.0,
                    ),
                    search
                        ? ListView(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xfff2f2f2),
                                ),
                                height: 340,
                                child: const Banner(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Categories",
                                          style: AppWidget
                                              .semiboldTextFieldStyle(),
                                        ),
                                        const Text(
                                          "See All",
                                          style: TextStyle(
                                            color: Color(0xE86EB069),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 130,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: categories.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return CategoryTile(
                                              image: categories[index],
                                              name: homename[index],
                                              text: homename[index],
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "All Homes",
                                          style: AppWidget
                                              .semiboldTextFieldStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xfff2f2f2),
                                ),
                                height: 400,
                                child: AllCategoryProduct(
                                  Products: 'Products',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      detail: data["Detail"],
                      name: data["Name"],
                      image: data["Image"],
                      price: data["Price"],
                      address: data["Address"],
                      phone: data["Phone"],
                      capacity: data["Capacity"],
                    )));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data["Image"],
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            data["Name"],
            style: AppWidget.semiboldTextFieldStyle(),
          )
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  String image, name, text;
  CategoryTile({
    super.key,
    required this.image,
    required this.name,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(category: name)));
      },
      child: Container(
        height: 260,
        width: 160,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          right: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            Text(
              text,
              style: AppWidget.semiboldTextFieldStyle_2(),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}

//banner
class Banner extends StatefulWidget {
  const Banner({super.key});

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  late final PageController pageController;
  int pageNo = 0;

  late final Timer carasouelTimer;

  // List of image paths or URLs
  final List<String> images = [
    'images/background.jpg',
    'images/background.jpg',
    'images/background.jpg',
    'images/background.jpg',
    'images/background.jpg',
  ];

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == images.length - 1) {
        pageNo = 0;
      } else {
        pageNo++;
      }
      pageController.animateToPage(
        pageNo,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCirc,
      );
    });
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );
    carasouelTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    carasouelTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    pageNo = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (_, index) {
                  return AnimatedBuilder(
                    animation: pageController,
                    builder: (ctx, child) {
                      return child!;
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: AssetImage(
                              images[index]), // or NetworkImage for URLs
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      pageNo = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.circle,
                      size: 12.0,
                      color: pageNo == index
                          ? const Color.fromARGB(255, 41, 161, 212)
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//all products

// ignore: must_be_immutable
class AllCategoryProduct extends StatefulWidget {
  String Products;
  AllCategoryProduct({super.key, required this.Products});

  @override
  State<AllCategoryProduct> createState() => _AllCategoryProductState();
}

class _AllCategoryProductState extends State<AllCategoryProduct> {
  Stream? AllCategoryStream;

  getontheload() async {
    AllCategoryStream = await DatabaseMethods().getAllProducts(widget.Products);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: AllCategoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    return Container(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: Image.network(
                                    ds["Image"],
                                    height: 240,
                                    width: 260,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiboldTextFieldStyle(),
                                ),
                                Text(
                                  ds["Address"],
                                  style: AppWidget.semiboldTextFieldStyle_3(),
                                ),
                                Text(
                                  ds["Phone"],
                                  style: AppWidget.smallboldTextFieldStyle(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rs." + ds["Price"] + ".00",
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 24, 176, 253),
                                          fontSize: 27.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
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
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 24, 176, 253),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: const Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
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
      body: Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: allProducts()),
    );
  }
}
