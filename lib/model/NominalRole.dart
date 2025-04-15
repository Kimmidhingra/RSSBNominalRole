class NominalRole {
  int? id;
  final String jathedarName;
  final String jathedarPhoneNumber;
  final String vehicleType;
  final String vehicleNumber;
  final String driverName;
  final String driverPhoneNumber;
  final String zone = "3";
  final String area = "Fridabad";
  final String sewaType;
  final DateTime sewaStartDate;
  final DateTime sewaEndDate;
  final int numberOfDays;

  NominalRole(
      {this.id,
      required this.jathedarName,
      required this.jathedarPhoneNumber,
      required this.vehicleType,
      this.vehicleNumber = "NA",
      this.driverName = "NA",
      this.driverPhoneNumber = "NA",
      required this.sewaType,
      required this.sewaStartDate,
      required this.sewaEndDate,
      required this.numberOfDays});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jathedar_name': jathedarName,
      'jathedar_phone_no': jathedarPhoneNumber,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'driver_name': driverName,
      'driver_phone_number': driverPhoneNumber,
      'zone': zone,
      'area': area,
      'sewaType': sewaType,
      'sewa_start_date': sewaStartDate.toIso8601String(),
      'sewa_end_date': sewaEndDate.toIso8601String(),
      'number_of_days': numberOfDays
    };
  }

  factory NominalRole.fromMap(Map<String, dynamic> map) {
    return NominalRole(
      id: map['id'] as int?,
      jathedarName: map['jathedar_name'] as String,
      jathedarPhoneNumber: map['jathedar_phone_no'] as String,
      vehicleType: map['vehicle_type'] as String,
      vehicleNumber: map['vehicle_number'] as String,
      driverName: map['driver_name'] as String,
      driverPhoneNumber: map['driver_phone_number'] as String,
      sewaType: map['sewaType'] as String,
      sewaStartDate: DateTime.parse(map["sewa_start_date"]),
      // DateTime.fromMicrosecondsSinceEpoch(map["sewa_start_date"] as int),
      sewaEndDate: DateTime.parse(map["sewa_end_date"]),
      numberOfDays: map['number_of_days'] as int,
    );
  }
}
