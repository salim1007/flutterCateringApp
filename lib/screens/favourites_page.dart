import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          padding: EdgeInsets.only(top: 130),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios),
                    Text(
                      'Your Favourites',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(35))),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 235, 233, 232),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.amber,
                                      image: DecorationImage(
                                          image: NetworkImage(''),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //
                                          'Name',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          'Price',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '4.2',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                            Row(children: [
                              GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  child: Icon(
                                    FontAwesomeIcons.heart,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
