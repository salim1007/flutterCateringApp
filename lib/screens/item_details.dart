import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int quantity = 1;
  bool isSmallSelected = true;
  bool isMediumSelected = false;
  bool isLargeSelected = false;
  double factor = 1.0;
  List<dynamic> favList = [];

  bool showLeadingButton = true;

  // Future<void> submitRating(
  //     double rating, int userID, int productID, String token) async {
  //   var response =
  //       await DioProvider().rateProduct(rating, userID, productID, token);

  //   if (response == true) {
  //     showToast('Rated', backGroundColor, textColor, fontSize, gravity)
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    var product = args['product'];
    var category = args['category'];

    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    final nullCheck = category['small_size'] != null &&
        category['medium_size'] != null &&
        category['large_size'] != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            MyApp.navigatorKey.currentState!.pop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: MediaQuery.of(context).size.width * 0.06,
          ),
        ),
        actions: [
          Consumer<AuthModel>(builder: (context, auth, child) {
            bool isFav = auth.getFav.contains(product['id']);
            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: GestureDetector(
                  onTap: () async {
                    final list = auth.getFav;

                    if (list.contains(product['id'])) {
                      list.removeWhere((id) => id == product['id']);
                      showToast(
                          "${product['product_name']} removed from liked list",
                          Theme.of(context).canvasColor,
                          Theme.of(context).textTheme.headlineMedium?.color,
                          MediaQuery.of(context).size.width * 0.035,
                          ToastGravity.BOTTOM);
                    } else {
                      list.add(product['id']);
                      showToast(
                          "${product['product_name']} added to liked list",
                          Theme.of(context).canvasColor,
                          Theme.of(context).textTheme.headlineMedium?.color,
                          MediaQuery.of(context).size.width * 0.035,
                          ToastGravity.BOTTOM);
                    }

                    auth.setFavList(list);

                    var response = await DioProvider()
                        .storeFavProdList(list, auth.getAuthUserToken);
                    if (response) {
                      setState(() {
                        isFav = !isFav;
                      });
                    }
                  },
                  child: FaIcon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                    color: Colors.red,
                    size: MediaQuery.of(context).size.width * 0.08,
                  )),
            );
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 550
                  ? MediaQuery.of(context).size.width * 0.15
                  : MediaQuery.of(context).size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: DecorationImage(
                      image: NetworkImage(
                          'http://102.37.33.97/storage/${product['photo_path']}'),
                      fit: BoxFit.cover),
                  color: Colors.amberAccent,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              nullCheck
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSmallSelected = true;
                                isMediumSelected = false;
                                isLargeSelected = false;
                                factor = 1.0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isSmallSelected
                                      ? Theme.of(context).canvasColor
                                      : Color.fromARGB(255, 233, 148, 21),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Small',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                                fontFamily: 'VarelaRound',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  Text(
                                    '${category['small_size']}' +
                                        ' ' +
                                        'inches',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.013,
                                              fontFamily: 'VarelaRound',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMediumSelected = true;
                                isSmallSelected = false;
                                isLargeSelected = false;
                                factor = 1.5;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isMediumSelected
                                      ? Theme.of(context).canvasColor
                                      : Color.fromARGB(255, 233, 148, 21),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Medium',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                                fontFamily: 'VarelaRound',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  Text(
                                    '${category['medium_size']}' +
                                        ' ' +
                                        'inches',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.013,
                                              fontFamily: 'VarelaRound',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLargeSelected = true;
                                isSmallSelected = false;
                                isMediumSelected = false;
                                factor = 2.0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isLargeSelected
                                      ? Theme.of(context).canvasColor
                                      : Color.fromARGB(255, 233, 148, 21),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Large',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                                fontFamily: 'VarelaRound',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  Text(
                                    '${category['large_size']}' +
                                        ' ' +
                                        'inches',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.013,
                                              fontFamily: 'VarelaRound',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Consumer<AuthModel>(builder: (context, auth, child) {
                return Container(
                    width: 20,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      )))),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RatingDialog(
                                  title: Text(
                                    product['product_name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.016,
                                                fontFamily: 'VarelaRound',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  message: Text(
                                    'Please help us rate ${product['product_name']}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.014,fontFamily: 'VarelaRound',),
                                    textAlign: TextAlign.center,
                                  ),
                                  image: ClipRect(
                                    child: Image.network(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      'http://102.37.33.97/storage/${product['photo_path']}',
                                    ),
                                  ),
                                  initialRating: 1.0,
                                  enableComment: false,
                                  submitButtonText: 'Submit',
                                  submitButtonTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.color,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.016,
                                      fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),
                                  onSubmitted: (ratingResponse) async {
                                    await DioProvider()
                                        .rateProduct(
                                            ratingResponse.rating,
                                            auth.getAuthUserID,
                                            product['id'],
                                            auth.getAuthUserToken);

                                    
                                      context.mounted
                                          ? showToast(
                                              'Rated ${product['product_name']}',
                                              Theme.of(context).canvasColor,
                                              Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.color,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                              ToastGravity.BOTTOM)
                                          : null;
                                    
                                  });
                            });
                      },
                      child: Text(
                        'Rate product',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'VarelaRound',
                            fontSize:
                                MediaQuery.of(context).size.height * 0.015),
                      ),
                    ));
              }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['product_name'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontFamily: 'VarelaRound',
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: MediaQuery.of(context).size.height * 0.035,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                } else {
                                  quantity;
                                }
                              });
                            },
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              size: MediaQuery.of(context).size.height * 0.02,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color,
                            // backgroundColor: Theme.of(context).primaryColor,
                            fontSize: 22,fontFamily: 'VarelaRound',),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: MediaQuery.of(context).size.height * 0.035,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              size: MediaQuery.of(context).size.height * 0.02,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: nullCheck
                    ? MediaQuery.of(context).size.height * 0.08
                    : MediaQuery.of(context).size.height * 0.12,
                child: SingleChildScrollView(
                  child: Text(
                    product['description'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.height * 0.014,
                      fontFamily: 'VarelaRound',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tsh. ' +
                          (double.parse(product['price']) * quantity * factor)
                              .toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.015,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'VarelaRound',
                          color: Colors.black),
                    ),
                    Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: TextButton.icon(
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var token = prefs.getString('token') ?? '';
                            if (token.isNotEmpty) {
                              final user = await DioProvider().getUser(token);
                              final userData = json.decode(user);

                              var priceTotal = double.parse(product['price']) *
                                  quantity *
                                  factor;

                              int? productSize;

                              if (factor == 1.0 && nullCheck) {
                                productSize = 12;
                              } else if (factor == 1.5 && nullCheck) {
                                productSize = 14;
                              } else if (factor == 2.0 && nullCheck) {
                                productSize = 16;
                              } else {
                                productSize = null;
                              }

                              final response = await DioProvider().addToCart(
                                  userData['id'],
                                  product['id'],
                                  quantity,
                                  priceTotal,
                                  productSize,
                                  product['photo_path'],
                                  token);

                              if (response) {
                                var newCart = await DioProvider()
                                    .getUserCart(userData['id']);
                                if (context.mounted) {
                                  var authModel = Provider.of<AuthModel>(
                                      context,
                                      listen: false);
                                  authModel.updateCart(json.decode(newCart));
                                  showDelighfulToast(
                                      context,
                                      "${product['product_name']} added to cart!",
                                      Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.color,
                                      Icons.shopping_cart,
                                      Theme.of(context).canvasColor,
                                      Theme.of(context).canvasColor);
                                }
                                MyApp.navigatorKey.currentState!
                                    .pushNamed('cart_page', arguments: {
                                  'showLeadingButton': showLeadingButton
                                });
                              } else {
                                context.mounted
                                    ? showDelighfulToast(
                                        context,
                                        "${product['product_name']} already added to cart!",
                                        const Color.fromARGB(
                                            255, 220, 201, 164),
                                        Icons.remove_shopping_cart,
                                        Colors.black,
                                        Colors.black)
                                    : null;
                              }
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.cartPlus,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Add To Cart',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                    fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
