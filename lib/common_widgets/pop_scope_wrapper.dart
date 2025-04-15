import 'package:flutter/material.dart';

class PopScopeWrapper extends StatelessWidget {
  final Widget child;

  const PopScopeWrapper({super.key, required this.child});
  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure"),
            content: const Text("Are you sure you want to leave this page"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Stay on this page")),
              TextButton(
                  onPressed: ()
                      // => Navigator.pop(context, true),
                      {
                    Navigator.popUntil(context, (route) {
                      if (route.isFirst) {
                        Navigator.pushReplacementNamed(context, "/",
                            arguments: true);
                        return true;
                      }
                      return false;
                    });
                  },
                  child: const Text("Leave this page")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PopScope<Object>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
