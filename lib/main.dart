import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:food_delivery_app/components/image_slider.dart';
import 'package:food_delivery_app/firebase_options.dart';
import 'package:food_delivery_app/main_layout.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/models/connectivity_model.dart';
import 'package:food_delivery_app/providers/theme_provider.dart';
import 'package:food_delivery_app/screens/auth_page.dart';
import 'package:food_delivery_app/screens/book_list.dart';
import 'package:food_delivery_app/screens/cart_page.dart';
import 'package:food_delivery_app/screens/edit_page.dart';
import 'package:food_delivery_app/screens/favourites_page.dart';
import 'package:food_delivery_app/screens/item_details.dart';
import 'package:food_delivery_app/screens/notification_layout.dart';
import 'package:food_delivery_app/screens/notification_page.dart';
import 'package:food_delivery_app/screens/order_page.dart';
import 'package:food_delivery_app/screens/otp_verification.dart';
import 'package:food_delivery_app/screens/password_renewal_page.dart';
import 'package:food_delivery_app/screens/profile_page.dart';
import 'package:food_delivery_app/screens/search_page.dart';
import 'package:food_delivery_app/screens/verify_email.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _checkLoginStatus();

  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await isUserLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(create: (context) => AuthModel()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
        ChangeNotifierProvider<ConnectivityService>(
            create: (context) => ConnectivityService())
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
        return MaterialApp(
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
          initialRoute: _isLoggedIn ? '/main_layout' : '/',
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
            'edit_page': (context) => const EditPage(),
            'profile_page': (context) => const ProfilePage(),
            'verify_email': (context) => const VerifyEmail(),
            'renew_password': (context) => const PasswordRenewalPage(),
          },
        );
      },
    );
  }
}
