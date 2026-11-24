import 'package:flutter/material.dart';
import 'package:mylanguageapp/components/tools/page.dart';
import 'package:mylanguageapp/constants/page.const.dart';
import 'package:mylanguageapp/lib/provider.lib.dart';
import 'package:mylanguageapp/lib/voices.lib.dart';
import 'package:mylanguageapp/models/providers/keyboard.provider.model.dart';
import 'package:mylanguageapp/models/providers/language.provider.model.dart';
import 'package:mylanguageapp/models/providers/page.provider.model.dart';
import 'package:mylanguageapp/models/providers/tts.provider.model.dart';
import 'package:mylanguageapp/pages/settings.dart';
import 'package:mylanguageapp/pages/study.dart';
import 'package:mylanguageapp/pages/studySettings.dart';
import 'package:mylanguageapp/pages/wordAdd.dart';
import 'package:mylanguageapp/pages/languageAdd.dart';
import 'package:mylanguageapp/pages/home.dart';
import 'package:mylanguageapp/pages/wordList.dart';

import 'package:mylanguageapp/pages/studyPlan.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    try {
      final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);
      if (ttsProviderModel.voices.isEmpty) {
        await ttsProviderModel.setVoices(await VoicesLib.getVoices());
      }
    } catch (e) {
      print("_MyAppState _pageInit tts $e");
    }
  }

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
