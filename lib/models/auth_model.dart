import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> favProducts = [];
  List<dynamic> _fav = [];
  int userId = 0;
  String token = '';
  List<dynamic> notificationLength = [];
  String todaysDate = DateFormat('M/d/y').format(DateTime.now());

  Position? _currentLocation;
  late bool servicePermisiion = false;
  late LocationPermission permission;
  String _currentAddress = '';

  List<dynamic> authCart = [];
  double totalCartPrice = 0;

  List<dynamic> authBookings = [];

  List<dynamic> systemProducts = [];

  List<dynamic> get getSystemProducts {
    return systemProducts;
  }

  String get getAuthUserToken {
    return token;
  }

  int get getAuthUserID {
    return userId;
  }

  List<dynamic> get getAuthBookings {
    return authBookings;
  }

  List<dynamic> get getAuthCart {
    return authCart;
  }

  double get getTotalCartPrice {
    return totalCartPrice;
  }

  String get getCurrentLocation {
    return _currentAddress;
  }

  int get getNotificationCount {
    return notificationLength.length;
  }

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

  List<Map<String, dynamic>> get getFavProducts {
    favProducts.clear();

    for (var num in _fav) {
      for (var prod in user['products']) {
        if (num == prod['id']) {
          favProducts.add(prod);
        }
      }
    }
    return favProducts;
  }

  Future<void> initializeLocation() async {
    _currentLocation = await _getCurrentLocation();
    await _getAddressFromCoordinates();
   
  }

  Future<Position> _getCurrentLocation() async {
    servicePermisiion = await Geolocator.isLocationServiceEnabled();
    if (servicePermisiion == false) {
     
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];

      _currentAddress = '${place.subLocality}, ${place.locality}';

      return _currentAddress;

    
    } catch (error) {
      return error;
    }
  }

  void updateTotalCartPrice() {
    double total = 0;
    for (var cartItem in authCart) {
      total += cartItem['total_price'];
    }
    totalCartPrice = total;
    notifyListeners();
  }

  void updateCart(List<dynamic> newCart) {
    authCart = newCart;
    updateTotalCartPrice();
    notifyListeners();
  }

  void updateBookings(List<dynamic> newBookings) {
    authBookings = newBookings;
    notifyListeners();
  }

  void updateUser(Map<String, dynamic> newUserData) {
    user = newUserData;
    notifyListeners();
  }

  void updateNotificationCount(int newCount) {
    notificationLength.length = newCount;
    notifyListeners();
  }

  void updateProductRatings(List<dynamic> fetchedProducts) {
    systemProducts = fetchedProducts;
    notifyListeners();
  }

  void loginSuccess(Map<String, dynamic> userData) async {
    _isLogin = true;
    user = userData;
    if (user['user_details']['fav'] != null) {
      _fav = json.decode(user['user_details']['fav']);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';


    var products = await DioProvider().getAllProducts(token);
    var productDetails = json.decode(products);


    var bookings = await DioProvider().fetchBooks(user['id'], token);
    var authUserBookings = json.decode(bookings);
   

    var cart = await DioProvider().getUserCart(user['id']);
    var authUserCart = json.decode(cart);
  

    double total = 0;
    for (var cartItem in authUserCart) {
      total += cartItem['total_price'];
    }

    for (var msg in user['user_notes']) {
      msg['status'] == 'not_viewed';
      notificationLength.add(msg);
    }

    userId = user['id'];
    authBookings = authUserBookings;
    authCart = authUserCart;
    totalCartPrice = total;
    // authOrders = authUserOrders;
    systemProducts = productDetails;

    await initializeLocation();

    notifyListeners();
  }
}
