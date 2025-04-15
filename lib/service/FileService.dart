import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nominal_role/model/Sewadar.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

Future<void> createExcelFile(List<Sewadar> sewadars) async {
  debugPrint("Starting creating excel file");
  // 1. Create Excel
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sewadars'];
  sheet.appendRow([
    TextCellValue('s.no'),
    TextCellValue('badge_no/adhar_no'),
    TextCellValue('name of sewadar'),
    TextCellValue('Father/Husband\'s Name'),
    TextCellValue('M/F'),
    TextCellValue('age'),
    TextCellValue('address/phoneNo')
  ]);
  var counter = 0;
  for (var sewadar in sewadars) {
    sheet.appendRow([
      IntCellValue(counter++),
      TextCellValue(sewadar.adhar_badge ?? ""),
      TextCellValue(sewadar.sewadar_name),
      TextCellValue(sewadar.guardian_name),
      TextCellValue(sewadar.gender),
      IntCellValue(sewadar.age),
      TextCellValue(sewadar.address ?? ""),
    ]);
  }

  // 2. Get directory (Downloads or app directory)
  Directory? directory;
  if (Platform.isAndroid) {
    directory = await getExportDirectory();
  }
  String formattedDate = DateFormat('MMMdd_HHmm').format(DateTime.now());
  // String outputFile = "";

  String outputFile = "${directory!.path}/nominal_role_$formattedDate.xlsx";
  List<int>? fileBytes = excel.encode();

  if (fileBytes != null) {
    try {
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      debugPrint("Excel file saved at: $outputFile");
    } catch (e) {
      debugPrint("Error writing to file: $e");
    }
  } else {
    debugPrint("File bytes null");
  }
}

Future<void> createExcelFileUsingSyncFusion(List<Sewadar> sewadars) async {
  // 1. Create excel sheet
  final workBook = xlsio.Workbook();
  final sheet = workBook.worksheets[0];
  sheet.name = "sewadar_details";
  // 2. set Header
  final headers = [
    "S.No",
    "Badge_no/Aadhar_no",
    "Name of Sewadar",
    "Father/Husband's Name",
    "M/F",
    "age",
    "Address/Phone Number"
  ];
  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1) // row is 1
      ..setText(headers[i])
      ..autoFitColumns()
      ..cellStyle.bold = true;
  }
  // 3. Write user data
  for (int i = 0; i < sewadars.length; i++) {
    final sewadar = sewadars[i];
    sheet.getRangeByIndex(i + 2, 1).setText("${i + 1}");
    sheet.getRangeByIndex(i + 2, 2).setText(sewadar.adhar_badge);
    sheet.getRangeByIndex(i + 2, 3).setText(sewadar.sewadar_name);
    sheet.getRangeByIndex(i + 2, 4).setText(sewadar.guardian_name);
    sheet.getRangeByIndex(i + 2, 5).setText(sewadar.gender);
    sheet.getRangeByIndex(i + 2, 6).setText("${sewadar.age}");
    sheet.getRangeByIndex(i + 2, 7).setText(sewadar.address);
    for (int j = 1; j <= 7; j++) {
      sheet.getRangeByIndex(i + 2, j).cellStyle.wrapText = true;
    }
  }
  // Auto fit columns
  for (int j = 1; j <= 6; j++) {
    // Dont want to auto fit address/phone number column
    sheet.autoFitColumn(j);
  }
  // 2. Get directory (Downloads or app directory)
  Directory? directory;
  if (Platform.isAndroid) {
    directory = await getExportDirectory();
  }
  String formattedDate = DateFormat('MMMdd_HHmm').format(DateTime.now());
  // String outputFile = "";

  String outputFile = "${directory!.path}/nominal_role_$formattedDate.xlsx";
  final fileBytes = workBook.saveAsStream();
  workBook.dispose();
  // List<int>? fileBytes = excel.encode();

  try {
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
    debugPrint("Excel file saved at: $outputFile");
  } catch (e) {
    debugPrint("Error writing to file: $e");
  }
}

Future<Directory> getExportDirectory() async {
  final dir =
      await getExternalStorageDirectory(); // app-specific // /storage/emulated/0/Android/data/com.example.nominal_role/files/file_name
  // You can also use Downloads directory if you want:
  // directory = Directory('/storage/emulated/0/Download');
  final exportDirectory = Directory('${dir!.path}/nominal_roles');
  if (!(await exportDirectory.exists())) {
    return exportDirectory.create(recursive: true);
  }
  return exportDirectory;
}

Future<List<FileSystemEntity>> listFiles() async {
  final dir = await getExportDirectory();
  final allFiles = await dir.list().toList();
  return allFiles.where((file) {
    final name = file.path.toLowerCase();
    return name.endsWith('.xls') || name.endsWith('.xlsx');
  }).toList();
}

void openFile(FileSystemEntity file) {
  OpenFilex.open(file.path);
}
