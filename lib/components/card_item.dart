import 'dart:convert';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class CardItem extends StatefulWidget {
  const CardItem({Key? key, required this.product, required this.isFav});

  final Map<String, dynamic> product;
  final bool isFav;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  int catId = 0;

  @override
  Widget build(BuildContext context) {
    final double price = double.parse(widget.product['price'].toString());
    final formattedPrice = NumberFormat("#,##0", "en_US").format(price);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: GestureDetector(
        onTap: () async {
          catId = widget.product['category_id'];
          final categoryItems = await DioProvider().getCategory(catId);
          final category = json.decode(categoryItems);

          MyApp.navigatorKey.currentState!.pushNamed('item_details',
              arguments: {'product': widget.product, 'category': category});
        },
        child: Container(
          height: MediaQuery.of(context).size.width > 550
              ? MediaQuery.of(context).size.height * 0.5
              : MediaQuery.of(context).size.height * 0.3,
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.width > 550
                    ? MediaQuery.of(context).size.height * 0.27
                    : MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'http://102.37.33.97/storage/${widget.product['photo_path']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: LoadingAnimationWidget.flickr(
                              leftDotColor: Colors.orangeAccent,
                              rightDotColor: Colors.black,
                              size: MediaQuery.of(context).size.width * 0.09,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: MediaQuery.of(context).size.width * 0.028,
                    color: Colors.yellowAccent,
                  ),
                  Text(
                    widget.product['avg_product_rating'] != null
                        ? widget.product['avg_product_rating'].toString()
                        : '5',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontFamily: 'VarelaRound',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Text(
                widget.product['product_name'],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.025,
                    fontFamily: 'VarelaRound',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Tsh. $formattedPrice/=',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.025,
                    fontFamily: 'VarelaRound',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
