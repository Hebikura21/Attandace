import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pages/database.dart';
import 'models_profile.dart';
import 'pages/models_absen.dart';

class ProfileBloc {
  final _profileStreamController = StreamController<Profile>();
  Stream<Profile> get profileStream => _profileStreamController.stream;

  final _attendanceStreamController = StreamController<List<Attendance>>();
  Stream<List<Attendance>> get attendanceStream =>
      _attendanceStreamController.stream;

  Future<void> fetchProfiles() async {
    final headers = {
      'accept': 'application/json',
      'Authorization':
          'Bearer ${await DatabaseHelper.instance.getToken() ?? ''}',
    };

    final response = await http.get(
      Uri.parse('https://absensi.codesantara.com/api/profiles'),
      headers: headers,
    );

    print(response.body); // Print the response body for debugging

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['data'] != null) {
        final profile = Profile.fromJson(jsonData['data']);
        _profileStreamController.sink.add(profile);
      } else {
        throw Exception('Invalid response format: Missing profile data');
      }
    } else if (response.statusCode == 401) {
      // Token expired or invalid, retrieve new token and try again
      final newToken = await retrieveNewToken();
      if (newToken != null) {
        await DatabaseHelper.instance.insertToken(newToken);
        await fetchProfiles(); // Use await to wait for the profiles to be fetched
      } else {
        throw Exception('Failed to retrieve new token');
      }
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  Future<void> fetchAttendance(String? selectedMonth, String? selectedYear) async {
  final headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer ${await DatabaseHelper.instance.getToken() ?? ''}',
  };

  final formattedMonth = selectedMonth?.padLeft(2, '0');
  final formattedYear = selectedYear;

  final response = await http.get(
    Uri.parse('https://absensi.codesantara.com/api/presences?month=$formattedMonth&year=$formattedYear'),
    headers: headers,
  );

  print(response.body); // Print the response body for debugging

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData['data'] != null) {
      final List<Attendance> attendanceList = [];
      for (var attendanceData in jsonData['data']) {
        final attendance = Attendance.fromJson(attendanceData);
        attendanceList.add(attendance);
      }
      _attendanceStreamController.sink.add(attendanceList);
    } else {
      throw Exception('Invalid response format: Missing attendance data');
    }
  } else if (response.statusCode == 401) {
    // Token expired or invalid, retrieve new token and try again
    final newToken = await retrieveNewToken();
    if (newToken != null) {
      await DatabaseHelper.instance.insertToken(newToken);
      await fetchAttendance(selectedMonth, selectedYear); // Use await to wait for the attendance to be fetched
    } else {
      throw Exception('Failed to retrieve new token');
    }
  } else {
    throw Exception('Failed to load attendance');
  }
}


  Future<String?> retrieveNewToken() async {
    // Perform the necessary steps to retrieve a new token from your authentication system
    // For example, making a login request and obtaining the token from the response
    // Replace the code below with your actual implementation

    final loginResponse = await http.post(
      Uri.parse('https://absensi.codesantara.com/api/login'),
      body: {
        'username': 'your_username',
        'password': 'your_password',
      },
    );

    if (loginResponse.statusCode == 200) {
      final loginData = jsonDecode(loginResponse.body);
      return loginData['token'];
    } else {
      return null;
    }
  }

  void dispose() {
    _profileStreamController.close();
    _attendanceStreamController.close();
  }
}
