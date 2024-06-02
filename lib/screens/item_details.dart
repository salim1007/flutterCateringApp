import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<void> submitRating(
      double rating, int userID, int productID, String token) async {
    var response =
        await DioProvider().rateProduct(rating, userID, productID, token);

    if (response == true) {}
  }

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
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
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
                    } else {
                      list.add(product['id']);
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
                  )),
            );
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 290,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: DecorationImage(
                      image: NetworkImage(
                          'http://192.168.1.131:8000/storage/${product['photo_path']}'),
                      fit: BoxFit.cover),
                  color: Colors.amberAccent,
                ),
              ),
              SizedBox(
                height: 20,
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
                                      ? Color.fromARGB(255, 240, 235, 222)
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${category['small_size']}' +
                                        ' ' +
                                        'inches',
                                    style: TextStyle(
                                      fontSize: 12,
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
                                      ? Color.fromARGB(255, 240, 235, 222)
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${category['medium_size']}' +
                                        ' ' +
                                        'inches',
                                    style: TextStyle(
                                      fontSize: 12,
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
                                      ? Color.fromARGB(255, 240, 235, 222)
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${category['large_size']}' +
                                        ' ' +
                                        'inches',
                                    style: TextStyle(
                                      fontSize: 12,
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
                    child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor,)))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RatingDialog(
                              title: Text(
                                product['product_name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              message: Text(
                                'Please help us rate ${product['product_name']}',
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              image: ClipRect(
                                child: Image.network(
                                  height: 80,
                                  'http://192.168.1.131:8000/storage/${product['photo_path']}',
                                ),
                              ),
                              initialRating: 1.0,
                              enableComment: false,
                              submitButtonText: 'Submit',
                              submitButtonTextStyle: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),
                              onSubmitted: (ratingResponse) {
                                submitRating(
                                    ratingResponse.rating,
                                    auth.getAuthUserID,
                                    product['id'],
                                    auth.getAuthUserToken);
                              });
                        });
                  },
                  child: Text(
                    'Rate product',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12),
                  ),
                ));
              }),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['product_name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            color: Theme.of(context).primaryColor,),
                        height: 30,
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
                            child:  FaIcon(
                              FontAwesomeIcons.minus,
                              size: 18,
                              color: Colors.black,
                            )),
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          color: Colors.black,
                            backgroundColor:Theme.of(context).primaryColor,
                            fontSize: 21),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: Theme.of(context).primaryColor,),
                        height: 30,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              size: 18,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: nullCheck ? 80 : 120,
                child: SingleChildScrollView(
                  child: Text(
                    product['description'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tsh. ' +
                          (double.parse(product['price']) * quantity * factor)
                              .toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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

                              var productSize;

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
                                var authModel = Provider.of<AuthModel>(context,
                                    listen: false);
                                authModel.updateCart(json.decode(newCart));
                                MyApp.navigatorKey.currentState!
                                    .pushNamed('cart_page', arguments: {
                                  'showLeadingButton': showLeadingButton
                                });
                              } else {
                                print('Product already added to cart!');
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
                                fontSize: 12,
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
