import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/timeline.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> ordersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAuthUserOrders();
    });
  }

  Future<void> _getAuthUserOrders() async {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    var userOrders = await DioProvider()
        .getAuthUserOrders(authModel.getAuthUserID, authModel.getAuthUserToken);
    setState(() {
      ordersList = json.decode(userOrders);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        !didPop
            ? MyApp.navigatorKey.currentState!
                .pushNamedAndRemoveUntil('main_layout', (route) => false)
            : null;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'VarelaRound',
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.orangeAccent,
            shadowColor: Colors.black,
            automaticallyImplyLeading: false,
          ),
          body: isLoading
              ? Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.09,
                  ),
                )
              : ordersList.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'You currently have no Orders!',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'VarelaRound',
                              ),
                            ),
                            Lottie.asset('assets/orders_empty.json',
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.width * 0.3)
                          ]),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: ordersList.map((orderItem) {
                            return Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width > 550
                                      ? MediaQuery.of(context).size.width * 0.02
                                      : 10),
                              margin: EdgeInsets.all(
                                MediaQuery.of(context).size.width > 550
                                    ? MediaQuery.of(context).size.width * 0.04
                                    : 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text('Items',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.022,
                                                    fontFamily: 'VarelaRound',
                                                  )),
                                            ),
                                            Expanded(
                                              child: Text('Qty',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.022,
                                                    fontFamily: 'VarelaRound',
                                                  )),
                                            ),
                                            Expanded(
                                              child: Text('Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.022,
                                                    fontFamily: 'VarelaRound',
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ]
                                        ..addAll(orderItem['prod_list']
                                            .map<Widget>((product) {
                                          return Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${product['product_name']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.022,
                                                      fontFamily: 'VarelaRound',
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      '${product['prod_qty']}',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.022,
                                                        fontFamily:
                                                            'VarelaRound',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      '${product['total_price']}/=',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.022,
                                                        fontFamily:
                                                            'VarelaRound',
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ]);
                                        }).toList())
                                        ..add(Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Placed On: ${orderItem['updated_at']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.022,
                                                fontFamily: 'VarelaRound',
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Delivery Location: ${orderItem['destination']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.022,
                                                    fontFamily: 'VarelaRound',
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.locationDot,
                                                  size: 14,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.color,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Total Amount: ${orderItem['total_amount']}/=',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.022,
                                                fontFamily: 'VarelaRound',
                                              ),
                                            ),
                                          ],
                                        )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: EdgeInsets.all(1),
                                          child: TextButton(
                                            style: ButtonStyle(),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.7,
                                                          child: Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  'Track Your Order',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.03,
                                                                      fontFamily:
                                                                          'VarelaRound',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                OrderTimeLine(
                                                                    isFirst:
                                                                        true,
                                                                    isLast:
                                                                        false,
                                                                    isPast:
                                                                        true,
                                                                    progressCard:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Placed',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                              fontFamily: 'VarelaRound',
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        orderItem['status'] ==
                                                                                'Placed'
                                                                            ? Text(
                                                                                '${orderItem['track_time']} Hrs',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                  fontFamily: 'VarelaRound',
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                'Your order has been placed!',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                  fontFamily: 'VarelaRound',
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    )),
                                                                OrderTimeLine(
                                                                    isFirst:
                                                                        false,
                                                                    isLast:
                                                                        false,
                                                                    isPast: orderItem['status'] == 'confirmed' ||
                                                                            orderItem['status'] ==
                                                                                'on_delivery' ||
                                                                            orderItem['status'] ==
                                                                                'delivered'
                                                                        ? true
                                                                        : false,
                                                                    progressCard:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Confirmed',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                              fontFamily: 'VarelaRound',
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        orderItem['status'] ==
                                                                                'confirmed'
                                                                            ? Text(
                                                                                '${orderItem['track_time']} Hrs',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                  fontFamily: 'VarelaRound',
                                                                                ),
                                                                              )
                                                                            : orderItem['status'] == 'on_delivery' || orderItem['status'] == 'delivered'
                                                                                ? Text('Your order has been confirmed!',
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                      fontFamily: 'VarelaRound',
                                                                                    ))
                                                                                : Text(
                                                                                    'Awaiting...',
                                                                                    style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                      fontFamily: 'VarelaRound',
                                                                                    ),
                                                                                  ),
                                                                      ],
                                                                    )),
                                                                OrderTimeLine(
                                                                    isFirst:
                                                                        false,
                                                                    isLast:
                                                                        false,
                                                                    isPast: orderItem['status'] ==
                                                                                'on_delivery' ||
                                                                            orderItem['status'] ==
                                                                                'delivered'
                                                                        ? true
                                                                        : false,
                                                                    progressCard:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'On Delivery',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                              fontFamily: 'VarelaRound',
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        orderItem['status'] ==
                                                                                'on_delivery'
                                                                            ? Text(
                                                                                '${orderItem['track_time']} Hrs',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                  fontFamily: 'VarelaRound',
                                                                                ),
                                                                              )
                                                                            : orderItem['status'] == 'delivered'
                                                                                ? Text('Your order has been confirmed!',
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                      fontFamily: 'VarelaRound',
                                                                                    ))
                                                                                : Text(
                                                                                    'Awaiting...',
                                                                                    style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                      fontFamily: 'VarelaRound',
                                                                                    ),
                                                                                  ),
                                                                      ],
                                                                    )),
                                                                OrderTimeLine(
                                                                    isFirst:
                                                                        false,
                                                                    isLast:
                                                                        true,
                                                                    isPast: orderItem['status'] ==
                                                                            'delivered'
                                                                        ? true
                                                                        : false,
                                                                    progressCard:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Delivered',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                              fontFamily: 'VarelaRound',
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        orderItem['status'] ==
                                                                                'delivered'
                                                                            ? Text(
                                                                                '${orderItem['track_time']} Hrs',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                  fontFamily: 'VarelaRound',
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                'Awaiting...',
                                                                                style: TextStyle(
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                                  fontFamily: 'VarelaRound',
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    )),
                                                              ])),
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              'Track Order',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.color,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.022,
                                                fontFamily: 'VarelaRound',
                                              ),
                                            ),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )),
    );
  }
}
