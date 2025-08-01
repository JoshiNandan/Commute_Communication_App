import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projects_flutter/LocationComplaint.dart';
import 'package:projects_flutter/SOS.dart';
import 'package:projects_flutter/UserProfile.dart';
import 'package:projects_flutter/vehicle_data.dart';

import 'BusComplaint.dart';
import 'DriverComplaint.dart';
import 'api_service.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  VehicleData? vehicle;
  Timer? timer;
  bool isLoading = true;
  GoogleMapController? _mapController;
  double zoom = 17.0;

  @override
  void initState() {
    super.initState();
    fetchData();
    timer = Timer.periodic(Duration(seconds: 60), (_) => fetchData());
  }

  void fetchData() async {
    // Only set loading to true if it's the first fetch
    if (isLoading) {
      setState(() {
        isLoading = true; // Set loading to true only for the first fetch
      });
    }

    VehicleData? data = await ApiService.fetchVehicleData();
    print("Received: ${data?.latitude}, ${data?.longitude}");

    if (data != null) {
      setState(() {
        vehicle = data; // Update the vehicle variable with the fetched data
        isLoading = false; // Set loading to false after data is fetched
      });
    } else {
      // If data is null, keep the existing data and loading state
      setState(() {
        isLoading = false; // Stop loading even if data is null
      });
    }
  }

  @override
  void dispose() {
    timer
        ?.cancel(); // Cancel the timer to prevent it from running after the widget is disposed
    super.dispose(); // Call the superclass dispose method
  }

  final List<Map<String, dynamic>> buttonData = [
    {
      'label': 'Location Complaint',
      'icon': Icons.location_on_outlined,
      'route': Locationcomplaint(),
    },
    {
      'label': 'Vehicle Complaint',
      'icon': Icons.directions_bus,
      'route': Buscomplaint(),
    },
    {
      'label': 'Driver Complaint',
      'icon': Icons.person,
      'route': Drivercomplaint(),
    },
    {
      'label': 'SOS',
      'icon': Icons.report_gmailerrorred,
      'route': Sos(),
      'iconColor': Colors.red,
      'fontSize': 30.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Explicitly navigate back to VehicleSelection page
        Navigator.pop(context);
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          title: Center(
            child:
                vehicle == null
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        Text(
                          '${vehicle?.vehicleNo}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${vehicle?.datetime}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
          ),
        ),
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
                      color: Color(0xFFADAFB3), // Base background
                    ),

                    // First curved container (Bottom layer)
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

                    // Second curved container (Top layer)
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
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child:
                            vehicle == null
                                ? Center(child: CircularProgressIndicator())
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Vehicle No: ${vehicle!.vehicleNo.split('-')[0]}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Location: ${vehicle!.location}',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                      ),
                      SizedBox(height: 20),
                      vehicle == null
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 300,
                            width: double.infinity,
                            child: GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  double.tryParse(vehicle!.latitude) ?? 0.0,
                                  double.tryParse(vehicle!.longitude) ?? 0.0,
                                ),
                                zoom: zoom,
                              ),
                              mapToolbarEnabled: false,
                              // And this:
                              gestureRecognizers:
                                  Set()..add(
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('vehicle_marker'),
                                  position: LatLng(
                                    double.tryParse(vehicle!.latitude ?? '0') ??
                                        0.0,
                                    double.tryParse(
                                          vehicle!.longitude ?? '0',
                                        ) ??
                                        0.0,
                                  ),
                                  infoWindow: InfoWindow(
                                    title: "Vehicle: ${vehicle?.vehicleNo}",
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed,
                                  ),
                                ),
                              },
                            ),
                          ),
                      SizedBox(height: 50),
                      Center(
                        child: Row(
                          children: [
                            SizedBox(width: 40.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Locationcomplaint(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(130, 130.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Colors.black26,
                                    width: 5.0,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => Locationcomplaint(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.location_on_outlined,
                                      size: 40.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Location Complaint",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Buscomplaint(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(130.0, 130.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Colors.black26,
                                    width: 5.0,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Buscomplaint(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.directions_bus,
                                      size: 40.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Vehicle Complaint",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: Row(
                          children: [
                            SizedBox(width: 40.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Drivercomplaint(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(130.0, 130.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Colors.black26,
                                    width: 5.0,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => Drivercomplaint(),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.person),
                                    iconSize: 40,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Driver Complaint",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Sos(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(130.0, 130.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Colors.black26,
                                    width: 5.0,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Sos(),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.report_gmailerrorred),
                                    iconSize: 70,
                                    color: Colors.red,
                                  ),

                                  Text(
                                    "SOS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 10.0),
                    ],
                  ),
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
                      Navigator.pop(context);
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
                                      'Vehicle Information',
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
                                if (vehicle != null) ...{
                                  Text(
                                    'Vehicle type: ${vehicle!.Vehicletype ?? "N/A"}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Vehicle No: ${vehicle!.vehicleNo.split('-')[0] ?? "N/A"}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Vehicle Model: ${vehicle!.DeviceModel ?? "N/A"}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Status: ${vehicle!.status ?? "N/A"}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Speed: ${vehicle!.speed ?? "N/A"} Km/h',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                } else ...{
                                  Text(
                                    'No vehicle data available',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                },
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.directions_bus, color: Colors.black),
                  ),

                  Text(
                    'Vehicle',
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
                                  'First Name: ${vehicle?.driverFirstName ?? "N/A"} ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Last Name: ${vehicle?.driverLastName ?? "N/A"}',
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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Userprofile()),
                      );
                    },
                    icon: Icon(Icons.person, color: Colors.black),
                  ),
                  Text('Profile', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
