/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profiles = {};

  @override
  void initState() {
    super.initState();
    getProfiles();
  }

  Future<void> getProfiles() async {
    final headers = {
      'accept': 'application/json',
      'Authorization':
          'Bearer 18|HXccOQfD3eqD3yerRA2TvTUbZA3v11JjgBhEfjOF' // Ganti dengan token akses yang valid
    };

    final response = await http.get(
      Uri.parse('https://absensi.codesantara.com/api/profiles'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        profiles = jsonDecode(response.body);
      });
    } else {
      print('Failed to load profiles: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load profiles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (BuildContext context, int index) {
          final profile = profiles.values.elementAt(index);
          return ListTile(
            title: Text(profile['name'].),
            subtitle: Text(profile['occupation']),
            trailing: Text(profile['age'].toString()),
          );
        },
      ),
    );
  }
}
*/