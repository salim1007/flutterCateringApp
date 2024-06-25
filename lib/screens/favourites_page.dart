import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/fav_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
        ),
        padding: EdgeInsets.only(top: 270),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios_rounded),
                  Text(
                    'Your Favourites',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width > 550
                  ? MediaQuery.of(context).size.width * 0.1
                  : MediaQuery.of(context).size.width * 0.01),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                  )),
              child: Consumer<AuthModel>(builder: (context, auth, child) {
                if (auth.getFavProducts.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Your favourites will appear here!',
                            style: TextStyle(fontSize: 13),
                          ),
                          Lottie.asset('assets/favlist_empty.json',
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.25)
                        ]),
                  );
                }
                return ListView.builder(
                    itemCount: auth.getFavProducts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          var categId =
                              auth.getFavProducts[index]['category_id'];
                          final categoryItems =
                              await DioProvider().getCategory(categId);
                          final category = json.decode(categoryItems);

                          MyApp.navigatorKey.currentState!
                              .pushNamed('item_details', arguments: {
                            'category': category,
                            'product': auth.getFavProducts[index]
                          });
                        },
                        child: FavCard(
                          productData: auth.getFavProducts[index],
                          isFav: true,
                        ),
                      );
                    });
              }),
            ))
          ],
        ),
      ),
    );
  }
}
