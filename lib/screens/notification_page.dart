import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/notification_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    var notificationCount = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            MyApp.navigatorKey.currentState!.pushNamed('main_layout');
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                'Notifications',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
             
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () async{
                  await DioProvider().updateSeenNotifications(authModel.getAuthUserID, authModel.getAuthUserToken);
                  int newNoficationCount = await DioProvider().getNotifications(authModel.getAuthUserID, authModel.getAuthUserToken);
                  authModel.updateNotificationCount(newNoficationCount);
                  MyApp.navigatorKey.currentState!.pushNamed('notification_layout', arguments:authModel.user['user_notes']);
                },
                child:  NotificationCard(userNotifications: authModel.user['user_notes'], notificationCount: notificationCount,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
