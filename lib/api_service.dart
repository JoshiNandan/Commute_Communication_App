import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects_flutter/VehicleList.dart';
import 'package:projects_flutter/vehicle_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<VehicleData?> fetchVehicleData() async {
    var sharedPref = await SharedPreferences.getInstance();
    String? vehicleNo = sharedPref.getString('VehicleNo');
    String? userName = sharedPref.getString('username');
    String? password = sharedPref.getString('password');

    if (userName == null || password == null || vehicleNo == null) return null;
    // the parameter passing in the form of the variables stored in the api_constants class
    final url = Uri.parse("http://sarvam.trackapp.in/webservice?token=getLiveData&user=$userName&pass=$password&vehicle_no=$vehicleNo&format=json");

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['root']['VehicleData'] is List &&
            jsonData['root']['VehicleData'].isNotEmpty) {
          final vehicleJson = jsonData['root']['VehicleData'][0];
          return VehicleData.fromJson(vehicleJson);
        } else {
          return null;
        }
      } else {
        print('Error fetching vehicle data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }

  static Future<VehicleList?> fetchVehicleList() async {
    var sharedPref = await SharedPreferences.getInstance();
    String? userName = sharedPref.getString('username');
    String? password = sharedPref.getString('password');

    if (userName == null || password == null) return null;
    // the paramater passing in the form of the variables stored in the api_constants class
    final url = Uri.parse("http://sarvam.trackapp.in/webservice?token=getLiveData&user=$userName&pass=$password&format=json");

    try {
      final responseList = await http.get(url).timeout(Duration(seconds: 10));
      if (responseList.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(responseList.body);
        if (jsonData['root']['VehicleData'] is List &&
            jsonData['root']['VehicleData'].isNotEmpty) {
          return VehicleList.fromJson(jsonData['root']['VehicleData']);
        } else {
          return null;
        }
      } else {
        print('Error fetching vehicle list: ${responseList.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }
}
