import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nominal_role/service/FileService.dart';

class Nominalroledocscreen extends StatelessWidget {
  const Nominalroledocscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Nominal Role"),
      ),
      body: NominalRoleDoc(),
    );
  }
}

class NominalRoleDoc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NominalRoleDocState();
  }
}

class _NominalRoleDocState extends State<NominalRoleDoc> {
  List<FileSystemEntity> files = [];
  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final fetchedFiles = await listFiles();
    setState(() {
      files = fetchedFiles;
    });
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    try {
      await file.delete();
      _loadFiles();
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return files.isEmpty
        ? const Center(
            child: Text("No files found"),
          )
        : ListView.builder(
            itemCount: files.length,
            itemBuilder: (BuildContext context, int index) {
              final file = files[index];
              final fileName = file.path.split('/').last;
              return ListTile(
                leading: const Icon(
                  Icons.insert_drive_file,
                  color: Colors.green,
                ),
                title: Text(fileName),
                onTap: () => openFile(file),
                onLongPress: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("delete $fileName"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _deleteFile(file);
                              },
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            )
                          ],
                        )),
              );
            });
  }
}
