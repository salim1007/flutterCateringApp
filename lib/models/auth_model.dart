import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> favProducts = [];
  List<dynamic> _fav = [];
  int userId = 0;
  String token = '';


  Position? _currentLocation;
  late bool servicePermisiion = false;
  late LocationPermission permission;
  String _currentAddress = '';

  List<dynamic> authCart = [];
  double totalCartPrice = 0;
  List<dynamic> authOrders = [];
  List<dynamic> authBookings = [];
  List<dynamic> systemProducts = [];

  List<dynamic> get getSystemProducts{
    return systemProducts;
  }

  String get getAuthUserToken{
    return token;
  }

  int get getAuthUserID{
    return userId;
  }

  List<dynamic> get getAuthBookings{
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

  List<dynamic> get getUserOrders{
    return authOrders;
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

  Future<void> _initializeLocation() async {
    _currentLocation = await _getCurrentLocation();
    await _getAddressFromCoordinates();
    print(_currentAddress);
  }

  Future<Position> _getCurrentLocation() async {
    servicePermisiion = await Geolocator.isLocationServiceEnabled();
    if (servicePermisiion == false) {
      print('Service disabled!');
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

      _currentAddress =
          '${place.street} - ${place.subLocality}, ${place.locality}';
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

  void updateOrder(List<dynamic> newOrder){
    authOrders = newOrder;
    notifyListeners();
  }
  
  void updateBookings(List<dynamic> newBookings){
    authBookings = newBookings;
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

    var orders = await DioProvider().getAuthUserOrders(user['id'], token);
    var authUserOrders = json.decode(orders);

    var cart = await DioProvider().getUserCart(user['id']);
    var authUserCart = json.decode(cart);
    double total = 0;
    for (var cartItem in authUserCart) {
      total += cartItem['total_price'];
    }

    userId = user['id'];
    authBookings = authUserBookings;
    authCart = authUserCart;
    totalCartPrice = total;
    authOrders = authUserOrders;
    systemProducts = productDetails;

    await _initializeLocation();

    notifyListeners();
  }
}
