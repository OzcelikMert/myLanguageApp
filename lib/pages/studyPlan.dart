import 'package:flutter/material.dart';
import 'package:my_language_app/components/pages/studyPlan/studyTypeButton.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';

class PageStudyPlan extends StatefulWidget {
  const PageStudyPlan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageStudyPlanState();
}

class _PageStudyPlanState extends State<PageStudyPlan> {
  late bool _statePageIsLoading = true;
  late Map<String, dynamic> _stateLanguage = {};
  late List<Map<String, dynamic>> _stateWordCountReports = [];

  void onClickStudy(int type) {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content: "You have selected '" +
                StudyTypeConst.getTypeName(type) +
                "'. Are you sure about this?",
            onPressed: (bool isConfirm) {
              if (isConfirm) {
                RouteLib(context)
                    .change(target: StudyTypeConst.getRouteName(type));
              }
            }));
  }

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var languages = await LanguageService.get(
        LanguageGetParamModel(languageId: Values.getLanguageId));
    var wordCountReports = await WordService.getCountReport(
        WordGetCountReportParamModel(wordLanguageId: Values.getLanguageId));

    setState(() {
      _stateLanguage = languages[0];
      _stateWordCountReports = wordCountReports;
      _statePageIsLoading = false;
    });
  }

  Widget componentDaily() {
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: StudyTypeConst.Daily);
    var studiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 1);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    return ComponentStudyTypeButton(
        bgColor: ThemeConst.colors.success,
        title: StudyTypeConst.getTypeName(StudyTypeConst.Daily),
        onStartPressed: () => onClickStudy(StudyTypeConst.Daily),
        totalWords: reports.isNotEmpty
            ? reports.map((e) => e["wordCount"]).reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports.map((e) => e["wordCount"]).reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e["wordCount"])
                .reduce((a, b) => a + b)
            : 0);
  }

  Widget componentWeekly() {
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: StudyTypeConst.Weekly);
    var studiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 1);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    return ComponentStudyTypeButton(
        bgColor: ThemeConst.colors.danger,
        title: StudyTypeConst.getTypeName(StudyTypeConst.Weekly),
        onStartPressed: () => onClickStudy(StudyTypeConst.Weekly),
        totalWords: reports.isNotEmpty
            ? reports.map((e) => e["wordCount"]).reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports.map((e) => e["wordCount"]).reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e["wordCount"])
                .reduce((a, b) => a + b)
            : 0);
  }

  Widget componentMonthly() {
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: StudyTypeConst.Monthly);
    var studiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 1);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    return ComponentStudyTypeButton(
        bgColor: ThemeConst.colors.info,
        title: StudyTypeConst.getTypeName(StudyTypeConst.Monthly),
        onStartPressed: () => onClickStudy(StudyTypeConst.Monthly),
        totalWords: reports.isNotEmpty
            ? reports.map((e) => e["wordCount"]).reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports.map((e) => e["wordCount"]).reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e["wordCount"])
                .reduce((a, b) => a + b)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
        isLoading: _statePageIsLoading,
        title: "Study Plan",
        withScroll: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              componentDaily(),
              Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
              componentWeekly(),
              Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
              componentMonthly(),
            ],
          ),
        ));
  }
}
