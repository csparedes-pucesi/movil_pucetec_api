// import 'package:flutter/material.dart ';

import 'package:flutter/material.dart';

const Color _customColor = Color.fromARGB(255, 6, 176, 248);
const List<Color> _colorTheme = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Color.fromARGB(255, 76, 130, 175),
  Colors.orange,
  Colors.yellow,
  Colors.pink
];

class AppTheme {
  final int selectedColor;
  final bool isDark;
  AppTheme({required this.selectedColor, required this.isDark});
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorTheme[selectedColor],
      brightness: isDark == true ? Brightness.dark : Brightness.light,
    );
  }
}
