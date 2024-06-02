import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartsPage extends StatefulWidget {
  const CartsPage({super.key});

  @override
  State<CartsPage> createState() => _CartsPageState();
}

class _CartsPageState extends State<CartsPage> {
  TextEditingController _addressController = TextEditingController();
  int qty = 1;

  bool showLeading = false;

  @override
  void initState() {
    super.initState();
    var authModel = Provider.of<AuthModel>(context, listen: false);
    _addressController = TextEditingController(
        text: authModel.user['user_details']['address'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    bool showLeadingBtn =
        args != null ? args['showLeadingButton'] ?? false : false;
    setState(() {
      showLeading = showLeadingBtn;
    });

    var currentLocation =
        Provider.of<AuthModel>(context, listen: false).getCurrentLocation;
    var authCart = Provider.of<AuthModel>(context, listen: false).getAuthCart;
    var totalCartPrice =
        Provider.of<AuthModel>(context, listen: false).getTotalCartPrice;

    print(totalCartPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Carts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        shadowColor: Colors.black,
        automaticallyImplyLeading: showLeading,
      ),
      backgroundColor: Color.fromARGB(255, 216, 154, 73),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 216, 154, 73),
                ),
                child: Column(
                  children: authCart.map((cartItem) {
                    return Container(
                      height: 100,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 235, 233, 232),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'http://192.168.1.131:8000/storage/${cartItem['prod_image']}'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        //
                                        '${cartItem['product_name']}',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                        'Rated: 2.4',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                        'Cost: ${cartItem['total_price']}/=',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                        '${cartItem['prod_size'] != null ? 'Size: ${cartItem['prod_size']} inches' : ''}',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          Row(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                      onPressed: () async {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var token =
                                            prefs.getString('token') ?? '';
                                        if (token.isNotEmpty) {
                                          var user = await DioProvider()
                                              .getUser(token);
                                          final userData = json.decode(user);
                                          final response = await DioProvider()
                                              .cartIncr(userData['id'],
                                                  cartItem['prod_id'], token);
                                          if (response) {
                                            print(
                                                'increased qty successfully!');
                                            setState(() {
                                              var divider =
                                                  cartItem['total_price'] /
                                                      cartItem['prod_qty'];
                                              cartItem['prod_qty']++;
                                              cartItem['total_price'] =
                                                  divider *
                                                      cartItem['prod_qty'];

                                              Provider.of<AuthModel>(context,
                                                      listen: false)
                                                  .updateTotalCartPrice();
                                            });
                                          }
                                        }
                                      },
                                      icon: FaIcon(FontAwesomeIcons.plus),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(11)),
                                    )),
                                Container(
                                  height: 25,
                                  width: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    '${cartItem['prod_qty']}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                      onPressed: () async {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var token =
                                            prefs.getString('token') ?? '';
                                        if (token.isNotEmpty) {
                                          var user = await DioProvider()
                                              .getUser(token);
                                          final userData = json.decode(user);
                                          final response = await DioProvider()
                                              .cartDecr(userData['id'],
                                                  cartItem['prod_id'], token);
                                          if (response) {
                                            print(
                                                'decreased qty successfully!');
                                            setState(() {
                                              var divider =
                                                  cartItem['total_price'] /
                                                      cartItem['prod_qty'];
                                              cartItem['prod_qty']--;
                                              cartItem['total_price'] =
                                                  divider *
                                                      cartItem['prod_qty'];

                                              Provider.of<AuthModel>(context,
                                                      listen: false)
                                                  .updateTotalCartPrice();
                                            });
                                          }
                                        }
                                      },
                                      icon: FaIcon(FontAwesomeIcons.minus),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(11)),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var token = prefs.getString('token') ?? '';
                                if (token.isNotEmpty) {
                                  var user = await DioProvider().getUser(token);
                                  final userData = json.decode(user);
                                  final response = await DioProvider()
                                      .deleteCartProduct(userData['id'],
                                          cartItem['prod_id'], token);
                                  if (response) {
                                    var updatedCart = await DioProvider()
                                        .getUserCart(userData['id']);
                                    var authModel = Provider.of<AuthModel>(
                                        context,
                                        listen: false);
                                    setState(() {
                                      authModel
                                          .updateCart(json.decode(updatedCart));
                                    });
                                    print('prod deleted');
                                  }
                                }
                              },
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.trashCan,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.all(10),
                child: Text(
                  'Total Cost: $totalCartPrice/=',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orangeAccent),
                  child: TextButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                titlePadding: EdgeInsets.all(25),
                                title: const Text(
                                  'You are about to place an Order!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 219, 135, 10)),
                                ),
                                content: Container(
                                  height: 250,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Total Amount:',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${totalCartPrice}/=',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Delivery Location',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      TextFormField(
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        controller: _addressController,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        cursorColor: Colors.orangeAccent,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            var authModel =
                                                Provider.of<AuthModel>(context,
                                                    listen: false);

                                            var user = await DioProvider()
                                                .getUser(
                                                    authModel.getAuthUserToken);
                                            final userData = json.decode(user);

                                            final response = await DioProvider()
                                                .placeOrder(
                                                    userData['id'],
                                                    authCart,
                                                    totalCartPrice,
                                                    _addressController.text,
                                                    authModel.getAuthUserToken);

                                            print(response);
                                            if (response) {
                                              // var newOrder = await DioProvider()
                                              //     .getAuthUserOrders(
                                              //         userData['id'],
                                              //         authModel
                                              //             .getAuthUserToken);
                                              //
                                              // authModel.updateOrder(
                                              //     json.decode(newOrder));

                                              var isDeleted = await DioProvider()
                                                  .deleteUserCart(
                                                      userData['id'],
                                                      authModel
                                                          .getAuthUserToken);
                                              if (isDeleted == true) {
                                                var newCartData =
                                                    await DioProvider()
                                                        .getUserCart(
                                                            userData['id']);

                                                setState(() {
                                                  authModel.updateCart(
                                                      json.decode(newCartData));
                                                });

                                                print('data deleted!');
                                              }
                                              MyApp.navigatorKey.currentState!
                                                  .pushNamed('orders_page');
                                            }
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.orangeAccent),
                                              padding: EdgeInsets.all(10),
                                              child: const Text(
                                                'Place Order',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )))
                                    ],
                                  ),
                                ));
                          });

                      //  }
                    },
                    child: const Text(
                      'Continue To Checkout',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
