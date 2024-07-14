import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  List<String> assetImages = [
    'assets/variety_food.jpg',
    'assets/packed_food.jpg',
    'assets/reservation.jpg',
    'assets/delivery_guy.jpg',
  ];

  List<String> imageTexts = [
    'Order what you like',
    'Have it safely packed',
    'Book a reservation',
    'Pay after you receive'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Ydde Fast Foods',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'VarelaRound'),
          ),
          Expanded(
            child: CarouselSlider(
              items: List.generate(assetImages.length, (index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10),
                      child: Image.asset(
                        assetImages[index],
                        fit: BoxFit.cover,
                        height: 380,
                        width: double.infinity, 
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      imageTexts[index],
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,fontFamily: 'VarelaRound', fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.6,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {});
                },
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('auth_page');
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orangeAccent),
                overlayColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 179, 174, 174)),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'VarelaRound',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
