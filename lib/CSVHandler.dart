import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';

Future<List<List<dynamic>>> uploadFile() async {
  await FilePicker.platform.clearTemporaryFiles();
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    // allowedExtensions: ['csv'],
  );

  if (result != null && result.files.single.path != null) {

    File file = File(result.files.single.path!);

    // Read the file as a string
    String csvString = await file.readAsString();
    // print(csvString);

    // Parse the CSV string to a list of maps
    List<List<dynamic>> csvData = CsvToListConverter(eol: "\n").convert(csvString);

    // Print the data
    // print("Printing file $csvData");
    return csvData;

  } else {
    // print("uploadFile: File Load Failed");
    throw Exception('File Load Failed');
    // User canceled the picker
  }
}
