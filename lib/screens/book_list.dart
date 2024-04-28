import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList>
    with SingleTickerProviderStateMixin {
  String? token;
  List<dynamic> userBooks = [];
  Map<dynamic, dynamic>? userData;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getBooks();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _getBooks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    var user = await DioProvider().getUser(token!);
    setState(() {
      userData = json.decode(user);
      print(userData!['id']);
    });

    final books = await DioProvider().fetchBooks(userData!['id'], token!);
    setState(() {
      userBooks = json.decode(books);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(
                child: Text('upcoming'),
              ),
              Tab(
                child: Text('completed'),
              ),
              Tab(
                child: Text('canceled'),
              ),
            ]),
            title: const Text(
              'Your Bookings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: GestureDetector(
              onTap: () {
                MyApp.navigatorKey.currentState!
                    .pushNamed('main_layout', arguments: userData);
              },
              child: Icon(FontAwesomeIcons.arrowLeft),
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: userBooks
                        .where((booking) => booking['status'] == 'upcoming')
                        .map((item) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 223, 219, 214),
                                ),
                                child: Text(
                                  'Table Structure: ${item['no_of_people']} chair(s)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 223, 219, 214),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['day'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(item['date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(item['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var token =
                                              prefs.getString('token') ?? '';

                                          final response = await DioProvider()
                                              .changeBookStatus('completed',
                                                  item['id'], token);

                                          if (response) {
                                            await _getBooks();
                                            _tabController?.animateTo(1);
                                          }
                                        },
                                        child: const Text('Completed',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 39, 139, 43)))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var token =
                                              prefs.getString('token') ?? '';

                                          final response = await DioProvider()
                                              .changeBookStatus('canceled',
                                                  item['id'], token);

                                          if (response) {
                                            await _getBooks();
                                            _tabController?.animateTo(2);
                                          }
                                        },
                                        child: const Text('Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 248, 48, 33)))),
                                  ],
                                ))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: userBooks
                        .where((booking) => booking['status'] == 'completed')
                        .map((item) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 223, 219, 214),
                                ),
                                child: Text(
                                  'Table Structure: ${item['no_of_people']} chair(s)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 223, 219, 214),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['day'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(item['date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(item['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: userBooks
                        .where((booking) => booking['status'] == 'canceled')
                        .map((item) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 224, 106, 98),
                                ),
                                child: Text(
                                  'Table Structure: ${item['no_of_people']} chair(s)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 224, 106, 98),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['day'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(item['date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(item['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
