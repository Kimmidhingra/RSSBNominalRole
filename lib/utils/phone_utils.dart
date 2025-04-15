import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void makePhoneCall(String number) async {
  print("Phone number : $number");
  if (Platform.isAndroid) {
    final intent = AndroidIntent(
      action: 'android.intent.action.DIAL',
      data: 'tel:$number',
    );
    intent.launch().catchError((e) {
      debugPrint('Could not launch dialer: $e');
    });
  }
  final Uri uri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    // Handle if the device can't place a call
    debugPrint('Could not launch $uri');
  }
}
