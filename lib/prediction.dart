import 'package:aanchal_ai/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

// import 'package:open_filex/open_filex.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String text = " ";
  String text2 = answer!;
  //String translation = " ";
  bool fp = false;
  List<List<dynamic>> _data = [];

  Future<void> _downloadCsv() async {
    try {
      final url = Uri.parse(
          'http://10.222.76.205:6000/download_csv'); // Change to your Flask server URL
      final response = await http.get(url);

      // if (response.statusCode == 200) {
      final directory = "/sdcard/Download/csvFiles/";
      //   // var fileName = "${name}_hindi.txt";
      String savePath="$directory${name}_data_nooneshot.csv";
      //   await file.writeAsBytes(response.bodyBytes);

      //   setState(() {
      //     text = 'File downloaded to: ${file.path}';
      //   });
      //   // You can now use this file as needed in your app.
      // } else {
      //   print('Failed to download file.');
      // }
      if (response.statusCode == 200) {
        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded successfully');
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> downloadFile(String url, String savePath) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      File file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print('File downloaded successfully');
    } else {
      print('Failed to download file: ${response.statusCode}');
    }
  }

  // Future<void> _uploadFile(PlatformFile file) async {
  //   answer=null;
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('http://10.222.76.205:6000/upload'));
  //   request.files.add(await http.MultipartFile.fromPath('file', file.path!));
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     String responseString = await response.stream.bytesToString();
  //     final decoded=json.decode(responseString) as Map<String, dynamic>;
  //     setState(() {
  //       answer = decoded["result"];
  //     });
  //   } else {
  //     setState(() {
  //       answer =
  //           'File upload failed with status: ${response.statusCode} ${response.reasonPhrase} ${response.toString()}';
  //     });
  //   }
  //   setState(() {
  //     stc = response.statusCode;
  //   });
  // }

  Future<void> _uploadCsv(String csvPath) async {
    prediction = null;
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.222.76.205:6000/uploadCsvAndPredict'));
    request.files.add(await http.MultipartFile.fromPath('file', csvPath));
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      final decoded = json.decode(responseString) as Map<String, dynamic>;
      setState(() {
        text2 = decoded["prediction"];
        print("yayyyy");
      });
    } else {
      setState(() {
        text2 =
            'File upload failed with status: ${response.statusCode} ${response.reasonPhrase} ${response.toString()}';
        print(prediction);
      });
    }
    setState(() {
      stc2 = response.statusCode;
    });
  }

  Future<void> _uploadCSVfile() async {
    final path = "/sdcard/Download/csvFiles/";
    final dictToSave = Directory(path);
    if (!await dictToSave.exists()) {
      await dictToSave.create(recursive: true);
    }
    String csvPath = "${path}${name}_data_nooneshot.csv";
    _uploadCsv(csvPath);
    // setState(() {
    //   text2=prediction==Null?"couldn't get prediction":prediction!;
    // });
    // FilePickerResult? result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   PlatformFile file = result.files.first;
    //   _uploadFile(file);
    //   //final File fileForName = File(file.path!);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoadingPage()),
    //   );

    //   //name=basenameWithoutExtension(fileForName.path);
    //   // const spinkit = SpinKitRing(
    //   //   color: Colors.red,
    //   //   size: 50,
    //   // );
    // } else {
    //   // User canceled the picker
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            "Prediction",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              //Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          centerTitle: true,
          elevation: 6,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          //automaticallyImplyLeading: false,
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(text2,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.black)),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final response = await http
                      .get(Uri.parse('http://10.222.76.205:6000/hindi'));
                  final decoded =
                      json.decode(response.body) as Map<String, dynamic>;
                  setState(() {
                    text = decoded["transcript"];
                  });

                  final path = "/sdcard/Download/transcriptions/";
                  final dictToSave = Directory(path);
                  if (!await dictToSave.exists()) {
                    await dictToSave.create(recursive: true);
                  }
                  var fileName = "${name}_hindi.txt";
                  String filePath = path + fileName;
                  final File file = File(filePath);
                  print('Checking if file exists...');
                  bool exists = await file.exists();
                  print('File exists: $exists');

                  if (!exists) {
                    print('Creating file...');
                    await file.writeAsBytes(response.bodyBytes);
                    setState(() {
                      text = 'File downloaded to: ${file.path}';
                    });
                  } else {
                    print('File already exists.');
                  }
                  await file.writeAsString(text);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: const Color.fromARGB(255, 177, 214, 225),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16)),
                child: Text("HINDI TEXT",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black))),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await http
                    .get(Uri.parse('http://10.222.76.205:6000/english'));
                final decoded =
                    json.decode(response.body) as Map<String, dynamic>;
                setState(() {
                  text = decoded["translation"];
                });
                final path = "/sdcard/Download/translations/";
                final dictToSave = Directory(path);
                if (!await dictToSave.exists()) {
                  await dictToSave.create(recursive: true);
                }
                var fileName = "${name}_english.txt";
                String filePath = path + fileName;
                final File file = File(filePath);

                await file.writeAsString(text);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side:
                        BorderSide(color: Color.fromARGB(255, 177, 214, 225))),
                backgroundColor: const Color.fromARGB(255, 232, 243, 246),
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
              ),
              child: Text("ENGLISH TEXT",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black)),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: _downloadCsv,
              // () async {
              // setState(() {
              //   fp=true;
              // });
              // final response = await http
              //     .get(Uri.parse('http://10.222.76.205:6000/data'));
              // final decoded =
              //     json.decode(response.body) as Map<String, dynamic>;
              // setState(() {
              //   text = decoded.toString();
              // });
              // print(text);
              // final path = "/sdcard/Download/data/";
              // final dictToSave = Directory(path);
              // if (!await dictToSave.exists()) {
              //   await dictToSave.create(recursive: true);
              // }
              // List<List<dynamic>> _listData= const CsvToListConverter().convert(text);
              // setState(() {
              //   _data=_listData;
              // });
              // var fileName = "${name}_data.csv";
              // String filePath = path + fileName;
              // final File file = File(filePath);
              // await file.writeAsString(text);
              // },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: const Color.fromARGB(255, 177, 214, 225),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              child: Text("GET EXTRACTED FEATURES",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black)),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: _uploadCSVfile,
                child: Text('SUBMIT',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black))),
            SizedBox(
              height: 20,
            ),
            Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black)),
            // SizedBox(
            //   height: 100,
            //   child: ListView.builder(
            //     itemCount: _data.length,
            //     itemBuilder: (_,index){
            //       return Card(
            //         margin: const EdgeInsets.all(3),
            //         color: index==0 ? Colors.redAccent: Colors.white,
            //         child: ListTile(
            //           leading: Text(_data[index][0].toString()),
            //           title: Text(_data[index][1]),
            //         ),
            //       );
            //     },
            //     scrollDirection: Axis.horizontal,

            //   ),
            //   //fp=false;
            // ),
          ],
        ),
      )),
    );
  }
}
