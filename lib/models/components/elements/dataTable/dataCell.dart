import 'package:flutter/material.dart';

class ComponentDataCell<T>  {
  final Widget Function(T row) child;

  const ComponentDataCell({required this.child});
}