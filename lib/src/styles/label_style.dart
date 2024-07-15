import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LabelStyle {
  final Color color;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final double height;

  final int animationInMilliseconds;
  LabelStyle(
      {required this.color,
      this.border,
      required this.height,
      this.borderRadius,
      this.animationInMilliseconds = 300});
}
