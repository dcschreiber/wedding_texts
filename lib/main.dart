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
  // final TextEditingController sentMessageCounter = TextEditingController();
  List<List<dynamic>> listToText = [];
  String csvContent = "";

  @override
  void dispose() {
    csvContentController.dispose();
    // numberController.dispose();
    super.dispose();
  }

  void _sendText() {
    setState(() {
      // int sentMessageCounter = 0;
      for (List<dynamic> messageNumber in listToText) {
        String message = messageNumber[1];
        String number = messageNumber[0];
        print("message: $message - number: $number");
        sms.send(message, [number]);
      }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TextField(
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Enter Number',
            //   ),
            //   controller: numberController,
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Enter text to send',
            //   ),
            //   controller: textController,
            // ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Future<List<List<dynamic>>> future = csv.uploadFile();
                future.then((data) {listToText = data; csvContentController.text = data.toString();}).catchError((e) {
                  String errorMessage = 'Failed to fetch data: \n\n$e';
                  showErrorDialog(context, errorMessage);
                });
              },
              child: Text('Upload CSV'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Set button color
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Set text color
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 50)), // Set button size
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: csvContentController,
              textAlign: TextAlign.center,
              maxLines: 8,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(labelText: "CSV Content:", border: InputBorder.none),
            ),
            SizedBox(height: 10),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendText,
        // onPressed: ()=>print("nothing done"),
        tooltip: 'Send the SMSs',
        child: const Icon(Icons.send),
      ),
    );
  }
}
