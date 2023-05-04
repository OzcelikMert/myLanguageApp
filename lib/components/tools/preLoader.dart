import 'package:flutter/material.dart';
import 'package:my_language_app/constants/theme.const.dart';

class ComponentPreLoader extends StatefulWidget {
  final bool isLoading;

  const ComponentPreLoader({Key? key, required this.isLoading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComponentPreLoaderState();
}

class _ComponentPreLoaderState extends State<ComponentPreLoader> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading ? AbsorbPointer(
      absorbing: true,
      child: Container(
        color: ThemeConst.colors.dark,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ) : Visibility(visible: false, child: Text(""));
  }
}