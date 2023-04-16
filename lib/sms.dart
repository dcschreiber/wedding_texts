import 'package:flutter_sms/flutter_sms.dart';

  void send(String message, List<String> recipents) async {
    String results =
        await sendSMS(message: message, recipients: recipents, sendDirect: true)
            .catchError((onError) {
      print("error message: $onError");
    });
    print("Results: $results");
  }
