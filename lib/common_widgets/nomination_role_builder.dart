import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nominal_role/Screens/CreateNominalRoleScreen.dart';
import 'package:nominal_role/model/NominalRole.dart';
import 'package:nominal_role/utils/DateFormatter.dart';

class NominationRoleBuilder extends StatelessWidget {
  final Future<List<NominalRole>> future;
  // final Function(NominalRole) onDelete;
  // final Function(NominalRole) onEdit;

  const NominationRoleBuilder({
    super.key,
    required this.future,
    // required this.onDelete,
    // required this.onEdit
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NominalRole>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final NominalRole role = snapshot.data![index];
                  return GestureDetector(
                    child: nominationRoleCard(role, context),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Createnominalrolescreen(
                                    nominalRole: role,
                                  )))
                    },
                  );
                  // onDelete: onDelete,
                  // onEdit: onEdit,
                },
              ),
            );
          } else {
            return const Text('An error occurred');
          }
        });
  }

  Widget nominationRoleCard(NominalRole role, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple[200],
              ),
              alignment: Alignment.center,
              child: getSewaIcon(role),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jathedar Name: ${role.jathedarName}"),
                Text("Vehicle Type ${role.vehicleType}"),
                Text("Sewa ${role.sewaType}"),
                Row(children: [
                  Text(
                      "Start Date ${DateFormatter.formatFullDate(role.sewaStartDate)}"),
                  Text(
                      "End Date ${DateFormatter.formatFullDate(role.sewaEndDate)}"),
                ]),
              ],
            )),
          ],
        ),
      ),
    );
  }

  SvgPicture? getSewaIcon(NominalRole role) {
    if (role.sewaType == "Mechanical Jatha") {
      // return Icons.settings;
      return SvgPicture.asset(
        "assets/icons/mechanical_sewa.svg",
        height: 30,
        width: 30,
        fit: BoxFit.scaleDown,
      );
    } else if (role.sewaType == "Langar") {
      // return Icons.account_balance;
      return SvgPicture.asset(
        "assets/icons/langar_sewa.svg",
        height: 30,
        width: 30,
      );
    } else if (role.sewaType == "Security") {
      // return Icons.security;
      return SvgPicture.asset(
        "assets/icons/security_sewa.svg",
        height: 30,
        width: 30,
      );
    } else if (role.sewaType == "Cash") {
      // return Icons.security;
      return SvgPicture.asset(
        "assets/icons/cash_sewa.svg",
        height: 30,
        width: 30,
      );
    } else if (role.sewaType == "Accomodation") {
      // return Icons.security;
      return SvgPicture.asset(
        "assets/icons/accomodation.svg",
        height: 30,
        width: 30,
      );
    } else if (role.sewaType == "Traffic") {
      // return Icons.security;
      return SvgPicture.asset(
        "assets/icons/traffic.svg",
        height: 30,
        width: 30,
      );
    }
    return null;
  }
}
