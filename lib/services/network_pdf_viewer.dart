import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NetworkPdfViewer extends StatefulWidget {
  final String url;

  const NetworkPdfViewer({super.key, required this.url});

  @override
  _NetworkPdfViewerState createState() => _NetworkPdfViewerState();
}

class _NetworkPdfViewerState extends State<NetworkPdfViewer> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    downloadAndSavePdf();
  }

  Future<void> downloadAndSavePdf() async {
    try {
      var response = await http.get(Uri.parse(widget.url));
      var bytes = response.bodyBytes;

      Directory tempDir = await getTemporaryDirectory();
      File file = File("${tempDir.path}/downloaded.pdf");

      await file.writeAsBytes(bytes);
      setState(() {
        localPath = file.path;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Network PDF Viewer")),
      body: localPath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath!),
    );
  }
}
