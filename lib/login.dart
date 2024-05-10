import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/main.dart';
import 'package:first_app/signUp.dart';
import 'package:first_app/uihelper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      // Navigate to home page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NinjaCard()), // Replace Home() with your home page
      );
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      UiHelper.CustomAlertDialog(
          context, e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UiHelper.CustomTextField(
                emailController,
                "Email",
                Icons.email,
                false,
              ),
              UiHelper.CustomTextField(
                passwordController,
                "Password",
                Icons.password,
                true,
              ),
              SizedBox(height: 30.0),
              UiHelper.CustomButton(() {
                signInWithEmailAndPassword(context);
              }, 'Login'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
