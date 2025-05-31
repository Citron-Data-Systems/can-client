
import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  final String hex = hexString.replaceAll('#', '');
  int colorValue;

  if (hex.length == 6) {
    colorValue = int.parse('FF' + hex, radix: 16);
  } else if (hex.length == 8) {
    colorValue = int.parse(hex, radix: 16);
  } else {
    throw FormatException('Invalid hex color format: $hexString');
  }

  return Color(colorValue);
}
