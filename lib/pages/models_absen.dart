class Attendance {
  int id;
  String name;
  String inTime;
  String? outTime;
  String date;

  Attendance({
    required this.id,
    required this.name,
    required this.inTime,
    required this.outTime,
    required this.date,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      name: json['name'],
      inTime: json['in'],
      outTime: json['out'] ?? '',
      date: json['date'],
    );
  }
}