import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/card_item.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> productData = [];
  List<dynamic> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _getAllProducts();
  }

  Future<void> _getAllProducts() async {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    var products = await DioProvider().getAllProducts(authModel.getAuthUserToken);
    setState(() {
      productData = json.decode(products);
      filteredProducts = List.from(productData);
    });
  }

  void _filterProducts(String typedInText) {
    List<dynamic> results = [];

    if (typedInText.isEmpty) {
      results = List.from(productData);
    } else {
      results = productData
          .where((product) => product['product_name']
              .toLowerCase()
              .contains(typedInText.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: List.empty()),
            padding: const EdgeInsets.all(20),
            child: SearchBar(
              textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(color: Colors.black)),
              onChanged: (value) => _filterProducts(value),
              hintText: 'Search...',
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.orangeAccent),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.3),
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Assuming each item in filteredProducts is of type Map<String, dynamic>
                    Map<String, dynamic> product = filteredProducts[index];
                    return CardItem(product: product);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            MyApp.navigatorKey.currentState!.pop();
          },
           backgroundColor:Color.fromARGB(255, 221, 212, 212) ,
          child: const Icon(FontAwesomeIcons.house, color: Colors.black,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
