import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      UiHelper.CustomAlertDialog(context, "Enter required fields");
      return;
    }

    try {
      // Create user account in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await saveUserDataToFirestore(userCredential.user!);

      // Navigate to home page after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NinjaCard()),
      );
    } on FirebaseAuthException catch (e) {
      UiHelper.CustomAlertDialog(context, e.code.toString());
    }
  }

  Future<void> saveUserDataToFirestore(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference userDocRef = users.doc(user.uid);

    // Check if user collection exists
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    // Check if the document exists and contains data
    if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
      // Convert the data to a Map<String, dynamic>
      Map<String, dynamic> userData =
          userDocSnapshot.data()! as Map<String, dynamic>;
      print('Existing user data: $userData');
      // You can handle the existing user data here if needed
    } else {
      // User collection doesn't exist or is empty, create it and save user data
      await userDocRef.set({
        'uid': user.uid,
        'email': user.email,
        // Add additional user data fields as needed
      });
      print('User collection created and user data saved.');
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Login"),
              )
            ],
          )
        ],
      ),
    );
  }
}
