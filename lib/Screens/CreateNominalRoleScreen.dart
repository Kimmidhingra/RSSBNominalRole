import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nominal_role/Screens/AddSewadarScreen.dart';
import 'package:nominal_role/model/NominalRole.dart';
import 'package:nominal_role/service/DatabaseService.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Createnominalrolescreen extends StatelessWidget {
  const Createnominalrolescreen({super.key, this.nominalRole});
  final NominalRole? nominalRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Nominal Role"),
      ),
      body: NominalForm(
        nominalRole: nominalRole,
      ),
    );
  }
}

class NominalForm extends StatefulWidget {
  const NominalForm({super.key, this.nominalRole});
  final NominalRole? nominalRole;
  @override
  State<StatefulWidget> createState() {
    return _NominalFormState();
  }
}

class _NominalFormState extends State<NominalForm> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController jatherdarNameController = TextEditingController();
  final TextEditingController jatherdarPhoneNumberController =
      TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverPhoneNumberController =
      TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();

  final List<String> _vehicleTypes = ['Train', 'Car', 'Bus'];
  String? _vehicleType;
  final formKey = GlobalKey<FormState>();
  int numberOfDays = 0;
  DateTime sewaStartDate = DateTime.now();
  DateTime sewaEndDate = DateTime.now();
  String sewaStartAndEndDate = "";
  final List<String> sewaTypes = [
    'Mechanical Jatha',
    'Langar',
    'Security',
    'Cash',
    'Accomodation',
    'Traffic'
  ];
  String? selectedSewaType;
  bool isLoading = false;
  bool isEdit = false;

  // List<DateTime?> _dialogCalendarPickerValue = [DateTime.now(), DateTime.now()];
  _NominalFormState() {
    sewaStartAndEndDate = getFormattedDate(sewaStartDate, sewaEndDate);
  }
  @override
  void initState() {
    super.initState();
    if (widget.nominalRole != null) {
      isEdit = true;
      jatherdarNameController.text = widget.nominalRole!.jathedarName;
      jatherdarPhoneNumberController.text =
          widget.nominalRole!.jathedarPhoneNumber;
      driverNameController.text = widget.nominalRole!.driverName;
      driverPhoneNumberController.text = widget.nominalRole!.driverPhoneNumber;
      vehicleNumberController.text = widget.nominalRole!.vehicleNumber;
      _vehicleType = widget.nominalRole!.vehicleType;
      selectedSewaType = widget.nominalRole!.sewaType;
      sewaStartDate = widget.nominalRole!.sewaStartDate;
      sewaEndDate = widget.nominalRole!.sewaEndDate;
      sewaStartAndEndDate = getFormattedDate(sewaStartDate, sewaEndDate);
      numberOfDays = widget.nominalRole!.numberOfDays;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AbsorbPointer(
            absorbing: isLoading,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text("Area  -  Fridabad"),
                    const Text("Zone  -  3"),
                    TextFormField(
                      controller: jatherdarNameController,
                      decoration:
                          const InputDecoration(labelText: "Jathedar Name"),
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Jathedar Name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: jatherdarPhoneNumberController,
                      decoration: const InputDecoration(
                          labelText: "Jathedar Phone Number"),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Jathedar Phone number";
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: _vehicleType, //default selcted
                      hint: const Text("<<select>>"),
                      items: _vehicleTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null && _vehicleType != value) {
                          //handle change in vehicle type here
                          _vehicleType = value;
                          // handle logic to display additional fields based on vehicle type
                        } else {
                          _vehicleType = null;
                        }
                        setState(() {});
                      },
                      decoration:
                          const InputDecoration(labelText: "Type of Vehicle"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a vehicle type";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: showDriverDetails(_vehicleType),
                      child: TextFormField(
                        controller: vehicleNumberController,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(labelText: "Vehicle Number"),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Vehicle Number";
                          }
                          return null;
                        },
                      ),
                    ),
                    Visibility(
                      visible: showDriverDetails(_vehicleType),
                      child: TextFormField(
                        controller: driverNameController,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(labelText: "Driver Name"),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Driver Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Visibility(
                      visible: showDriverDetails(_vehicleType),
                      child: TextFormField(
                        controller: driverPhoneNumberController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: "Driver Phone Number"),
                        keyboardType: TextInputType.phone,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Driver Phone Number";
                          }
                          return null;
                        },
                      ),
                    ),
                    DropdownButtonFormField(
                      value: selectedSewaType, //default selcted
                      hint: const Text("<<select>>"),
                      items: sewaTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null && selectedSewaType != value) {
                          //handle change in vehicle type here
                          selectedSewaType = value;
                          // handle logic to display additional fields based on vehicle type
                        } else {
                          selectedSewaType = null;
                        }
                        setState(() {});
                      },
                      decoration: const InputDecoration(labelText: "Sewa Type"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select sewa type";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Sewa Start & End Date",
                          maxLines: 1,
                        ),
                        TextButton(
                            onPressed: () {
                              showDateDialog();
                            },
                            child: Row(
                              children: [
                                Text(sewaStartAndEndDate),
                                const Icon(Icons.calendar_month)
                              ],
                            )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //       content: Text('Nominal role created.')),
                          // );
                          myAsyncMethod((NominalRole nr) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddsewadarScreen(
                                          nominalRole: nr,
                                        )));
                          });
                        }
                      },
                      child: Text(isEdit ? "Edit" : "Continue"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54, // Semi-transparent background
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Future<void> myAsyncMethod(Function(NominalRole) onSuccess) async {
    final nominalRole = NominalRole(
        id: isEdit ? widget.nominalRole?.id : null,
        jathedarName: jatherdarNameController.text,
        jathedarPhoneNumber: jatherdarPhoneNumberController.text,
        vehicleType: _vehicleType ?? "",
        vehicleNumber: vehicleNumberController.text,
        driverName: driverNameController.text,
        driverPhoneNumber: driverPhoneNumberController.text,
        sewaStartDate: sewaStartDate,
        sewaEndDate: sewaEndDate,
        numberOfDays: numberOfDays,
        sewaType: selectedSewaType ?? "");
    if (isEdit) {
      await _databaseService.updateNominalRole(nominalRole);
    } else {
      var id = await _databaseService.insertNominalRole(nominalRole);
      nominalRole.id = id;
    }
    onSuccess.call(nominalRole);
  }

  Future<void> saveNominalRole(NominalRole nominalRole) async {}

  Future<void> updateNominalRole(NominalRole nominalRole) async {}

  void showDateDialog() {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return SfDateRangePicker(
            showActionButtons: true,
            enablePastDates: false,
            selectionMode: DateRangePickerSelectionMode.range,
            onSubmit: (Object? value) {
              setState(() {
                if (value is PickerDateRange) {
                  var endDate = (value).endDate ?? DateTime.now();
                  var startDate = (value).startDate ?? DateTime.now();

                  if (endDate.isBefore(startDate)) {
                    Fluttertoast.showToast(
                        msg: "Please select sewa end date",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //   content: Text("Please select correct end date"),
                    // ));
                  } else {
                    sewaEndDate = endDate;
                    sewaStartDate = startDate;
                    sewaStartAndEndDate =
                        getFormattedDate(sewaStartDate, sewaEndDate);
                    Navigator.pop(context);
                  }
                } else if (value is List<DateTime>) {
                  numberOfDays = (value).length;
                }
              });
            },
            initialSelectedRange: PickerDateRange(sewaStartDate, sewaEndDate),
            onCancel: () {
              Navigator.pop(context);
            },
          );
        });
  }
}

bool showDriverDetails(String? vehicleType) {
  return vehicleType == 'Car' || vehicleType == 'Bus';
}

String getFormattedDate(DateTime startDate, DateTime endDate) {
  return '${DateFormat('dd MMM').format(startDate)}-${DateFormat('dd MMM').format(endDate)}';
}
