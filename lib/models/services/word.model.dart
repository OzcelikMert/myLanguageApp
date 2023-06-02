import 'package:my_language_app/config/db/tables/words.dart';

class WordGetResultModel {
  final int wordId;
  final int wordLanguageId;
  final String wordTextTarget;
  final String wordTextNative;
  final String wordComment;
  final String wordCreatedAt;
  final String wordUpdatedAt;
  final int wordStudyType;
  final int wordIsStudy;
  final int wordType;

  WordGetResultModel({
    required this.wordId,
    required this.wordLanguageId,
    required this.wordTextTarget,
    required this.wordTextNative,
    required this.wordComment,
    required this.wordCreatedAt,
    required this.wordUpdatedAt,
    required this.wordStudyType,
    required this.wordIsStudy,
    required this.wordType
  });

  Map<String, dynamic> toJson() {
    return {
      DBTableWords.columnId: wordId,
      DBTableWords.columnLanguageId: wordLanguageId,
      DBTableWords.columnTextTarget: wordTextTarget,
      DBTableWords.columnTextNative: wordTextNative,
      DBTableWords.columnComment: wordComment,
      DBTableWords.columnCreatedAt: wordCreatedAt,
      DBTableWords.columnUpdatedAt: wordUpdatedAt,
      DBTableWords.columnStudyType: wordStudyType,
      DBTableWords.columnIsStudy: wordIsStudy,
      DBTableWords.columnType: wordType
    };
  }

  static WordGetResultModel fromJson(Map<String, dynamic> json) {
    return WordGetResultModel(
        wordId: int.tryParse(json[DBTableWords.columnId].toString()) ?? 0,
        wordLanguageId: int.tryParse(json[DBTableWords.columnLanguageId].toString()) ?? 0,
        wordTextTarget: json[DBTableWords.columnTextTarget].toString(),
        wordTextNative: json[DBTableWords.columnTextNative].toString(),
        wordComment: json[DBTableWords.columnComment].toString(),
        wordCreatedAt: json[DBTableWords.columnCreatedAt].toString(),
        wordUpdatedAt: json[DBTableWords.columnUpdatedAt].toString(),
        wordStudyType: int.tryParse(json[DBTableWords.columnStudyType].toString()) ?? 0,
        wordIsStudy: int.tryParse(json[DBTableWords.columnIsStudy].toString()) ?? 0,
        wordType: int.tryParse(json[DBTableWords.columnType].toString()) ?? 0
    );
  }
}

class WordGetCountReportResultModel {
  final int wordCount;
  final int wordStudyType;
  final int wordType;
  final int wordIsStudy;

  WordGetCountReportResultModel({
    required this.wordCount,
    required this.wordStudyType,
    required this.wordIsStudy,
    required this.wordType
  });

  Map<String, dynamic> toJson() {
    return {
      DBTableWords.asColumnCount: wordCount,
      DBTableWords.columnStudyType: wordStudyType,
      DBTableWords.columnIsStudy: wordIsStudy,
      DBTableWords.columnType: wordType,
    };
  }

  static WordGetCountReportResultModel fromJson(Map<String, dynamic> json) {
    return WordGetCountReportResultModel(
      wordCount: int.tryParse(json[DBTableWords.asColumnCount].toString()) ?? 0,
      wordStudyType: int.tryParse(json[DBTableWords.columnStudyType].toString()) ?? 0,
      wordIsStudy: int.tryParse(json[DBTableWords.columnIsStudy].toString()) ?? 0,
      wordType: int.tryParse(json[DBTableWords.columnType].toString()) ?? 0
    );
  }
}

class WordGetParamModel {
  final int? wordId;
  final int wordLanguageId;
  final String? wordTextTarget;
  final String? wordTextNative;
  final int? wordStudyType;
  final int? wordIsStudy;
  final int? wordType;

  WordGetParamModel({
    required this.wordLanguageId,
    this.wordId,
    this.wordStudyType,
    this.wordIsStudy,
    this.wordType,
    this.wordTextTarget,
    this.wordTextNative
  });
}

class WordGetCountParamModel {
  final int wordLanguageId;
  final int? wordStudyType;
  final int? wordIsStudy;
  final int? wordType;

  WordGetCountParamModel({
    required this.wordLanguageId,
    this.wordStudyType,
    this.wordIsStudy,
    this.wordType
  });
}

class WordGetCountReportParamModel {
  final int wordLanguageId;
  final int? wordStudyType;
  final int? wordType;

  WordGetCountReportParamModel({
    required this.wordLanguageId,
    this.wordStudyType,
    this.wordType
  });
}


class WordAddParamModel {
  final int wordLanguageId;
  final String wordTextTarget;
  final String wordTextNative;
  final String wordComment;
  final int wordStudyType;
  final int wordIsStudy;
  final int wordType;

  WordAddParamModel({
    required this.wordTextTarget,
    required this.wordTextNative,
    required this.wordLanguageId,
    required this.wordComment,
    required this.wordStudyType,
    required this.wordType,
    this.wordIsStudy = 0
  });
}

class WordUpdateParamModel {
  final int whereWordLanguageId;
  final int? whereWordId;
  final int? whereWordStudyType;
  final int? whereWordType;
  final String? wordTextTarget;
  final String? wordTextNative;
  final String? wordComment;
  final int? wordStudyType;
  final int? wordIsStudy;
  final int? wordType;

  WordUpdateParamModel({
    required this.whereWordLanguageId,
    this.whereWordId,
    this.whereWordStudyType,
    this.whereWordType,
    this.wordTextTarget,
    this.wordTextNative,
    this.wordComment,
    this.wordStudyType,
    this.wordIsStudy,
    this.wordType
  });
}

class WordDeleteParamModel {
  final int? wordId;
  final int? wordLanguageId;

  WordDeleteParamModel({
    this.wordId,
    this.wordLanguageId
  });
}