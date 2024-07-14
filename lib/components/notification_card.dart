import 'dart:convert';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key, required this.userNotifications, required this.notificationCount});
  final List<dynamic> userNotifications;
  final int notificationCount;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  String latestMessage = '';

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> message =
        json.decode(widget.userNotifications.last['message']);
    latestMessage = message['greeting'] +
        ' ' +
        message['introduction'] +
        ' ' +
        message['encouragement'] +
        ' ' +
        message['closing'] +
        ' ' +
        message['from'];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.transparent, borderRadius: BorderRadius.circular(50), image: const DecorationImage(image: AssetImage('assets/app_icon.png'))),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.all(2),
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text(
                      'YDDE FAST FOODS',
                      style:
                          TextStyle(fontSize: 13,fontFamily: 'VarelaRound', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    widget.notificationCount > 0 ?
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.orangeAccent,
                      child: Text('${widget.notificationCount}', style: TextStyle(fontSize: 10,fontFamily: 'VarelaRound',),),
                    ) : Text(''),
                  ]),
                  Text(
                    latestMessage,
                    style: const TextStyle(fontSize: 13,fontFamily: 'VarelaRound',),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                ],
              )),
        )
      ],
    );
  }
}
