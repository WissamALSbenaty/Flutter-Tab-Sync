

import 'package:flutter/material.dart';

extension GlobalKeyUtils on GlobalKey{

  double get width=>(currentContext!.findRenderObject()as RenderBox).size.width;
  double get height=>(currentContext!.findRenderObject()as RenderBox).size.height;
}