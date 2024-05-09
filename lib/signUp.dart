import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/login.dart';
import 'package:first_app/main.dart';
import 'package:first_app/uihelper.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signUp(String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      UiHelper.CustomAlertDialog(context, "Enter required fields");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NinjaCard()),
        );
      } on FirebaseAuthException catch (e) {
        UiHelper.CustomAlertDialog(context, e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Sign Up',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(
              emailController, "Email", Icons.email, false),
          UiHelper.CustomTextField(
              passwordController, "Password", Icons.password, true),
          SizedBox(
            height: 30.0,
          ),
          UiHelper.CustomButton(() {
            signUp(emailController.text, passwordController.text, context);
          }, "Sign Up"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("Login"))
            ],
          )
        ],
      ),
    );
  }
}
