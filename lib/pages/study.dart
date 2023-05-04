import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import '../components/elements/button.dart';

class PageStudy extends StatefulWidget {
  final int type;

  PageStudy({Key? key, required this.type}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => _PageStudyState();
}

class _PageStudyState extends State<PageStudy> {
  late bool _statePageIsLoading = true;
  late int _type = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    _pageInit();
  }

  _pageInit() async {
    setState(() {
      _statePageIsLoading = false;
    });
  }

  void onClickNext() {}

  void onClickApprove() {}

  void onClickBack() {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content: "You have selected 'daily'. Are you sure about this?",
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                RouteLib(context).change(target: "/study/plan");
              }
            }));
  }

  void onClickSettings() {
    RouteLib(context).change(target: "/study/settings", safeHistory: true);
  }

  String? onValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
        isLoading: _statePageIsLoading,
        title: "Study",
        hideAppBar: true,
        hideSidebar: true,
        withScroll: true,
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: ComponentIconButton(
                    onPressed: onClickBack,
                    icon: Icons.arrow_back,
                  ),
                ),
                Container(
                  child: ComponentIconButton(
                      onPressed: onClickSettings, icon: Icons.settings),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            Text(
              "[word]",
              style: TextStyle(fontSize: ThemeConst.fontSizes.lg),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            Text(
              "[comment]",
              style: TextStyle(fontSize: ThemeConst.fontSizes.md),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickApprove,
              submitButtonText: "Approve",
              submitButtonIcon: Icons.check,
              children: <Widget>[
                const Text("[Native or Target Language Name]"),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '...',
                  ),
                  validator: onValidator,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            ComponentButton(
              onPressed: onClickNext,
              text: "Skip Next",
              icon: Icons.arrow_forward,
              bgColor: ThemeConst.colors.secondary,
              reverseIconAlign: true,
            ),
          ],
        ));
  }
}
