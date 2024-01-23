import 'package:flutter/material.dart ';


const Color _customColor = Color(0xff49149f);
const List<Color>_colorTheme = [
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
AppTheme({required this.selectedColor});
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorTheme[selectedColor],
      brightness: Brightness.dark,
    );
  }
}
