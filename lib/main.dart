import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/image_slider.dart';
import 'package:food_delivery_app/main_layout.dart';
import 'package:food_delivery_app/screens/auth_page.dart';
import 'package:food_delivery_app/screens/book_list.dart';
import 'package:food_delivery_app/screens/cart_page.dart';
import 'package:food_delivery_app/screens/item_details.dart';
import 'package:food_delivery_app/screens/order_page.dart';
import 'package:food_delivery_app/screens/otp_verification.dart';
import 'package:food_delivery_app/screens/search_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const ImageSlider(),
        'auth_page': (context) => const AuthPage(),
        'reg_otp_verification': (context) => const OtpVerification(),
        'main_layout': (context) => const MainLayout(),
        'item_details': (context) => const ItemDetails(),
        'cart_page': (context) => const CartsPage(),
        'orders_page': (context) => const OrdersPage(),
        'book_list':(context) => const BookList(),
        'search_page':(context) => const SearchPage()
      },
    );
  }
}
