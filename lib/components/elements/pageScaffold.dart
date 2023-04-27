import 'package:flutter/material.dart';

import '../tools/sidebar.dart';

class ComponentPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool? hideAppBar;
  final bool? hideSidebar;
  final bool? withScroll;

  const ComponentPageScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.hideAppBar,
      this.hideSidebar,
      this.withScroll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar == true
            ? null
            : AppBar(
                title: Text(title),
              ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child:
                withScroll == true ? SingleChildScrollView(child: body) : body),
        drawer: hideSidebar == true ? null : const ComponentSideBar());
  }
}
