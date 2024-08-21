import 'package:flutter/material.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            "Files",
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("data"),
          ],
        ),
      ),
    );
  }
}
