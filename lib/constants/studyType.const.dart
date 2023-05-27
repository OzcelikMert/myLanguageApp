class StudyTypeConst {
  static const daily = 1;
  static const weekly = 2;
  static const monthly = 3;

  static getTypeName(int type) {
    String name = "";
    switch(type) {
      case StudyTypeConst.daily: name = "Daily"; break;
      case StudyTypeConst.weekly: name = "Weekly"; break;
      case StudyTypeConst.monthly: name = "Monthly"; break;
    }
    return name;
  }
}