import 'package:flutter/material.dart';
import 'package:nominal_role/common_widgets/pop_scope_wrapper.dart';
import 'package:nominal_role/model/NominalRole.dart';
import 'package:nominal_role/model/Sewadar.dart';
import 'package:nominal_role/service/DatabaseService.dart';
import 'package:nominal_role/service/FileService.dart';

class AddsewadarScreen extends StatelessWidget {
  const AddsewadarScreen({super.key, required this.nominalRole});
  final NominalRole nominalRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Nominal Role"),
      ),
      body: PopScopeWrapper(
          child: AddSewadar(
        nominalRole: nominalRole,
      )),
    );
  }
}

class AddSewadar extends StatefulWidget {
  const AddSewadar({super.key, required this.nominalRole});
  final NominalRole nominalRole;
  @override
  _AddSewadarState createState() => _AddSewadarState();
}

class _AddSewadarState extends State<AddSewadar> {
  List<Sewadar> allSewadars = [];
  List<Sewadar> filteredSewadars = [];
  List<Sewadar> selectedSewadars = [];
  Sewadar? selectedSewadar;
  TextEditingController searchController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  Future<void> getSewadarsMasterList() async {
    var list = await _databaseService.getSewadarMasterList();
    var sewadarAlreadyAddedList = await _databaseService
        .getSewadarAssignedToNominalRole(widget.nominalRole.id ?? 0);
//         for(var sewadar in sewadarAlreadyAddedList){
// print("My sewadr list is: $sewadar");
//         }

    setState(() {
      if (sewadarAlreadyAddedList.isNotEmpty) {
        Set<int> selectedSewadarIds = {
          for (var sewadarAlreadyAdded in sewadarAlreadyAddedList)
            sewadarAlreadyAdded.id as int
        };
        selectedSewadars = sewadarAlreadyAddedList;
        list.removeWhere((sewadar) => selectedSewadarIds.contains(sewadar.id));
      }
      allSewadars = list;
      filteredSewadars = allSewadars;
    });
  }

  void searchSewadars(String query) {
    setState(() {
      filteredSewadars = allSewadars.where((sewadar) {
        return sewadar.sewadar_name
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            sewadar.guardian_name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void addSewadar() {
    setState(() {
      if (selectedSewadar != null) {
        selectedSewadars.add(selectedSewadar!);
        allSewadars.remove(selectedSewadar!);
        searchController.clear();
        filteredSewadars = List.from(allSewadars); //refresh search results
      }
    });
  }

  void removeSewadar(Sewadar sewadar) {
    setState(() {
      selectedSewadars.remove(sewadar);
      allSewadars.add(sewadar);
      filteredSewadars = List.from(allSewadars); //refresh search results
    });
  }

  @override
  void initState() {
    super.initState();
    getSewadarsMasterList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Autocomplete<Sewadar>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable.empty();
                    }
                    return filteredSewadars.where((Sewadar sewadar) {
                      return sewadar.sewadar_name
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()) ||
                          sewadar.guardian_name
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (Sewadar sewadar) =>
                      sewadar.sewadar_name,
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    searchController = controller;
                    return TextField(
                      controller: searchController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Search By Name or Guardian Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: searchSewadars,
                    );
                  },
                  onSelected: (Sewadar sewadar) {
                    setState(() {
                      selectedSewadar = sewadar;
                      searchController.text = sewadar.sewadar_name;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              ElevatedButton(
                onPressed: addSewadar,
                child: const Text("Add"),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: selectedSewadars.length,
                itemBuilder: (context, index) {
                  var sewadar = selectedSewadars[index];
                  return ListTile(
                    title: Text(sewadar.sewadar_name),
                    subtitle: Text(sewadar.guardian_name),
                    trailing: IconButton(
                        onPressed: () => removeSewadar(sewadar),
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.red,
                        )),
                  );
                }),
          ),
          SizedBox(height: 20), // Spacing
          Align(
            alignment: Alignment.center, // Keep button initially in the center
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Button Width
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: selectedSewadars.isNotEmpty
                        ? () async {
                            // save data to db and go to home page
                            print("nominal role id: ${widget.nominalRole.id}");
                            await _databaseService.assignSewaToSewadar(
                                selectedSewadars, widget.nominalRole.id ?? 0);
                            // assignSewadarToSewa();
                            Navigator.popUntil(context, (route) {
                              if (route.isFirst) {
                                Navigator.pushReplacementNamed(context, "/",
                                    arguments: true);
                                return true;
                              }
                              return false;
                            });
                          }
                        : null,
                    child: const Text("Submit"),
                  ),
                  ElevatedButton(
                    onPressed: selectedSewadars.isNotEmpty
                        ? () async {
                            // save data to db and go to home page
                            print("nominal role id: ${widget.nominalRole.id}");
                            await _databaseService.assignSewaToSewadar(
                                selectedSewadars, widget.nominalRole.id ?? 0);
                            await createExcelFileUsingSyncFusion(
                                selectedSewadars);
                            // await createExcel(
                            //     selectedSewadars, widget.nominalRole);
                            // assignSewadarToSewa();
                            Navigator.popUntil(context, (route) {
                              if (route.isFirst) {
                                Navigator.pushReplacementNamed(context, "/",
                                    arguments: true);
                                return true;
                              }
                              return false;
                            });
                          }
                        : null,
                    child: const Text("Submit & create Excel"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
