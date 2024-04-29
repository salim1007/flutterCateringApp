import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier{
  bool _isLogin = false;
  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> favProduct = [];
  List <dynamic> _fav = [];

  bool get isLogin{
    return _isLogin;
  }

  List<dynamic> get getFav{
    return _fav;
  }

  Map<String, dynamic> get getUser{
    return user;
  }

  void setFavList(List<dynamic> list){
    _fav = list;
    notifyListeners();
  }

  List<Map<String, dynamic>> get getFavProduct{
    favProduct.clear();

    for(var num in _fav){
      for(var prod in user['products']){
        if(num == prod['id']){
          favProduct.add(prod);
        }
      }
    }
    return favProduct;
  }

  void loginSuccess(Map<String, dynamic> userData){
    _isLogin = true;
    user = userData;
    if(user['user_details']['fav'] != null){
      _fav = json.decode(user['user_details']['fav']);
    }

    notifyListeners();

  }
}