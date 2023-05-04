import 'package:flutter/material.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class ComponentSideBar extends StatelessWidget {
  const ComponentSideBar({Key? key}) : super(key: key);

  Color? getActiveBG(String? routeName, String itemRouteName) {
    return routeName == itemRouteName ? ThemeConst.colors.dark : null;
  }

  void onClickReturnHome(BuildContext context) async {
    DialogLib.show(context, ComponentDialogOptions(icon: ComponentDialogIcon.loading));
    var result = await LanguageService.update(LanguageUpdateParamModel(
        languageId: Values.getLanguageId,
        languageIsSelected: 0
    ));

    if(result > 0){
      RouteLib(context).change(target: '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(child: Text(Values.getLanguageName)),
            decoration: BoxDecoration(
              color: ThemeConst.colors.primary,
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/study/plan"),
            child: ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Study Plan'),
              onTap: () {
                RouteLib(context).change(target: '/study/plan');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/word/add"),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Word'),
              onTap: () {
                RouteLib(context).change(target: '/word/add');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/word/list"),
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('List Words'),
              onTap: () {
                RouteLib(context).change(target: '/word/list');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/settings"),
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                RouteLib(context).change(target: '/settings');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/"),
            child: ListTile(
              leading: const Icon(Icons.keyboard_return),
              title: const Text('Return Home'),
              onTap: () => onClickReturnHome(context),
            ),
          ),
        ],
      ),
    );
  }
}
