import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aanchal_ai/global_vars.dart';
import 'package:aanchal_ai/prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:aanchal_ai/home.dart';
import 'package:http/http.dart' as http;

class LoadingPage extends StatefulWidget {
  // final int statusCode;
  // final Function(int)? onStcChanged;
  // LoadingPage({
  //   required this.statusCode,
  //   this.onStcChanged,
  // }) : super(key: Key('loading_page'));
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Timer? _timer;
  //int myStc = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (stc1 == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsPage()),
        );
        _timer?.cancel();
        final nameVar =
            await http.get(Uri.parse('http://10.222.76.205:6000/name'));
        final decoded = json.decode(nameVar.body) as Map<String, dynamic>;
        setState(() {
          name = decoded["name"];
          stc1=0;
        });
        return;
      }
    });
  }

  // void _updateStc() {
  //   // setState(() {
  //   //   myStc = newStc;
  //   // });
  //   if (widget.onStcChanged != null) {
  //     widget.onStcChanged!(newStc);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //print(widget.stageMessage);
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SpinKitRing(color: Colors.red, size: 80),
              LinearProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                "Processing ...",
                style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black)
              )
            ],
          ),
        ));
  }
}
