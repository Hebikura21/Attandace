import 'package:final_project/pages/attendance.dart';

import 'package:final_project/pages/home_barcode.dart';

import 'package:final_project/pages/profile.dart';
import 'package:flutter/material.dart';

class NavBarHome extends StatefulWidget {
  final String data;
  const NavBarHome({Key? key, required this.data}) : super(key: key);

  @override
  State<NavBarHome> createState() => _NavBarHomeState();
}

class _NavBarHomeState extends State<NavBarHome> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      DateTimeExample(),
      AttendancePage(data: widget.data),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books, color: Colors.white,),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.white,),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(
            255, 17, 45, 78),
        onTap: _onItemTapped,
      ),
    );
  }
}
