import 'package:flutter/material.dart';

class CropStyles {
  // Title text style for crop-related titles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Description text style for crop-related descriptions
  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  // Subtitle text style for additional crop information
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );

  // Label text style for form fields related to crops
  static const TextStyle labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  // Text style for crop information on the detail screen
  static const TextStyle infoStyle = TextStyle(
    fontSize: 14,
    color: Colors.black45,
  );

  // Heading text style for crop categories or sections
  static const TextStyle sectionHeadingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey,
  );

  // Text style for crop statistics or data
  static const TextStyle dataStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.green,
  );

  // Button text style for crop-related actions
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Decoration for crop cards or list items
  static BoxDecoration cardDecoration = BoxDecoration(
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

  // Elevated button style for crop-related actions
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.green,
    onPrimary: Colors.white,
    textStyle: buttonTextStyle,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  // Outlined button style for crop-related actions
  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.green,
    side: BorderSide(color: Colors.green),
    textStyle: buttonTextStyle,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  // Text field decoration for crop-related input
  static InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    labelText: 'Enter crop detail',
    hintText: 'E.g., Crop name, description',
  );
}
