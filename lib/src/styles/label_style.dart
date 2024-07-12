import 'package:flutter/material.dart';

class LabelStyle{
  final Color color;
  final EdgeInsets? padding;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final double height;

  LabelStyle({required this.color,  this.padding, this.border,required this.height, this.borderRadius});
}