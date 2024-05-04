// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/my_button.dart';
import 'package:untitled/square_tale.dart';
import 'my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

 // sign in method
 void signUserIn() async {

   // show loading circle
   showDialog(context: context, builder: (context) {
     return Center(
       child: CircularProgressIndicator(),
     );
   },);

   try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: usernameController.text,
       password: passwordController.text,
     );
     Navigator.pop(context);
   } on FirebaseAuthException catch (e) {
     Navigator.pop(context);
     // error message
     showErrorMessage(e.code);
   }
 }

 // show error message to user
 void showErrorMessage(String message) {
   showDialog(
     context: context,
     builder: (context) {
       return AlertDialog(
         backgroundColor: Colors.deepPurple,
         title: Center(
             child: Text(
               message,
               style: TextStyle(color: Colors.white),
             ),
         )
       );
       },
   );
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.gamepad,
                  size: 120,
                ),

                // greeting
                const SizedBox(height: 50),
                Text(
                    "Welcome back, you've missed!",
                  style: TextStyle(
                      color: Colors.grey[900],
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),


                // username text field
                MyTextField(
                  controller: usernameController,
                  obscureText: false,
                  hintText: "Email",
                ),

                const SizedBox(height: 10),

                // password text field
                MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                ),
                const SizedBox(height:25),
                // sign in button
                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
                ),

                const SizedBox(height: 60),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            "Or continue with:",
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // google, apple sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    SquareTile(imagePath: "lib/images_png/Google_logo.png"),

                    SizedBox(width: 25),
                    // apple button
                    SquareTile(imagePath: "lib/images_png/Apple_logo.png")
                  ],
                ),
                const SizedBox(height: 40),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Not a member?",
                      style: TextStyle(
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                          "Register now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
