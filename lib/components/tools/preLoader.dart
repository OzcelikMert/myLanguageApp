import 'package:flutter/material.dart';

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
        color: Colors.black12,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ) : Visibility(visible: false, child: Text(""));
  }
}