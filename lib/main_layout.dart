import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/connectivity_model.dart';
import 'package:food_delivery_app/screens/booking_page.dart';
import 'package:food_delivery_app/screens/cart_page.dart';
import 'package:food_delivery_app/screens/home_page.dart';
import 'package:food_delivery_app/screens/order_page.dart';
import 'package:food_delivery_app/screens/profile_page.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPage = 0;
  final PageController _page = PageController();

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected =
        Provider.of<ConnectivityService>(context).getInternetConnectionStatus;
    if (!isConnected) {
      ScaffoldMessenger(
        child: SnackBar(
            showCloseIcon: true,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red[300],
            content: Text(
              'No internet Connection!',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color: Colors.black),
            )),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(didPop){
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
            // FavouritesPage(),
            ProfilePage(),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'favBtn',
                    backgroundColor: Theme.of(context).canvasColor,
                    child: const Icon(Icons.favorite, color: Colors.red,),
                    onPressed: () {
                      MyApp.navigatorKey.currentState!.pushNamed('favourites_page');
                    },
                  ),
                  const SizedBox(height: 16), 
                  FloatingActionButton(
                    heroTag: 'bookBtn',
                    backgroundColor: Theme.of(context)
                        .canvasColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.listUl,
                          color: Colors.orangeAccent,
                        ),
                        Text(
                          'Bookings',
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).textTheme.headlineMedium?.color,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      MyApp.navigatorKey.currentState!.pushNamed('book_list');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
            // CurvedNavigationBarItem(
            //   child: FaIcon(FontAwesomeIcons.heart),
            //   // label: 'Notify'
            // ),
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
      ),
    );
  }
}
