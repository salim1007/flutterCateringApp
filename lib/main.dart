import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/image_slider.dart';
import 'package:food_delivery_app/firebase_options.dart';
import 'package:food_delivery_app/main_layout.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/theme_provider.dart';
import 'package:food_delivery_app/screens/auth_page.dart';
import 'package:food_delivery_app/screens/book_list.dart';
import 'package:food_delivery_app/screens/cart_page.dart';
import 'package:food_delivery_app/screens/favourites_page.dart';
import 'package:food_delivery_app/screens/item_details.dart';
import 'package:food_delivery_app/screens/notification_layout.dart';
import 'package:food_delivery_app/screens/notification_page.dart';
import 'package:food_delivery_app/screens/order_page.dart';
import 'package:food_delivery_app/screens/otp_verification.dart';
import 'package:food_delivery_app/screens/search_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(create: (context) => AuthModel()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
      ],
      builder: (context, _) {
        final themeProvider =
            Provider.of<ThemeProvider>(context, listen: true);
        return MaterialApp(
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.themeMode,
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
            'book_list': (context) => const BookList(),
            'search_page': (context) => const SearchPage(),
            'favourites_page': (context) => const FavouritesPage(),
            'notification_layout': (context) => const NotificationLayout(),
            'notification_page': (context) => const NotificationPage(),
          },
        );
      },
    );
  }
}
