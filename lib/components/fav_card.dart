import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';

class FavCard extends StatelessWidget {
  const FavCard({super.key, required this.productData, required this.isFav});
  final Map<String, dynamic> productData;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                    image: DecorationImage(
                        image: NetworkImage(
                            'http://192.168.1.131:8000/storage/${productData['photo_path']}'),
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
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                        ),
                      ),
                      Text(
                        '${productData['price']}/=',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                        ),
                      ),
                      Text(
                        '4.2',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                        ),
                      )
                    ]),
              ),
            ],
          ),
          Row(children: [
            GestureDetector(
              onTap: () {
                var authModel = Provider.of<AuthModel>(context, listen: false);
                var favlist = authModel.getFav;
                favlist.removeWhere((id) => id == productData['id']);
                authModel.setFavList(favlist);
                DioProvider()
                    .storeFavProdList(favlist, authModel.getAuthUserToken);
              },
              child: Container(
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
