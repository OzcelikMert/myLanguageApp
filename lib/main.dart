import 'package:flutter/material.dart';
import 'package:my_language_app/constants/studyTypes.const.dart';
import 'package:my_language_app/pages/settings.dart';
import 'package:my_language_app/pages/study.dart';
import 'package:my_language_app/pages/studySettings.dart';
import 'package:my_language_app/pages/wordAdd.dart';
import 'package:my_language_app/pages/languageAdd.dart';
import 'package:my_language_app/pages/home.dart';
import 'package:my_language_app/pages/wordList.dart';

import 'package:my_language_app/pages/studyPlan.dart';

void main() {
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
        "/settings": (context) => PageSettings(),
        "/language/add": (context) => const PageLanguageAdd(),
        "/word/add": (context) => const PageWordAdd(),
        "/word/list": (context) => const PageWordList(),
        "/study/plan": (context) => const PageStudyPlan(),
        "/study/daily": (context) => PageStudy(type: StudyTypes.Daily),
        "/study/weekly": (context) => PageStudy(type: StudyTypes.Weekly),
        "/study/monthly": (context) => PageStudy(type: StudyTypes.Monthly),
        "/study/settings": (context) => PageStudySettings(),
      }
    );
  }
}
