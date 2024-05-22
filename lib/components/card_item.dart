import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';

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

          print(category);

          MyApp.navigatorKey.currentState!.pushNamed('item_details',
              arguments: {'product': widget.product, 'category': category});
        },
        child: Container(
          height: 300,
          margin: EdgeInsets.all(5),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 169,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.orangeAccent,
                  image: DecorationImage(
                    image: NetworkImage(
                        'http://192.168.1.145:8000/storage/${widget.product['photo_path']}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.yellowAccent,
                  ),
                  Text(
                    '4.7',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Text(
                widget.product['product_name'],
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                'Tsh. $formattedPrice/=',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
