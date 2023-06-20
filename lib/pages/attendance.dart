import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models_absen.dart';
import 'database.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  final String data;

  AttendancePage({Key? key, required this.data}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Attendance> attendanceList = [];
  late String selectedMonth;
  late String selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth =
        now.month.toString().padLeft(2, '0'); // Initial month (current month)
    selectedYear = now.year.toString(); // Initial year
    fetchAttendance(selectedMonth, selectedYear);
  }

  Future<void> fetchAttendance(String month, String year) async {
    try {
      final headers = {
        'accept': 'application/json',
        'Authorization':
            'Bearer ${await DatabaseHelper.instance.getToken() ?? ''}',
      };

      final url = Uri.parse(
          'https://absensi.codesantara.com/api/presences?month=${month}&year=${year}');
      final response = await http.get(
        url,
        headers: headers,
      );
      print(response.body); // Print the response body for debugging

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          List<dynamic> jsonList = jsonData['data'];
          List<Attendance> attendances =
              jsonList.map((json) => Attendance.fromJson(json)).toList();
          setState(() {
            attendanceList = attendances;
          });
        } else {
          throw Exception('Invalid response format: Missing attendance data');
        }
      } else if (response.statusCode == 401) {
        // Token expired or invalid, retrieve new token and try again
        final newToken = await retrieveNewToken();
        if (newToken != null) {
          await DatabaseHelper.instance.insertToken(newToken);
          await fetchAttendance(month, year); // Retry fetching attendance
        } else {
          throw Exception('Failed to retrieve new token');
        }
      } else {
        throw Exception('Failed to load attendance');
      }
    } catch (error) {
      print('Error: $error');
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

  Future<void> _showFilterDialog() async {
    String newMonth = selectedMonth;
    String newYear = selectedYear;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 17, 45, 78),
            title: const Text(
              'Filter Attendance',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Month:',
                  style: TextStyle(color: Colors.white),
                ),
                DropdownButton<String>(
                  dropdownColor: const Color.fromARGB(255, 17, 45, 78),
                  value: newMonth,
                  onChanged: (String? newValue) {
                    setState(() {
                      newMonth = newValue!;
                    });
                  },
                  items: <String>[
                    '01',
                    '02',
                    '03',
                    '04',
                    '05',
                    '06',
                    '07',
                    '08',
                    '09',
                    '10',
                    '11',
                    '12',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Year:',
                  style: TextStyle(color: Colors.white),
                ),
                DropdownButton<String>(
                  dropdownColor: const Color.fromARGB(255, 17, 45, 78),
                  value: newYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      newYear = newValue!;
                    });
                  },
                  items: <String>[
                    '2023', '2024', '2025' // Add more years if needed
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Filter', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  setState(() {
                    selectedMonth = newMonth;
                    selectedYear = newYear;
                  });
                  fetchAttendance(selectedMonth, selectedYear);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 45, 78),
        automaticallyImplyLeading: false,
        title: Text(
          'Attendance',
          style: GoogleFonts.akshar(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              fetchAttendance(
                  selectedMonth, selectedYear); // Refresh attendance
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF162A49), Color(0xFF2C3965)],
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // Wrap the ListView.builder with Container
                      height: MediaQuery.of(context).size.height -
                          300, // Adjust the height as needed
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: attendanceList.length,
                        itemBuilder: (context, index) {
                          Attendance attendance = attendanceList[index];
                          Color backgroundColor = index % 2 == 0
                              ? const Color(
                                  0xFF162A49) // Warna latar belakang untuk indeks genap
                              : const Color(0xFF2C3965);
                          return Container(
                            color: backgroundColor,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(attendance.name,
                                      style: GoogleFonts.akshar(
                                          color: Colors.white, fontSize: 20)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jam Masuk ${attendance.inTime}',
                                        style: GoogleFonts.abel(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      if (attendance.outTime != null)
                                        Text(
                                          'Jam Pulang ${attendance.outTime}',
                                          style: GoogleFonts.abel(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                    ],
                                  ),
                                  trailing: Text(
                                    '${attendance.date}',
                                    style: GoogleFonts.akshar(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _showFilterDialog,
        child: const Icon(
          Icons.filter_list,
          color: Colors.black,
        ),
      ),
    );
  }
}
