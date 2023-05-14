import 'package:flutter/material.dart';
import 'sms.dart' as sms;
import 'CSVHandler.dart' as csv;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Texter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Wedding Texter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController csvContentController = TextEditingController();
  final TextEditingController numberOfSentSMSs = TextEditingController();
  final TextEditingController numberOfFailedSMSs = TextEditingController();

  // final TextEditingController sentMessageCounter = TextEditingController();
  List<List<dynamic>> listToText = [];
  String csvContent = "";

  @override
  void dispose() {
    csvContentController.dispose();
    // numberController.dispose();
    super.dispose();
  }

  void _sendText() async {
    int successCounter = 0;
    int failureCounter = 0;
    String failedNumbers = "";
    for (List<dynamic> messageNumber in listToText) {
      String message = messageNumber[1];
      String number = messageNumber[0];

      try {
        await sms.send(message, [number]);
        successCounter++;
      } catch (e) {
        failureCounter++;
        // print('Error sending SMS to $number: $e');
        failedNumbers = "$failedNumbers, $number";
      }
    }
    setState(() {
      // print("$successCounter messages sent successfully");
      // print("$failureCounter messages failed to send");
      numberOfFailedSMSs.text =
          "$failureCounter \n \n Numbers that Failed:\n$failedNumbers";
      numberOfSentSMSs.text = successCounter.toString();
    });
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 300),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Future<List<List<dynamic>>> future = csv.uploadFile();
                        future.then((data) {
                          listToText = data;
                          csvContentController.text = data.toString();
                        }).catchError((e) {
                          String errorMessage = 'Failed to fetch data: \n\n$e';
                          showErrorDialog(context, errorMessage);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue), // Set button color
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set text color
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(200, 50)), // Set button size
                      ),
                      child: Text('Upload CSV'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: csvContentController,
                      textAlign: TextAlign.center,
                      maxLines: 8,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          labelText: "CSV Content:", border: InputBorder.none),
                      readOnly: true,
                    ),
                    TextField(
                      controller: numberOfSentSMSs,
                      textAlign: TextAlign.center,
                      maxLines: 8,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          labelText: "Sent SMSs:", border: InputBorder.none),
                      readOnly: true,
                    ),
                    TextField(
                      controller: numberOfFailedSMSs,
                      textAlign: TextAlign.center,
                      maxLines: 8,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          labelText: "Failed SMSs:", border: InputBorder.none),
                      readOnly: true,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendText,
        // onPressed: ()=>print("nothing done"),
        tooltip: 'Send the SMSs',
        child: const Icon(Icons.send),
      ),
    );
  }
}
