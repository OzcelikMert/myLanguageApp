import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/file.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';
import 'package:permission_handler/permission_handler.dart';

class ComponentSideBar extends StatefulWidget {
  const ComponentSideBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComponentSideBarState();
}

class _ComponentSideBarState extends State<ComponentSideBar> {
  Color? getActiveBG(String? routeName, String itemRouteName) {
    return routeName == itemRouteName ? ThemeConst.colors.dark : null;
  }

  void onClickReturnHome() async {
    await DialogLib.show(context, ComponentDialogOptions(icon: ComponentDialogIcon.loading));
    var result = await LanguageService.update(LanguageUpdateParamModel(
        whereLanguageId: Values.getLanguageId,
        languageIsSelected: 0
    ));
    if(result > 0){
      await RouteLib(context).change(target: '/');
    }
  }

  void onClickExport() async {
    if (await Permission.storage.request().isGranted) {
      DialogLib.show(
          context,
          ComponentDialogOptions(
              title: "Are you sure?",
              content: "Are you sure you want to export whole words?",
              showCancelButton: true,
              onPressed: (bool isConfirm) async {
                if (isConfirm) {
                  await DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "Loading...",
                          icon: ComponentDialogIcon.loading));
                  var words = await WordService.get(WordGetParamModel(wordLanguageId: Values.getLanguageId));
                  File? file = await FileLib.convertJsonStringToFile(fileName: "${Values.getLanguageName}.json", jsonString: jsonEncode(words));
                  if(file != null){
                    await FileLib.saveLocation(file);
                    DialogLib.show(
                        context,
                        ComponentDialogOptions(
                            title: "Successfully!",
                            content: "The file has saved successfully.",
                            icon: ComponentDialogIcon.success
                        ));
                  }else {
                    DialogLib.show(
                        context,
                        ComponentDialogOptions(
                            title: "Error!",
                            content: "It couldn't save.",
                            icon: ComponentDialogIcon.error
                        ));
                  }
                }
              }));
    }

  }

  void onClickImport() async {
    if (await Permission.storage.request().isGranted) {

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
              onTap: () async {
                await RouteLib(context).change(target: '/study/plan');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/word/add"),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Word'),
              onTap: () async {
                await RouteLib(context).change(target: '/word/add');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/word/list"),
            child: ListTile(
              leading: const Icon(Icons.list),
              title: const Text('List Words'),
              onTap: () async {
                await RouteLib(context).change(target: '/word/list');
              },
            ),
          ),
          Container(
            child: ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Words'),
              onTap: () => onClickExport(),
            ),
          ),
          Container(
            child: ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Import Words'),
              onTap: () => onClickImport(),
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/settings"),
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () async {
                await RouteLib(context).change(target: '/settings');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/"),
            child: ListTile(
              leading: const Icon(Icons.keyboard_return),
              title: const Text('Return Home'),
              onTap: () => onClickReturnHome(),
            ),
          ),
        ],
      ),
    );
  }
}
