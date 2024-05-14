// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:PS_project/my_button.dart';
import 'my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up method
  void signUserUp() async {
    showDialog(context: context, builder: (context) {
      return Center(child: CircularProgressIndicator());
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Create user with FirebaseAuth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        // User registration successful, now add user details to Firestore
        User? user = userCredential.user;

        if (user != null) {
          // You might want to store other details, like displayName, photoURL, etc.
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': user.email, // saving email
            // add other fields as needed
          });
        }

        Navigator.pop(context); // Close the CircularProgressIndicator

        // You might want to navigate the user to another screen or show a success message
      } else {
        Navigator.pop(context); // Remove CircularProgressIndicator first
        showErrorMessage("Passwords do not match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
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
                const SizedBox(height: 90),
                // logo
                const Icon(
                  Icons.gamepad,
                  size: 120,
                ),
                // greeting
                const SizedBox(height: 50),
                Text(
                  "Let's create an account for you!",
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
                const SizedBox(height:10),
                // confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirm Password",
                ),
                const SizedBox(height:25),
                // sign up button
                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),
                const SizedBox(height: 20),
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
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login now",
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
