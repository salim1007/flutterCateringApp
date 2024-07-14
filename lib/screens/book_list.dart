import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList>
    with SingleTickerProviderStateMixin {
  String? token;
  List<dynamic> userBooks = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userBooks = Provider.of<AuthModel>(context, listen: false).getAuthBookings;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: TabBar(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return states.contains(MaterialState.focused)
                        ? null
                        : Colors.transparent;
                  },
                ),
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).textTheme.headlineMedium?.color,
                unselectedLabelColor: Colors.orange[500],
                tabs: const [
                  Tab(
                    child: Text(
                      'upcoming',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'completed',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'canceled',
                    ),
                  ),
                ]),
            title: const Text(
              'Your Bookings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: GestureDetector(
              onTap: () {
                MyApp.navigatorKey.currentState!.pushNamed('main_layout');
              },
              child: Icon(Icons.arrow_back_ios_rounded),
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
                                      color: Theme.of(context).iconTheme.color),
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
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                                  Text(item['date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                                  Text(item['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
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
                                          var authModel =
                                              Provider.of<AuthModel>(context,
                                                  listen: false);

                                          final response = await DioProvider()
                                              .changeBookStatus(
                                                  'completed',
                                                  item['id'],
                                                  authModel.getAuthUserToken);

                                          if (response) {
                                            var bookings = await DioProvider()
                                                .fetchBooks(
                                                    authModel.getAuthUserID,
                                                    authModel.getAuthUserToken);
                                            setState(() {
                                              authModel.updateBookings(
                                                  json.decode(bookings));
                                            });
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
                                          var authModel =
                                              Provider.of<AuthModel>(context,
                                                  listen: false);
                                          final response = await DioProvider()
                                              .changeBookStatus(
                                                  'canceled',
                                                  item['id'],
                                                  authModel.getAuthUserToken);

                                          if (response) {
                                            var bookings = await DioProvider()
                                                .fetchBooks(
                                                    authModel.getAuthUserID,
                                                    authModel.getAuthUserToken);
                                            setState(() {
                                              authModel.updateBookings(
                                                  json.decode(bookings));
                                            });
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
                            color: Color.fromARGB(255, 154, 224, 157),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 149, 187, 151),
                                ),
                                child: Text(
                                  'Table Structure: ${item['no_of_people']} chair(s)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).iconTheme.color),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 149, 187, 151),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['day'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                                  Text(item['date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                                  Text(item['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
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
                            color: Color.fromARGB(255, 215, 111, 104),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 237, 146, 139),
                                ),
                                child: Text(
                                  'Table Structure: ${item['no_of_people']} chair(s)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).iconTheme.color),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 237, 146, 139),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['day'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                                  Text(item['date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                                  Text(item['time'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
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
