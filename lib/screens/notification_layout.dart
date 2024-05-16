import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';

class NotitficationLayout extends StatefulWidget {
  const NotitficationLayout({super.key});

  @override
  State<NotitficationLayout> createState() => _NotitficationLayoutState();
}

class _NotitficationLayoutState extends State<NotitficationLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Ydde Fast Foods', style: TextStyle(fontSize: 20)),
            centerTitle: true,
            backgroundColor: Colors.orangeAccent,
            leading: GestureDetector(
              onTap: () {
                MyApp.navigatorKey.currentState!.pop();
              },
              child: const Icon(Icons.arrow_back_ios),
            )),
        backgroundColor: Colors.amber[100],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Text(
                '10:24 AM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(7)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: Text(
                  'Data ddf fdljfjd Data ddf fdljfjd Data ddf fdljfjd Data ddf fdljfjd Data ddf fdljfjd',
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
