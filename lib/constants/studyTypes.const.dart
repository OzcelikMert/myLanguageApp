class StudyTypes {
  static const Daily = 1;
  static const Weekly = 2;
  static const Monthly = 3;

  static getTypeName(int type) {
    String name = "";
    switch(type) {
      case StudyTypes.Daily: name = "Daily"; break;
      case StudyTypes.Weekly: name = "Weekly"; break;
      case StudyTypes.Monthly: name = "Monthly"; break;
    }
    return name;
  }

  static getRouteName(int type) {
    String name = "";
    switch(type) {
      case StudyTypes.Daily: name = "daily"; break;
      case StudyTypes.Weekly: name = "weekly"; break;
      case StudyTypes.Monthly: name = "monthly"; break;
    }
    return "/study/$name";
  }
}