import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:trapp/environment.dart';

bool isProd() {
  return Environment.envName == "production";
}

Future<String> createFileFromByteData(Uint8List data) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  String fullPath = '$dir/test.png';
  File file = File(fullPath);
  await file.writeAsBytes(data);
  return file.path;
}

bool passwordValidation(String str) {
  return RegExp(r'([a-zA-Z]+)').hasMatch(str) && RegExp(r'([0-9]+)').hasMatch(str);
}

Future<Uint8List?> bytesFromImageUrl(String path) async {
  try {
    var response = await http.get(Uri.parse(path));

    return response.bodyBytes;
  } catch (e) {
    return null;
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isNumbers(String? s) {
  if (s == null) {
    return false;
  }
  return RegExp(r'^[0-9]+$').hasMatch(s);
}

String ordinal(int number) {
  if (!(number >= 1 && number <= 100)) {
    //here you change the range
    throw Exception('Invalid number');
  }

  if (number >= 11 && number <= 13) {
    return 'th';
  }

  switch (number % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
