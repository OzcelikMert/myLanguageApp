import 'package:flutter/material.dart';
import 'package:my_language_app/components/pages/studyPlan/studyTypeButton.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
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

  void onClickStudy(int type) async {
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: type);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    int totalWordCount = reports.isNotEmpty
        ? reports
        .map((e) => e[DBTableWords.asColumnCount])
        .reduce((a, b) => a + b)
        : 0;

    int unstudiedWordCount = unstudiedReports.isNotEmpty
        ? unstudiedReports
        .map((e) => e[DBTableWords.asColumnCount])
        .reduce((a, b) => a + b)
        : 0;

    if(totalWordCount == 0){
      DialogLib.show(
          context,
          ComponentDialogOptions(
              content: "There are no words. Please firstly you must add a word.",
              icon: ComponentDialogIcon.error));
    }else {
      DialogLib.show(
          context,
          ComponentDialogOptions(
              title: "Are you sure?",
              content: "You have selected '${StudyTypeConst.getTypeName(type)}'. ${unstudiedWordCount == 0 ? "If you continue your all words in '${StudyTypeConst.getTypeName(type)}' will set is 'unstudied'." : ""} Are you sure you want to continue?",
              showCancelButton: true,
              icon: ComponentDialogIcon.confirm,
              onPressed: (bool isConfirm) async {
                if (isConfirm) {
                  await DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "Loading...",
                          icon: ComponentDialogIcon.loading));

                  bool changeRoute = true;

                  if (unstudiedWordCount == 0) {
                    var wordUpdate = await WordService.update(
                        WordUpdateParamModel(
                            whereWordLanguageId: Values.getLanguageId,
                            whereWordStudyType: type,
                            wordIsStudy: 0));
                    if (wordUpdate < 1) {
                      changeRoute = false;
                    }
                  }

                  var date = DateTime.now().toUtc().toString();
                  var languageUpdate =
                  await LanguageService.update(LanguageUpdateParamModel(
                    whereLanguageId: Values.getLanguageId,
                    languageDailyUpdatedAt:
                    type == StudyTypeConst.Daily ? date : null,
                    languageWeeklyUpdatedAt:
                    type == StudyTypeConst.Weekly ? date : null,
                    languageMonthlyUpdatedAt:
                    type == StudyTypeConst.Monthly ? date : null,
                  ));

                  if(languageUpdate < 1){
                    changeRoute = false;
                  }

                  if (changeRoute) {
                    await RouteLib(context)
                        .change(target: "/study", arguments: {DBTableWords.columnStudyType: type});
                  } else {
                    DialogLib.show(
                        context,
                        ComponentDialogOptions(
                            content: "It couldn't continue!",
                            icon: ComponentDialogIcon.error));
                  }
                  return false;
                }
              }));
    }
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
        lastStudyDate: _stateLanguage[DBTableLanguages.columnDailyUpdatedAt].toString(),
        totalWords: reports.isNotEmpty
            ? reports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e[DBTableWords.asColumnCount])
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
        lastStudyDate: _stateLanguage[DBTableLanguages.columnWeeklyUpdatedAt].toString(),
        totalWords: reports.isNotEmpty
            ? reports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e[DBTableWords.asColumnCount])
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
        lastStudyDate: _stateLanguage[DBTableLanguages.columnMonthlyUpdatedAt].toString(),
        totalWords: reports.isNotEmpty
            ? reports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e[DBTableWords.asColumnCount])
                .reduce((a, b) => a + b)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
        isLoading: _statePageIsLoading,
        title: "Study Plan",
        withScroll: true,
        body: _statePageIsLoading ? Container() : Center(
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
