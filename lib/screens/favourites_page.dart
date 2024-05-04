import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/components/fav_card.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
          ),
          padding: EdgeInsets.only(top: 130),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios),
                    Text(
                      'Your Favourites',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(35))),
                child: Consumer<AuthModel>(builder: (context, auth, child) {
                  return ListView.builder(
                      itemCount: auth.getFavProducts.length,
                      itemBuilder: (context, index) {
                        return FavCard(
                          productData: auth.getFavProducts[index],
                          isFav: true,
                        );
                      });
                }),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
