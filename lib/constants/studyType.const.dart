class StudyTypeConst {
  static const Daily = 1;
  static const Weekly = 2;
  static const Monthly = 3;

  static getTypeName(int type) {
    String name = "";
    switch(type) {
      case StudyTypeConst.Daily: name = "Daily"; break;
      case StudyTypeConst.Weekly: name = "Weekly"; break;
      case StudyTypeConst.Monthly: name = "Monthly"; break;
    }
    return name;
  }
}