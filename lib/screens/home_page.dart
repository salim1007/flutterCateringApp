import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/card_item.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userDetails = {};
  List<dynamic> favList = [];
  String currentAddress = '';
  int notifications = 0;

  bool isFirstLoaded = true;
  bool isLoading = false;

  List<dynamic> productDetails = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> _getProducts() async {
    final productInit = await DioProvider().getProducts('Main Course');
    setState(() {
      productDetails = json.decode(productInit);
    });
  }

  @override
  Widget build(BuildContext context) {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    userDetails = Provider.of<AuthModel>(context, listen: false).getUser;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;
    currentAddress =
        Provider.of<AuthModel>(context, listen: false).getCurrentLocation;

    print('user data is: $userDetails');
    print('favlist is data is: $favList');

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome ${userDetails['name'] ?? ''}',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1), () {
                        return DioProvider().getNotifications(
                            authModel.getAuthUserID,
                            authModel.getAuthUserToken);
                      }),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return GestureDetector(
                            onTap: () {
                              MyApp.navigatorKey.currentState!.pushNamed(
                                  'notification_page',
                                  arguments: notifications);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                FontAwesomeIcons.solidBell,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.color,
                                size: 20,
                              ),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return GestureDetector(
                            onTap: () {
                              MyApp.navigatorKey.currentState!.pushNamed(
                                  'notification_page',
                                  arguments: snapshot.data);
                            },
                            child: snapshot.data > 0
                                ? Lottie.asset('assets/bell.json',
                                    width: 40, height: 40)
                                : Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      FontAwesomeIcons.solidBell,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.color,
                                      size: 20,
                                    ),
                                  ),
                          );
                        }
                        return Icon(
                          FontAwesomeIcons.solidBell,
                          color:
                              Theme.of(context).textTheme.headlineMedium?.color,
                          size: 20,
                        );
                      })
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  currentAddress == ''
                      ? Container(
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator(
                            value: null,
                            strokeWidth: 2.0,
                          ),
                        )
                      : Text(
                          currentAddress,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SearchBar(
                onTap: () {
                  MyApp.navigatorKey.currentState!.pushNamed('search_page');
                },
                hintText: 'Search...',
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('book a table');
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Book a Table',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/pizza3.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: double.infinity,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 20.0,
                          ),
                          itemCount: userDetails['categories'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                print(userDetails);
                                final products = await DioProvider()
                                    .getProducts(userDetails['categories']
                                        [index]['category_name']);
                                setState(() {
                                  productDetails = json.decode(products);
                                });
                              },
                              child: Card(
                                margin: const EdgeInsets.all(5),
                                color: Theme.of(context).cardColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        userDetails['categories'][index]
                                            ['category_name'],
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.3),
                        ),
                        itemCount: productDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Assuming each item in productDetails is of type Map<String, dynamic>
                          Map<String, dynamic> product =
                              productDetails[index] as Map<String, dynamic>;
                          return CardItem(
                              product: product,
                              isFav: favList.contains(product['id']));
                        },
                      ),
                    ],
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
