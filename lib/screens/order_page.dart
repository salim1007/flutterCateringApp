import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/timeline.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    ordersList = Provider.of<AuthModel>(context, listen: false).getUserOrders;

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
                            const Row(
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
                            ..addAll(
                                orderItem['prod_list'].map<Widget>((product) {
                              return Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10),
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
                                        return Dialog(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 233, 224, 211),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              height: 670,
                                              child: Column(children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                  'Track Your Order',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                OrderTimeLine(
                                                    isFirst: true,
                                                    isLast: false,
                                                    isPast: true,
                                                    progressCard: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Placed',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        orderItem['status'] ==
                                                                'Placed'
                                                            ? Text(
                                                                '${orderItem['track_time']} Hrs',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                ),
                                                              )
                                                            : const Text(
                                                                'Your order has been placed!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                      ],
                                                    )),
                                                OrderTimeLine(
                                                    isFirst: false,
                                                    isLast: false,
                                                    isPast: orderItem[
                                                                    'status'] ==
                                                                'confirmed' ||
                                                            orderItem[
                                                                    'status'] ==
                                                                'on_delivery' ||
                                                            orderItem[
                                                                    'status'] ==
                                                                'delivered'
                                                        ? true
                                                        : false,
                                                    progressCard: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Confirmed',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        orderItem['status'] ==
                                                                'confirmed'
                                                            ? Text(
                                                                '${orderItem['track_time']} Hrs',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            : orderItem['status'] ==
                                                                        'on_delivery' ||
                                                                    orderItem[
                                                                            'status'] ==
                                                                        'delivered'
                                                                ? const Text(
                                                                    'Your order has been confirmed!',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12))
                                                                : const Text(
                                                                    'Awaiting...'),
                                                      ],
                                                    )),
                                                OrderTimeLine(
                                                    isFirst: false,
                                                    isLast: false,
                                                    isPast: orderItem[
                                                                    'status'] ==
                                                                'on_delivery' ||
                                                            orderItem[
                                                                    'status'] ==
                                                                'delivered'
                                                        ? true
                                                        : false,
                                                    progressCard: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'On Delivery',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        orderItem['status'] ==
                                                                'on_delivery'
                                                            ? Text(
                                                                '${orderItem['track_time']} Hrs',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            : orderItem['status'] ==
                                                                    'delivered'
                                                                ? const Text(
                                                                    'Your order has been confirmed!',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12))
                                                                : const Text(
                                                                    'Awaiting...'),
                                                      ],
                                                    )),
                                                OrderTimeLine(
                                                    isFirst: false,
                                                    isLast: true,
                                                    isPast:
                                                        orderItem['status'] ==
                                                                'delivered'
                                                            ? true
                                                            : false,
                                                    progressCard: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Delivered',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        orderItem['status'] ==
                                                                'delivered'
                                                            ? Text(
                                                                '${orderItem['track_time']} Hrs',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            : const Text(
                                                                'Awaiting...'),
                                                      ],
                                                    )),
                                              ])),
                                        );
                                      });
                                },
                                child: const Text(
                                  'Track Order',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
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
