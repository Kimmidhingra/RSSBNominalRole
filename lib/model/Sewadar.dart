class Sewadar {
  final int? id;
  final String? adhar_badge;
  final String sewadar_name;
  final String guardian_name;
  final String? address;
  final String? contact;
  final String? remarks;
  final String gender;
  final int age;
  final String? adhar_no;
  final String? badge_no;

  Sewadar(
      {this.id,
      this.adhar_badge,
      required this.sewadar_name,
      required this.guardian_name,
      this.address,
      this.contact,
      this.remarks,
      required this.gender,
      required this.age,
      this.adhar_no,
      this.badge_no});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adhar_badge': adhar_badge,
      'sewadar_name': sewadar_name,
      'guardian_name': guardian_name,
      'address': address,
      'contact': contact,
      'remarks': remarks,
      'gender': gender,
      'age': age,
      'adhar_no': adhar_no,
      'badge_no': badge_no
    };
  }

  factory Sewadar.fromMap(Map<String, dynamic> map) {
    return Sewadar(
        id: map['id'],
        adhar_badge: map['adhar_badge'],
        sewadar_name: map['sewadar_name'],
        guardian_name: map['guardian_name'],
        address: map['address'],
        contact: map['contact'],
        remarks: map['remarks'],
        gender: map['gender'],
        age: map['age'],
        adhar_no: map['adhar_no'],
        badge_no: map['badge_no']);
  }

  @override
  String toString() {
    return "Sewadar("
        "id: $id, "
        "adhar_badge: $adhar_badge, "
        "sewadar_name: $sewadar_name, "
        "guardian_name: $guardian_name, "
        "address: $address, "
        "contact: $contact, "
        "remarks: $remarks, "
        "gender: $gender, "
        "age: $age, "
        "adhar_no: $adhar_no, "
        "badge_no: $badge_no)";
  }
}
