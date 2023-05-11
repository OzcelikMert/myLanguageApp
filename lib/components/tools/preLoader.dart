import 'package:flutter/material.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/providers/page.provider.dart';

class ComponentPreLoader extends StatefulWidget {
  const ComponentPreLoader({Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComponentPreLoaderState();
}

class _ComponentPreLoaderState extends State<ComponentPreLoader> {
  @override
  Widget build(BuildContext context) {
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading ? AbsorbPointer(
      absorbing: true,
      child: Container(
        color: ThemeConst.colors.dark,
        child: Center(
          child: CircularProgressIndicator(
            color: ThemeConst.colors.primary,
            backgroundColor: ThemeConst.colors.light,
          ),
        ),
      ),
    ) : Visibility(visible: false, child: Text(""));
  }
}