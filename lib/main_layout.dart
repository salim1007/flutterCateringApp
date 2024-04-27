import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screens/booking_page.dart';
import 'package:food_delivery_app/screens/cart_page.dart';
import 'package:food_delivery_app/screens/home_page.dart';
import 'package:food_delivery_app/screens/order_page.dart';
import 'package:food_delivery_app/screens/profile_page.dart';

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
    final userData = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: [
          HomePage(userData: userData),
          CartsPage(),
          OrdersPage(),
          BookingPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Center(
          child: Column(
          children: [
            SizedBox(height: 9),
            Icon(FontAwesomeIcons.listUl, color: Colors.orangeAccent,),
            Text('Bookings', style: TextStyle(fontSize: 10),)
          ],
        ),
        ),
        onPressed: () {
          MyApp.navigatorKey.currentState!.pushNamed('book_list');
        }
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimney,
                color: Colors.orangeAccent),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cartShopping,
                  color: Colors.orangeAccent),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.truck, color: Colors.orangeAccent),
              label: 'Orders'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.book, color: Colors.orangeAccent),
              label: 'Book'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.person, color: Colors.orangeAccent),
              label: 'Profile'),
        ],
        selectedItemColor: Colors.black,
        elevation: 5.0,
      ),
    );
  }
}
