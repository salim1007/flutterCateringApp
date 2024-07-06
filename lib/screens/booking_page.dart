import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/models/date_time_convert.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _calFormat = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Book Table',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width > 550
              ? MediaQuery.of(context).size.width * 0.16
              : MediaQuery.of(context).size.width * 0.03),
          child: CustomScrollView(
            primary: true,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Select Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width > 550
                              ? MediaQuery.of(context).size.width * 0.022
                              : 16,
                        )),
                    _tableCalendar(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Text('Select Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width > 550
                                ? MediaQuery.of(context).size.width * 0.022
                                : 16,
                          )),
                    )
                  ],
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          _timeSelected = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index
                                ? Colors.orangeAccent
                                : null),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 9}:00 ${index + 9 > 11 ? 'PM' : 'AM'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width > 550
                                ? MediaQuery.of(context).size.width * 0.022
                                : 12,
                            color: _currentIndex == index ? Colors.white : null,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 12,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.4,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 30,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  child: Column(
                    children: [
                      Text('Number of people',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 550
                                  ? MediaQuery.of(context).size.width * 0.022
                                  : 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Colors.orangeAccent),
                            height: 30,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                    } else {
                                      quantity;
                                    }
                                  });
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.minus,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.color,
                                  size: 18,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(fontSize: 21),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Colors.orangeAccent),
                            height: 30,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.color,
                                  size: 18,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    child: Button(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width > 550 ? 50 : 40,
                      title: "Book",
                      onPressed: () async {
                        var authModel =
                            Provider.of<AuthModel>(context, listen: false);

                        final getDate = ConvertDate.getDate(_currentDay);
                        final getTime = ConvertDate.getTime(_currentIndex!);
                        final getDay = ConvertDate.getDay(_currentDay.weekday);

                        final response = await DioProvider().bookTable(
                            getDate,
                            getTime,
                            getDay,
                            authModel.getAuthUserID,
                            quantity,
                            authModel.getAuthUserToken);

                        if (response) {
                          var bookings = await DioProvider().fetchBooks(
                              authModel.getAuthUserID,
                              authModel.getAuthUserToken);
                          setState(() {
                            authModel.updateBookings(json.decode(bookings));
                          });

                          if (context.mounted) {
                            showDelighfulToast(
                                context,
                                "Booking placed successfully!",
                                Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.color,
                                Icons.book_online,
                                Theme.of(context).canvasColor,
                                Theme.of(context).canvasColor);
                          }

                          MyApp.navigatorKey.currentState!
                              .pushNamed('book_list');
                        }
                      },
                      disable: _timeSelected && _dateSelected ? false : true,
                    )),
              )
            ],
          ),
        ));
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2030, 12, 31),
      calendarFormat: _calFormat,
      currentDay: _currentDay,
      rowHeight: MediaQuery.of(context).size.width > 550
          ? MediaQuery.of(context).size.width * 0.06
          : 48,
      calendarStyle: CalendarStyle(
          selectedTextStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.4,
          ),
          todayDecoration: const BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          )),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      onFormatChanged: (format) {
        setState(() {
          _calFormat = format;
        });
      },
      onDaySelected: ((
        selectedDay,
        focusedDay,
      ) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
        });
      }),
    );
  }
}
