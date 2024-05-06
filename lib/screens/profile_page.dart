import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orangeAccent,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      print('object');
                    },
                    child: Icon(
                      Icons.edit,
                    ),
                  ))
            ],
          ),
          body: Consumer<AuthModel>(builder: (context, auth, child) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      height: 270,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Center(
                        child: Column(children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                if (auth.getUser['profile_photo_path'] != null)
                                  Image.network(
                                    'http://127.0.0.1:8000/storage/${auth.getUser['profile_photo_path']}',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                if (auth.getUser['profile_photo_path'] == null)
                                  Center(
                                    child: Text(
                                      auth.getUser['name'].substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 48,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            auth.getUser['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contacts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(auth.getUser['phone']),
                      Text(auth.getUser['email']),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Address',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(auth.getStaticLocation),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Center(
                  child: Container(
                      margin: EdgeInsets.all(6),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ))),
                )
              ],
            );
          })),
    );
  }
}
