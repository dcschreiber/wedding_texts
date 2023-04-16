import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'sms.dart' as sms;

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
  final TextEditingController textController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void _sendText() {
    setState(() {
      String message = textController.text;
      List<String> recipients = [numberController.text];
      sms.send(message, recipients);
    });
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
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Number',
              ),
              controller: numberController,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text to send',
              ),
              controller: textController,
            ),
            SizedBox(height: 10),
            Text(
              'Your number: ${numberController.text}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your message: ${textController.text}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendText,
        tooltip: 'Send',
        child: const Icon(Icons.send),
      ),
    );
  }
}
