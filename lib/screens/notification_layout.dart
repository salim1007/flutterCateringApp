import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:provider/provider.dart';

class NotificationLayout extends StatefulWidget {
  const NotificationLayout({super.key});

  @override
  State<NotificationLayout> createState() => _NotificationLayoutState();
}

class _NotificationLayoutState extends State<NotificationLayout> {
  @override
  Widget build(BuildContext context) {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    var userNotifications =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text('Ydde Fast Foods', style: TextStyle(fontSize: 20)),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
          leading: GestureDetector(
            onTap: () {
              MyApp.navigatorKey.currentState!.pushNamed('notification_page', arguments: authModel.getNotificationCount);
            },
            child: const Icon(Icons.arrow_back_ios),
          )),
      backgroundColor: Colors.amber[100],
      body: ListView.builder(
          itemCount: userNotifications.length,
          itemBuilder: (context, index) {
            // Decode the JSON object
            Map<String, dynamic> message =
                jsonDecode(userNotifications[index]['message']);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    userNotifications[index]['created_at'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['greeting'],
                          softWrap: true,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          message['introduction'],
                          softWrap: true,
                        ),
                        Text(
                          message['encouragement'],
                          softWrap: true,
                        ),
                        SizedBox(height: 20,),
                        Text(
                          message['closing'],
                          softWrap: true,
                        ),
                        Text(
                          message['from'],
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    ));
  }
}
