import 'package:flutter/material.dart';
import 'package:my_language_app/components/tools/preLoader.dart';

import 'sidebar.dart';

class ComponentPageScaffold<T> extends StatelessWidget {
  final String title;
  final Widget body;
  final bool? hideAppBar;
  final bool? hideSidebar;
  final bool? withScroll;
  final bool isLoading;
  final T? leadingArgs;

  const ComponentPageScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.hideAppBar,
      this.hideSidebar,
      this.withScroll,
      required this.isLoading, this.leadingArgs})
      : super(key: key);

  Widget _getBody() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: isLoading == true ? null : body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar == true || isLoading
            ? null
            : AppBar(
                centerTitle: true,
                title: Text(title),
                leading: Navigator.canPop(context) && hideSidebar == true ? BackButton(
                  onPressed: () {
                    Navigator.of(context).pop(leadingArgs);
                  },
                ) : null,
              ),
        body: Stack(
          children: [
            ComponentPreLoader(isLoading: isLoading),
            (withScroll == true && !isLoading
                ? SingleChildScrollView(child: _getBody())
                : _getBody()),
          ],
        ),
        drawer:
            hideSidebar == true || isLoading ? null : const ComponentSideBar());
  }
}
