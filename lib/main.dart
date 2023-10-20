import 'package:flutter/material.dart';
import 'package:my_language_app/components/tools/page.dart';
import 'package:my_language_app/constants/page.const.dart';
import 'package:my_language_app/models/providers/keyboard.provider.model.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/providers/page.provider.model.dart';
import 'package:my_language_app/models/providers/tts.provider.model.dart';
import 'package:my_language_app/pages/settings.dart';
import 'package:my_language_app/pages/study.dart';
import 'package:my_language_app/pages/studySettings.dart';
import 'package:my_language_app/pages/wordAdd.dart';
import 'package:my_language_app/pages/languageAdd.dart';
import 'package:my_language_app/pages/home.dart';
import 'package:my_language_app/pages/wordList.dart';

import 'package:my_language_app/pages/studyPlan.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<LanguageProviderModel>(
                create: (_) => LanguageProviderModel()),
            ChangeNotifierProvider<TTSProviderModel>(
                create: (_) => TTSProviderModel()),
            ChangeNotifierProvider<KeyboardProviderModel>(
                create: (_) => KeyboardProviderModel())
          ],
          child: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Language App',
        theme: ThemeData.dark(),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          var routeName = settings.name;
          Function(BuildContext context) returnPage = (context) {};

          if(routeName == PageConst.routeNames.home) {
            returnPage = (context) => PageHome(context: context);
          }else if(routeName == PageConst.routeNames.settings) {
            returnPage = (context) => PageSettings(context: context);
          }else if(routeName == PageConst.routeNames.languageAdd) {
            returnPage = (context) => PageLanguageAdd(context: context);
          }else if(routeName == PageConst.routeNames.wordAdd) {
            returnPage = (context) => PageWordAdd(context: context);
          }else if(routeName == PageConst.routeNames.wordEdit) {
            returnPage = (context) => PageWordAdd(context: context);
          }else if(routeName == PageConst.routeNames.wordList) {
            returnPage = (context) => PageWordList(context: context);
          }else if(routeName == PageConst.routeNames.wordListStudied) {
            returnPage = (context) => PageWordList(context: context);
          }else if(routeName == PageConst.routeNames.study) {
            returnPage = (context) => PageStudy(context: context);
          }else if(routeName == PageConst.routeNames.studyPlan) {
            returnPage = (context) => PageStudyPlan(context: context);
          }else if(routeName == PageConst.routeNames.studySettings) {
            returnPage = (context) => PageStudySettings(context: context);
          }

          return MaterialPageRoute(builder: (context) => ChangeNotifierProvider<PageProviderModel>(
              create: (_) => PageProviderModel(),
              child: ComponentPage(child: returnPage(context)),
          ), settings: settings);
        });
  }
}
