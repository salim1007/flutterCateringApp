import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/card_item.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userData});

  final Map<dynamic, dynamic> userData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';

  Map<dynamic, dynamic> userDetails = {};

  bool isFirstLoaded = true;
  bool isLoading = false;

  List<dynamic> productDetails = [];

  Position? _currentLocation;
  late bool servicePermisiion = false;
  late LocationPermission permission;
  String _currentAddress = '';

  @override
  void initState(){
    super.initState();
    userDetails = widget.userData;
    _getProducts();
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
        print(_currentAddress);
       

      });

    }catch(error){
      return error;
    }
  }

   

  Future<void> _getProducts() async {
    final productInit = await DioProvider().getProducts('Main Course');
    setState(() {
      productDetails = json.decode(productInit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome, ${userDetails['name']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  FaIcon(
                    FontAwesomeIcons.bell,
                    color: Colors.black,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FaIcon(FontAwesomeIcons.locationDot),
                  SizedBox(
                    width: 5,
                  ),
                  _currentAddress == '' ? 
                  Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 2.0,
                    ),
                  ) :
                  Text(
                   '${_currentAddress}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SearchBar(
                hintText: 'Search...',
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orangeAccent),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('salim');
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Book a Table',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // Add this line
                                  child: Image.asset(
                                    'assets/pizza3.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 20.0,
                          ),
                          itemCount: userDetails['categories'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                print(userDetails);
                                final products = await DioProvider()
                                    .getProducts(userDetails['categories']
                                        [index]['category_name']);
                                setState(() {
                                  productDetails = json.decode(products);
                                });
                              },
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                color: Colors.orangeAccent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      // FaIcon(
                                      //   categories[index]['icon'],
                                      //   color: Colors.white,
                                      // ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        userDetails['categories'][index]
                                            ['category_name'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.3),
                        ),
                        itemCount: productDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Assuming each item in productDetails is of type Map<String, dynamic>
                          Map<String, dynamic> product =
                              productDetails[index] as Map<String, dynamic>;
                          return CardItem(product: product);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
