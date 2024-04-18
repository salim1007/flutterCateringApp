import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CartsPage extends StatefulWidget {
  const CartsPage({super.key});

  @override
  State<CartsPage> createState() => _CartsPageState();
}

class _CartsPageState extends State<CartsPage> {
  int qty = 1;
  List<dynamic> authCart = [];
  double totalCartPrice = 0;
  bool showLeading = false;

  Position? _currentLocation;
  late bool servicePermisiion = false;
  late LocationPermission permission;
  String _currentAddress = '';


  @override
  void initState() {
    super.initState();
    _getUserCarts();
     _initializeLocation();
  }


Future<void> _initializeLocation() async {
  _currentLocation = await _getCurrentLocation();
  await _getAddressFromCoordinates();
  print(_currentAddress);
}

  Future<Position> _getCurrentLocation() async{
    servicePermisiion = await Geolocator.isLocationServiceEnabled();
    if(servicePermisiion == false){
      print('Service disabled!');

    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

    }

    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async{
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = '${place.street} - ${place.subLocality}, ${place.locality}';
       

      });

    }catch(error){
      return error;
    }
  }

  

  Future<void> _getUserCarts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';
      if (token.isNotEmpty) {
      var user = await DioProvider().getUser(token);
      final userData = json.decode(user);
      var Cart = await DioProvider().getUserCart(userData['id']);
      final authUserCart = json.decode(Cart);

      double total = 0;
      for(var cartItem in authUserCart){
        total += cartItem['total_price'];
      }

      setState(() {
         authCart = authUserCart;
         totalCartPrice = total;
      });

      print(authCart);
      print(totalCartPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    bool showLeadingBtn = args['showLeadingButton'] ?? false;
    setState(() {
      showLeading = showLeadingBtn;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Carts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        shadowColor: Colors.black,
        automaticallyImplyLeading: showLeading,
      ),
      backgroundColor: Color.fromARGB(255, 216, 154, 73),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 216, 154, 73),
                ),
                child: Column(
                  children: authCart.map((cartItem){
                    return Container(
                      height: 100,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 235, 233, 232),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'http://127.0.0.1:8000/storage/${cartItem['prod_image']}'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        //
                                       '${cartItem['product_name']}',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                        'Rated: 2.4',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                        'Cost: ${cartItem['total_price']}/=',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                      '${cartItem['prod_size'] != null ? 'Size: ${cartItem['prod_size']} inches' : ''}',
                                       style: TextStyle(fontSize: 9),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          Row(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                      onPressed: () async{
                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var token = prefs.getString('token') ?? '';
                                         if (token.isNotEmpty) {
                                           var user = await DioProvider().getUser(token);
                                           final userData = json.decode(user);
                                           final response = await DioProvider().cartIncr(userData['id'], cartItem['prod_id'], token);
                                           if(response){
                                            print('increased qty successfully!');
                                            setState(() {
                                             var divider = cartItem['total_price'] / cartItem['prod_qty'];
                                             cartItem['prod_qty']++;
                                             cartItem['total_price'] = divider * cartItem['prod_qty'];

                                             double total = 0;
                                             for(var cartItem in authCart){
                                              total += cartItem['total_price'];
                                             }

                                             totalCartPrice = total;
                                             
                                            });
                                           }
                                          }
                                           
                                      },
                                      icon: FaIcon(FontAwesomeIcons.plus),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(11)),
                                    )),
                                Container(
                                  height: 25,
                                  width: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    '${cartItem['prod_qty']}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                      onPressed: () async{
                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var token = prefs.getString('token') ?? '';
                                         if (token.isNotEmpty) {
                                           var user = await DioProvider().getUser(token);
                                           final userData = json.decode(user);
                                           final response = await DioProvider().cartDecr(userData['id'], cartItem['prod_id'], token);
                                           if(response){
                                            print('decreased qty successfully!');
                                            setState(() {
                                            var divider = cartItem['total_price'] / cartItem['prod_qty'];
                                             cartItem['prod_qty']--;
                                             cartItem['total_price'] = divider * cartItem['prod_qty'];


                                             double total = 0;
                                             for(var cartItem in authCart){
                                              total += cartItem['total_price'];
                                             }

                                             totalCartPrice = total;
                                            });
                                           }
                                          }
                                        
                                      },
                                      icon: FaIcon(FontAwesomeIcons.minus),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(11)),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async{
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var token = prefs.getString('token') ?? '';
                                         if (token.isNotEmpty) {
                                           var user = await DioProvider().getUser(token);
                                           final userData = json.decode(user);
                                           final response = await DioProvider().deleteCartProduct(userData['id'], cartItem['prod_id'], token);
                                           if(response){
                                            _getUserCarts();
                                           }
                                           }
                                
                              },
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.trashCan,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                 margin: EdgeInsets.all(10),
                child: Text(
                  'Total Cost: ${totalCartPrice}/=', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orangeAccent
                ),
                child: TextButton(
                  onPressed: () async{
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text(
                          'You are about to place an Order!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 219, 135, 10)),
                        ),
                        content: Container(
                          height: 200,
                          child: Column(
                            children: [
                              Text('Total Amount:', style: TextStyle(fontSize: 16,),),
                              Text('${totalCartPrice}/=', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              SizedBox(height: 20,),
                              Text('Delivery Location', style: TextStyle(fontSize: 16),),
                              Text('${_currentAddress}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                              SizedBox(height: 20,),
                              TextButton(
                                onPressed: () async{
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var token = prefs.getString('token') ?? '';
                                  if (token.isNotEmpty) {
                                  var user = await DioProvider().getUser(token);
                                  final userData = json.decode(user);
                                  

                                  final response = await DioProvider().placeOrder(userData['id'], authCart, totalCartPrice,_currentAddress,token);
                                   print(response);
                                  if(response){
                                    var isDeleted = await DioProvider().deleteUserCart(userData['id'], token);
                                    if(isDeleted == true){
                                      print('data deleted!');
                                    }
                                     MyApp.navigatorKey.currentState!.pushNamed('orders_page');
                                  }

                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orangeAccent
                                  ),
                                  padding: EdgeInsets.all(10),
                                 
                                  child: Text('Place Order', style: TextStyle(color: Colors.black,),))
                                )
                            ],
                          ),
                        )
                      );
                    });
                    

                      
                    //  }
                  },
                  child: Text('Continue To Checkout', style: TextStyle(fontSize: 15, color: Colors.black), ),
                  
                )
              )
            ],
          ),
        ),
        
      ),
  
    );
  }
}
