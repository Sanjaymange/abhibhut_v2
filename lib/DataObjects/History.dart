class History {
  String app_name;
  int start_time;
  int end_time;

  History(
      {required this.app_name,
      required this.start_time,
      required this.end_time});

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      app_name: map['app_name'],
      start_time: map['start_time'],
      end_time: map['end_time'],
    );
  }
}
