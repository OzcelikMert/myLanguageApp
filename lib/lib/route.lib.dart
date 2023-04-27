import 'package:flutter/material.dart';

class RouteLib {
  final BuildContext context;

  RouteLib(this.context);

  change({required String target, bool? safeHistory}) {
    if(safeHistory == true){
      Navigator.pushNamed(context, target);
    }else {
      Navigator.pushNamedAndRemoveUntil(context, target, (r) => false);
    }
  }
}