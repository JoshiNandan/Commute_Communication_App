import 'package:flutter/material.dart';
import 'package:projects_flutter/VehicleList.dart';
import 'package:projects_flutter/vehicleSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _loginState();
}

class _loginState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(700),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Icon(
                      Icons.lock_open_rounded,
                      size: 80.0,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            Center(
                              child: Text(
                                'SignIn Account',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text(
                                  'Username',
                                  style: TextStyle(color: Colors.black),
                                ),
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline_sharp,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Employee Code is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text(
                                  'Password',
                                  style: TextStyle(color: Colors.black),
                                ),
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 40.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true; // Set loading to true
                                  });

                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  String userName = _userNameController.text;
                                  String password = _passwordController.text;
                                  sharedPref.setString('username', userName);
                                  sharedPref.setString('password', password);

                                  VehicleList? vehicleList =
                                      await ApiService.fetchVehicleList();
                                  setState(() {
                                    _isLoading = false; // Set loading to false
                                  });

                                  if (vehicleList != null &&
                                      vehicleList.vehicles.isNotEmpty) {
                                    // If the API call is successful and vehicles are available, navigate to vehicleSelection
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => vehicleSelection(
                                              vehicleList: vehicleList,
                                            ),
                                      ), // Pass the vehicleList
                                    );
                                  } else {
                                    // Show an error message if no vehicles are available or API call fails
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to fetch vehicle data. Enter the correct details.',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                minimumSize: Size(double.infinity, 50.0),
                              ),
                              child: Text(
                                'Login Account',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            // Show circular progress indicator if loading
                            if (_isLoading)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
