import 'package:flutter/material.dart';

class Sos extends StatefulWidget {
  @override
  State<Sos> createState() => _Sos();
}

class _Sos extends State<Sos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFADAFB3), // Blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red,
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Raise SOS Alert',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              Row(
                children: [
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // You can add logic here if needed
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150.0, 150.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.black26, width: 5.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 40.0,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Medical Emergency",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic here if needed
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150.0, 150.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.black26, width: 5.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_police,
                          size: 40.0,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Call Police ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic here if needed
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150.0, 150.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.black26, width: 5.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, size: 40.0, color: Colors.black),
                        SizedBox(height: 10.0),
                        Text(
                          "Call to Company",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic here if needed
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150.0, 150.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.black26, width: 5.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fire_truck, size: 40.0, color: Colors.black),
                        SizedBox(height: 10.0),
                        Text(
                          "Fire Emergency",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  SizedBox(width: 110.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic here if needed
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150.0, 150.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.black26, width: 5.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bus_alert_sharp,
                          size: 40.0,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Accident",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyTile(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
