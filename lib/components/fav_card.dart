import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:provider/provider.dart';

class FavCard extends StatelessWidget {
  const FavCard({super.key, required this.productData, required this.isFav});
  final Map<String, dynamic> productData;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 224, 211),
              borderRadius: BorderRadius.circular(20)),
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
                                'http://192.168.1.145:8000/storage/${productData['photo_path']}'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData['product_name'],
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${productData['price']}/=',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '4.2',
                            style: TextStyle(fontSize: 12),
                          )
                        ]),
                  ),
                ],
              ),
              Row(children: [
                GestureDetector(
                  onTap: () async {
                    var authModel =
                        Provider.of<AuthModel>(context, listen: false);
                    var favlist = authModel.getFav;
                    favlist.removeWhere((id) => id == productData['id']);

                    authModel.setFavList(favlist);
                  },
                  child: Container(
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ]),
            ],
          ),
        )
      ],
    );
  }
}
