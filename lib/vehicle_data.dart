class VehicleData {
  final String vehicleName;
  final String company;
  final String latitude;
  final String longitude;
  final String speed;
  final String status;
  final String gps;
  final String ign;
  final String ac;
  final String power;
  final String location;
  final String gpsActualTime;
  final String datetime;
  final String vehicleNo;
  final String driverFirstName;
  final String driverLastName;
  final String Vehicletype;
  final String DeviceModel;

  VehicleData({
    required this.DeviceModel,
    required this.vehicleName,
    required this.Vehicletype,
    required this.company,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.status,
    required this.gps,
    required this.ign,
    required this.ac,
    required this.power,
    required this.location,
    required this.gpsActualTime,
    required this.datetime,
    required this.vehicleNo,
    required this.driverFirstName,
    required this.driverLastName,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      vehicleName: json['Vehicle_Name'] ?? '',
      company: json['Company'] ?? '',
      latitude: json['Latitude'] ?? '',
      longitude: json['Longitude'] ?? '',
      speed: json['Speed'] ?? '',
      status: json['Status'] ?? '',
      gps: json['GPS'] ?? '',
      ign: json['IGN'] ?? '',
      ac: json['AC'] ?? '',
      power: json['Power'] ?? '',
      location: json['Location'] ?? '',
      gpsActualTime: json['GPSActualTime'] ?? '',
      datetime: json['Datetime'] ?? '',
      vehicleNo: json['Vehicle_No'] ?? '',
      driverFirstName: json['Driver_First_Name'] ?? '',
      driverLastName: json['Driver_Last_Name'] ?? '',
      Vehicletype: json['Vehicletype'] ?? '',
      DeviceModel: json['DeviceModel'] ?? '',
    );
  }
}
