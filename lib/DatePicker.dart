import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectedDatePicker(),
    );
  }
}

class SelectedDatePicker extends StatefulWidget {
  const SelectedDatePicker({super.key});

  @override
  _SelectedDatePickerState createState() => _SelectedDatePickerState();
}

class _SelectedDatePickerState extends State<SelectedDatePicker> {
  String? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MaterialButton(
          child: Container(
            child: _selectedDate == null
                ? const Text('Select a date ')
                : Text(_selectedDate!),
          ),
          onPressed: () {
            showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return SfDateRangePicker(
                    showActionButtons: true,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSubmit: (p0) => {},
                    // onSubmit: (Object value) {
                    //   Navigator.pop(context);
                    // },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  );
                });
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return AlertDialog(
            //           title: Text(''),
            //           content: Expanded(
            //             child: Column(
            //               children: <Widget>[
            //                 getDateRangePicker(),
            //                 MaterialButton(
            //                   child: Text("OK"),
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                 )
            //               ],
            //             ),
            //           ));
            //     });
          },
        ),
      ],
    ));
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);

    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  Widget getDateRangePicker() {
    return SizedBox(
        height: 250,
        child: Card(
            child: SfDateRangePicker(
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: selectionChanged,
        )));
  }
}
