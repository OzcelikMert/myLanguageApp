import 'package:flutter/material.dart';
import 'package:my_language_app/constants/studyTypes.const.dart';
import 'package:my_language_app/pages/study.dart';
import 'package:my_language_app/pages/wordAdd.dart';
import 'package:my_language_app/pages/languageAdd.dart';
import 'package:my_language_app/pages/home.dart';
import 'package:my_language_app/pages/wordList.dart';

import 'package:my_language_app/pages/studyPlan.dart';

void main() {
  runApp(const MyLanguageApp());
}

class MyLanguageApp extends StatelessWidget {
  const MyLanguageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Language App',
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        "/": (context) => const PageHome(),
        "/language/add": (context) => const PageLanguageAdd(),
        "/study/plan": (context) => const PageStudyPlan(),
        "/word/add": (context) => const PageWordAdd(),
        "/word/list": (context) => const PageWordList(),
        "/study/daily": (context) => const PageStudy(type: StudyTypes.Daily),
        "/study/weekly": (context) => const PageStudy(type: StudyTypes.Weekly),
        "/study/monthly": (context) => const PageStudy(type: StudyTypes.Monthly),
      }
    );
  }
}
