import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/pages/settings.dart';
import 'package:my_language_app/pages/study.dart';
import 'package:my_language_app/pages/studySettings.dart';
import 'package:my_language_app/pages/wordAdd.dart';
import 'package:my_language_app/pages/languageAdd.dart';
import 'package:my_language_app/pages/home.dart';
import 'package:my_language_app/pages/wordList.dart';

import 'package:my_language_app/pages/studyPlan.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyLanguageApp());
}

class MyLanguageApp extends StatelessWidget {
  MyLanguageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Language App',
        theme: ThemeData.dark(),
        initialRoute: "/",
        routes: {
          "/": (context) => const PageHome(),
          "/settings": (context) => const PageSettings(),
          "/language/add": (context) => const PageLanguageAdd(),
          "/word/add": (context) => PageWordAdd(context: context),
          "/word/edit": (context) => PageWordAdd(context: context),
          "/word/list": (context) => const PageWordList(),
          "/study": (context) => PageStudy(context: context),
          "/study/plan": (context) => const PageStudyPlan(),
          "/study/settings": (context) => PageStudySettings(context: context),
        }
    );
  }
}
