import 'dart:convert';
import 'dart:io';
import 'package:aanchal_ai/global_vars.dart';
import 'package:aanchal_ai/home.dart';
import 'package:aanchal_ai/loading_page.dart';
import 'package:aanchal_ai/prediction.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class SpeechRecordPage extends StatefulWidget {
  const SpeechRecordPage({super.key});

  @override
  State<SpeechRecordPage> createState() => _SpeechRecordPageState();
}

class _SpeechRecordPageState extends State<SpeechRecordPage> {
  bool pressed = false;
  //String? _response;

  // Future<void> _pickFileAndUpload() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     _uploadFile(file);
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // Future<void> _uploadFile(String? filePath) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('http://10.222.76.205:6000/upload'));
  //   request.files.add(await http.MultipartFile.fromPath("file", filePath!));
  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     String responseString = await response.stream.bytesToString();
  //     setState(() {
  //       _response = responseString;
  //     });
  //   } else {
  //     setState(() {
  //       _response =
  //           'File upload failed with status: ${response.statusCode} ${response.reasonPhrase} ${response.toString()}';
  //     });
  //   }
  // }

  Future<void> _uploadFile(String? filePath) async {
    answer=null;
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.222.76.205:6000/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', filePath!));
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

  final AudioRecorder audioRecorder = AudioRecorder();
  String? recordingPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            "Start A Conversation",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          elevation: 6,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  if (!pressed) {
                    if (await audioRecorder.hasPermission()) {
                      //final directory = await getExternalStorageDirectory();
                      final path = "/sdcard/Download/audio_recordings/";
                      final dictToSave = Directory(path);
                      if (!await dictToSave.exists()) {
                        await dictToSave.create(recursive: true);
                      }
                      name = "audio_${DateTime.now().millisecondsSinceEpoch}";
                      String filePath = "$path$name.mp4";
                      await audioRecorder.start(
                        const RecordConfig(),
                        path: filePath,
                      );
                      setState(() {
                        pressed = true;
                        recordingPath = null;
                      });
                    }
                  } else {
                    String? filePath = await audioRecorder.stop();
                    setState(() {
                      pressed = false;
                      recordingPath = filePath;
                    });
                    _uploadFile(recordingPath);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoadingPage()),
                    );
                  }
                },
                child: Icon(
                  !pressed ? Icons.mic_rounded : Icons.stop,
                  color: Color.fromARGB(255, 119, 157, 169),
                  size: 120,
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(30),
                    backgroundColor: Color.fromARGB(255, 232, 243, 246))),
            SizedBox(
              height: 60,
            ),
            Text(
              !pressed
                  ? "PRESS BUTTON TO START RECORDING"
                  : "PRESS BUTTON TO STOP RECORDING",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
    // return ResultsPage();
  }

/*class BottomNavBar extends StatelessWidget{
  var _currentIndex=0;
  Function onTabChange;

  BottomNavBar(this._currentIndex,{required this.onTabChange});

  @override
  Widget build(BuildContext context){
    return bottomNavBar();
  }

  var selectedTabs=[
    Icon(Icons.home_filled,color: Colors.white,),
    Icon(Icons.folder,color: Colors.white,),
  ];

  var unSelectedTabs=[
    Icon(Icons.home_outlined,color: Colors.white,),
    Icon(Icons.folder_open_outlined,color: Colors.white,),
  ];

  BottomNavigationBar bottomNavBar(){
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: unSelectedTabs[0],
          activeIcon: selectedTabs[0],
          backgroundColor:Color.fromARGB(255, 119, 157, 169),
          label: " ", 
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/aanchalai_logo.png",
            scale: 1.5,
          ),
          label: " ",
        ),
        BottomNavigationBarItem(
          icon: unSelectedTabs[1],
          activeIcon: selectedTabs[1],
          backgroundColor:Color.fromARGB(255, 119, 157, 169),    
          label: " ",       
        ),
      ],
    );
  }

  void onTabTapped(int index){
    _currentIndex=index;
    onTabChange(index);
  }*/
}
