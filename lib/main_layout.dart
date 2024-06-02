import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screens/booking_page.dart';
import 'package:food_delivery_app/screens/cart_page.dart';
import 'package:food_delivery_app/screens/favourites_page.dart';
import 'package:food_delivery_app/screens/home_page.dart';
import 'package:food_delivery_app/screens/notification_page.dart';
import 'package:food_delivery_app/screens/order_page.dart';
import 'package:food_delivery_app/screens/profile_page.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: [
          //to be added - condition for drivers
          HomePage(),
          CartsPage(),
          OrdersPage(),
          BookingPage(),
          NotificationPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor:Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child:  Center(
            child: Column(
              children: [
                SizedBox(height: 9),
                const Icon(
                  FontAwesomeIcons.listUl,
                  color: Colors.orangeAccent,
                ),
                Text(
                  'Bookings',
                  style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.headlineMedium?.color),
                )
              ],
            ),
          ),
          onPressed: () {
            MyApp.navigatorKey.currentState!.pushNamed('book_list');
          }),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.orangeAccent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // currentIndex: currentPage,

        items: const [
          CurvedNavigationBarItem(
            child: FaIcon(FontAwesomeIcons.houseChimney),
            // label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: FaIcon(FontAwesomeIcons.cartShopping),
            // label: 'Cart'
          ),
          CurvedNavigationBarItem(
            child: FaIcon(FontAwesomeIcons.truck),
            // label: 'Orders'
          ),
          CurvedNavigationBarItem(
            child: FaIcon(FontAwesomeIcons.book),
            // label: 'Book'
          ),
          CurvedNavigationBarItem(
            child: FaIcon(FontAwesomeIcons.heart),
            // label: 'Notify'
          ),
          CurvedNavigationBarItem(
            child: FaIcon(
              FontAwesomeIcons.person,
            ),
            // label: 'Profile'
          ),
        ],
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.jumpToPage(page);
          });
        },
      ),
    );
  }
}
