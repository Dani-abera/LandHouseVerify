import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class  UploadFileService {
  // Asset Registry APi for uploading image and documents
  static const String APIURL = "https://asset-registry-api.up.railway.app/";
  static const String UPLOAD_IMAGE = "${APIURL}api/upload/image";
  static const String UPLOAD_MULTIPLE_IMAGE = "${APIURL}api/upload/images";
  static const String UPLOAD_FILE = "${APIURL}api/upload/pdf";

  // api for cloudinary services
  final cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dyzeb4vxu/image/upload';
  final preset = 'Asset-Registry';

  Future<List<String>> uploadMultipleImagesToCloudinary(
      List<File> images) async {
    List<String> uploadedUrls = [];

    try {
      // Use Future.wait to upload all images concurrently
      final uploadTasks = images.map<Future<String>>((image) async {
        final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
          ..fields['upload_preset'] = preset
          ..files.add(await http.MultipartFile.fromPath('file', image.path));

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final data = jsonDecode(responseBody);
          return data['secure_url']; // Extract the secure URL
        } else {
          throw Exception('Failed to upload image: ${response.statusCode}');
        }
      });

      // Wait for all uploads to complete
      uploadedUrls = await Future.wait(uploadTasks);
    } catch (e) {
      print('Error uploading images: $e');
    }

    return uploadedUrls; // Return the list of uploaded image URLs
  }

  Future<List<String>> uploadMultipleImages(List<File> images) async {
    List<String> uploadedUrls = [];

    try {
      var uri = Uri.parse(UPLOAD_MULTIPLE_IMAGE);
      var request = http.MultipartRequest('POST', uri);

      // Add all images to request
      for (var image in images) {
        String mimeType = lookupMimeType(image.path) ?? 'image/jpeg'; // Auto-detect type
        request.files.add(await http.MultipartFile.fromPath(
          'images', image.path, // ✅ Use 'images' (same as backend)
          contentType: MediaType.parse(mimeType), // ✅ Auto-detect MIME type
        ));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        // ✅ Extract URLs correctly
        uploadedUrls = List<String>.from(data['files'].map((file) => file['filePath']));
      } else {
        throw Exception('Failed to upload images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }

    return uploadedUrls;
  }

  Future<String?> uploadPDF(String? result) async {
    if (result != null) {
      final file = File(result);

      var uri = Uri.parse(UPLOAD_FILE);
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
            'pdfs', file.path, // ✅ Ensure full file path
            contentType: MediaType('application', 'pdf')
        ));

      // Send the request
      var response = await request.send();

      // ✅ Read and decode response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);

        print('File uploaded successfully: ${jsonResponse['filePath']}');
        return jsonResponse['filePath']; // ✅ Return correct file path
      } else {
        print('Failed to upload file');
      }
    }
    return null;
  }
}