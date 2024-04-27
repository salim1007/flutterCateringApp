import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> ordersList = [];

  @override
  void initState() {
    super.initState();
    _getUserOrders();
  }

  Future<void> _getUserOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      var user = await DioProvider().getUser(token);
      final userData = json.decode(user);
      var orders = await DioProvider().getAuthUserOrders(userData['id'], token);
      if (orders != null) {
        setState(() {
          ordersList = json.decode(orders);
          print(ordersList);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
          shadowColor: Colors.black,
        ),
        backgroundColor: Color.fromARGB(255, 223, 165, 79),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: ordersList.map((orderItem) {
                return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 224, 211),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('Items',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                ),
                                Expanded(
                                  child: Text('Qty',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                ),
                                Expanded(
                                  child: Text('Price',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                ),
                              ],
                            ),
                          ]
                            ..addAll(orderItem['prod_list'].map<Widget>((product) {
                              return Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${product['product_name']}',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${product['prod_qty']}',
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                    Expanded(
                                      child: Text('${product['total_price']}/=',
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                  ],
                                ),
                              ]);
                            }).toList())
                            ..add(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Placed On: ${orderItem['updated_at']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                      fontSize: 10),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery Location: ${orderItem['destination']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.locationDot,
                                      size: 14,
                                    ),
                                  ],
                                ),
                                Text(
                                  'Total Amount: ${orderItem['total_amount']}/=',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: 10),
                                ),
                              ],
                            )),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 224, 211),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(1),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog.adaptive(
                                          backgroundColor:
                                              Color.fromARGB(255, 223, 219, 214),
                                          title: Center(
                                            child: Text(
                                              'Track your Order',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          titleTextStyle: TextStyle(
                                              fontSize: 16, color: Colors.black),
                                          content: Container(
                                            height: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      orderItem['status'] ==
                                                              'Placed'
                                                          ? Text(
                                                              'Time: ${orderItem['track_time']}Hrs',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                            )
                                                          : Text(''),
                                                      Container(
                                                        width: 110,
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            color: orderItem[
                                                                            'status'] ==
                                                                        'Placed' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'confirmed' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'on_delivery' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'delivered'
                                                                ? Colors
                                                                    .orangeAccent
                                                                : Colors.grey),
                                                        child: Text(
                                                          'Order Placed',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 130),
                                                  child: CustomPaint(
                                                    size: Size(10, 80),
                                                    painter: LinePainter(
                                                        orderItem['status']),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      orderItem['status'] ==
                                                              'confirmed'
                                                          ? Text(
                                                              'Time: ${orderItem['track_time']}Hrs')
                                                          : Text(''),
                                                      Container(
                                                        width: 110,
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            color: orderItem[
                                                                            'status'] ==
                                                                        'confirmed' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'on_delivery' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'delivered'
                                                                ? Colors
                                                                    .orangeAccent
                                                                : Colors.grey),
                                                        child: Text(
                                                          'Confirmed',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 130),
                                                  child: CustomPaint(
                                                    size: Size(10, 80),
                                                    painter: LinePainter2(
                                                        orderItem['status']),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      orderItem['status'] ==
                                                              'on_delivery'
                                                          ? Text(
                                                              'Time: ${orderItem['track_time']}Hrs')
                                                          : Text(''),
                                                      Container(
                                                        width: 110,
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            color: orderItem[
                                                                            'status'] ==
                                                                        'on_delivery' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'delivered'
                                                                ? Colors
                                                                    .orangeAccent
                                                                : Colors.grey),
                                                        child: Text(
                                                          'On Delivery',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 130),
                                                  child: CustomPaint(
                                                    size: Size(10, 80),
                                                    painter: LinePainter3(
                                                        orderItem['status']),
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      orderItem['status'] ==
                                                              'delivered'
                                                          ? Text(
                                                              'Time: ${orderItem['track_time']}Hrs')
                                                          : Text(''),
                                                      Container(
                                                        width: 110,
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            color: orderItem[
                                                                        'status'] ==
                                                                    'delivered'
                                                                ? Colors
                                                                    .orangeAccent
                                                                : Colors.grey),
                                                        child: Text(
                                                          'Delivered',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  'Track Order',
                                  style:
                                      TextStyle(color: Colors.black, fontSize: 12),
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
        ));
  }
}

class LinePainter extends CustomPainter {
  final String status;
  LinePainter(this.status);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = (status == 'confirmed') ? Colors.orangeAccent : Colors.grey
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LinePainter2 extends CustomPainter {
  final String status;
  LinePainter2(this.status);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = (status == 'on_delivery') ? Colors.orangeAccent : Colors.grey
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LinePainter3 extends CustomPainter {
  final String status;
  LinePainter3(this.status);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = (status == 'delivered') ? Colors.orangeAccent : Colors.grey
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
