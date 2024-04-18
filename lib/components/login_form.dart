import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

   final _formKey = GlobalKey<FormState>();  

   final _emailController = TextEditingController();
   final _passwordController = TextEditingController();
   bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         
           TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.orangeAccent,
            decoration:  InputDecoration(
              hintText: 'Email',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Colors.orangeAccent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), 
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), 
                borderSide: const BorderSide(
                  color: Colors.orangeAccent, 
                  width: 2.0, 
                ),
              ),
            ),
          ),
          const SizedBox(height: 15,),
           TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Colors.orangeAccent,
            obscureText: obscurePass,
            decoration:  InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.lock_outline),
              prefixIconColor: Colors.orangeAccent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), 
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), 
                borderSide: const BorderSide(
                  color: Colors.orangeAccent, 
                  width: 2.0, 
                ),
              ),
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    obscurePass = !obscurePass;
                  });
                },
                icon: obscurePass ? 
                const Icon(Icons.visibility_off_outlined, color: Colors.black38,) :
                const Icon(Icons.visibility_outlined, color: Colors.orangeAccent,) 
,
              )
            ),
          ),           
          const SizedBox(height: 30,),
          TextButton(
            onPressed: () async{
              final token = await DioProvider().getToken(_emailController.text, _passwordController.text);
              if(token){
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                final tokenValue = prefs.getString('token') ?? '';

                if(tokenValue.isNotEmpty && token !=''){
                  final userDetail = await DioProvider().getUser(tokenValue);

                  final userData = json.decode(userDetail);
                  print(userData);

                  if(userData != null){
                    MyApp.navigatorKey.currentState!.pushNamed('main_layout', arguments: userData);
                  }

                }


              }

            },
             style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
              overlayColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 179, 174, 174)),
            ),
             child: const Text(
              'Sign In',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),
             )
             ),
             
        ],
      )
 
    );
  }
}