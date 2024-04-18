import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/login_form.dart';
import 'package:food_delivery_app/components/register_form.dart';
import 'package:food_delivery_app/screens/forgot_password.dart';
import 'package:food_delivery_app/utils/text.dart';
import 'package:lottie/lottie.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isSignIn = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child:  CircleAvatar(
                    child: Lottie.asset('assets/bugger.json',
                    ),
                
                    ),
                  ),
                  ),
              Text( 
                isSignIn ? AppText.enText['welcome_back_text']! :
                AppText.enText['welcome_text']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              const SizedBox(height: 15,),
               Text(
                isSignIn ? AppText.enText['login_text']! :
                AppText.enText['register_text']!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
            
                ),
              ),
              const SizedBox(height: 20,),
               isSignIn ?  LoginForm() : const RegisterForm(),
              const SizedBox(height: 20,),
              isSignIn ? Container() 
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/google.png',
                  height: 30,
                  width: 30,
                  ),
                  TextButton(
                   onPressed: (){},
                   style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 226, 224, 224)),
                    overlayColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 173, 170, 170)),
                   ),
                   child: Text(
                    AppText.enText['google_login']!,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                 )
                 )
                ],
              ),
              SizedBox(height: 5),
              isSignIn ?
              TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPassword()));
                },
                 child: const Text(
                  'forgot password?',
                    style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold
                ),
              ),
              ) :
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    isSignIn ? AppText.enText['sign_up_text']!
                    : AppText.enText['registered_text']!,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn ? 'Sign Up' :'Sign In',
                      style: TextStyle(
                        color: Colors.blueAccent,fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              )

            ],
          )
          ),
     
      ),
    );
  }
}