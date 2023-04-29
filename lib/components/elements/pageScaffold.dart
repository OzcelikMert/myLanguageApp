import 'package:flutter/material.dart';
import 'package:my_language_app/components/tools/preLoader.dart';

import '../tools/sidebar.dart';

class ComponentPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool? hideAppBar;
  final bool? hideSidebar;
  final bool? withScroll;
  final bool isLoading;

  const ComponentPageScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.hideAppBar,
      this.hideSidebar,
      this.withScroll,
      this.isLoading = true})
      : super(key: key);

  Widget _getBody() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: isLoading == true ? null : body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar == true || isLoading
            ? null
            : AppBar(
                title: Text(title),
              ),
        body: Stack(
          children: [
            (withScroll == true && !isLoading
                ? SingleChildScrollView(child: _getBody())
                : _getBody()),
            ComponentPreLoader(isLoading: isLoading)
          ],
        ),
        drawer:
            hideSidebar == true || isLoading ? null : const ComponentSideBar());
  }
}
