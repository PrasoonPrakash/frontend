import 'dart:io';
import 'dart:convert';
import 'package:aanchal_ai/conv.dart';
import 'package:aanchal_ai/global_vars.dart';
import 'package:aanchal_ai/layout.dart';
import 'package:aanchal_ai/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import "package:flutter_spinkit/flutter_spinkit.dart";
//import 'package:aanchal_ai/global_vars.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String? _response;
  //int stc = 0;

  Future<void> _pickFileAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      _uploadFile(file);
      //final File fileForName = File(file.path!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingPage()),
      );
      
      //name=basenameWithoutExtension(fileForName.path);
      // const spinkit = SpinKitRing(
      //   color: Colors.red,
      //   size: 50,
      // );
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadFile(PlatformFile file) async {
    answer=null;
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.222.76.205:6000/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path!));
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      final decoded=json.decode(responseString) as Map<String, dynamic>;
      setState(() {
        answer = decoded["result"];
      });
    } else {
      setState(() {
        answer =
            'File upload failed with status: ${response.statusCode} ${response.reasonPhrase} ${response.toString()}';
      });
    }
    setState(() {
      stc1 = response.statusCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          toolbarHeight: 100,
          elevation: 6,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          title: Image.asset(
            "images/aanchalai_logo.png",
            //fit: BoxFit.fitHeight,
            alignment: Alignment.center,
          ),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/lady.png"),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeechRecordPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: const Color.fromARGB(255, 177, 214, 225),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16)),
                child: Text("START A CONVERSATION",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black))),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: _pickFileAndUpload,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side:
                        BorderSide(color: Color.fromARGB(255, 177, 214, 225))),
                backgroundColor: const Color.fromARGB(255, 232, 243, 246),
                padding:
                    const EdgeInsets.symmetric(horizontal: 67, vertical: 16),
              ),
              child: Text("UPLOAD AUDIO",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
