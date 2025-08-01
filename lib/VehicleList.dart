import 'package:projects_flutter/vehicle_model.dart';

class VehicleList {
  final List<Vehicle> vehicles;

  VehicleList({required this.vehicles});

  factory VehicleList.fromJson(List<dynamic> json) {
    List<Vehicle> vehicleList = json.map((i) => Vehicle.fromJson(i)).toList();
    return VehicleList(vehicles: vehicleList);
  }
}