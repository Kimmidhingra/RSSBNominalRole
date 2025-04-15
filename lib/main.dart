import 'package:flutter/material.dart';
import 'package:nominal_role/Screens/CreateNominalRoleScreen.dart';
import 'package:nominal_role/Screens/MasterListScreen.dart';
import 'package:nominal_role/Screens/NominalRoleDocScreen.dart';
import 'package:nominal_role/common_widgets/nomination_role_builder.dart';
import 'package:nominal_role/model/NominalRole.dart';
import 'package:nominal_role/model/Sewadar.dart';
import 'package:nominal_role/service/DatabaseService.dart';
import 'package:nominal_role/service/ExcelServices.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Nominal Role '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<NominalRole>> futureNominalRoles;
  List<Sewadar> masterListSewadars = [];
  // final ExcelService _excelService = ExcelService();

  Future<List<NominalRole>> _getNominalRoles() async {
    return await _databaseService.nominalRoles();
  }

  Future<void> saveSewadarMasterListFromExcelToDB() async {
    masterListSewadars = await _databaseService.getSewadarMasterList();
    if (masterListSewadars.isEmpty) {
// Data not saved to db yet, Get data from excel and save to db
      var a = await readExcelFromAssets();
      if (a.isNotEmpty) {
        await _databaseService.insertSewadarMasterList(a);
      }
      masterListSewadars = a;
    } else {
      // print("Woo data saved to db ${a.length}");
      // print(a[100].toString());
      // print(a[1057].toString());
    }
  }

  @override
  void initState() {
    super.initState();
    futureNominalRoles = _getNominalRoles();
    saveSewadarMasterListFromExcelToDB();
  }

  Future<void> _refreshNominalRoles() async {
    setState(() {
      futureNominalRoles = _getNominalRoles(); // Fetch new data
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments == true) {
      _getNominalRoles();
    }
  }

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'show_nominal_roles':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Nominalroledocscreen()));
      case 'master_list':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Masterlistscreen(sewadars: masterListSewadars)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
              onSelected: (value) => _onMenuSelected(context, value),
              itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: "show_nominal_roles",
                      child: Text("Show Nominal Roles"),
                    ),
                    const PopupMenuItem(
                      value: "master_list",
                      child: Text("Master List"),
                    )
                  ])
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNominalRoles,
        child: Center(
          child: NominationRoleBuilder(future: futureNominalRoles),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Createnominalrolescreen()));
          // builder: (context) => const MyCalendarView()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
