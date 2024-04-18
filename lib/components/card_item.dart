import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';

class CardItem extends StatefulWidget {
  const CardItem({Key? key, required this.product});

  final Map<String, dynamic> product;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {

  int catId = 0;

  @override
  void initState() {
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: GestureDetector(
        onTap: () async{
          catId = widget.product['category_id'];
          final categoryItems = await DioProvider().getCategory(catId);
          final category = json.decode(categoryItems);
          
          print(category);
  
          MyApp.navigatorKey.currentState!.pushNamed('item_details', arguments: {'product': widget.product, 'category':category});
        },
        child: Container(
          height: 300,
          margin: EdgeInsets.all(5),
          color: Colors.orangeAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 15, color: Colors.yellowAccent,),
                  Text(
                    '4.7',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.all(5),
                height: 110,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orangeAccent,
                  image: DecorationImage(
                    image: NetworkImage('http://127.0.0.1:8000/storage/${widget.product['photo_path']}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text(
                widget.product['product_name'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5,),
              Text(
                widget.product['price'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}