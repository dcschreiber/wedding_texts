import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> askForPermission() async {
  // Check if the permission is already granted.
  var status = await Permission.sms.status;
  if (status == PermissionStatus.granted) {
    // The permission is already granted, so do nothing.
    return true;
  } else {
    // The permission is not granted, so request it from the user.
    var result = await Permission.sms.request();
    if (result == PermissionStatus.granted) {
      // The permission was granted, so do what you need to do.
      return true;
    } else {
      // The permission was denied, so show an error message to the user.
      print('Permission to send SMS denied.');
      return false;
    }
  }
}

Future<void> send(String message, List<String> recipients) async {
  // Check if the permission is already granted.
  if (!await askForPermission()) {
    return;
  }
  // Send the SMS message.
  try {
    await sendSMS(message: message, recipients: recipients, sendDirect: true);
  } catch (e) {
    // print("error message: $e");
    throw Exception('Failed to send SMS: $e');
  }
}
