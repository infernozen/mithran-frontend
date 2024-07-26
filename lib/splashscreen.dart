import 'package:flutter/material.dart';
import 'dart:async';
import 'screen/home-section/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Color> _colors = [
    Color(0xFF000000),
    Color(0xFF0A0A0A),
    Color(0xFF141414),
    Color(0xFF1E1E1E),
    Color(0xFF282828),
  ];

  final List<Alignment> _alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _index = (_index + 1) % _alignments.length;
      });
    });

    Timer(const Duration(seconds: 4), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: _alignments[_index],
            end: _alignments[(_index + 1) % _alignments.length],
            colors: [_colors[_index], _colors[(_index + 1) % _colors.length]],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/splashscreen/Mithran_logo.png', // Ensure you have your logo image in the assets folder
            width: 300, // Adjust size as needed
            height: 300,
          ),
        ),
      ),
    );
  }
}
