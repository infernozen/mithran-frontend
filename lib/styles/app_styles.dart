import 'package:flutter/material.dart';

class AppStyles {
  // Heading text style
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Subheading text style
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Body text style
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  // Caption text style
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  // Button text style
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // AppBar title text style
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Error text style
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.red,
  );

  // Link text style
  static const TextStyle linkTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  // Custom container style with padding
  static BoxDecoration containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 2),
        blurRadius: 6.0,
      ),
    ],
  );

  // Elevated button style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    textStyle: buttonTextStyle,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  // Outlined button style
  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.blue,
    side: BorderSide(color: Colors.blue),
    textStyle: buttonTextStyle,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  // Text field decoration
  static InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    labelText: 'Input',
    hintText: 'Enter text here',
  );
}
