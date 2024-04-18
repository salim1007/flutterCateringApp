import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  List<String> assetImages = [
    'assets/pizza.jpg',
    'assets/pizza2.jpg',
    'assets/pizza3.jpg',
  ];

  List<String> imageTexts = [
    'Delicious Pizza',
    'Cheesy Pizza',
    'Pepperoni Pizza',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: const Text('Ydde Restaurant',
           style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        )),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24,),
          const Text('Welcome To Ydde Restaurant',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400
          ),
          ),
          Expanded(
            child: CarouselSlider(
              items: List.generate(assetImages.length, (index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Set border radius here
                      child: Image.asset(
                        assetImages[index],
                        fit: BoxFit.cover,
                        height: 380,
                        width: double.infinity, // Adjust image height as needed
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      imageTexts[index],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              }).toList(),
              options: CarouselOptions(
                height: 500.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                  });
                },
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pushNamed('auth_page');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
              overlayColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 179, 174, 174)),
            ),
             child: const Text('Get Started',
             style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
             ),
             )
            ),
          const SizedBox(height: 30,),

         
        ],
      ),
    );
  }
}

