import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_project/bloc.dart';
import 'package:final_project/pages/database.dart';
import 'package:final_project/pendukung/navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../icons/icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.blue,
            Colors.red,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 100),
                  const IconsCircle(imagePath: "lib/images/logo5.png"),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Login",
                      style: GoogleFonts.akshar(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Email Textformfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Menentukan radius sudut kotak
                          borderSide: const BorderSide(
                            color:
                                Colors.black, // Ubah warna border Email di sini
                          ),
                        ),
                        labelText: "Email",
                      ),
                      style: const TextStyle(
                          color: Colors.white), // Ubah warna teks input di sini
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email tidak Boleh Kosong";
                        }
                        return null;
                      },
                    ),
                  ),
                  // Password TexformField
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Menentukan radius sudut kotak
                          borderSide: const BorderSide(
                            color: Colors
                                .black, // Ubah warna border Password di sini
                          ),
                        ),
                        labelText: "Password",
                      ),
                      style: const TextStyle(
                          color: Colors.white), // Ubah warna teks input di sini
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Tidak Boleh Kosong";
                        }
                        return null;
                      },
                    ),
                  ),
                  // Login Button
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Menentukan radius sudut kotak
                        ),
                      ),
                      child: const Text("Masuk"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform login
                          loginApi(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginApi(String email, String password) async {
    final url = Uri.parse('https://absensi.codesantara.com/api/login/user');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Login successful
      final loginData = jsonDecode(response.body);
      final token = loginData['token'];

      // Save token to local database
      await DatabaseHelper.instance.insertToken(token);

      // Fetch profiles
      final profileBloc = ProfileBloc();
      await profileBloc.fetchProfiles();

      // Navigate to home screen
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return NavBarHome(data: '');
        },
      ));
    } else {
      // Login failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email atau password salah"),
        ),
      );
    }
  }

 
}
