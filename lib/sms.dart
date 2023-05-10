import 'package:flutter_sms/flutter_sms.dart';

  Future<void> send(String message, List<String> recipients) async {
    try {
      String results = await sendSMS(
          message: message, recipients: recipients, sendDirect: true);
      print("Results: $results");
    } catch (e) {
      print("error message: $e");
      throw Exception('Failed to send SMS: $e');
    }
  }
