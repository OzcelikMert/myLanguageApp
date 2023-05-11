import 'package:flutter/material.dart';

class RouteLib {
  static change({required BuildContext context, required String target, dynamic arguments, bool? safeHistory}) async {
    if(safeHistory == true){
      return await Navigator.pushNamed(context, target, arguments: arguments);
    }else {
      return await Navigator.pushNamedAndRemoveUntil(context, target, (r) => false, arguments: arguments);
    }
  }
}