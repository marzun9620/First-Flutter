import 'package:flutter/material.dart';

class Landing_page extends StatefulWidget {
  const Landing_page({super.key});

  @override
  State<Landing_page> createState() => _Landing_pageState();
}

class _Landing_pageState extends State<Landing_page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EcoSync',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.green[200],
          image: DecorationImage(
            image: AssetImage('assets/nature_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.green.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to EcoSync',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your login logic here
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
