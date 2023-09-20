import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpold;
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class UploadFileApiProvider {
  static String apiUrl = 'upload/file_upload_to_s3';

  static uploadFile({@required File? file, @required String? bucketName, String? fileName, String directoryName = ""}) async {
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      Uint8List imageByteData = await file!.readAsBytes();

      var request = new httpold.MultipartRequest("POST", Uri.parse(url));
      request.fields.addAll({"bucketName": bucketName!, "directoryName": directoryName});

      var cmnHeaders = await commonHeaders();
      request.headers.addAll(cmnHeaders);

      fileName = (fileName ?? file.path.split('/').last.split('.').first) + '.' + file.path.split('/').last.split('.').last;
      request.files.add(
        httpold.MultipartFile.fromBytes(
          'file',
          imageByteData,
          filename: fileName,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();

        return {
          "success": true,
          "data": result,
        };
      } else {
        throw new Exception(response);
      }
    });
  }
}
