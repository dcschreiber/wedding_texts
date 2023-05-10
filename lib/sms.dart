import 'package:flutter_sms/flutter_sms.dart';

  void send(String message, List<String> recipients) async {
    String results =
        await sendSMS(message: message, recipients: recipients, sendDirect: true)
            .catchError((onError) {
      print("error message: $onError");
    });
    print("Results: $results");
  }
