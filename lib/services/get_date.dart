getstartDate(int week) {
  DateTime now = DateTime.now();
  var mondayIndex = 1;

  while (now.weekday != mondayIndex) {
    now = now.subtract(new Duration(days: 1));
  }
  now = now.subtract(new Duration(days: week * 7));
  return now;
}

getendDate(int week) {
  DateTime now = DateTime.now();
  var sundayIndex = 7;

  while (now.weekday != sundayIndex) {
    now = now.add(new Duration(days: 1));
  }
  now = now.subtract(new Duration(days: week * 7));
  return now;
}

getFirstDayOfMonth(int month) {
  DateTime now = DateTime.now();
  return (DateTime(now.year, now.month - month, 1));
}

getEndDayOfMonth(int month) {
  DateTime now = DateTime.now();
  return (DateTime(now.year, now.month - month + 1, 0));
}

String getWeekDay(int dayInt) {
  List<String> daysOfTheWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  return daysOfTheWeek[dayInt - 1];
}
