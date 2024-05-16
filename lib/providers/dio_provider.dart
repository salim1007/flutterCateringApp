import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  Future<dynamic> register(String username, String email, String phone,
      String password, String passwordConfirm) async {
    try {
      var user = await Dio().post('http://127.0.0.1:8000/api/register', data: {
        'name': username,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirm
      });
      if (user.statusCode == 201 && user.data != '') {
        return json.encode(user.data);
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> verifyOtp(String otpValue, String email) async {
    try {
      var otp = await Dio().post('http://127.0.0.1:8000/api/verifyOtp',
          data: {'otp': otpValue, 'email': email});
      if (otp.statusCode == 200 && otp.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> getProducts(String category) async {
    try {
      var products = await Dio().get('http://127.0.0.1:8000/api/getProducts',
          queryParameters: {'category': category});
      if (products.statusCode == 200 && products.data != '') {
        return json.encode(products.data);
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/login',
          data: {'email': email, 'password': password});
      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        return 'error';
      }
    } catch (error) {
      print(error.toString());
      return 'Error';
    }
  }

  Future<dynamic> getUser(String token) async {
    try {
      var user = await Dio().get('http://127.0.0.1:8000/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> getCategory(int categoryId) async {
    try {
      var category = await Dio().get('http://127.0.0.1:8000/api/category',
          queryParameters: {'category_id': categoryId});
      if (category.statusCode == 200 && category.data != '') {
        return json.encode(category.data);
      } else {
        false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> addToCart(
      int userId,
      int productId,
      int prodQty,
      double totalPrice,
      dynamic prodSize,
      String prodImage,
      String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/addToCart',
          data: {
            'user_id': userId,
            'prod_id': productId,
            'prod_qty': prodQty,
            'total_price': totalPrice,
            'prod_size': prodSize,
            'prod_image': prodImage
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.data['status'] == 409 && response.data['cartData'] == null) {
        return false;
      } else if (response.data['status'] == 201 &&
          response.data['cartData'] != null) {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> getUserCart(int userId) async {
    try {
      var cart = await Dio().get(
        'http://127.0.0.1:8000/api/getCarts',
        queryParameters: {'user_id': userId},
      );
      if (cart.statusCode == 200 && cart.data != '') {
        return json.encode(cart.data);
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> cartIncr(int userId, int prodId, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/incrCart',
          data: {'user_id': userId, 'prod_id': prodId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200 && response.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> cartDecr(int userId, int prodId, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/decrCart',
          data: {'user_id': userId, 'prod_id': prodId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200 && response.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> deleteCartProduct(
      int userId, int prodId, String token) async {
    try {
      var response = await Dio().delete(
          'http://127.0.0.1:8000/api/deleteProduct',
          queryParameters: {'user_id': userId, 'prod_id': prodId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200 && response.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> placeOrder(int userId, List cartItems, double totalAmount,
      String location, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/placeOrder',
          data: {
            'user_id': userId,
            'prod_list': cartItems,
            'total_amount': totalAmount,
            'location': location
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200 && response.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> deleteUserCart(int userId, String token) async {
    try {
      var response = await Dio().delete(
          'http://127.0.0.1:8000/api/deleteUserCart',
          queryParameters: {'user_id': userId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200 && response.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> getAuthUserOrders(int userId, String token) async {
    try {
      var orders = await Dio().get('http://127.0.0.1:8000/api/retrieveOrders',
          queryParameters: {'user_id': userId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (orders.statusCode == 200 && orders.data != '') {
        return json.encode(orders.data);
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> bookTable(String date, String time, String day, int userId,
      int noOfPeople, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/bookTable',
          data: {
            'date': date,
            'time': time,
            'day': day,
            'user_id': userId,
            'no_of_people': noOfPeople
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200 && response.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<dynamic> fetchBooks(int userId, String token) async {
    try {
      var books = await Dio().get('http://127.0.0.1:8000/api/getUserBooks',
          queryParameters: {'user_id': userId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (books.statusCode == 200 && books.data != '') {
        return json.encode(books.data);
      } else {
        return false;
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<dynamic> changeBookStatus(
      String status, int bookId, String token) async {
    try {
      var response = await Dio().put(
          'http://127.0.0.1:8000/api/changeBookStatus',
          data: {'status': status},
          queryParameters: {'book_id': bookId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.data['status'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Errorz: $error');
      return error.toString();
    }
  }

  Future<dynamic> getAllProducts(String token) async {
    try {
      var products = await Dio().get('http://127.0.0.1:8000/api/getAllProducts',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (products.statusCode == 200 && products.data != '') {
        return json.encode(products.data);
      } else {
        return false;
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<dynamic> storeFavProdList(List list, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/storeFavs',
          data: {'fav_list': list},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<dynamic> rateProduct(double ratingValue, int userId, int prodId, String token) async{
    try{
      var response = await Dio().post('http://127.0.0.1:8000/api/rateProduct',
      data: {'user_id': userId,'prod_id':prodId, 'rate_value': ratingValue},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        return false;
      }

    }catch(error){
      return error.toString();
    }
  }

  Future<dynamic> updateProfile(int userId, String email, String phone, String address, String token) async{
    try{
      var response = await Dio().put('http://127.0.0.1:8000/api/updateProfile',
      data: {'user_id':userId, 'email':email, 'phone':phone, 'address':address},
      options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(error){
      return error.toString();
    }
  }
}
