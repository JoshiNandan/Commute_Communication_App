import 'package:flutter/material.dart';
import 'package:projects_flutter/FirstPage.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                children: [
                  // Background Color
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Color(0xFFFFFFFF), // Base background
                  ),

                  // First curved container (Top Left Corner)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 30,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Color(0xFF52A3F5), // Medium blue
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(500),
                        ),
                      ),
                    ),
                  ),
                  // Second curved container (Bottom Right Corner)
                  Positioned(
                    bottom: 0,
                    left: 30,
                    right: 0,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Color(0xFF97CEF6), // Light blue
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Foreground content
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),

                  // Profile container
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(
                          Icons.person_outline_rounded,
                          size: 100,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Employee Code:IT@203',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Stop:Waghodia Road',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Travelled Days:20',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 70),

                  // Additional details can be added here
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 30, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Department: Designing",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Mobile: 9876543210",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Email: EmpCode@email.com",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Date of Joining: 12th May, 2025",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text("Gender: Male", style: TextStyle(fontSize: 20)),
                        SizedBox(height: 50),
                        Row(children: [SizedBox(width: 130)]),
                      ],
                    ),
                  ),

                  SizedBox(height: 1000),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  },
                  icon: Icon(Icons.home, color: Colors.black),
                ),
                Text('Home', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) {
                        return Container(
                          color: Color(0xFFBBDEFB),
                          padding: EdgeInsets.all(20),
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bus Information',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bus Number: MH12 AB 1234',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Route: Pune Station → Hinjewadi',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'ETA: 12 mins',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.directions_bus, color: Colors.black),
                ),

                Text(
                  'Bus',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) {
                        return Container(
                          color: Color(0xFFBBDEFB),
                          padding: EdgeInsets.all(20),
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row with title and close button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Driver Information',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // Driver details
                              Text(
                                'Name: John Doe',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Contact No: 9898766421',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Experience: 5 Years',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.person, color: Colors.black),
                ),

                Text('Driver', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
