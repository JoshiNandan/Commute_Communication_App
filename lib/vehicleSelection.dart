import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator
import 'package:projects_flutter/FirstPage.dart';
import 'package:projects_flutter/VehicleList.dart';
import 'package:projects_flutter/vehicle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class vehicleSelection extends StatefulWidget {
  final VehicleList vehicleList; // Accept VehicleList as a parameter

  const vehicleSelection({Key? key, required this.vehicleList})
    : super(key: key);

  @override
  State<vehicleSelection> createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<vehicleSelection> {
  DateTime? lastBackPressTime; // To track the last back press time
  bool canClick = true; // To track if the user can click
  Timer? clickTimer; // Timer to manage click timing
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search input
  List<Vehicle> _filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _filteredVehicles =
        widget.vehicleList.vehicles; // Initialize with all vehicles
    _searchController.addListener(
      _filterVehicles,
    ); // Add listener to search controller
  }

  @override
  void dispose() {
    clickTimer?.cancel(); // Cancel the timer if the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  void _filterVehicles() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVehicles =
          widget.vehicleList.vehicles.where((vehicle) {
            return vehicle.vehicleNo.toLowerCase().contains(
              query,
            ); // Filter by vehicle number
          }).toList();
    });
  }

  Future<void> _refreshVehicles() async {
    setState(() {
      _filteredVehicles = widget.vehicleList.vehicles;
    });
    _filterVehicles(); // Re-apply search if anything typed
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
      child: Scaffold(
        body: Container(
          color: Colors.white, // Light background color
          padding: EdgeInsets.all(16.0), // Padding around the list
          child: Column(
            children: [
              SizedBox(height: 50), // Space at the top
              Center(
                child: Text(
                  'Select the Vehicle',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ), // Title styling
                ),
              ),
              SizedBox(height: 20), // Space between title and list
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by vehicle number',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              _filteredVehicles.isEmpty // Check if filtered vehicle list is empty
                  ? Center(
                    child: Text(
                      "No Vehicles Available",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                  : Expanded(
                child:RefreshIndicator(
                  onRefresh: _refreshVehicles,
                  child: ListView.builder(
                    itemCount: _filteredVehicles.length,
                    // Use the length of the filtered vehicle list
                    itemBuilder: (context, index) {
                      final vehicle =
                          _filteredVehicles[index]; // Get the vehicle at the current index
                      return Card(
                        elevation: 4,
                        // Shadow effect
                        margin: EdgeInsets.symmetric(vertical: 18.0),
                        // Space between cards
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Center the icon and speed
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 40,
                                color:
                                    vehicle.status == 'STOP'
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              Text('${vehicle.speed} km/h'),
                            ],
                          ), // Custom icon
                          title: Text(
                            vehicle.vehicleNo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ), // Bold title
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.date_range_sharp),
                                  SizedBox(width: 5),
                                  Text(
                                    "${vehicle.gpsActualTime}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 5),
                                  // Add spacing between icon and text
                                  Expanded(
                                    // Use Expanded to allow text to wrap
                                    child: Text(
                                      vehicle.location,
                                      maxLines: 3,
                                      // Limits text to max 3 lines
                                      overflow: TextOverflow.ellipsis,
                                      // Gracefully truncate if longer
                                      style: TextStyle(
                                        color: Colors.black,
                                      ), // Subtitle color
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.key,
                                        color:
                                            vehicle.ign == 'ON'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                      Text('Ignition'),
                                    ],
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.ac_unit,
                                        color:
                                            vehicle.ac == 'ON'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                      Text('AC'),
                                    ],
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Icon(Icons.local_gas_station),
                                      Text('Fuel'),
                                    ],
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.battery_charging_full,
                                        color:
                                            vehicle.ign == 'ON'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                      Text('Power'),
                                    ],
                                  ),
                                  SizedBox(width: 16),

                                  Column(
                                    children: [
                                      Icon(
                                        Icons.battery_alert,
                                        color: Colors.green,
                                      ),
                                      Text('0.00v'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (canClick) {
                              // Check if the user can click
                              // Store the selected vehicle number in SharedPreferences
                              var sharedPref =
                                  await SharedPreferences.getInstance();
                              sharedPref.setString(
                                'VehicleNo',
                                vehicle.vehicleNo,
                              );

                              // Show a SnackBar to confirm selection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Selected Vehicle: ${vehicle.vehicleNo}',
                                  ),
                                ),
                              );

                              // Navigate to another page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FirstPage(),
                                ),
                              );

                              // Disable further clicks
                              setState(() {
                                canClick = false; // Disable clicking
                              });

                              // Start a timer to re-enable clicking after 1 minute
                              clickTimer = Timer(Duration(minutes: 1), () {
                                setState(() {
                                  canClick = true; // Re-enable clicking
                                });
                              });
                            } else {
                              // Show a message if the user tries to click again too soon
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please wait for some time before selecting another vehicle.',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),

              )
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
      lastBackPressTime = now; // Update the last back press time
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press back again to exit the app.')),
      );
      return false; // Prevent the back navigation
    }
    // Close the application
    SystemNavigator.pop(); // This will close the app
    return true; // Allow the back navigation (exit the app)
  }
}
