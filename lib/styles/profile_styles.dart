import 'package:flutter/material.dart';

class ProfileStyles {
  // Style for the profile name
  static const TextStyle nameStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Style for the profile email
  static const TextStyle emailStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  // Style for profile bio or additional information
  static const TextStyle bioStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
    fontStyle: FontStyle.italic,
  );

  // Style for profile section headings
  static const TextStyle sectionHeadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.blueGrey,
  );

  // Style for profile action buttons
  static const TextStyle actionButtonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Style for profile details (e.g., age, location)
  static const TextStyle detailStyle = TextStyle(
    fontSize: 14,
    color: Colors.black45,
  );

  // Decoration for profile card or container
  static const BoxDecoration profileCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 4),
        blurRadius: 8.0,
      ),
    ],
  );

  // Elevated button style for profile actions
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue, // Button background color
    onPrimary: Colors.white, // Button text color
    textStyle: actionButtonStyle,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  // Outlined button style for profile actions
  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.blue, // Button border and text color
    side: BorderSide(color: Colors.blue),
    textStyle: actionButtonStyle,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  // Text field decoration for profile editing
  static final InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    labelText: 'Enter information',
    hintText: 'E.g., Full name, email address',
  );
}
