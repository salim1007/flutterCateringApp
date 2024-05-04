import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orangeAccent,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  print('object');
                },
                child: Icon(Icons.edit,),
              )
              )
          ],
        ),
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.all(0),
                child: Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Center(
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          image: DecorationImage(
                              image: AssetImage('assets/pizza.jpg'),
                              fit: BoxFit.cover),
                          color: Colors.amberAccent,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Salim Iddi Mchomvu',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                )),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('0748088341'),
                      Text('salimmchomvu7@gmail.com'),
                      SizedBox(height: 20,),
                      Text('Address', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Dar-es-salaam - Tanzania'),
                    ],
                  ),
                ),
                SizedBox(height: 70,),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: ElevatedButton(
                      onPressed: (){}, 
                      child: Text('Logout', style: TextStyle(fontSize: 16, color: Colors.black, ),))
                  ),
                )
          ],
        ),
        
      ),
    );
  }
}
