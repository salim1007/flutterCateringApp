import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/card_item.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:food_delivery_app/providers/theme_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  List<bool> categorySelected = [];

  List<dynamic> productDetails = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getProducts();
    _initializeCategories();
  }

  Future<void> _getProducts() async {
    final productInit = await DioProvider().getProducts('Main Course');
    setState(() {
      productDetails = json.decode(productInit);
    });
  }

  Future<void> _getCurrentLocation() async {
    var authModel = Provider.of<AuthModel>(context, listen: true);
    await authModel.initializeLocation();
  }

  void _initializeCategories() {
    if (userDetails['categories'] != null) {
      categorySelected =
          List<bool>.filled(userDetails['categories'].length, false);
      categorySelected[0] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    userDetails = Provider.of<AuthModel>(context, listen: false).getUser;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;
    currentAddress =
        Provider.of<AuthModel>(context, listen: true).getCurrentLocation;

    if (categorySelected.isEmpty && userDetails['categories'] != null) {
      _initializeCategories();
    }

    Brightness brightness = Theme.of(context).brightness;

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
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
                          fontFamily: 'VarelaRound',
                          fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 0), () {
                          return DioProvider().getNotifications(
                              authModel.getAuthUserID,
                              authModel.getAuthUserToken);
                        }),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                              child: snapshot.data is int && snapshot.data > 0
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
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color,
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
                    currentAddress.isEmpty
                        ? Container(
                            height: 20,
                            width: 20,
                            child: LoadingAnimationWidget.waveDots(
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : Text(
                            currentAddress,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'VarelaRound',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SearchBar(
                  autoFocus: false,
                  focusNode: FocusNode(),
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.06),
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
                          onTap: () {},
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                FlutterCarousel.builder(
                                  itemCount: userDetails['ads'].length,
                                  itemBuilder: (BuildContext context,
                                          int itemIndex, int pageViewIndex) =>
                                      Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.015),
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'http://102.37.33.97/storage/${userDetails['ads'][itemIndex]['ad_path']}'),
                                            fit: BoxFit.cover)),
                                  ),
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    autoPlay: true,
                                    pauseAutoPlayOnTouch: true,
                                    autoPlayInterval: Duration(seconds: 5),
                                    autoPlayAnimationDuration:
                                        Duration(seconds: 2),
                                    showIndicator: true,
                                    slideIndicator:
                                        CircularWaveSlideIndicator(),
                                    enableInfiniteScroll: true,
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
                                  final products = await DioProvider()
                                      .getProducts(userDetails['categories']
                                          [index]['category_name']);
                                  setState(() {
                                    productDetails = json.decode(products);
                                    for (int i = 0;
                                        i < categorySelected.length;
                                        i++) {
                                      categorySelected[i] = i == index;
                                    }
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(5),
                                  color: categorySelected[index]
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).primaryColor,
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
                                                  0.028,
                                              fontFamily: 'VarelaRound',
                                              color: brightness ==
                                                          Brightness.dark &&
                                                      categorySelected[index]
                                                  ? Colors.white
                                                  : Colors.black,
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
                        productDetails.isEmpty
                            ? Center(
                                child: LoadingAnimationWidget.prograssiveDots(
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.3),
                                ),
                                itemCount: productDetails.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // Assuming each item in productDetails is of type Map<String, dynamic>
                                  Map<String, dynamic> product =
                                      productDetails[index]
                                          as Map<String, dynamic>;
                                  return product.isEmpty
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.white,
                                          highlightColor: Color.fromARGB(
                                              255, 210, 207, 207),
                                          child: CardItem(
                                              product: product,
                                              isFav: favList
                                                  .contains(product['id'])),
                                        )
                                      : CardItem(
                                          product: product,
                                          isFav:
                                              favList.contains(product['id']));
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
      ),
    );
  }
}
