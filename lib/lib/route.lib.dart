import 'package:flutter/material.dart';

class RouteLib {
  final BuildContext context;

  RouteLib(this.context);

  change({required String target, bool? safeHistory}) async {
    if(safeHistory == true){
      return await Navigator.pushNamed(context, target);
    }else {
      return await Navigator.pushNamedAndRemoveUntil(context, target, (r) => false);
    }
  }
}