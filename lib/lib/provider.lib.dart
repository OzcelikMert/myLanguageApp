import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderLib {
  static T get<T>(BuildContext context, {bool listen = false}) {
    return Provider.of<T>(context, listen: listen);
  }
}