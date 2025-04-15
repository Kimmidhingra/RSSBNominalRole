import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nominal_role/model/Sewadar.dart';
import 'package:nominal_role/utils/utils.dart';

Future<List<Sewadar>> readExcelFromAssets() async {
  List<Sewadar> sewadars = [];
  try {
    ByteData data = await rootBundle.load("assets/excel/master_list.xlsx");
    List<int> bytes = data.buffer.asUint8List();
    // Decode excel file
    var excel = Excel.decodeBytes(bytes);
    // Read first sheet
    // var sheetName = excel.tables.keys.first;
    // var sheet = excel.tables[sheetName];
    // Iterate through each sheet
    for (var table in excel.tables.keys) {
      var sheet = excel.sheets[table];
      // for (int i = 1; i < sheet!.rows.length; i++) {
      //   var row = sheet.rows[i];
      for (var row in sheet!.rows) {
        // String serialNumber = getCellValue(row.isNotEmpty ? row[0] : null);
        String adharBadge = getCellValue(row.length > 1 ? row[1] : null);
        String sewadarName = getCellValue(row.length > 2 ? row[2] : null);
        String guardianName = getCellValue(row.length > 3 ? row[3] : null);
        String gender = getCellValue(row.length > 4 ? row[4] : null);
        int age = getCellIntValue(row.length > 5 ? row[5] : null);
        String address = getCellValue(row.length > 6 ? row[6] : null);
        String? contact;
        if (address.isNotEmpty) {
          contact = getPhoneNumber(address) ?? "";
        }
        String adharNumber = getCellValue(row.length > 7 ? row[7] : null);
        String badgeNumber = getCellValue(row.length > 8 ? row[8] : null);
        String remarks = getCellValue(row.length > 9 ? row[9] : null);
        var sewadar = Sewadar(
            adhar_badge: adharBadge,
            sewadar_name: sewadarName,
            guardian_name: guardianName,
            address: address,
            contact: contact,
            remarks: remarks,
            gender: gender,
            age: age,
            adhar_no: adharNumber,
            badge_no: badgeNumber);
        sewadars.add(sewadar);
      }
    }
    sewadars.removeAt(0); // we have remove headers
  } catch (e) {
    debugPrint("Error reading Excel file: $e");
  }
  return sewadars;
}

// Function to safely extract a string value
String getCellValue(Data? cell) {
  return cell?.value?.toString() ?? "";
}

// Function to safely extract an integer value
int getCellIntValue(Data? cell) {
  return int.tryParse(cell?.value?.toString() ?? "0") ?? 0;
}
