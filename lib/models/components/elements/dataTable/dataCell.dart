import 'package:flutter/material.dart';

class ComponentDataCellModule<T>  {
  final Widget Function(T row) child;

  const ComponentDataCellModule({required this.child});
}