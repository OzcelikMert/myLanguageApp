import 'package:flutter/material.dart';

class ComponentPreLoader extends StatefulWidget {
  final bool isLoading;

  const ComponentPreLoader({Key? key, required this.isLoading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComponentPreLoaderState();
}

class _ComponentPreLoaderState extends State<ComponentPreLoader> {
  late bool _isAnimationEnd = false;

  @override
  Widget build(BuildContext context) {
    return !_isAnimationEnd ? AbsorbPointer(
      absorbing: widget.isLoading,
      child: AnimatedOpacity(
        onEnd: () => setState(() {
          _isAnimationEnd = true;
        }),
        curve: Curves.easeInOut,
        opacity: widget.isLoading ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          color: Colors.black12,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    ) : Container();
  }
}