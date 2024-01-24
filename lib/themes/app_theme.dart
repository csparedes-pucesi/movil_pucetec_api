// import 'package:flutter/material.dart ';

import 'package:flutter/material.dart';

const Color _customColor = Color(0xff49149f);
const List<Color> _colorTheme = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
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
