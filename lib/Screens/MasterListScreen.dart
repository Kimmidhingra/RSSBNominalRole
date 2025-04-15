import 'package:flutter/material.dart';
import 'package:nominal_role/model/Sewadar.dart';
import 'package:nominal_role/utils/phone_utils.dart';

// class Masterlistscreen extends StatelessWidget {
//   const Masterlistscreen({super.key, required this.sewadars});
//   final List<Sewadar> sewadars;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sewadar Details"),
//       ),
//       body: Masterlist(
//         sewadars: sewadars,
//       ),
//     );
//   }
// }

class Masterlistscreen extends StatefulWidget {
  const Masterlistscreen({super.key, required this.sewadars});
  final List<Sewadar> sewadars;

  @override
  State<StatefulWidget> createState() {
    return _MasterlistState();
  }
}

class _MasterlistState extends State<Masterlistscreen> {
  List<Sewadar> filteredSewadars = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    filteredSewadars = widget.sewadars;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredSewadars = widget.sewadars.where((s) {
        return s.sewadar_name.toLowerCase().contains(query) ||
            s.guardian_name.toLowerCase().contains(query) ||
            s.adhar_badge!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        filteredSewadars = widget.sewadars;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: "Search Sewadars...", border: InputBorder.none),
              )
            : const Text("Sewadar List"),
        actions: [
          IconButton(
              onPressed: _toggleSearch,
              icon: Icon(_isSearching ? Icons.delete : Icons.search))
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: filteredSewadars.length,
          itemBuilder: (context, index) {
            final sewadar = filteredSewadars[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                    text: "Name: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: sewadar.sewadar_name,
                                ),
                              ]),
                        ),
                        RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                    text: "Father/Husband Name: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: sewadar.guardian_name,
                                ),
                              ]),
                        ),
                        RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                    text: "Aadhar/ Badge No: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: sewadar.adhar_badge,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      makePhoneCall("${sewadar.contact}");
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Colors.green[800],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
