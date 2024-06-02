import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/edit_form.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orangeAccent,
          actions: [
            Consumer<AuthModel>(builder: (context, auth, child) {
              return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                                insetAnimationCurve: Curves.easeInOut,
                                insetAnimationDuration:
                                    const Duration(milliseconds: 500),
                                insetPadding: EdgeInsets.all(30),
                                child: EditForm(
                                  email: auth.user['email'] ?? '',
                                  phone: auth.user['phone'] ?? '',
                                  address: auth.user['user_details']
                                          ['address'] ??
                                      '',
                                  username: auth.user['name'] ?? '',
                                ));
                          });
                    },
                    child: Icon(
                      Icons.edit,
                    ),
                  ));
            })
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Stack(
                            children: [
                              if (auth.getUser['profile_photo_path'] != null)
                                Image.network(
                                  'http://192.168.1.131:8000/storage/${auth.getUser['profile_photo_path']}',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              if (auth.getUser['profile_photo_path'] == null)
                                Center(
                                  child: auth.getUser['name'] != null &&
                                          auth.getUser['name'].isNotEmpty
                                      ? Text(
                                          auth.getUser['name']
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 48,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.color,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.color,
                                          size: 48,
                                        ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          auth.getUser['name'] ?? '',
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
                    const Text(
                      'Contacts',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(auth.getUser['email'] ?? ''),
                    Text(auth.getUser['phone'] ?? ''),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    auth.user['user_details']['address'] != null
                        ? Text(auth.user['user_details']['address'])
                        : const Text(
                            'No specified Address',
                            style: TextStyle(
                                color: Colors.red, fontStyle: FontStyle.italic),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      child: Column(
                        children: [
                          Text(
                            'Toogle theme:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Switch.adaptive(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              var themeProvider = Provider.of<ThemeProvider>(
                                  context,
                                  listen: false);
                              themeProvider.toogleTheme(value);
                            },
                            activeColor: Colors.black,
                            activeTrackColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.black,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Center(
                child: Container(
                    margin: EdgeInsets.all(6),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ))),
              )
            ],
          );
        }));
  }
}
