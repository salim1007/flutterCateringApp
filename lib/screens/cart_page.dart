import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartsPage extends StatefulWidget {
  const CartsPage({super.key});

  @override
  State<CartsPage> createState() => _CartsPageState();
}

class _CartsPageState extends State<CartsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    bool showLeadingBtn =
        args != null ? args['showLeadingButton'] ?? false : false;
    setState(() {
      showLeading = showLeadingBtn;
    });

    var authCart = Provider.of<AuthModel>(context, listen: true).getAuthCart;
    var totalCartPrice =
        Provider.of<AuthModel>(context, listen: true).getTotalCartPrice;
    var phoneNumber =
        Provider.of<AuthModel>(context, listen: true).getUser['phone'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Carts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'VarelaRound',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        shadowColor: Colors.black,
        automaticallyImplyLeading: showLeading,
        leading: showLeading
            ? IconButton(
                onPressed: () {
                  MyApp.navigatorKey.currentState!.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded))
            : null,
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width > 550
                ? MediaQuery.of(context).size.width * 0.1
                : MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width > 550
                ? MediaQuery.of(context).size.width * 0.1
                : MediaQuery.of(context).size.width * 0.02,
            top: 20),
        child: authCart.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You cart is empty!',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'VarelaRound',
                        ),
                      ),
                      Lottie.asset('assets/cart_empty.json',
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.25)
                    ]),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: authCart.map((cartItem) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.amber,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'http://102.37.33.97/storage/${cartItem['prod_image']}'),
                                              fit: BoxFit.cover)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              //
                                              '${cartItem['product_name']}',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                fontFamily: 'VarelaRound',
                                              ),
                                            ),
                                            if (cartItem['prod_size'] !=
                                                null) ...[
                                              Text(
                                                'Size: ${cartItem['prod_size']} inches',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                ),
                                              ),
                                            ],
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Cost:',
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.025,
                                                    fontFamily: 'VarelaRound',
                                                    fontStyle: FontStyle.italic,
                                                     fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Text(
                                                  '${cartItem['total_price']}/=',
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.025,
                                                    fontFamily: 'VarelaRound',
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                  prefs.getString('token') ??
                                                      '';
                                              if (token.isNotEmpty) {
                                                var user = await DioProvider()
                                                    .getUser(token);
                                                final userData =
                                                    json.decode(user);
                                                final response =
                                                    await DioProvider()
                                                        .cartIncr(
                                                            userData['id'],
                                                            cartItem['prod_id'],
                                                            token);
                                                if (response) {
                                                  setState(() {
                                                    var divider = cartItem[
                                                            'total_price'] /
                                                        cartItem['prod_qty'];
                                                    cartItem['prod_qty']++;
                                                    cartItem['total_price'] =
                                                        divider *
                                                            cartItem[
                                                                'prod_qty'];

                                                    Provider.of<AuthModel>(
                                                            context,
                                                            listen: false)
                                                        .updateTotalCartPrice();
                                                  });
                                                }
                                              }
                                            },
                                            icon: FaIcon(FontAwesomeIcons.plus),
                                            style: ButtonStyle(
                                                iconSize:
                                                    MaterialStateProperty.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01)),
                                          )),
                                      Container(
                                        height: 25,
                                        width: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          '${cartItem['prod_qty']}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                            fontFamily: 'VarelaRound',
                                          ),
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
                                                  prefs.getString('token') ??
                                                      '';
                                              if (token.isNotEmpty) {
                                                var user = await DioProvider()
                                                    .getUser(token);
                                                final userData =
                                                    json.decode(user);
                                                final response =
                                                    await DioProvider()
                                                        .cartDecr(
                                                            userData['id'],
                                                            cartItem['prod_id'],
                                                            token);
                                                if (response) {
                                                  setState(() {
                                                    var divider = cartItem[
                                                            'total_price'] /
                                                        cartItem['prod_qty'];
                                                    cartItem['prod_qty']--;
                                                    if (cartItem['prod_qty'] <
                                                        1) {
                                                      cartItem['prod_qty'] =
                                                          qty;
                                                    }
                                                    cartItem['total_price'] =
                                                        divider *
                                                            cartItem[
                                                                'prod_qty'];

                                                    Provider.of<AuthModel>(
                                                            context,
                                                            listen: false)
                                                        .updateTotalCartPrice();
                                                  });
                                                }
                                              }
                                            },
                                            icon:
                                                FaIcon(FontAwesomeIcons.minus),
                                            style: ButtonStyle(
                                                iconSize:
                                                    MaterialStateProperty.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01)),
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
                                      var token =
                                          prefs.getString('token') ?? '';
                                      if (token.isNotEmpty) {
                                        var user =
                                            await DioProvider().getUser(token);
                                        final userData = json.decode(user);
                                        final response = await DioProvider()
                                            .deleteCartProduct(userData['id'],
                                                cartItem['prod_id'], token);
                                        if (response) {
                                          var updatedCart = await DioProvider()
                                              .getUserCart(userData['id']);
                                          var authModel =
                                              Provider.of<AuthModel>(context,
                                                  listen: false);
                                          setState(() {
                                            authModel.updateCart(
                                                json.decode(updatedCart));
                                          });
                                          if (context.mounted) {
                                            showToast(
                                                "${cartItem['product_name']} removed from cart",
                                                Theme.of(context).canvasColor,
                                                Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.color,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                ToastGravity.BOTTOM);
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      child: Icon(
                                        FontAwesomeIcons.trashCan,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.color,
                                        size: 20,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'VarelaRound',
                        ),
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
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      titlePadding: EdgeInsets.all(25),
                                      title: const Text(
                                        'You are about to place an Order!',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'VarelaRound',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 219, 135, 10)),
                                      ),
                                      content: Container(
                                        height: 250,
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Total Amount:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'VarelaRound',
                                              ),
                                            ),
                                            Text(
                                              '${totalCartPrice}/=',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'VarelaRound',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'Delivery Location',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'VarelaRound',
                                              ),
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                controller: _addressController,
                                                keyboardType:
                                                    TextInputType.streetAddress,
                                                cursorColor:
                                                    Colors.orangeAccent,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.red[
                                                        300], // Change to your preferred error color
                                                    fontSize: 12.0,
                                                    fontFamily: 'VarelaRound',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height:
                                                        1.0, // Adjust to fine-tune the spacing
                                                    // This centers the error text
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter Delivery address';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    if (phoneNumber == null ||
                                                        phoneNumber == '') {
                                                      context.mounted
                                                          ? showToast(
                                                              'Please provide your Phone Number before placing Order for delivery purpose, update your profile',
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  202,
                                                                  187,
                                                                  187),
                                                              Colors.black,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.035,
                                                              ToastGravity.TOP)
                                                          : null;
                                                    } else {
                                                      var authModel = Provider
                                                          .of<AuthModel>(
                                                              context,
                                                              listen: false);

                                                      var user = await DioProvider()
                                                          .getUser(authModel
                                                              .getAuthUserToken);
                                                      final userData =
                                                          json.decode(user);

                                                      final response =
                                                          await DioProvider().placeOrder(
                                                              userData['id'],
                                                              authCart,
                                                              totalCartPrice,
                                                              _addressController
                                                                  .text,
                                                              authModel
                                                                  .getAuthUserToken);

                                                      if (response) {
                                                        var isDeleted =
                                                            await DioProvider()
                                                                .deleteUserCart(
                                                                    userData[
                                                                        'id'],
                                                                    authModel
                                                                        .getAuthUserToken);
                                                        if (isDeleted == true) {
                                                          var newCartData =
                                                              await DioProvider()
                                                                  .getUserCart(
                                                                      userData[
                                                                          'id']);

                                                          setState(() {
                                                            authModel.updateCart(
                                                                json.decode(
                                                                    newCartData));

                                                            if (context
                                                                .mounted) {
                                                              showDelighfulToast(
                                                                  context,
                                                                  "Order placed successfully!",
                                                                  Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineMedium
                                                                      ?.color,
                                                                  Icons
                                                                      .delivery_dining,
                                                                  Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  Theme.of(
                                                                          context)
                                                                      .canvasColor);
                                                            }
                                                          });
                                                        }

                                                        if (context.mounted) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }

                                                        MyApp.navigatorKey
                                                            .currentState!
                                                            .pushNamed(
                                                                'orders_page');
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors
                                                            .orangeAccent),
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
                          child: Text(
                            'Continue To Checkout',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: 'VarelaRound',
                            ),
                          ),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
